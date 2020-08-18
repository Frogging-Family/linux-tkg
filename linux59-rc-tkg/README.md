**Due to intel_pstate poor performances as of late, I have decided to set it to passive mode to make use of the acpi_cpufreq governors passthrough, keeping full support for turbo frequencies.**

### PDS, MuQSS and BMQ are not yet available options for this revision
## Nvidia prop drivers need to be patched (https://github.com/Frogging-Family/nvidia-all can do that automatically for you)

A custom Linux kernel 5.9 RC with added tweaks for a nice interactivity/performance balance, aiming for the best gaming experience.

Various personalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can enable support for it at the beginning of the PKGBUILD file. Make sure to read everything you need to know about it.

## Other stuff included:
- Graysky's per-CPU-arch native optimizations - https://github.com/graysky2/kernel_gcc_patch
- memory management and swapping tweaks
- scheduling tweaks
- optional "Zenify" patchset using core blk, mm and scheduler tweaks from Zen
- CFS tweaks
- using yeah TCP congestion algo by default
- using cake network queue management system
- using vm.max_map_count=524288 by default
- cherry-picked clear linux patches
- **optional** overrides for missing ACS capabilities
- **optional** ZFS fpu symbols


## Install procedure

### Arch & derivatives
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg/linux59-rc-tkg
# Edit customization.cfg file
makepkg -si
```

### Ubuntu & derivatives
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg/linux59-rc-tkg
# Edit customization.cfg file to at least set _distro to "Ubuntu"
./install.sh install
```
To uninstall custom kernels installed through the script:
```
cd path/to/linux-tkg/linux59-rc-tkg
./install.sh uninstall
```

### Other linux distributions
Other distros are not supported, Debian may work with the `install.sh` script. Otherwise,
that same `install.sh` script can clone, patch and edit a `.config` file from your current distro's
that is expected at ``/boot/config-`uname -r`.config``. Otherwise it won't work as-is.

The command to do for that is:
```
./install.sh config
```
