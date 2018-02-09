#! /usr/bin/env ruby

require "json"
require "date"

def tableize(data)
  data.map do |grant|
    datetime = Time.at(grant.first).to_datetime

    [
      datetime.strftime("%d %b %Y %H:%M:%S"),
      grant[7].round(2),
      grant[3].round(2),
      grant[1].round(2),
      grant[4].round(2),
      grant[2].round(2),
      grant[5].round(2),
      grant[8].round(2)
    ]
    .join("\t")
  end
end

data = JSON.parse(File.read("tether-effect.json"))
grants = tableize(data["grants"])
control = tableize(data["random"])

File.write("tether-effect-grants.tsv", grants.join("\n"))
File.write("tether-effect-random.tsv", control.join("\n"))
