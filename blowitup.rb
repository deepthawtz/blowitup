require File.join(File.dirname(__FILE__), "setup")

module Blowitup
  def self.redis
    @redis ||= Redis.new
  end

  class App < Sinatra::Base
    set :public, "#{File.dirname(File.expand_path(__FILE__))}/public"
    set :static, true
    enable :sessions

    def initialize(*args)
      super
    end

    def redis
      Blowitup.redis
    end

    def sha(msg)
      Digest::SHA1.hexdigest(msg).slice(0, 8)
    end

    get "/" do
      haml :index
    end

    post "/" do
      message = {
        :message => params["message"].upcase,
        :created => Time.now
      }

      message_sha = sha(message[:message])
      redis.hset "blowitup:messages", message_sha, Marshal.dump(message)
      redis.bgsave

      haml :paste, :locals => {
        :url => "message/#{message_sha}"
      }
    end

    get "/message/:sha" do
      begin
        m = redis.hget "blowitup:messages", params[:sha]
        message = Marshal.load(m)
        redis.hincrby "blowitup:messages:views", params[:sha], 1
        haml :show, :layout => false, :locals => {
          :message => message[:message],
          :style => message[:style]
        }
      rescue TypeError
        haml :"404"
      end

    end

    get "/huh" do
      haml :huh
    end

    get "/stats" do
      total = redis.hlen("blowitup:messages")
      report = []
      redis.hgetall("blowitup:messages").each do |k,v|
        m = Marshal.load v
        views = redis.hget "blowitup:messages:views", k
        report << "<li><a href='/message/#{k}'>#{k}</a> || <em>#{m[:created].strftime("%m-%d-%Y [%I:%M%p]")}</em> || <b>#{m[:message]}</b> || <span class='views'>#{(views || 0)} views</span>"
      end

      haml :stats, :locals => {
        :total => total,
        :report => report
      }
    end
  end
end

