Bundler.require
require File.expand_path(File.dirname(__FILE__) + '/mr_dashboard')

use Rack::JSONP
use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_TOKEN']
end

run MrDashboard::App
