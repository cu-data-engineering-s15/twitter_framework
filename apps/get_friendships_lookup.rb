require_relative '../requests/FriendshipsLookup'

require 'trollop'

USAGE = %Q{
get_friendships_lookup: Returns the relationships of the current user to the sapce-separated list of up to 100 screen_names or user_ids provided. 

Usage: ruby get_friendships_lookup.rb <options>

  <screen_names>: space-separated list of Twitter screen names.
  <user_ids>    : space-separated list of Twitter user ids.

The following options are supported:
}

def parse_command_line
  
  # Create ruby hash representing JSON schema
  options_props = {type: :string, required: true}
  options_names = {type: :strings}
  options_ids   = {type: :integers}

  # trollop returns a hash of the command line required strings
  opts = Trollop::options do
    version "get_friendships_lookup 0.1 (c) 2015 Kenneth M. Anderson; Updated by David Aragon"
    banner USAGE
    opt :props, "OAuth Properties File", options_props
    opt :screen_names, "Screen Names", options_names
    opt :user_ids, "User Ids", options_ids
    conflicts :screen_names, :user_ids
  end	
		
  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end

# Only run the following code when this file ("__FILE__") is the main file 
# being run ("$0") instead of having been required or loaded by another 
# file; "$:" is the LOAD_PATH directory

if __FILE__ == $0

  # synchronise STDOUT by default to see output as it happens.
  STDOUT.sync = true

  input  = parse_command_line

  params = {}

  if input.has_key?(:screen_names_given)
    params[:screen_name] = input[:screen_names].join(',')
  else
    params[:user_id] = input[:user_ids].join(',')
  end

  data = { props: input[:props] }
  args = { params: params, data: data }

  twitter = FriendshipsLookup.new(args)

  puts "Determining friendship relationships with:"
  if input.has_key?(:screen_names_given)
    puts "   Screen Names: " + input[:screen_names].join(', ')
  else
    puts "   User Ids: " + input[:user_ids].join(', ')
  end
  
  File.open('friendship_info.json', 'w') do |f|
    twitter.collect do |friendships|
      friendships.each do |info|
        f.puts "#{info.to_json}"
      end
    end
  end

  puts "Friendship information stored in 'friendship_info.json'."
  puts "DONE."	

end
