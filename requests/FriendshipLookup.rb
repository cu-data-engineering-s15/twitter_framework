require_relative '../core/TwitterRequest'

class FriendshipLookup < TwitterRequest
	
	def initialize(args)
		super args
	end

	def request_name
		"FriendshipLookup"
	end

	def twitter_endpoint
		"/friendships/lookup"
	end

	def url
		'https://api.twitter.com/1.1/friendships/lookup.json'
	end

	def success(response)
		log.info("SUCCESS")
    	friendships_data = JSON.parse(response.body)
    	log.info("friendships data received.")
    	yield friendships_data
  	end

end