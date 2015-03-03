require_relative '../core/CursorRequest'

class FollowersList < CursorRequest

  def initialize(args)
    super args
    params[:count] = 5000
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
    ids = JSON.parse(response.body)['ids']
    @count += ids.size
    log.info("#{ids.size} ids received.")
    log.info("#{@count} total ids received.")
    yield ids
  end

end
