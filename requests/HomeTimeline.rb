require_relative '../core/MaxIdRequest'

class HomeTimeline < MaxIdRequest

  def initialize(args)
    super args
    params[:count] = 200
    @count = 0
  end

  def request_name
    "HomeTimeline"
  end

  def twitter_endpoint
    "/statuses/home_timeline"
  end

  def url
    'https://api.twitter.com/1.1/statuses/home_timeline.json'
  end

  def success(response)
    log.info("SUCCESS")
    tweets = JSON.parse(response.body)
    @count += tweets.size
    log.info("#{tweets.size} tweet(s) received.")
    log.info("#{@count} total tweet(s) received.")
    yield tweets
  end

  def init_condition
    @last_count = 1
  end

  def condition
    @last_count > 0
  end

  def update_condition(tweets)
    @last_count = tweets.size
  end

end
