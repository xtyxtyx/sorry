require 'erb'
require 'digest'

require_relative './cache.rb'

module Sorry

	$cache = LocalCache.new

	def Sorry.calculate_hash(sentences)
		Digest::MD5.hexdigest sentences.to_s
	end

	def Sorry.make_gif_with_ffmpeg(sentences, filename)
		ass_path = render_ass(sentences, filename)
		path =  Config::TEMP_FOLDER + filename

		cmd = <<-CMD
			ffmpeg \
			-i #{Config::TEMPLATE_VIDEO} \
			-r 7 \
			-vf ass=#{ass_path},scale=500:-1 \
			-y \
			#{path}
		CMD

		pid = spawn(cmd, [:out, :err]=>"/dev/null")
		Process.wait pid

		path
	end

	def Sorry.render_ass(sentences, filename)
		path = Config::TEMP_FOLDER + filename + ".ass"

		ass_text = ERB.new(File.read Config::TEMPLATE_SUBTITLE).result binding

		File.write(path, ass_text)

		path
	end

	def render_gif(sentences)
		filename = calculate_hash(sentences) + ".gif"

		if !$cache.file_exists?(filename)
			path = make_gif_with_ffmpeg(sentences, filename)

			$cache.add_file(path)
			File.delete(path)
		end

		<<-HTML
		<p><a href="#{$cache.get_url(filename)}" target="_blank"><p>点击下载</p></a></p>
		HTML
	end

	module_function :render_gif
end
