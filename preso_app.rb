class Preso < Sinatra::Base

  set :public_folder, Proc.new { File.join(root, "public") }
  set :layout, :layout

  enable :sessionsend

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :developer
  end

  before do
     if request.path_info != '/auth/developer/callback'
       redirect '/auth/developer' unless session[:uid]
      end
  end

  get '/' do
    haml :root
  end

  get '/logout' do
    session['uid'] = nil
    redirect "/"
  end

  get "/application.js" do
    coffee :application
  end

  get "/application.css" do
    scss :application
  end

  post '/auth/developer/callback' do
    session[:uid] = request.env['omniauth.auth']["uid"]
    redirect '/'
  end
end
