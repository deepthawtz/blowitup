%w[
  rubygems
  digest/sha1
  sinatra
  redis
  haml
].map {|x| require x}

module Blowitup
  def self.redis
    if "production" == ENV["RACK_ENV"]
      uri = URI.parse(ENV["REDISTOGO_URL"])
      return @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end
    @redis ||= Redis.new
  end
end