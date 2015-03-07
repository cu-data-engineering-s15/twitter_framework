require_relative '../requests/MuteIDs'

require 'trollop'

USAGE = %Q{
get_mute_ids: Retrieve user objects followed by a given Twitter screen_name.

USAGE:
  ruby get_mute_ids.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_mute_ids 0.1 (c) 2015 Kenneth M Anderson; Updated by Joe Cosenza"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  data   = { props: input[:props] }

  args   = { params: {}, data: data }

  twitter = MuteIDs.new(args)

  puts "Collecting the objects of the Twitter users followed by '#{input[:screen_name]}'"

  File.open('mute_ids.json', 'w') do |f|
    twitter.collect do |mutes|
      mutes.each do |mute|
        f.puts "#{mute}\n"
      end
    end
  end

  puts "DONE."

end
