require_relative '../core/TwitterRequest'

class Languages < TwitterRequest

  def request_name
    "Languages"
  end

  def twitter_endpoint
    "/help/languages"
  end

  def url
    'https://api.twitter.com/1.1/help/languages.json'
  end

  def success(response)
    log.info("SUCCESS")
    languages = JSON.parse(response.body)
    yield languages
  end

end
