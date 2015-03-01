require_relative '../requests/FriendshipLookup'

require 'trollop'

USAGE = %Q{
get_friendships_lookup = Returns the relationships of a given user to the comma-separated 
list of up to 100 screen_names or user_ids provided. 

USAGE =
}

def parse_command_line
	render :nothing => true
end

if __FILE__ = $0
	render :nothing => true
end
