require_relative '../requests/ListsSubscriptions'

require 'trollop'

USAGE = %Q{
get_lists_subscriptions: Returns the lists subscribed to by the given user.

Usage:
  ruby get_lists_subscriptions.rb <options> <screen_name>

  <screen_name>: The screen name of the user for whom to return results for.

  Example:
  ruby get_lists_subscriptions.rb --props oath.properties episod
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_lists_subscriptions 0.1 (c) 2015 Kenneth M. Anderson; "\
            "Updated by Sanghee Kim"
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

  args     = { params: params, data: data }

  twitter = ListsSubscriptions.new(args)

  puts "Getting lists subscribed to by '#{input[:screen_name]}' "

  File.open('lists_subscriptions.txt', 'w') do |f|
    twitter.collect do |subs|
      subs.each do |sub|
        f.puts "#{sub.to_json}"
      end
    end
  end

  puts "List info stored in file 'lists_subscriptions.txt'."
  puts "DONE."

end
