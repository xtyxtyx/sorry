require 'sinatra'

require_relative "./sorry/make_gif.rb"
require_relative "./sorry/config.rb"

get "/" do
  send_file Config::PAGE_INDEX
end



get "/make" do
  sentences = []

  x = Config::TEMPLATE_SENTENCES
  x.times do |n|
    sentences[n] = (params[n.to_s] || "")
  end

  Sorry.render_gif(sentences)
end



not_found do
  send_file Config::PAGE_404
end



set :static, true
set :public_folder, Dir.pwd + '/public'


set :port, Config::SERVER_PORT
set :bind, Config::SERVER_IP