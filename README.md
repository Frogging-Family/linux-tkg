## linux-tkg

This repository provides scripts to automatically download, patch and compile the Linux Kernel from [the official Linux git repository](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git), with a selection of patches aiming for better desktop/gaming experience. The provided patches can be enabled/disabled by editing the `customization.cfg` file and/or by following the interactive install script. You can use an external config file (default is `$HOME/.config/frogminer/linux-tkg.cfg`, tweakable with the `_EXT_CONFIG_PATH` variable in `customization.cfg`). You can also use your own patches (more information in `customization.cfg` file).

### Important information

- **Non-pacman distros support can be considered experimental. You're invited to report issues you might encounter with it.**
- **If your distro isn't using systemd, please set _configfile="running-kernel" in customization.cfg or you might end up with a non-bootable kernel**

- Keep in mind building recent linux kernels with GCC will require ~20-25GB of disk space. Using llvm/clang, LTO, ccache and/or enabling more drivers in the defconfig will push that requirement higher, so make sure you have enough free space on the volume you're using to build.
- In `intel_pstate` driver, frequency scaling aggressiveness has been changed with kernel 5.5 which results in stutters and poor performance in low/medium load scenarios (for higher power savings). As a workaround for our gaming needs, we are setting it to passive mode to make use of the `acpi_cpufreq` governor passthrough, keeping full support for turbo frequencies. It's combined with our aggressive ondemand governor by default for good performance on most CPUs while keeping frequency scaling for power savings. In a typical low/medium load scenario (Core i7 9700k, playing Mario Galaxy on Dolphin emulator) intel_pstate in performance mode gives a stuttery 45-50 fps experience, while passive mode + aggressive ondemand offers a locked 60 fps.
- Nvidia's proprietary drivers might need to be patched if they don't support your chosen kernel OOTB: [Frogging-Family nvidia-all](https://github.com/Frogging-Family/nvidia-all) can do that automatically for you.
- Note regarding kernels older than 5.9 on Arch Linux: since the switch to `zstd` compressed `initramfs` by default, you will face an `invalid magic at start of compress` error by default. You can workaround the issue by editing `/etc/mkinitcpio.conf` to uncomment the `COMPRESSION="lz4"` (for example, since that's the best option after zstd) line and regenerating `initramfs` for all kernels with `sudo mkinitpcio -P`

### Customization options
#### Alternative CPU schedulers

[CFS](https://en.wikipedia.org/wiki/Completely_Fair_Scheduler) is the only CPU scheduler available in the "vanilla" kernel sources ≤ 6.5.
[EEVDF](https://lwn.net/Articles/925371/) is the only CPU scheduler available in the "vanilla" kernel sources ≥ 6.6.

Its current implementation doesn't allow for injecting additional schedulers at kernel level, and requires replacing it. Only one scheduler can be patched in at a time.
However, using [Sched-ext](https://github.com/sched-ext/scx), it's possible to inject CPU schedulers at runtime. We offer support for it on ≥ 6.8 by default.
Arch users can find scx schedulers on the [AUR](https://aur.archlinux.org/packages/scx-scheds) thanks to @sirlucjan (for persistence, set scheduler in "/etc/default/scx" and enable the `scx` service).

Alternative schedulers are available to you in linux-tkg:
- Project C / PDS & BMQ by Alfred Chen: [blog](http://cchalpha.blogspot.com/ ), [code repository](https://gitlab.com/alfredchen/projectc)
- MuQSS by Con Kolivas : [blog](http://ck-hack.blogspot.com/), [code repository](https://github.com/ckolivas/linux)
- CacULE by Hamad Marri - CFS based : [code repository](https://github.com/hamadmarri/cacule-cpu-scheduler)
- Task Type (TT) by Hamad Marri - CFS based : [code repository](https://github.com/hamadmarri/TT-CPU-Scheduler)
- BORE (Burst-Oriented Response Enhancer) by Masahito Suzuki - CFS/EEVDF based : [code repository](https://github.com/firelzrd/bore-scheduler)
- Undead PDS : TkG's port of the pre-Project C "PDS-mq" scheduler by Alfred Chen. While PDS-mq got dropped with kernel 5.1 in favor of its BMQ evolution/rework, it wasn't on par with PDS-mq in gaming. "U" PDS still performed better in some cases than other schedulers, so it's been kept undead for a while.

These alternative schedulers can offer a better performance/latency ratio for gaming and desktop use. The availability of each scheduler depends on the chosen Kernel version: the script will display what's available on a per-version basis.
#### Default tweaks
- Memory management and swapping tweaks
- Scheduling tweaks
- `CFS/EEVDF` tweaks
- Using the ["Cake"](https://www.bufferbloat.net/projects/codel/wiki/CakeTechnical/) network queue management system
- Using `vm.max_map_count=16777216` by default
- Cherry-picked patches from [Clear Linux's patchset](https://github.com/clearlinux-pkgs/linux)

#### Optional tweaks
The `customization.cfg` file offers many toggles for extra tweaks:
- `Fsync` and `Futex2`(deprecated) support: can improve the performance in games, needs a patched wine like [wine-tkg](https://github.com/Frogging-Family/wine-tkg-git)
- [Graysky's per-CPU-arch native optimizations](https://github.com/graysky2/kernel_compiler_patch): tunes the compiled code to to a specified CPU
- Compile with GCC or Clang with optional `O2`/`O3` and `LTO` (Clang only) optimizations.
  - **Warning regarding DKMS modules prior to v3.0.2 (2021-11-21) and Clang:** `DKMS` version v3.0.1 and earlier will default to using GCC, which will fail to build modules against a Clang-built kernel. This will - for example - break Nvidia drivers. Forcing older `DKMS` to use Clang can be done but isn't recommended.
- Using [Modprobed-db](https://github.com/graysky2/modprobed-db)'s database can reduce the compilation time and produce a smaller kernel which will only contain the modules listed in it. **NOT recommended**
  - **Warning**: make sure to read [thoroughly about it first](https://wiki.archlinux.org/index.php/Modprobed-db) since it comes with caveats that can lead to an unbootable kernel.
- "Zenify" patchset using core blk, mm and scheduler tweaks from Zen
- `ZFS` FPU symbols (<5.9)
- Overrides for missing ACS capabilities
- [Waydroid](https://wiki.archlinux.org/title/Waydroid) support
- [OpenRGB](https://gitlab.com/CalcProgrammer1/OpenRGB) support
- Provide own kernel `.config` file
- ...
#### User patches

To apply your own patch files using the provided scripts, you will need to put them in a `linux<VERSION><PATCHLEVEL>-tkg-userpatches` folder -- where _VERSION_ and _PATCHLEVEL_ are the kernel version and patch level, as specified in [linux Makefile](https://github.com/torvalds/linux/blob/master/Makefile), the patch works on, _e.g_ `linux65-tkg-userpatches` -- at the same level as the `PKGBUILD` file, with the `.mypatch` extension. The script will by default ask if you want to apply them, one by one. The option `_user_patches` should be set to `true` in the `customization.cfg` file for this to work.


### Install procedure

For all the supported linux distributions, `linux-tkg` has to be cloned with `git`. Since it keeps a clone of the kernel's sources within (`linux-src-git`, created during the first build after a fresh clone), it is recommended to keep the cloned `linux-tkg` folder and simply update it with `git pull`, the install script does the necessary cleanup at every run.

#### Arch & derivatives
```shell
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
makepkg -si
```
The script will use a slightly modified Arch config from the `linux-tkg-config` folder, it can be changed through the `_configfile` variable in `customization.cfg`. The options selected at build-time are installed to `/usr/share/doc/$pkgbase/customization.cfg`, where `$pkgbase` is the package name.

**Note:** the `base-devel` package group is expected to be installed, see [here](https://wiki.archlinux.org/title/Makepkg) for more information.

#### DEB (Debian, Ubuntu and derivatives) and RPM (Fedora, SUSE and derivatives) based distributions

**Important notes:**
An issue has been reported for Ubuntu where the stock kernel cannot boot properly any longer, the whereabouts are not entirely clear (only a single user reported that, see https://github.com/Frogging-Family/linux-tkg/issues/436).

The interactive `install.sh` script will create, depending on the selected distro, `.deb` or `.rpm` packages, move them in the the subfolder `DEBS` or `RPMS` then prompts to install them with the distro's package manager.
```shell
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
./install.sh install
```
Uninstalling custom kernels installed through the script has to be done
manually. `install.sh` can can help out with some useful information:
```shell
cd path/to/linux-tkg
./install.sh uninstall-help
```
The script will use a slightly modified Arch config from the `linux-tkg-config` folder, it can be changed through the `_configfile` variable in `customization.cfg`.

#### Generic install
The interactive `install.sh` script can be used to perform a "Generic" install by choosing `Generic` when prompted. It git clones the kernel tree in the `linux-src-git` folder, patches the code and edits a `.config` file in it. The commands to do are the following:
```shell
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
./install.sh install
```
The script will compile the kernel then prompt before doing the following:
```shell
sudo cp -R . /usr/src/linux-tkg-${kernel_flavor}
cd /usr/src/linux-tkg-${kernel_flavor}
sudo make modules_install
sudo make install
sudo dracut --force --hostonly --kver $_kernelname $_dracut_options
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
**Notes:**
- All the needed dependencies to patch, configure, compile or install the kernel are expected to be installed by the user beforehand.
- If you only want the script to patch the sources in `linux-src-git`, you can use `./install.sh config`
- `${kernel_flavor}` is a default naming scheme but can be customized with the variable `_kernel_localversion` in `customization.cfg`.
- `_dracut_options` is a variable that can be changed in `customization.cfg`.
- `_libunwind_replace` is a variable that can be changed in `customization.cfg` for replacing `libunwind` with `llvm-libunwind`.
- The script uses Arch's `.config` file as a base. A custom one can be provided through `_configfile` in `customization.cfg`.
- The installed files will not be tracked by your package manager and uninstalling requires manual intervention. `./install.sh uninstall-help` can help with useful information if your install procedure follows the `Generic` approach.

#### Gentoo
The interactive `install.sh` script supports Gentoo by following the same procedure as `Generic`, symlinks the sources folder in `/usr/src/` to `/usr/src/linux`, then offers to do an `emerge @module-rebuild` for convenience
```shell
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
./install.sh install
```
**Note:** If you're running openrc, you'll want to set `_configfile="running-kernel"` to use your current kernel's defconfig instead of Arch's. Else the resulting kernel won't boot.
