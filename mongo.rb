# -*- coding: utf-8 -*-

require 'mongo'

#データベースと接続
# connection = Mongo::Connection.new
# connection = Mongo::Connection.new('localhost');
# connection = Mongo::Client.new([ '127.0.0.1:27017' ])

db = Mongo::Client.new([ '127.0.0.1:27017'], :database => 'test')
collection = db[:users]
# puts coll.find({"name": "katsuya"})
# puts db.collections

collection.insert_one({name: 'oura'})
collection.find.each{ |info| puts info.inspect }
