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
    removepackages = false
    foundpackage = false

    for line in config.readlines()
        if line.include?("environment.systemPackages") == true
            removepackages = true
        elsif removepackages == true && line.include?("];") == true
            removepackages = false
        end

        if line.include?(package) == true && removepackages == true
            processed_line, foundpackage = get_line_without_package(package, line)
            config_string += processed_line
        else
            config_string += line
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

def get_line_without_package(packagename, line)
    combinedchars = ""
    for char in line.chars
        if char == " " || char == "\n" || char == "\t"
            if combinedchars == packagename
                return line.sub(combinedchars, ""), true
            end
            combinedchars = ""
        else
            combinedchars += char
        end
        puts "combined chars: #{combinedchars}"
    end
    return line, false
end
