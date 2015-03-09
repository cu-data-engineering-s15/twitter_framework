require_relative '../core/CursorRequest'

class ListsSubscriptions < CursorRequest

  def initialize(args)
    super args
    params[:count] = 1000
    @count = 0
  end

  def request_name
    "ListsSubscriptions"
  end

  def twitter_endpoint
    "/lists/subscriptions"
  end

  def url
    'https://api.twitter.com/1.1/lists/subscriptions.json'
  end

  def success(response)
    log.info("SUCCESS")
    subs = JSON.parse(response.body)["lists"]
    @count += subs.size
    log.info("#{subs.size} subscriptions received.")
    log.info("#{@count} total subscriptions received.")
    yield subs
  end

end
