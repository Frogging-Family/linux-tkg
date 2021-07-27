## linux-tkg

This repository provides scripts to automatically download, patch and compile the Linux Kernel from [the official Linux git repository](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git), with a selection of patches aiming for better desktop/gaming experience. The provided patches can be enabled/disabled by editing the `customization.cfg` file and/or by following the interactive install script. You can also use your own patches (more information in `customization.cfg` file).

### Important information

- In `intel_pstate` driver, frequency scaling aggressiveness has been changed with kernel 5.5 which results in stutters and poor performance in low/medium load scenarios (for higher power savings). As a workaround for our gaming needs, we are setting it to passive mode to make use of the `acpi_cpufreq` governor passthrough, keeping full support for turbo frequencies. It's combined with our aggressive ondemand governor by default for good performance on most CPUs while keeping frequency scaling for power savings. In a typical low/medium load scenario (Core i7 9700k, playing Mario Galaxy on Dolphin emulator) intel_pstate in performance mode gives a stuttery 45-50 fps experience, while passive mode + aggressive ondemand offers a locked 60 fps.
- Nvidia's proprietary drivers might need to be patched if they don't support your chosen kernel OOTB: [Frogging-Family nvidia-all](https://github.com/Frogging-Family/nvidia-all) can do that automatically for you.
- Note regarding kernels older than 5.9 on Arch Linux: since the switch to `zstd` compressed `initramfs` by default, you will face an `invalid magic at start of compress` error by default. You can workaround the issue by editing `/etc/mkinitcpio.conf` to uncomment the `COMPRESSION="lz4"` (for example, since that's the best option after zstd) line and regenerating `initramfs` for all kernels with `sudo mkinitpcio -P`

### Customization options
#### Alternative CPU schedulers

[CFS](https://en.wikipedia.org/wiki/Completely_Fair_Scheduler) is the only CPU scheduler available in the "vanilla" kernel sources. Its current implementation doesn't allow for injecting additional schedulers, and requires replacing it. Only one scheduler can be patched in at a time.

Alternative schedulers are available to you in linux-tkg:
- Project C / PDS & BMQ by Alfred Chen: [blog](http://cchalpha.blogspot.com/ ), [code repository](https://gitlab.com/alfredchen/projectc)
- MuQSS by Con Kolivas : [blog](http://ck-hack.blogspot.com/), [code repository](https://github.com/ckolivas/linux)
- CacULE by Hamad Marri: [code repository](https://github.com/hamadmarri/cacule-cpu-scheduler)
- Undead PDS: TkG's port of the pre-Project C "PDS-mq" scheduler by Alfred Chen. While PDS-mq got dropped with kernel 5.1 in favor of its BMQ evolution/rework, it wasn't on par with PDS-mq in gaming. "U" PDS still performs better in some cases than other schedulers, so it's been kept undead.

These alternative schedulers can offer a better performance/latency ratio for gaming and desktop use. The availability of each scheduler depends on the chosen Kernel version: the script will display what's available on a per-version basis.
#### Default tweaks
- Memory management and swapping tweaks
- Scheduling tweaks
- `CFS` tweaks
- Using the ["Cake"](https://www.bufferbloat.net/projects/codel/wiki/CakeTechnical/) network queue management system
- Using `vm.max_map_count=524288` by default
- Cherry-picked patches from [Clear Linux's patchset](https://github.com/clearlinux-pkgs/linux)

#### Optional tweaks
The `customization.cfg` file offers many toggles for extra tweaks:
- `Fsync`, `Futex2` and `Fastsync+winesync` support: can improve the performance in games, needs a patched wine like [wine-tkg](https://github.com/Frogging-Family/wine-tkg-git)
- [Graysky's per-CPU-arch native optimizations](https://github.com/graysky2/kernel_compiler_patch): tunes the compiled code to to a specified CPU
- Compile with GCC or Clang with optional `O2`/`O3` and `LTO` (Clang only) optimizations.
  - **Warning regarding DKMS modules and Clang:** `DKMS` will default to using GCC, which will fail to build modules against a Clang-built kernel. This will - for example - break Nvidia drivers. Forcing `DKMS` to use Clang can be done but isn't recommended.
- Using [Modprobed-db](https://github.com/graysky2/modprobed-db)'s database can reduce the compilation time and produce a smaller kernel which will only contain the modules listed in it. **NOT recommended**
  - **Warning**: make sure to read [thoroughly about it first]((https://wiki.archlinux.org/index.php/Modprobed-db)) since it comes with caveats that can lead to an unbootable kernel.
- "Zenify" patchset using core blk, mm and scheduler tweaks from Zen
- [Anbox](https://wiki.archlinux.org/title/Anbox) support (See [Anbox usage](https://github.com/Frogging-Family/linux-tkg#anbox-usage))
- `ZFS` FPU symbols (<5.9)
- Overrides for missing ACS capabilities
- Provide own kernel `.config` file
- ...
#### User patches

To apply your own patch files using the provided scripts, you will need to put them in a `linux5y-tkg-userpatches` folder -- `y` needs to be changed with the kernel version the patch works on, _e.g_ `linux510-tkg-userpatches` -- at the same level as the `PKGBUILD` file, with the `.mypatch` extension. The script will by default ask if you want to apply them, one by one. The option `_user_patches` should be set to `true` in the `customization.cfg` file for this to work.

#### Anbox usage

When enabling the anbox support option, the `binder` and `ashmem` modules are built-in. You don't have to load them. However you'll need to mount binderfs :
```
sudo mkdir /dev/binderfs
sudo mount -t binder binder /dev/binderfs
```

To make this persistent, you can create `/etc/tmpfiles.d/anbox.conf` with the following content :
```
d! /dev/binderfs 0755 root root
```
After which you can add the following to your `/etc/fstab` :
```
binder                         /dev/binderfs binder   nofail  0      0
```

Then, if needed, start the anbox service :
```
systemctl start anbox-container-manager.service
```

You can also enable the service for it to be auto-started on boot :
```
systemctl enable anbox-container-manager.service
```

You're set to run Anbox.
If you prefer automatic setup you can install `anbox-support` from AUR which will take care of everything by itself.


### Install procedure

#### Arch & derivatives
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
makepkg -si
```
The script will use a slightly modified Arch config from the `linux-tkg-config` folder. The options selected at build-time are installed to `/usr/share/doc/$pkgbase/customization.cfg`, where `$pkgbase` is the package name.



#### DEB (Debian, Ubuntu and derivatives) and RPM (Fedora, SUSE and derivatives) based distributions
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
./install.sh install
```
Uninstalling custom kernels installed through the script has to be done
manually. The script can can help out with some useful information:
```
cd path/to/linux-tkg
./install.sh uninstall-help
```
The script will use your current kernel's `.config` file, which will be searched for either at ``/boot/config-`uname -r`.config`` or ``/proc/config.gz`` (otherwise the script won't work as-is). It's recommended to run the script booted on your distro-provided kernel.

#### Void Linux
```
git clone -b tkg https://github.com/Hyper-KVM/void-packages/
cd void-packages
./xbps-src binary-bootstrap
# Optional: edit customization.cfg located in srcpkgs/linux-tkg/files
# Optional: add custom userpatches with the ".mypatch" extension to srcpkgs/linux-tkg/files/mypatches
./xbps-src pkg -j$(nproc) linux-tkg
```
If you have to restart the build for any reason, run `./xbps-src clean linux-tkg` first.

#### Other linux distributions
If your distro is neither DEB nor RPM based, `install.sh` script can clone the kernel tree in the `linux-src-git` folder, patch and edit a `.config` file based on your current kernel's. It's expected either at ``/boot/config-`uname -r`.config`` or ``/proc/config.gz`` (otherwise it won't work as-is).

To do so, run:
```
# Optional: edit the "customization.cfg" file
./install.sh config
```

When selecting `Generic` as distro, `./install.sh install` will compile the kernel then prompt before doing the following:
```shell
sudo make modules_install
sudo make headers_install INSTALL_HDR_PATH=/usr # CAUTION: this will replace files in /usr/include
sudo make install
sudo dracut --force --hostonly --kver $_kernelname
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
**Note:** these changes will not be tracked by your package manager and uninstalling requires manual intervention. `./install.sh uninstall-help` can help with useful information if your install procedure follows the `Generic` approach.
