require_relative '../core/CursorRequest'

class ListsOwnerships < CursorRequest

  def initialize(args)
    super args
    params[:count] = 1000
    @count = 0
  end

  def request_name
    "ListsOwnerships"
  end

  def twitter_endpoint
    "/lists/ownerships"
  end

  def url
    'https://api.twitter.com/1.1/lists/ownerships.json'
  end

  def success(response)
    log.info("SUCCESS")
    lists = JSON.parse(response.body)['lists']
    @count += lists.size
    log.info("#{lists.size} list(s) received.")
    log.info("#{@count} total list(s) received.")
    yield lists
  end

end
