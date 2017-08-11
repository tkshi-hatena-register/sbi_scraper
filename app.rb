require 'sinatra'
require 'sinatra/reloader'
require 'mongo'

get '/' do
  db = Mongo::Client.new([ '127.0.0.1:27017'], :database => 'test')
  collection = db[:users]

  @user_name = collection.find.limit(1).first[:name]

  @hello = "こんにちわ"
  erb :index

end
