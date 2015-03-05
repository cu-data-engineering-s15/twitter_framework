require_relative '../core/TwitterRequest'

class StatusRetweetId < TwitterRequest

  def initialize(args)
    super args
    params[:count] = 100
    params[:id] = 123
    @count = 0
    @id = 0
  end

  def request_name
    "StatusRetweetId"
  end

  def twitter_endpoint
    "/statuses/retweets/:id"
  end

  def url
    'https://api.twitter.com/1.1/statuses/retweets.json'
  end

  def success(response)
    log.info("SUCCESS")
    tweets = JSON.parse(response.body)
    @count += tweets.size
    yield tweets
  end

end