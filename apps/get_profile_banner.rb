require_relative '../requests/UsersProfileBanner'

require 'trollop'

USAGE = %Q{
get_profile_banner: gets profile banner size information for a given user.

Usage:

  ruby get_profile_banner.rb <options> [sceen_name]

  <screen_name>: Twitter Screen Name.

The following options are required:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_profile_banner 0.1 (c) 2015 Kenneth M. Anderson; Updated by Kevin Rau"
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

  input   = parse_command_line

  params  = { screen_name: input[:screen_name] }
  data    = { props: input[:props] }

  args    = { params: params, data: data }

  twitter = UsersProfileBanner.new(args)

  puts "Get profile banner size information for '#{input[:screen_name]}'"

  File.open('sizes.json', 'w') do |f|
    twitter.collect do |sizes|
      sizes.each do |size|
        f.puts "#{size.to_json}"
      end
    end
  end

  puts "Size information stored in file 'sizes.json'."
  puts "DONE."

end
