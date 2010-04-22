%w{digest/sha1 rubygems sinatra redis haml}.map {|x| require x}

before do
  @redis = Redis.new
end

get "/" do
  haml :index
end

post "/" do
  message = {
    :message => params["message"].upcase,
    :created => Time.now
  }
  
  sha = Digest::SHA1.hexdigest("#{message[:message]}").slice 0, 8
  @redis.hset "blowitup:messages", sha, Marshal.dump(message)
  @redis.bgsave
  
  haml :paste, :locals => {
    :sha => sha
  }
end

get "/message/:sha" do
  message = Marshal.load(@redis.hget "blowitup:messages", params[:sha])
  @redis.hincrby "blowitup:messages:views", params[:sha], 1
  
  haml :show, :layout => false, :locals => {
    :message => message[:message],
    :style => message[:style]
  }
end

get "/huh" do
  haml :huh
end

get "/stats" do
  total = @redis.hlen("blowitup:messages")
  report = []
  @redis.hgetall("blowitup:messages").each do |k,v|
    m = Marshal.load v
    views = @redis.hget "blowitup:messages:views", k
    report << "<li><a href='/message/#{k}'>#{k}</a> || <em>#{m[:created].strftime("%m-%d-%Y [%I:%M%p]")}</em> || <b>#{m[:message]}</b> || <span class='views'>#{views || 0} views</span>"
  end
  
  haml :stats, :locals => {
    :total => total,
    :report => report
  }
end
