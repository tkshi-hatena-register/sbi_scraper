require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @hello = "こんにちわ"
  erb :index

end
