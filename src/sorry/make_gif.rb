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

	def Sorry.make_gif_with_ffmpeg(template_name, sentences, filename)
		$mutex.lock
			$jobs += 1
		$mutex.unlock

		ass_path   = render_ass(template_name, sentences, filename)
		gif_path   = Config::TEMP_FOLDER + filename
		video_path = Config::TEMPLATE_FOLDER + template_name + "/template.mp4"

		cmd = <<-CMD
			ffmpeg \
			-i #{video_path} \
			-r 8 \
			-vf ass=#{ass_path},scale=300:-1 \
			-y \
			#{gif_path}
		CMD

		pid = spawn(cmd, [:out, :err]=>"/dev/null")
		Process.wait pid

		gif_path		
	ensure
		$mutex.lock
			$jobs -= 1
		$mutex.unlock
		puts "[ Current jobs ] #{$jobs}"
	end

	################################

	def Sorry.ass_text(template_name)
		File.read(
			Config::TEMPLATE_FOLDER + template_name + "/template.erb"
		)
	end

	def Sorry.render_ass(template_name, sentences, filename)
		output_file_path = Config::TEMP_FOLDER + filename + ".ass"

		rendered_ass_text =
			ERB.new(ass_text(template_name))
			.result(binding)

		File.write(output_file_path, rendered_ass_text)

		output_file_path
	end

	def render_gif(template_name, sentences)
		filename = calculate_hash(sentences) + ".gif"

		if !$cache.file_exists?(filename)
			if ffmpeg_avaliable?
				path = make_gif_with_ffmpeg(template_name, sentences, filename)
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


	def render_gif_api(template_name, sentences)
		filename = calculate_hash(sentences) + ".gif"

		if !$cache.file_exists?(filename)
			if ffmpeg_avaliable?
				path = make_gif_with_ffmpeg(template_name, sentences, filename)
				$cache.add_file(path)
				File.delete(path)
			else
				return 503, ""
			end
		end

		return 200, $cache.get_url(filename)
	end



	module_function :render_gif
	module_function :render_gif_api
end
