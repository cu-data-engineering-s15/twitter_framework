require_relative '../requests/FriendsList'

require 'trollop'

USAGE = %Q{
get_friends_list: Retrieve user objects followed by a given Twitter screen_name.

USAGE:
  ruby get_friends_list.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_friends_list 0.1 (c) 2015 Kenneth M Anderson; Updated by Neil Nistler"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args   = { params: params, data: data }

  twitter = FriendsList.new(args)

  puts "Collecting the objects of the Twitter users followed by '#{input[:screen_name]}'"

  File.open('friends_list.json', 'w') do |f|
    twitter.collect do |friends|
      friends.each do |friend|
        puts friend['screen_name']
        f.puts "#{friend.to_json}\n"
      end
    end
  end

  puts "DONE."

end
