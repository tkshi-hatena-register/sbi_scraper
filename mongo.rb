# -*- coding: utf-8 -*-

require 'mongo'

#データベースと接続
# connection = Mongo::Connection.new
# connection = Mongo::Connection.new('localhost');
# connection = Mongo::Client.new([ '127.0.0.1:27017' ])

db = Mongo::Client.new([ '127.0.0.1:127001'], :database => 'test')

# puts coll.find({"name": "katsuya"})
puts db.collections

# db['users'].find.each{ |info| puts info.inspect }
