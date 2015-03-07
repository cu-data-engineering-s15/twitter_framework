require_relative '../requests/Available'

require 'trollop'

USAGE = %Q{
get_trends: Retrieve trending terms for a given Where On Earth ID.
Usage:
  ruby get_available.rb <options> 
  
The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_available 0.1 (c) 2015 Dheeraj Chinni Ranga"
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

  input  = parse_command_line

  data   = { props: input[:props] }

  args     = { params:{} , data: data }

  twitter = Available.new(args)

  File.open('trendss.json', 'w') do |f|
    twitter.collect do |trendss|
      trendss.each do |trend|
        f.puts "#{trend.to_json}\n"
      end
    end
  end

  puts "DONE."

end