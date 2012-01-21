class Preso < Sinatra::Base
  
  set :public_folder, Proc.new { File.join(root, "static") }
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
    haml :home
  end

  get '/logout' do
    session['uid'] = nil
    redirect "/"
  end

  post '/auth/developer/callback' do
    session[:uid] = request.env['omniauth.auth']["uid"]
    redirect '/'
  end
end
