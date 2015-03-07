require_relative '../requests/Configuration'
require 'trollop'

USAGE = %Q{
get_configuration
use as 
ruby get_configuration.rb <your twitter id name> --props=oauth.properties
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_configuration   (c) 2015 Kenneth M. Anderson;Updated by Piyush Sudip Patel"
    banner USAGE
    opt :props, "OAuth_Properties_File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "Must point to a valid oauth Properties File"
  end

  opts[:identifiers] = ARGV[0]

  if opts[:identifiers] == nil
    Trollop::die "Need to specify a id (in this is it will be the screen name)"
  end

  opts
end


def parse_identifiers(input)
  if input.to_i.to_s.size == input.size
    return ["user_id", input]
  else
    return ["screen_name", input]
  end
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  id     = parse_identifiers(input[:identifiers])

  if id[0] == "user_id"
    params = { user_id: id[1] }
  else
    params = { screen_name: id[1] }
  end

  data   = { props: input[:props], user: id[1] }
  args   = { params: params, data: data }

  users_data = UsersShow.new(args)
  puts "Get the Configuration Data '#{id[1]}'"

  users_data.collect do |user|
    puts "#{user}\n"
  end


File.open('Configuration.json', 'w') do |f|
    users_data.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end  

  puts "DONE!!!"
end
