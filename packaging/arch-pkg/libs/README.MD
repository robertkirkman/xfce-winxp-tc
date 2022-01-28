# Shared Library Packaging (.pkg.tar.zst)
This directory contains the shared library packaging script for Arch Linux and derivatives (e.g. Manjaro).

## Usage
Simply run the script, passing the name of the library/libraries you would like to build.

For example:
```bash
./packlibs.sh comgtk
```

This will build packages for `libwintc-comgtk` and `libwintc-exec`. You can then install the package(s) with:
```bash
sudo pacman -U <package name>.pkg.tar.zst
```

## Any Problems?
If you have not already installed any required `libwintc-*` dependencies for the library/libraries you are building, `makepkg`, which `packlibs.sh` wraps, will print an error, and you must build and install that dependency's package first. After that point, log files are generated as part of `makepkg`'s build process, review them to troubleshoot other problems.

For example, `libwintc-comgtk` must be installed before `exec` can be compiled. To do so, first build `comgtk`:
```bash
./packlibs.sh comgtk
```
Then, install it using `pacman`:
```bash
sudo pacman -U libwintc-comgtk-<version>.pkg.tar.zst
```
Finally, `exec` can be built:
```bash
./packlibs.sh exec
```

If you have any other problems, feel free to [submit an issue](https://github.com/rozniak/xfce-winxp-tc/issues) and include the generated log file. 😁
