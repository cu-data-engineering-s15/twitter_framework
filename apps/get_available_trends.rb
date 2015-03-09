require_relative '../requests/AvailableTrends'

require 'trollop'

USAGE = %Q{
get_available_trends: Retrieve locations where trending terms are available.

Usage:
  ruby get_available_trends.rb <options> 
  
The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_available 0.1 (c) 2015 Kenneth M. Anderson; Updated by Dheeraj Chinni Ranga"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid file"
  end
  
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input   = parse_command_line
  data    = { props: input[:props] }
  args    = { params: {}, data: data }

  twitter = AvailableTrends.new(args)

  File.open('available_trend_locations.json', 'w') do |f|
    twitter.collect do |locations|
      locations.each do |location|
        f.puts "#{location.to_json}\n"
      end
    end
  end

  puts "Locations saved to file 'available_trend_locations.json'."
  puts "DONE."

end
