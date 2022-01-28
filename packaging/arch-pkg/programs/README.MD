# Program Packaging (.tar.pkg.zst)
This directory contains the program packaging script for Arch Linux and derivatives (e.g. Manjaro).

## Usage
Simply run the script, passing the name of the program you would like to build, relative to the repository's root.

For example:
```bash
./packprog.sh shell/run shell/winver
```

This will build and output packages for the `run` and `winver` programs. You can then install the package(s) with:
```bash
sudo pacman -U <package name>.pkg.tar.zst
```

## Any Problems?
If you have not already installed any required `libwintc-*` dependencies for the package/packages you are building, `makepkg`, which `packlibs.sh` wraps, will print an error, and you must build and install that dependency's package first. After that point, log files are generated as part of `makepkg`'s build process, review them to troubleshoot other problems.

For example, `libwintc-comgtk` and `libwintc-exec` must be installed before `run` can be compiled. For directions, read the [libs installation README](https://github.com/rozniak/xfce-winxp-tc/tree/master/packaging/arch-pkg/libs).

If you have any other problems, feel free to [submit an issue](https://github.com/rozniak/xfce-winxp-tc/issues) and include the generated log file. 😁
