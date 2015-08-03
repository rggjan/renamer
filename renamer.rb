#!/usr/bin/ruby

require 'mini_exiftool'

def rename(from, to)
  if from == to
    puts "#{from} already has correct name, nothing to do..."
    return
  end
  raise "File #{to} already existing" if File.file?(to)
  puts "Rename " + from + " to " + to
  File.rename(from, to)
end

counts = {}
Dir.foreach(".") do |item|
  next if item == '.' or item == '..'
  puts "Processing #{item}..."
  extension = File.extname(item).downcase
  next unless [".jpg", ".mts", ".arw"].include? extension
  # do work on real items
  File.open(item) do |file|
    name = [MiniExiftool.new(item).date_time_original.strftime("%Y-%m-%d %H:%M:%S"), extension]
    if counts[name].nil?
      counts[name] = [item]
    else
      counts[name] << item
    end
  end
end

puts

# Sort by original name
counts.each do |key, values|
  if values[1]
    count = 0
    values.sort.each do |value|
      rename(value, key.join("_#{count}"))
      count += 1
    end
  else
    rename(values[0], key.join(""))
  end
end
