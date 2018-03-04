require 'sinatra'
require 'json'

require_relative "./sorry/make_gif.rb"
require_relative "./sorry/config.rb"

get "/" do
  # Enter `sorry` template by default
  redirect to('/sorry/')
end



get "/:template_name" do
  template_name = params['template_name']
  redirect to("/#{template_name}/")
end



get "/:template_name/" do
  template_name = params['template_name']
  path_to_file = "public/#{template_name}/index.html"

  if File.exist?(path_to_file)
    send_file path_to_file
  else
    send_file Config::PAGE_404
  end
end



post "/:template_name/make" do
  template_name = params['template_name']

  body = JSON.parse(request.body.read)
  sentences = []
  i = 0
  while sentence = body[i.to_s]
    sentences[i] = sentence
    i += 1
  end

  Sorry.render_gif(template_name, sentences)
end

# For compability
post "/make" do
  "<p>请刷新或清空浏览器缓存🍃</p>"
end

not_found do
  if %r<^/cache/.+> =~ request.path_info
    send_file Config::PAGE_INVALID
  else
    send_file Config::PAGE_404
  end
end



set :static, true
set :public_folder, Dir.pwd + '/public'


set :port, Config::SERVER_PORT
set :bind, Config::SERVER_IP