**Due to intel_pstate poor performances as of late, I have decided to set it to passive mode to make use of the acpi_cpufreq governors passthrough, keeping full support for turbo frequencies.**

### MuQSS is not yet an available option for this revision

A custom Linux kernel 5.7 RC with specific PDS and BMQ CPU schedulers related patchsets selector (stock CFS is also an option) and added tweaks for a nice interactivity/performance balance, aiming for the best gaming experience.

Various personalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

BMQ : http://cchalpha.blogspot.com/

PDS-mq was originally created by Alfred Chen : http://cchalpha.blogspot.com/

While he dropped it with kernel 5.1 in favor of its BMQ evolution/rework, my pretty bad gaming experiences with BMQ up to this point convinced me to keep PDS afloat for as long as it'll make sense/I'll be able to.

Various personalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can enable support for it at the beginning of the PKGBUILD file. Make sure to read everything you need to know about it.

## Other stuff included:
- Per-CPU-arch native optimizations
- memory management and swapping tweaks
- scheduling tweaks
- optional "Zenify" patchset using core blk, mm and scheduler tweaks from Zen
- CFS tweaks
- using yeah TCP congestion algo by default
- using cake network queue management system
- using vm.max_map_count=262144 by default
- cherry-picked clear linux patches
- **optional** overrides for missing ACS capabilities
- **optional** ZFS fpu symbols
- **optional** Fsync support (proton)

```
git clone https://github.com/Frogging-Family/linux-tkg.git
cd linux-tkg/linux57-rc-tkg
makepkg -si
```
