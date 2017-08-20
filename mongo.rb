Encoding.default_external = Encoding::UTF_8 # windows対応

require 'mongo'

# puts 'データベース一覧'
# puts connection.database_names

db = Mongo::Client.new([ '127.0.0.1:27017'], :database => 'test')
collection = db[:users]

collection.insert_one({name: 'katsuya'})
collection.find.each{ |info| puts info.inspect }
