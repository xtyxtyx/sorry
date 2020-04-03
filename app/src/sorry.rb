require 'sinatra'
require 'json'
require 'erb'

require_relative "./sorry/make_gif.rb"
require_relative "./sorry/config.rb"
require_relative "./sorry/check_deps.rb"

# 检查依赖
DepsChecker.check_all()

# 默认跳转到sorry模板
get "/" do
  redirect to('/sorry/')
end

# 兼容旧版
get "/index.html" do
  redirect to('/sorry/')
end

# 跳转到/<template_name>/
get "/:template_name" do
  template_name = params['template_name']
  redirect to("/#{template_name}/")
end


# 模板主页
get "/:template_name/" do
  template_name = params['template_name']
  path_to_file = "views/#{template_name}.erb"

  if File.exist?(path_to_file)
    erb params['template_name'].to_sym    
  else
    send_file Config::PAGE_404
  end

end

# Gif制作请求
post "/:template_name/make" do
  template_name = params['template_name']

  body = JSON.parse(request.body.read)
  sentences = []
  i = 0
  while sentence = body[i.to_s]
    sentences[i] = sentence
    i += 1
  end

  path_to_template_dir = "templates/#{template_name}/"
  if ! Dir.exist?(path_to_template_dir)
    halt 404
  end
  
  Sorry.render_gif("templates/#{template_name}/", sentences)
end

# Gif制作请求(微信兼容版)
post "/sorry/wechat/make" do
  template_name = "sorry"

  body = JSON.parse(request.body.read)
  sentences = []
  i = 0
  while sentence = body[i.to_s]
    sentences[i] = sentence
    i += 1
  end
  
  Sorry.render_gif("templates/sorry/wechat/", sentences)
end

# API
post "/api/:template_name/make" do
  template_name = params['template_name']

  body = JSON.parse(request.body.read)
  if body.is_a?(Array)
    sentences = body
  else
    sentences = []
    i = 0
    while sentence = body[i.to_s]
      sentences[i] = sentence
      i += 1
    end
  end

  path_to_template_dir = "templates/#{template_name}/"
  if ! Dir.exist?(path_to_template_dir)
    halt 404
  end

  status_code, msg = Sorry.render_gif_api("templates/#{template_name}/", sentences)

  status(status_code)
  msg
end

# 兼容旧版
post "/make" do
  "<p>请刷新或清空浏览器缓存🍃</p>"
end


# 404页面
not_found do
  if %r<^/cache/.+> =~ request.path_info
    send_file Config::PAGE_INVALID
  else
    send_file Config::PAGE_404
  end
end


# 静态文件
set :static, true
set :public_folder, Dir.pwd + '/public'


# 设置监听地址
set :port, Config::SERVER_PORT
set :bind, Config::SERVER_IP

# 设置网页模板目录
set :views, Dir.pwd + '/views'