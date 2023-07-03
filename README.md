# Banananix
Banananix is a frontend tool for NixOS's package management and other system management tasks. Most of its capabilities are meant to be used with NixOS.

Banananix basically adds a TUI interface to add, list and remove packages from your configuration.nix in `environment.systemPackages`

You can also backup your home users' .config folder

# How to use

You need Ruby to use my program

* Add to your configuration.nix:
```nix
environment.systemPackages = with pkgs; [ruby];
```
You can also choose a specific version of Ruby if the default isn't the latest (for example `ruby_3_2_2`)

* Download my program from the releases once it gets a stable release or download directly from the master branch

* Open a terminal in the same directory as banananix.rb and launch my program with `ruby banananix.rb`
