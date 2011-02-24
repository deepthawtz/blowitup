require "rubygems"
require "sinatra"

set :env, :production
disable :run, :reload

require "./blowitup"

run Blowitup::App
