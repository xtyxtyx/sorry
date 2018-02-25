require 'sinatra'
require 'json'

require_relative "./sorry/make_gif.rb"
require_relative "./sorry/config.rb"

get "/" do
  send_file Config::PAGE_INDEX
end



post "/make" do
  sentences = []

  json = JSON.parse(request.body.read)

  x = Config::TEMPLATE_SENTENCES
  x.times do |n|
    sentences[n] = (json[n.to_s] || "")
  end

  p "render!"
  Sorry.render_gif(sentences)
end



not_found do
  send_file Config::PAGE_404
end



set :static, true
set :public_folder, Dir.pwd + '/public'


set :port, Config::SERVER_PORT
set :bind, Config::SERVER_IP