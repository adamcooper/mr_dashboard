Bundler.require
require File.expand_path(File.dirname(__FILE__) + '/app/mr_dashboard')

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_TOKEN']
end

run MrDashboard::App
