require 'erb'
require 'digest'
require "thread"

require_relative './cache.rb'
require_relative './config.rb'

module Sorry

	$cache = LocalCache.new

	def Sorry.calculate_hash(sentences)
		Digest::MD5.hexdigest sentences.to_s
	end

	######################

	$jobs  = 0
	$mutex = Mutex.new

	def Sorry.ffmpeg_avaliable?
		$jobs < Config::MAX_JOBS
	end

	def Sorry.make_gif_with_ffmpeg(sentences, filename)
		$mutex.lock
			$jobs += 1
		$mutex.unlock

		ass_path = render_ass(sentences, filename)
		path =  Config::TEMP_FOLDER + filename

		cmd = <<-CMD
			ffmpeg \
			-i #{Config::TEMPLATE_VIDEO} \
			-r 6 \
			-vf ass=#{ass_path},scale=300:-1 \
			-y \
			#{path}
		CMD

		pid = spawn(cmd, [:out, :err]=>"/dev/null")
		Process.wait pid

		$mutex.lock
			$jobs -= 1
		$mutex.unlock
		p "[ Current jobs ] #{$jobs}"

		path
	end

	################################

	def Sorry.render_ass(sentences, filename)
		path = Config::TEMP_FOLDER + filename + ".ass"

		ass_text = ERB.new(File.read Config::TEMPLATE_SUBTITLE).result binding

		File.write(path, ass_text)

		path
	end

	def render_gif(sentences)
		filename = calculate_hash(sentences) + ".gif"

		if !$cache.file_exists?(filename)
			if ffmpeg_avaliable?
				path = make_gif_with_ffmpeg(sentences, filename)
				$cache.add_file(path)
				File.delete(path)
			else
				return <<-HTML
				<p>服务器忙！等下说不定就能用了⏳</p>
				HTML
			end
		end

		<<-HTML
		<p><a href="#{$cache.get_url(filename)}" target="_blank"><p>点击下载</p></a></p>
		HTML
	end

	module_function :render_gif
end
