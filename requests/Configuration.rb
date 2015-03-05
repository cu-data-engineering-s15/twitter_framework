require_relative '../core/TwitterRequest'

class UsersShow < TwitterRequest

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
    users_data = JSON.parse(response.body)
    log.info("Configuration file '#{data[:user]}'")
    yield users_data
  end

  def error(response)
    if response.code == 404
      puts "No file found, error!!"
      return
    end
    super
  end

end
