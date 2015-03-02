require_relative '../requests/FriendshipLookup'

require 'trollop'

USAGE = %Q{
get_friendships_lookup = Returns the relationships of a given user to the comma-separated 
list of up to 100 screen_names or user_ids provided. 

USAGE =
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_members 0.1 (c) 2015 Kenneth M. Anderson; Updated by David Aragon"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end	
		
  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts

end

if __FILE__ = $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = FriendshipLookup.new(args)

  puts "Collecting up to 100 friendships of '#{input[:screen_name]}'"

  File.open('friendships.json' , 'w') do |f|
    twitter.collect do |friendships|
      tweets.each do |friendship|
        f.puts "#{friendship.to_json}\n"
      end
    end
  end

  puts "DONE."	
end
