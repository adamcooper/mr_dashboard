module MrDashboard
  class App < Sinatra::Base

    set :public_folder, Proc.new { File.join(root, "public") }
    set :layout, :layout
    set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)

    get '/' do
      redirect 'login' unless session[:user]
      haml :root
    end

    get '/settings.js' do
      content_type :json
      { sites: MrDashboard.settings['sites'], speed: MrDashboard.settings['speed'] }.to_json
    end

    get '/add' do
      MrDashboard.display[:pages] << params['page']
      MrDashboard.display[:sites] << params['site']
      :ok
    end

    get '/display.js' do
      content_type :json
      response = MrDashboard.display.to_json
      MrDashboard.display[:sites] = []
      MrDashboard.display[:pages] = []
      response
    end

    get '/login' do
      haml :login, :layout => :layout_bare
    end

    get '/logout' do
      session[:user] = nil
      redirect "/"
    end

    get "/application.js" do
      coffee :application
    end

    get "/application.css" do
      scss :application
    end

    get '/auth/github/callback' do
      auth_hash = request.env['omniauth.auth']
      user = {
        uid: auth_hash['uid'],
        nickname: auth_hash['info']['nickname'],
        token: auth_hash['credentials']['token']
      }

      if MrDashboard.belongs_to_github_organization(user)
        session[:user] = user
        redirect '/'
      else
        session[:user] = nil
        redirect '/login'
      end
    end
  end
end
