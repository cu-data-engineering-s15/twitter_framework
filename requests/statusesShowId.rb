require_relative '../core/CursorRequest'

class StatusesShowId < CursorRequest

  def initialize(args)
    super args
    params[:count] = 5000
    @count = 0
  end

  def request_name
    "StatusesShowId"
  end

  def twitter_endpoint
    "/statuses/show/:id"
  end

  def url
    'https://api.twitter.com/1.1/statuses/show.json'
  end

  def success(response)
    log.info("SUCCESS")
    status = JSON.parse(response.body)['status']
    @count += status.size
    log.info("#{status.size} status received.")
    log.info("#{@count} total status received.")
    yield status
  end

end