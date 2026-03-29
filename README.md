# Linux-tkg

This repository provides scripts to automatically download, patch and compile any version ≥ 5.4 of the Linux Kernel.

`linux-tkg` also ships with a selection of patches that can improve the desktop/gaming experience: most can be toggled by editing the [customization.cfg](./customization.cfg) file, or by simply following the interactive install script.

- [Linux-tkg](#linux-tkg)
  - [Important information](#important-information)
  - [Customization options](#customization-options)
    - [Default tweaks](#default-tweaks)
    - [CPU task schedulers](#cpu-task-schedulers)
      - [Runtime scheduler change: sched-ext](#runtime-scheduler-change-sched-ext)
      - [Build-time default scheduler](#build-time-default-scheduler)
    - [Optional tweaks](#optional-tweaks)
    - [Bring your own patches](#bring-your-own-patches)
  - [Install procedure](#install-procedure)
    - [Arch \& derivatives](#arch--derivatives)
    - [DEB and RPM based distributions](#deb-and-rpm-based-distributions)
    - [Generic install](#generic-install)
    - [Gentoo](#gentoo)

## Important information

- **Non-pacman distros support can be considered experimental. You're invited to report issues you might encounter with it.**
- **If your distro isn't using systemd, please set _configfile="running-kernel" in customization.cfg or you might end up with a non-bootable kernel**
- Building recent linux kernels with GCC will require ~20-25GB of disk space. Using llvm/clang, LTO, ccache and/or enabling more drivers in the defconfig will push that requirement higher, so make sure you have enough free space on the volume you're using to build.
- Nvidia drivers might need to be patched to cleanly build/work on latest kernels.
  - For Arch users: [Frogging-Family nvidia-all](https://github.com/Frogging-Family/nvidia-all) is there for that :frog:

## Customization options

Most customizations can be toggled by:

- Editing the variables in [customization.cfg](./customization.cfg), those values can be overridden by (in increasing priority)
  - An external config file, as defined the `_EXT_CONFIG_PATH` variable (defaults to `~/.config/frogminer/linux-tkg.cfg`)
  - Setting the variables in the shell environment.
- Following the interactive install script (it does _not_ prompt for all of them).

### Default tweaks

These tweaks cannot be disabled with a toggle and come default-enabled.

- Memory management and swapping tweaks
- Scheduling tweaks
- `CFS/EEVDF` tweaks
- Using the ["Cake"](https://www.bufferbloat.net/projects/codel/wiki/CakeTechnical/) network queue management system
- Using `vm.max_map_count=16777216` by default
- Cherry-picked patches from [Clear Linux's patchset](https://github.com/clearlinux-pkgs/linux)
- Default `intel_pstate=passive` kernel option for Intel CPUs
  - Default frequency scaling aggressiveness with kernel ≥ 5.5 is conservative, which results in stutters and poor performance in low/medium load scenarios (for better power saving).
  - `intel_pstate=passive` make's use of the `acpi_cpufreq` governor passthrough, keeping full support for turbo frequencies.
  - It's combined with our aggressive `ondemand` governor by default for good performance while still preserving power.

### CPU task schedulers

Since a computer runs more "tasks" than there are cores, a CPU task scheduler is the algorithm that decides which one runs when, for how long, on which core. Those decisions can have an impact on throughput (how many things get done globally per unit of time), and latency (how long tasks have to wait before running again). Gaming is generally more sensitive to latency and some schedulers can be more more adapted for that.

#### Runtime scheduler change: sched-ext

Starting kernel ≥ 6.12, it's possible to switch CPU schedulers at runtime while keeping the kernel's built-in default scheduler one as fallback/backup, using [sched-ext](https://github.com/sched-ext/scx).

`sched-ext` offers various schedulers, `LAVD` is geared towards gaming workloads and used by Steam's Deck handheld console.

Arch users get scx schedulers from the `scx-scheds` package or on the [AUR](https://aur.archlinux.org/packages/scx-scheds-git) thanks to @sirlucjan.

For persistence of the chosen runtime scheduler upon reboots:

- set scheduler in `/etc/default/scx`
- enable the `scx` service `systemctl enable scx`.

#### Build-time default scheduler

[EEVDF](https://lwn.net/Articles/925371/) is the only CPU scheduler available in the "vanilla" kernel sources ≥ 6.6. Whereas [CFS](https://en.wikipedia.org/wiki/Completely_Fair_Scheduler) for earlier kernel versions.

Alternative default schedulers are optionally available in linux-tkg at build time:

- BORE (Burst-Oriented Response Enhancer) by Masahito Suzuki - CFS/EEVDF based : [code repository](https://github.com/firelzrd/bore-scheduler)
- Project C / PDS & BMQ by Alfred Chen: [blog](http://cchalpha.blogspot.com/ ), [code repository](https://gitlab.com/alfredchen/projectc)
- MuQSS by Con Kolivas : [blog](http://ck-hack.blogspot.com/), [code repository](https://github.com/ckolivas/linux)
- Undead PDS : TkG's port of the pre-Project C "PDS-mq" scheduler by Alfred Chen. While PDS-mq got dropped with kernel 5.1 in favor of its BMQ evolution/rework, it wasn't on par with PDS-mq in gaming. "U" PDS still performed better in some cases than other schedulers, so it's been kept undead for a while.

These alternative schedulers may offer a better performance/latency ratio in some scenarios. The availability of each scheduler depends on the chosen Kernel version: the script will display what's available on a per-version basis.

### Optional tweaks

The `customization.cfg` file offers many toggles for extra tweaks:

- [NTsync](https://repo.or.cz/linux/zf.git/shortlog/refs/heads/ntsync5), `Fsync` and `Futex2`(deprecated) support: can improve the performance in games, needs a patched wine like [wine-tkg](https://github.com/Frogging-Family/wine-tkg-git)
- [Graysky's per-CPU-arch native optimizations](https://github.com/graysky2/kernel_compiler_patch): tunes the compiled code to to a specified CPU
- Compile with GCC or Clang with optional `O2`/`O3` and `LTO` (Clang only) optimizations.
  - **Warning regarding DKMS modules prior to v3.0.2 (2021-11-21) and Clang:** `DKMS` version v3.0.1 and earlier will default to using GCC, which will fail to build modules against a Clang-built kernel. This will - for example - break Nvidia drivers. Forcing older `DKMS` to use Clang can be done but isn't recommended.
- Using [Modprobed-db](https://github.com/graysky2/modprobed-db)'s database can reduce the compilation time and produce a smaller kernel which will only contain the modules listed in it. **NOT recommended**
  - **Warning**: make sure to read [thoroughly about it first](https://wiki.archlinux.org/index.php/Modprobed-db) since it comes with caveats that can lead to an unbootable kernel.
- "Zenify" patchset using core blk, mm and scheduler tweaks from Zen
- `ZFS` FPU symbols (<5.9)
- Overrides for missing ACS capabilities
- [OpenRGB](https://gitlab.com/CalcProgrammer1/OpenRGB) support
- Provide own kernel `.config` file
- ...

### Bring your own patches

To apply your own patches with `linux-tkg`:

- Create a `linuxXY-tkg-userpatches` folder at the root of the clone
  - where `X` and `Y` specify the kernel version the patches applies to.
    - Examples: `linux65-tkg-userpatches`, `linux618-tkg-userpatches`
- Set `_user_patches=true` in your customization file.
- Drop your patches within that folder the `.mypatch` extension.

The install script will then find them, and ask if you want to apply each patch.

## Install procedure

For all the supported linux distributions, `linux-tkg` has to be cloned with `git`. Since it keeps a clone of the kernel's sources within (`linux-src-git`, created during the first build after a fresh clone), it is recommended to keep the cloned `linux-tkg` folder and simply update it with `git pull`, the install script does the necessary cleanup at every run.

### Arch & derivatives

```shell
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
makepkg -si
```

The script will use a slightly modified Arch config from the `linux-tkg-config` folder, it can be changed through the `_configfile` variable in `customization.cfg`. The options selected at build-time are installed to `/usr/share/doc/$pkgbase/customization.cfg`, where `$pkgbase` is the package name.

**Note:** the `base-devel` package group is expected to be installed, see [here](https://wiki.archlinux.org/title/Makepkg) for more information.

### DEB and RPM based distributions

The interactive `install.sh` script will create, depending on the selected distro, `.deb` or `.rpm` packages, move them in the the subfolder `DEBS` or `RPMS` then prompts to install them with the distro's package manager.

- `.deb` packages: for Debian, Ubuntu...
- `.rpm` packages: Fedora, RHEL, SUSE...

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

### Generic install

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
```

**Notes:**

- All the needed dependencies to patch, configure, compile or install the kernel are expected to be installed by the user beforehand.
- If you only want the script to patch the sources in `linux-src-git`, you can use `./install.sh config`
- `${kernel_flavor}` is a default naming scheme but can be customized with the variable `_kernel_localversion` in `customization.cfg`.
- `_dracut_options` is a variable that can be changed in `customization.cfg`.
- `_libunwind_replace` is a variable that can be changed in `customization.cfg` for replacing `libunwind` with `llvm-libunwind`.
- The script uses Arch's `.config` file as a base. A custom one can be provided through `_configfile` in `customization.cfg`.
- The installed files will not be tracked by your package manager and uninstalling requires manual intervention.
  `./install.sh uninstall-help` can help with useful information if your install procedure follows the `Generic` approach.
- Installing the kernel with `make install` calls `/sbin/installkernel` (see [here](https://docs.kernel.org/kbuild/kbuild.html#installkernel)) to put the kernel at the right place and trigger an initramfs (and UKI) generation,
  check your distro's documentation on how to configure it to your needs
  - [arch](https://wiki.archlinux.org/title/Kernel-install)
  - [gentoo](https://wiki.gentoo.org/wiki/Installkernel)

### Gentoo

The interactive `install.sh` script supports Gentoo by following the same procedure as `Generic`, with minor additions

1. Applies few Gentoo patches
   - `https://dev.gentoo.org/~mpagano/genpatches/trunk/$kver/4567_distro-Gentoo-Kconfig.patch`
   - `https://dev.gentoo.org/~mpagano/genpatches/trunk/$kver/3000_Support-printing-firmware-info.patch`
2. Symlinks the newly installed `/usr/src/linux-tkg-${kernel_flavor}` src folder to `/usr/src/linux`
3. Offers to do a `emerge @module-rebuild` for convenience

```shell
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit the "customization.cfg" file
./install.sh install
```

**Notes:**

- On OpenRC, in case of boot issues, try setting `_configfile="running-kernel"` in `customization.cfg`.
  - This will use the running kernel's `.config` file instead of Arch's.
