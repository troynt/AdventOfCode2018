require 'net/http'
require 'uri'
require "active_support/inflector"
require 'date'
require 'fileutils'
require 'pry'

def get_title(day)
  uri = URI.parse("https://adventofcode.com/2018/day/#{day}")
  response = Net::HTTP.get_response uri
  _, day, title = response.body.match(%r[--- Day (\d+): (.*) ---]).to_a

  title
end

def create_file_if_missing(file_path)
  return if File.exists? file_path

  File.open(file_path, 'w') do |f|
    yield(f)
  end
end


available_challenge_dirs = Set.new (1..25).map { |i| Date.new( 2018, 12, i) }.select {|x| x <= Date.today }.map(&:day)
existing_challenge_dirs = Set.new Dir.glob('challenges/**').map { |x| x.gsub('challenges/', '').to_i }.select { |x| x > 0 }

missing = (available_challenge_dirs - existing_challenge_dirs)
# missing = (available_challenge_dirs) # uncomment to recreate all

missing.to_a.sort.reverse.each do |day|
  path = File.join(File.dirname(__FILE__), "challenges", "#{day}");
  FileUtils.mkdir_p(File.join(path, "fixtures"))
  title = get_title(day)

  title_underscored = title.parameterize.underscore
  title_classified = title.gsub(" ", "").classify

  create_file_if_missing(File.join(path, "#{title_underscored}.rb")) do |f|
    f.puts """
class #{title_classified}
  def initialize
  end
end
"""
  end

  create_file_if_missing(File.join(path, "#{title_underscored}_spec.rb")) do |f|
    f.puts """
require_relative '#{title_underscored}'

describe '#{title_classified}' do
end
"""
  end
end

