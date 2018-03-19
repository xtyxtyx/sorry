require 'erb'
require 'digest'
require "thread"

require_relative './cache.rb'
require_relative './config.rb'

module Sorry

	$cache = LocalCache.new

	$jobs  = 0
	$mutex = Mutex.new

	def Sorry.calculate_hash(template_dir,sentences)
		Digest::MD5.hexdigest(template_dir + sentences.to_s)
	end

	def Sorry.ffmpeg_avaliable?
		$jobs < Config::MAX_JOBS
	end

	def Sorry.make_gif_with_ffmpeg(template_dir, sentences, filename)
		$mutex.lock
			$jobs += 1
		$mutex.unlock

		gif_path   = "temp/" + filename
		ass_path   = render_ass(template_dir, sentences, filename)
		video_path = template_dir + "template.mp4"

		cmd = <<-CMD
			#{Config::FFMPEG_COMMAND} -i #{video_path} \
			-vf ass=#{ass_path} -y #{gif_path}
		CMD

		pid = spawn(cmd, [:out, :err]=>"/dev/null")
		Process.wait(pid)

		gif_path		
	ensure
		$mutex.lock
			$jobs -= 1
		$mutex.unlock
		puts "[ Current jobs ] #{$jobs}"
	end

	def Sorry.ass_text(template_dir)
		File.read(template_dir + "template.ass")
	end

	def Sorry.render_ass(template_dir, sentences, filename)
		output_file_path = "temp/" + filename + ".ass"

		rendered_ass_text = ERB.new(ass_text(template_dir)).result(binding)

		File.write(output_file_path, rendered_ass_text)

		output_file_path
	end

	def render_gif(template_dir, sentences)
		gif_file = calculate_hash(template_dir, sentences) + ".gif"

		if !$cache.file_exists?(gif_file)
			if ffmpeg_avaliable?
				path = make_gif_with_ffmpeg(template_dir, sentences, gif_file)
				$cache.add_file(path)
				File.delete(path)
			else
				return <<-HTML
				<p>服务器忙！等下说不定就能用了⏳</p>
				HTML
			end
		end

		<<-HTML
		<p><a href="#{$cache.get_url(gif_file)}" target="_blank"><p>点击下载</p></a></p>
		HTML
	end

	def render_gif_api(template_dir, sentences)
		gif_file = calculate_hash(template_dir, sentences) + ".gif"

		if !$cache.file_exists?(gif_file)
			if ffmpeg_avaliable?
				path = make_gif_with_ffmpeg(template_dir, sentences, gif_file)
				$cache.add_file(path)
				File.delete(path)
			else
				return 503, ""
			end
		end

		return 200, $cache.get_url(gif_file)
	end


	module_function :render_gif
	module_function :render_gif_api
end
