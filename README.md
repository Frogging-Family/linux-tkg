## linux-tkg

This repository provides scripts to automatically download, patch and compile the Linux Kernel from [the official Linux git repository](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git), with extra select patches that aim for better desktop/gaming performance. Users can customize which patches are added to the "vanilla" sources by editing the file `customization.cfg` and/or by following the interactive install script. Users can also provide their own patches: more information is available in the file `customization.cfg`.

### Important information

- Due to `intel_pstate`'s poor performance as of late, it is set it to passive mode to make use of the `acpi_cpufreq` governor passthrough, keeping full support for turbo frequencies.

- Nvidia's proprietary drivers might need to be patched if they don't support your chosen kernel OOTB: [Frogging-Family nvidia-all](https://github.com/Frogging-Family/nvidia-all) can do that automatically for you.

---------------------
### Customization options
#### Alternative CPU schedulers

CFS is the only scheduler available in the "vanilla" kernel sources. Additional schedulers are provided: they can offer a better interactivity/throughput ratio that can be beneficial for gaming. The kernel can be compiled with one of the following alternative schedulers:
- 5.10rc: Undead PDS, Project C / PDS or BMQ, MuQSS, CFS
- 5.9.y: Undead PDS, Project C / PDS or BMQ, MuQSS, CFS
- 5.8.y: Undead PDS, Project C / PDS or BMQ, CFS
- 5.7.y: MuQSS, PDS, Project C / BMQ, CFS
- 5.4.y: MuQSS, PDS, BMQ, CFS

**More informaiton about the alternative schedulers:**
- MuQSS by ck : http://ck-hack.blogspot.com/
- Project C / PDS & BMQ by Alfred Chen, http://cchalpha.blogspot.com/
- Undead PDS: derived from PDS-mq by TKG, the ancestor of Project C PDS. While it got dropped with kernel 5.1 in favor of its BMQ evolution/rework, it wasn't on par PDS-mq in gaming, PDS will be kept afloat for as long as it remains possible and makes sense.

#### User patches

To apply your own patch files using the provided scripts, you will need to put them in a `linux5y-tkg-userpatches` folder -- `y` needs to be changed with the kernel version the patch works on, _e.g_ `linux510-tkg-userpatches` -- at the same level as the `PKGBUILD` file, with the `.mypatch` extension. The script will by default ask if you want to apply them, one by one. The option `_user_patches` should be set to `true` in the `customization.cfg` file for this to work.
#### Modprobed-db

If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can optionally enable support for it in the `customization.cfg` file. **Make sure to read everything you need to know about it as there are big caveats making it NOT recommended for most users**.

#### Misc additions:
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
- **optional** ZFS fpu symbols (<5.9)

-------------
### Install procedure

#### Arch & derivatives
```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg
# Optional: edit customization.cfg file
makepkg -si
```
The script will use a slightly modified Arch config, that is in the `linux-tkg-config` folder. The options built with are installed to `/usr/share/doc/$pkgbase/customization.cfg`, where `$pkgbase` is the package name.



#### DEB (Debian, Ubuntu and derivatives) and RPM (Fedora, SUSE and derivatives) based distributions
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
The script will use the `.config` file from the one that your current distro uses, that is expected either at ``/boot/config-`uname -r`.config`` or ``/proc/config.gz`` (otherwise the script won't work as-is). It is recommended to run the script on the kernel your distro is providing.

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
If your distro is not DEB or RPM based, `install.sh` script can clone the kernel tree, patch and edit a `.config` file from the one that your current distro uses. It is expected either at ``/boot/config-`uname -r`.config`` or ``/proc/config.gz`` (otherwise it won't work as-is).

The command to do for that is:
```
./install.sh config
```
