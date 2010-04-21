require "rubygems"
require "sinatra"

set :env, :production
disable :run, :reload

require "blowitup"

run Sinatra::Application
