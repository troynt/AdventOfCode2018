require 'net/http'
require 'uri'
require 'active_support'
require 'date'
require 'fileutils'


available_challenge_dirs = Set.new (1..25).map { |i| Date.new( 2018, 12, i) }.select {|x| x <= Date.today }.map(&:day)
existing_challenge_dirs = Set.new Dir.glob('challenges/**').map { |x| x.gsub('challenges/', '').to_i }.select { |x| x > 0 }

missing = (available_challenge_dirs - existing_challenge_dirs)

missing.to_a.sort.reverse.each do |day|
  path = File.join(File.dirname(__FILE__), "challenges", "#{day}");
  FileUtils.mkdir_p(File.join(path, "fixtures"))
  
end

=begin

uri = URI.parse("https://adventofcode.com/2018/day/8")
response = Net::HTTP.get_response uri
p response.body.scan(%r[--- Day (\d+): (.*) ---])
=end

