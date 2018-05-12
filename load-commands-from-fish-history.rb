#!/usr/bin/ruby
history = []
entry = nil
ARGF.each_line do |line|
  line.chomp!
  if line[0] == '-'
    unless entry.nil? or entry.size == 0
      history << [entry[:when], entry[:cmd]]
    end
    entry = {}
  end
  line = line[2..-1]
  case line
  when /^cmd:/
    entry[:cmd] = line['cmd: '.length..-1].strip
  when /^when:/
    entry[:when] = line['when: '.length..-1].strip.to_i
  end
end

history.sort_by {|time, _| -time }.each do |_, cmd|
  puts(cmd)
end
