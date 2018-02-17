#! /usr/bin/env ruby

require "date"
require "json"

TIME_SERIES = JSON.parse(File.read("data/coinbaseUSD-mm.json"))

def get_section(timestamp)
  len = 60 * 12 # SIX HOURS

  start = TIME_SERIES.each_with_index.detect { |t, i| t.first > timestamp - (60 * len) }
  time_of = TIME_SERIES.each_with_index.detect { |t, i| t.first > timestamp }
  finish = TIME_SERIES.each_with_index.detect { |t, i| t.first > timestamp + (60 * len) }

  start = start.last
  time_of = time_of.last - 1
  finish = finish.last - 1

  before = TIME_SERIES.slice(start, time_of - start).map(&:last)
  before_slope = (before.count - 1).times.reduce(0) do |acc, index|
    acc += before[index + 1] - before[index]
    acc
  end / (before.count - 1)

  after = TIME_SERIES.slice(time_of + 1, finish - time_of + 1).map(&:last)
  after_slope = (after.count - 1).times.reduce(0) do |acc, index|
    acc += after[index + 1] - after[index]
    acc
  end / (after.count - 1)

  after_high = after.first(len).max
  time_of = TIME_SERIES[time_of]

  [
    timestamp,
    before.reduce(0, :+) / before.count,
    after.reduce(0, :+) / after.count,
    before.first,
    time_of.last,
    after.last,
    after_high,
    before_slope,
    after_slope,
    before + [time_of.last] + after
  ]
end

grants = JSON.parse(File.read("data/tether-grants.json"))
  .map do |time|
    get_section(time["timestamp"])
  end

tend = DateTime.parse("2018/02/06 8:32:52 PM GMT").to_time.to_i
tstart = DateTime.parse("2015/12/01 9:01:13 PM GMT").to_time.to_i

randos = grants
  .count
  .times
  .map { |i| rand(tstart...tend) }
  .sort
  .map { |timestamp| get_section(timestamp) }

File.write("tether-effect-long.json", {
  grants: grants,
  random: randos
}.to_json)
