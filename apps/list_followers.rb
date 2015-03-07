require_relative '../requests/FollowersList'

require 'trollop'

USAGE = %Q{
list_followers: Retrieve user objects that follow a given Twitter user.

Usage:
  ruby list_followers.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_followers 0.1 (c) 2015 Kenneth M. Anderson; Updated by Priya Sudendra"
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

  args    = { params: params, data: data }

  twitter = FollowersList.new(args)

  puts "Getting the followers of '#{input[:screen_name]}'."

  File.open('followers.json', 'w') do |f|
    twitter.collect do |followers|
      followers.each do |follower|
        f.puts "#{follower.to_json}"
      end
    end
  end

  puts "User objects stored in file 'followers.json'."
  puts "DONE."

end
