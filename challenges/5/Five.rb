REGEXP = Regexp.new ('a'..'z').map {|c| "#{c.upcase}#{c}|#{c}#{c.upcase}"}.join("|")
CHUNK_SIZE = 1024
class Five

  def self.chunk(string, size)
    string.scan(/.{1,#{size}}/)
  end

  def self.better_calc(str)

    if( str.length > CHUNK_SIZE)
      chunks = chunk(str, CHUNK_SIZE)
      str = chunks.map {|c| calc(c) }.join('')
    end

    calc(str)
  end

  def self.calc(str)

    str.gsub!(REGEXP, '')
    prev_length = nil

    while( prev_length != str.length ) do
      prev_length = str.length
      str.gsub!(REGEXP, '')
    end

    str 
  end

  def self.calc2(str)
    letter, count = ('a'..'z').map do |c|
      [c, calc(str.gsub(Regexp.new(c, 'i'), '')).length]
    end.min_by { |letter, count| count }

    count
  end

end