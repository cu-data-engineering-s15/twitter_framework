require_relative '../core/TwitterRequest'

class Configuration < TwitterRequest

  def request_name
    "Configuration"
  end

  def twitter_endpoint
    "/help/configuration"
  end

  def url
    'https://api.twitter.com/1.1/help/configuration.json'
  end

  def success(response)
    log.info("SUCCESS!!!")
    info = JSON.parse(response.body)
    log.info("Configuration Info received.")
    yield info
  end

end
