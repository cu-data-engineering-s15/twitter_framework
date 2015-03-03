require_relative '../requests/FriendshipsShow'

require 'trollop'

USAGE = %Q{
get_friendships_show: Shows friendship level between given Twitter source_screen_name and target_screen_name.

Usage:
  ruby get_friendships_show.rb <options> <source_screen_name> <target_screen_name>

  <source_screen_name>: A Twitter source_screen_name.
  <target_screen_name>: A Twitter target_screen_name

The following options are supported:

  --params: An OAuth Properties File

}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_tweets 0.1 (c) 2015 Kenneth M. Anderson; Updated by Priyanka Goyal."
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:source_screen_name] = ARGV[0]
  opts[:target_screen_name] = ARGV[1]

  if opts[:source_screen_name] == nil
    Trollop::die "A source screen name is required to show friendship."
  end

  if opts[:target_screen_name] == nil
    Trollop::die "A target screen name is required to show friendship."
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { source_screen_name: input[:source_screen_name], target_screen_name: input[:target_screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = FriendshipsShow.new(args)

  puts "Showing the friendship level between two Twitter users, '#{input[:source_screen_name]}' and '#{input[:target_screen_name]}'"

  File.open('tweets.json', 'w') do |f|
    twitter.collect do |relationship|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "DONE."

end
