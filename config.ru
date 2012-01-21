Bundler.require

require File.expand_path(File.dirname(__FILE__) + '/preso_app')

#use Rack::Session::Cookie
# use OmniAuth::Builder do
#   provider :open_id, OpenID::Store::Filesystem.new('/tmp')
#   provider :twitter, 'consumerkey', 'consumersecret'
# end
run Preso
