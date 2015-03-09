require_relative '../core/CursorRequest'

class FollowersList < CursorRequest

  def initialize(args)
    super args
    params[:count] = 200
    @count = 0
  end

  def request_name
    "FollowersList"
  end

  def twitter_endpoint
    "/followers/list"
  end

  def url
    'https://api.twitter.com/1.1/followers/list.json'
  end

  def success(response)
    log.info("SUCCESS")
    users = JSON.parse(response.body)["users"]
    @count += users.size
    log.info("#{users.size} user(s) received.")
    log.info("#{@count} total user(s) received.")
    yield users
  end

end

