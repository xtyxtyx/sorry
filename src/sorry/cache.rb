require 'fileutils'

require_relative "./cache.rb"
require_relative "./config.rb"


class Cache
    def file_exists?(filename)
    end

    def add_file(path, filename = nil)
    end

    def get_url(filename)
    end
end


class LocalCache < Cache
    def initialize()
        @temp_folder = Config::CACHE_FOLDER
        @path        = File.expand_path(@temp_folder, "./public/")
    end
    
    # TODO: rewrite this
    def file_exists?(filename)
        File.exists?(@path + '/' + filename)
    end

    def add_file(path, filename = nil)
        FileUtils.cp path, @path
    end

    def get_url(filename)
        "/" + @temp_folder + filename
    end
end