**Due to intel_pstate poor performances as of late, I have decided to set it to passive mode to make use of the acpi_cpufreq governors passthrough, keeping full support for turbo frequencies.**

## Nvidia prop drivers might need to be patched if they aren't supporting your chosen kernel OOTB (https://github.com/Frogging-Family/nvidia-all can do that automatically for you)


Custom Linux kernels with specific CPU schedulers related patchsets selector (CFS is an option for every kernel) with added tweaks for a nice interactivity/performance balance, aiming for the best gaming experience.
- 5.11.y (Project C / PDS & BMQ, MuQSS)
- 5.10.y (Undead PDS, Project C / PDS & BMQ, MuQSS)
- 5.9.y (Undead PDS, Project C / PDS & BMQ, MuQSS)
- 5.8.y (Undead PDS, Project C / PDS & BMQ)
- 5.7.y (MuQSS, PDS, Project C / BMQ)
- 5.4.y (MuQSS, PDS, BMQ)

MuQSS : http://ck-hack.blogspot.com/

Project C / PDS & BMQ : http://cchalpha.blogspot.com/

Undead PDS: PDS-mq was originally created by Alfred Chen : http://cchalpha.blogspot.com/

While he dropped it with kernel 5.1 in favor of its BMQ evolution/rework, my pretty bad gaming experiences with BMQ up to this point convinced me to keep PDS afloat for as long as it'll make sense/I'll be able to.
Update: Alfred has revived PDS through Project C as of kernel 5.8.0 release.

Various personalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension). The options built with are installed to `/usr/share/doc/$pkgbase/customization.cfg`, where `$pkgbase` is the package name.

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can optionally enable support for it at the beginning of the PKGBUILD file. **Make sure to read everything you need to know about it as there are big caveats making it NOT recommended for most users**.

**Note regarding kernels older than 5.9 on Archlinux:**
**Since the switch to zstd compressed initramfs by default, you will face an "invalid magic at start of compress" error by default. You can workaround the issue by editing `/etc/mkinitcpio.conf` to uncomment the `COMPRESSION="lz4"` (for example, since that's the best option after zstd) line and regenerating for all kernels with `sudo mkinitpcio -P`.**


### Anbox usage

When enabling the anbox support option, the modules are built-in. You don't have to load them. However you'll need to mount binderfs :
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
- **optional** Fsync support (proton)
- **optional** futex2 support (proton)
- **optional** Anbox support (binder, ashmem)
- **optional** ZFS fpu symbols (<5.9)

## Install procedure

### Arch & derivatives
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit customization.cfg file
makepkg -si
```

### DEB (Debian, Ubuntu and derivatives) and RPM (Fedora, SUSE and derivatives) based distributions
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit customization.cfg file
./install.sh install
```
Uninstalling custom kernels installed through the script has to be done 
manually. The script can can help out with some useful information:
```
cd path/to/linux-tkg
./install.sh uninstall-help
```

### Void Linux
```
git clone -b tkg https://github.com/Hyper-KVM/void-packages/
cd void-packages
./xbps-src binary-bootstrap
# Optional: edit customization.cfg located in srcpkgs/linux-tkg/files
# Optional: add custom userpatches with the ".mypatch" extension to srcpkgs/linux-tkg/files/mypatches
./xbps-src pkg -j$(nproc) linux-tkg
```
If you have to restart the build for any reason, run `./xbps-src clean linux-tkg` first.

### Other linux distributions
If your distro is not DEB or RPM based, `install.sh` script can clone the kernel tree in the `linux-src-git` folder, patch and edit a `.config` file from the one that your current distro uses. It is expected either at ``/boot/config-`uname -r`.config`` or ``/proc/config.gz`` (otherwise it won't work as-is).

The command to do for that is:
```
./install.sh config
```

If one chooses `Generic` as distro. `./install.sh install` will compile the kernel then prompt before doing the following:
```shell
sudo make modules_install
sudo make headers_install INSTALL_HDR_PATH=/usr # CAUTION: this will replace files in /usr/include
sudo make install
sudo dracut --force --hostonly --kver $_kernelname
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
**Note:** these changes will not be tracked by your package manager and uninstalling requires manual intervention.

