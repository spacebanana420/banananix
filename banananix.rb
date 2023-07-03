require "./lib/nixconfig.rb"
require "./lib/userhome.rb"

if File::exist?("/etc/nixos/configuration.nix") == false
    puts "File configuration.nix has not been found in /etc/nixos\nAre you on NixOS?"
    return
end

while true
  puts "0. Exit     1. Add package     2. Remove package     3. Check installed packages
4. Update system     5. Collect garbage     6. Backup home config\n\nChoose an operation"

    operation = gets.chomp
    case operation.to_i
    when 0
        return
    when 1
        puts "Type the name of the package to add"; package = gets.chomp
        nixconfig_add(package)
    when 2
        puts "Type the name of the package to remove"; package = gets.chomp
        nixconfig_remove(package)
    when 3
        nixconfig_read()
    when 4
        system("sudo nixos-rebuild switch --upgrade")
    when 5
        system("sudo nix-collect-garbage -d")
    when 6
        get_config_directory()
    end
    puts ""
end
