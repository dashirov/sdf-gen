#!/usr/bin/env ruby
require 'sinatra'
require 'sqlite3'
require 'json'
helpers do
  def db
    @db ||= SQLite3::Database.new('list.db').tap do |db|
      db.execute 'CREATE TABLE IF NOT EXISTS list (name varchar);'
    end
  end

  def add_item name
    db.execute 'INSERT INTO list (name) VALUES (?)', [name]
  end

  def list
    db.execute('SELECT name FROM list').flatten
  end
end

get '/' do
  content_type 'application/json'
  {'list' => list}.to_json
end

post '/' do
  add_item params[:name]
  status 201
  ''
end