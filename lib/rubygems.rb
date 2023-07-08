def get_installed_gems()
    gemlist = `gem list`; gems = Array.new(); chars = ""

    for char in gemlist.chars
        if char == "\n"
            gems.push(chars)
            chars = ""
        else
            chars += char
        end
    end
    return gems
end


def parse_config_gem(line)
    gem = ""
    if line.include?("true") == true
        installgem = true
    else
        installgem = false
    end
    for char in line.chars
        if char == ":"
            break
        end
        gem += char
    end
    return gem, installgem
end

def get_config_gems()
    gemlist = File.readlines("gemconfig"); gems = Array.new(); gems_condition = Array.new()

    for line in gemlist
        if line.include?("#") == false
            gem, condition = parse_config_gem(line)
            gems.push(gem); gems_condition.push(condition)
        end
    end
    return gems, gems_condition
end

def install_gems()
    if File.file?("gemconfig") == false
        puts "There is no gemconfig in the root folder on banananix!\nCreate a text file named 'gemconfig' and for each line write the name of your gems alongside the condition to install or uninstall\n\nExample of a gemconfig:\n\nrubyzip: true\nmini_magick: false\n\nThe gem 'rubyzip' will be installed if not already and the gem mini_magick will be uninstalled if it's currently installed\nYou can also start the lines wiht '#' to introduce comments, descriptions, etc which will be ignored by banananix"
        return
    end
    config_gems, config_gems_condition = get_config_gems()
    installed_gems = get_installed_gems()

    iterate = 0
    for cfggem in config_gems
        installed = false
        for installgem in installed_gems
            if installgem.include?(cfggem) == true
                installed = true
                break
            end
        end
        if installed == false && config_gems_condition[iterate] == true
            puts "Installing gem: #{cfggem}"
            system("gem install #{cfggem}")
        elsif installed == true && config_gems_condition[iterate] == false
            puts "Uninstalling gem: #{cfggem}"
            system("gem uninstall #{cfggem}")
        end
        iterate+=1
    end
end
