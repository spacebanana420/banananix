require "./lib/nixconfig.rb"
require "./lib/userhome.rb"
require "./lib/rubygems.rb"

if File.exist?("/etc/nixos/configuration.nix") == false
    puts "File configuration.nix has not been found in '/etc/nixos/', shutting down...\nAre you on NixOS?"
    return
end

while true
  puts "BananaNix - The Banana NixOS Control Center\n\n0. Exit              1. Add package         2. Remove package     3. List installed packages
4. Update system     5. Collect garbage     6. Install Ruby gems  7. Backup home config\n8. Open Nix package search\n\nChoose an operation"

    operation = gets.chomp
    if "012345678".include?(operation) == true && operation != ""
        case operation.to_i
        when 0
            return
        when 1
            puts "Type the name of the package to add or type '0' to exit"; package = gets.chomp
            if package != "0" then nixconfig_add(package) end
        when 2
            puts "Type the name of the package to remove or type '0' to exit"; package = gets.chomp
            if package != "0" then nixconfig_remove(package) end
        when 3
            nixconfig_read()
        when 4
            system("sudo nixos-rebuild switch --upgrade")
        when 5
            system("sudo nix-collect-garbage -d")
        when 6
            install_gems()
        when 7
            get_config_directory()
        when 8
            system("xdg-open https://search.nixos.org/packages?query=")
        end
    end
    puts ""
end
