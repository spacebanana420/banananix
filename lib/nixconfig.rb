def nixconfig_read()
    config = File::open("/etc/nixos/configuration.nix")
    config_string = ""
    packages = ""
    addpackages = false

    while config.eof? == false
        line = config.readline
        config_string += line

        if line.include?("environment.systemPackages") == true
            addpackages = true
        elsif addpackages == true && line == "];"
            addpackages = false
        elsif addpackages == true && line.include?("];") == true
            addpackages = false
            packages += line.sub("];", "")
        end

        if addpackages == true && line.include?("environment.systemPackages") == false && line.include?("#") == false
            packages += line
        end
    end
    #for package in packages
        #packages[packages.length-1].sub!("\n", "")
        #package.sub!("\n", "")
    #end
    puts "List of packages in configuration.nix:\n#{packages}"
end

def nixconfig_check(package)
    config = File::open("/etc/nixos/configuration.nix")
    addpackages = false

    while config.eof? == false
        line = config.readline

        if line.include?("environment.systemPackages") == true
            addpackages = true
        elsif addpackages == true && line.include?("];") == true
            addpackages = false
        end

        if addpackages == true && line.include?("environment.systemPackages") == false && line.include?("#") == false && line.include?(package) == true
            return true
        end
    end
    return false
end

def nixconfig_add(package)
    if nixconfig_check(package) == true
        puts "Package '#{package}' already exists on configuration.nix!"
        return
    end
    config = File::open("/etc/nixos/configuration.nix")
    config_string = ""

    while config.eof? == false
        line = config.readline

        config_string += line
        if line.include?("environment.systemPackages") == true
            config_string += "\n" + package + "\n"
        end
    end

    File::rename("/etc/nixos/configuration.nix", "/etc/nixos/configuration.nix.bak")
    File::write("/etc/nixos/configuration.nix", config_string)
    puts "Package '#{package}' has been added to configuration.nix"
end

def nixconfig_remove(package)
    config = File::open("/etc/nixos/configuration.nix")
    config_string = ""
    addpackages = false
    foundpackage = false

    while config.eof? == false
        line = config.readline

        if line.include?("environment.systemPackages") == true
            addpackages = true
        elsif addpackages == true && line.include?("];") == true
            addpackages = false
        end

        if line.include?(package) == false || addpackages == false
            config_string += line
        elsif line == package
            config_string += line.sub(package, "")
            foundpackage = true
        else
            foundpackage = true
        end
    end

    if foundpackage == true
        File::rename("/etc/nixos/configuration.nix", "/etc/nixos/configuration.nix.bak")
        File::write("/etc/nixos/configuration.nix", config_string)
        puts "Package '#{package}' has been removed from configuration.nix"
    else
        puts "The package '#{package}' has not been found in configuration.nix!"
    end
end
