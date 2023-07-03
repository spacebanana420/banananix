def get_config_directory()
    homefolders = Dir::children("/home")
    if homefolders.length == 1
        homefolder = homefolders[0]
    else
        homefolder = get_home_folders(homefolders)
    end
    folders = Dir::children("/home/#{homefolder}/.config")
    puts "List of contents in .config:\n#{folders}\n\nCopying data..."

    backupfolder("/home/#{homefolder}/.config", ".config")
    File::rename(".config", "#{homefolder} config backup")
    puts "Data copied!\nUser config folder saved in current directory as '#{homefolder} config backup'"
end

def get_home_folders(homefolders)
    count = 0
    for folder in homefolders
        puts "#{count}: folder"
        count += 1
    end
    puts "Choose a folder"
    choice = gets.chomp.to_i
    return homefolders[choice]
end


def backupfolder(currentdir, first)
    if Dir::exist?(first) == false
        Dir::mkdir(first)
    end
    paths = Dir::children(currentdir)
    for path in paths
        if File::file?("#{currentdir}/#{path}") == true
            File::write("#{first}/#{path}", File::read("#{currentdir}/#{path}"))
        else
            backupfolder("#{currentdir}/#{path}", "#{first}/#{path}")
        end
    end
end
