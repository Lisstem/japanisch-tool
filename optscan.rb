def optscan(string, downcase = true)
  unless string.respond_to? :each
    string = string.split(' ')
  end
  args = {:flags => [], :params => [], :options => {}}
  flag = nil
  string.each do |s|
    if s[0] == '-'
      unless flag.nil?
        raise ArgumentError, "No value given for option #{flag}."
      end
      if s[1] == '-'
        s.downcase! if downcase
        flag = s[2..-1]
        flag = nil if flag == ''
      else
        s[1..-1].each_char do |char|
          args[:flags] << char
        end
      end
    else
      if flag.nil?
        args[:params] << s
      else
        args[:options][flag] = [] if args[:options][flag].nil?
        args[:options][flag] << s
        flag = nil
      end
    end
  end
  args
end

=begin
# -Asda sDsdd --As akdsj ads --d ajsd --as aj adg asd

input = 'asd'
exits = ['q', 'quit', 'exit']
while !input.nil? && !exits.include?(input.strip.downcase)
  input = gets
  puts optscan(input) unless input.nil?
end
=end