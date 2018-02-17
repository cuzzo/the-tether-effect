#! /usr/bin/env ruby

require "json"
require "date"
require "byebug"

grants = File
  .read("data/tether-grants.txt")
  .lines
  .map do |line|
    parts = line.split(" => ")

    date_time = parts.first.split(" ", 2)
    date = date_time.first.split("/")
    date = "#{date[2]}.#{date[0]}.#{date[1]}"
    time = DateTime.parse("#{date} #{date_time.last} GMT")
    byebug

    {
      timestamp: time.to_time.to_i,
      amount: parts.last.split(" ; ").first.to_f
    }
  end

File.write("data/tether-grants.json", grants.to_json)
