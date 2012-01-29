configure :development do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => '',
    :database => 'sinatra_development'})

    DataMapper::Logger.new(STDOUT, :debug)
end

configure :production do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'user' ,
    :password => 'pass',
    :database => 'sinatra_production'})
end
