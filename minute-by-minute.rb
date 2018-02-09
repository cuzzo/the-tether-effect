#! /usr/bin/env ruby

require "date"
require "json"

# IN: timestamp,price,volume
# OUT: timestamp, trades_at_minute, volume_at_minute, price_at_minute
times = File
  .foreach("data/coinbaseUSD.csv")
  .reduce([]) do |acc, line|
    parts = line.split(",")

    timestamp = parts.first.to_i

    if acc.last && (timestamp - acc.last.first < 60)
      last = acc.pop
      trades_at_minute = last[1]
      volume_at_minute = last[2] + parts.last.to_f

      avg_price = (last.last * trades_at_minute + parts[1].to_f) / (trades_at_minute + 1)
      acc << [last.first, trades_at_minute + 1, volume_at_minute, avg_price]
    else
      acc << [parts.first.to_i, 1, parts.last.to_f, parts[1].to_f]
    end

    acc
  end

File.write("data/coinbaseUSD-mm.json", times.to_json)
