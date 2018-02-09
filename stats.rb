#! /usr/bin/env ruby

require "json"
require "date"
require "byebug"

data = JSON.parse(File.read("tether-effect.json"))

grant_diff = data["grants"].reduce(0) do |acc, grant|
  acc + grant[6] - grant[3]
end

control_diff = data["random"].reduce(0) do |acc, grant|
  acc + grant[6] - grant[3]
end

grant_avg_inc = data["grants"].reduce(0) do |acc, grant|
  acc + (((grant[6] / grant[3]) - 1) * 100)
end / data["grants"].count

control_avg_inc = data["random"].reduce(0) do |acc, grant|
  acc + (((grant[6] / grant[3]) - 1) * 100)
end / data["random"].count

grant_declines = data["grants"].select do |grant|
  grant[2] < grant[1]
end

control_declines = data["random"].select do |grant|
  grant[2] < grant[1]
end

puts "TOTAL USD PRICE INCREASE:"
puts " - GRANTS: #{grant_diff}"
puts " - RANDOM: #{control_diff}"

puts "AVERAGE USD PRICE INCREASE:"
puts " - GRANTS: #{grant_avg_inc}"
puts " - RANDOM: #{control_avg_inc}"

puts "PRICE DECLINES:"
puts " - GRANTS: #{grant_declines.count}"
puts " - RANDOM: #{control_declines.count}"
