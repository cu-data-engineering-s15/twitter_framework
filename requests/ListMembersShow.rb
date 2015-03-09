require_relative '../core/TwitterRequest'

class ListMembersShow < TwitterRequest

  def initialize(args)
    super args
    #params[:count] = 1000
    @count = 0
  end

  def request_name
    "ListMembersShow"
  end

  def twitter_endpoint
    "/lists/members/show"
  end

  def url
    'https://api.twitter.com/1.1/lists/members/show.json'
  end

  def success(response)
    lists = JSON.parse(response.body)['lists']
    @count += lists.size
    log.info("member is in group list.")
    yield lists
  end

  def error(response)
    if response.code == 404
      puts "No information found at specified url. Member not in list"
      return
    end
    super
  end

end
