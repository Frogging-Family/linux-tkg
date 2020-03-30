A custom Linux kernel 4.19.y with specific PDS and MuQSS CPU schedulers related patchsets selector (stock CFS is also an option) and added tweaks for a nice interactivity/performance balance, aiming for the best gaming experience.

Various personalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

PDS-mq : http://cchalpha.blogspot.com/

MuQSS : http://ck-hack.blogspot.com/

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can enable support for it at the beginning of the PKGBUILD file. Make sure to read everything you need to know about it.

While using PDS, priority policies might induce thrashing in memory-starved scenarios. Using https://github.com/tobixen/thrash-protect (available on AUR as well) can remedy that.

## Other stuff included:
- Per-CPU-arch native optimizations
- built-in -O3 optimization and -O3 specific fixes
- memory management and swapping tweaks
- scheduling tweaks
- using prefered raid6 gen function directly
- using lz4 algo for zswap by default
- built-in Thinkpad hardware functions driver / embedded controller LPC3 functions / SMAPI support
- absolute mode for adb trackpads
- optional "Zenify" patchset using core blk, mm and scheduler tweaks from Zen
- CFS tweaks
- using yeah TCP congestion algo by default
- using cake network queue management system
- using vm.max_map_count=262144 by default
- intel E1000 fixes
- cherry-picked clear linux patches
- **optional** overrides for missing ACS capabilities
- **optional** umip-instruction-emulation support
- **optional** bcachefs support
- **optional** uksm support
- **optional** linux-hardened patchset and configuration
