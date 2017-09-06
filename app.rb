Encoding.default_external = Encoding::UTF_8 # windows対応

require 'sinatra'
require 'sinatra/reloader'
require 'mongo'

get '/' do
  db =  Mongo::Client.new('mongodb://test:test0812@ds149613.mlab.com:49613/sbi_scraper')
  collection = db[:securities]

  @first_brand = collection.find({}).sort({under_divided_over:-1}).limit(100).to_a

  erb :index

end
