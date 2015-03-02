require_relative '../requests/FriendshipLookup'

require 'trollop'

USAGE = %Q{
get_friendships_lookup = Returns the relationships of a given user to the comma-separated 
list of up to 100 screen_names or user_ids provided. 

USAGE =
  ruby get_friendships_lookup.rb <options> <screen_names> 

  <screen_name>: comma separated list of Screen Names.

  The following options are supported:
}

def parse_command_line
  
  # Create ruby hash representing JSON schema
  options = {type: :string, required: true}

  # trollop returns a hash of the command line required strings
  opts = Trollop::options do
    version "get_friendships_lookup 0.1 (c) 2015 Kenneth M. Anderson; Updated by David Aragon"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end	
		
  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts

end

# Only run the following code when this file ("__FILE__") is the main file 
# being run ("$0") instead of having been required or loaded by another 
# file; "$:" is the LOAD_PATH directory

if __FILE__ = $0
  # Find the parent directory of this file and add it to the front
  # of the list of locations to look in when using require

  # synchronise STDOUT by default to see output as it happens.
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
