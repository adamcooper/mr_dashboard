module MrDashboard

  def self.settings
    @settings ||=  begin
                     defaults = {
                       'speed' => ENV['SPEED'] || 15000,
                       'title' => ENV['TITLE'] || 'Mr. Dashboard',
                       'github_org' => ENV['GITHUB_ORG'] || nil,
                       'sites' => ENV['SITES'] || ['http://www.sinatrarb.com', 'http://news.ycombinator.com']
                     }
                     config_file = Pathname.new(File.dirname(__FILE__) + "/config.yml")
                     defaults.merge(YAML.load_file(config_file.to_s)) if config_file.exist?
                     defaults['sites'] = defaults['sites'].split(',') unless defaults['sites'].is_a?(Array)

                     defaults
                   end
  end

  def self.belongs_to_github_organization(user)
    org = MrDashboard.settings['github_org']
    return true if org.nil? || org.blank?

    begin
      RestClient.log = STDOUT
      response = RestClient.get("https://api.github.com/orgs/#{org}/members/#{user[:nickname]}", {"Authorization" => "token #{user[:token]}"})
      if response.code == 204
        true
      else
        false
      end
    rescue => e
      false
    end
  end

  class App < Sinatra::Base

    set :public_folder, Proc.new { File.join(root, "public") }
    set :layout, :layout

    get '/' do
      redirect 'login' unless session[:user]
      haml :root
    end

    get '/settings.js' do
      content_type :json
      { sites: MrDashboard.settings['sites'], speed: MrDashboard.settings['speed'] }.to_json
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
