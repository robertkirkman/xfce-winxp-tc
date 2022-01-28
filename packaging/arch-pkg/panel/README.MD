# XFCE Panel Plugin Packaging (.tar.pkg.zst)
This directory contains the XFCE panel plugin packaging script for Arch Linux and derivatives (e.g. Manjaro).

## Usage
Simply run the script, passing the name of the panel plugin you would like to build, relative to the repository's root.

For example:
```bash
./packplug.sh shell/start shell/systray
```

This will build and output packages for the Start menu and notification area panel plugins. You can then install the package(s) with:
```bash
sudo pacman -U <package name>.pkg.tar.zst
```

## Any Problems?
If you have not already installed any required `libwintc-*` dependencies for the package/packages you are building, `makepkg`, which `packlibs.sh` wraps, will print an error, and you must build and install that dependency's package first. After that point, log files are generated as part of `makepkg`'s build process, review them to troubleshoot other problems.

If you have any other problems, feel free to [submit an issue](https://github.com/rozniak/xfce-winxp-tc/issues) and include the generated log file. 😁
