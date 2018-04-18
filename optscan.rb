module OptScan
  def self.optscan(string, downcase = true)
    unless string.respond_to? :each
      string = string.split(' ')
    end
    args = {:flags => [], :params => [], :options => {}}
    flag = nil
    string.each do |s|
      if s[0] == '-'
        unless flag.nil?
          args[:flags] << flag
        end
        if s[1] == '-'
          s.downcase! if downcase
          flag = s[2..-1]
          flag = nil if flag == ''
        else
          s[1..-1].each_char do |char|
            args[:flags] << char
          end
          flag = nil
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
    args[:flags] << flag unless flag.nil?
    args
  end
end


=begin
# -Asda sDsdd --As akdsj ads --d ajsd --as aj adg asd

input = 'asd'
exits = ['q', 'quit', 'exit']
while !input.nil? && !exits.include?(input.strip.downcase)
  input = gets
  puts OptScan::optscan(input) unless input.nil?
end
=end