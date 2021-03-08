require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'

require_relative './config/environment'
require_relative './app/models/advertisement'
require_relative './app/routes/api/v1/advertisements'

DataMapper.finalize
Advertisement.auto_upgrade!
