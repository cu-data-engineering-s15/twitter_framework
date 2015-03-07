require_relative '../core/CursorRequest'

class FriendsList < CursorRequest

  def initialize(args)
    super args
    params[:count] = 20
    @count = 0
  end

  def request_name
    "FriendsList"
  end

  def twitter_endpoint
    "/friends/list"
  end

  def url
    'https://api.twitter.com/1.1/friends/list.json'
  end

  def success(response)
    log.info("SUCCESS")
    friends = JSON.parse(response.body)
    @count += friends.size
    log.info("#{friends.size} friend(s) recieved.")
    log.info("#{@count} total friend(s) recieved.")
    yield friends
  end

end
