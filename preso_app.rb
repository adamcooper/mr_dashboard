require 'pp'

class Preso < Sinatra::Base

  set :public_folder, Proc.new { File.join(root, "public") }
  set :layout, :layout

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_TOKEN']
  end

  get '/' do
    redirect 'login' unless session[:user]
    haml :root
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

    # checking that the github user actually belongs to partnerpedia
    begin
      RestClient.log = STDOUT
      response = RestClient.get("https://api.github.com/orgs/partnerpedia/members/#{user[:nickname]}", {"Authorization" => "token #{user[:token]}"})
      if response.code == 204
        session[:user] = user
        redirect '/'
      else
        redirct '/login'
      end
    rescue => e
      halt(401, "You don't have access")
    end
  end
end
