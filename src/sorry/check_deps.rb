require_relative "./config.rb"

# 检查依赖的安装情况

module DepsChecker
    def DepsChecker.check_ffmpeg
        if system "#{Config::FFMPEG_COMMAND} -version"
            return
        end

        print <<-MSG
看起来系统中没有安装ffmpeg😥        

安装方式：
# Ubuntu
apt install ffmpeg

# CentOS
yum install ffmpeg
MSG
        exit
    end

    def check_all()
        check_ffmpeg()
    end

    module_function :check_all
end