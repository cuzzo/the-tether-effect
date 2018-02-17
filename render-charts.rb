#! /usr/bin/env ruby

require "json"
require "date"
require "erb"
require "active_support/all"

data = JSON.parse(File.read("tether-effect.json"))

def labels(grant)
  [Time.at(grant.first - 60 * 60 * 6).to_datetime.strftime("%y.%m.%d %H:%M:%S")] +
    ([nil] * ((grant.last.count - 3) / 2)) +
    [Time.at(grant.first).to_datetime.strftime("%y.%m.%d %H:%M:%S")] +
    ([nil] * ((grant.last.count - 3) / 2)) +
    [Time.at(grant.first + 60 * 60 * 6).to_datetime.strftime("%y.%m.%d %H:%M:%S")]
end

def options(grant)
  {
    width: 700,
    height: 350,
    chartPadding: {
      right: 40,
    },
    high: [grant[4] * 1.05, grant.last.max].max,
    low: [grant[4] * 0.95, grant.last.min].min
  }
end

def meta(grant)
  {
    time: Time.at(grant.first).to_datetime.strftime("%d %b %Y %H:%M:%S"),
    percent_change: (grant.last.max - grant.last.min) / grant.last.max,
    percent_gain: (grant[2] - grant[1]) / (grant.last.reduce(0, :+) / grant.last.count)
  }
end

grants = data["grants"].map do |grant|
  {
    meta: meta(grant),
    chart: {
      labels: labels(grant),
      series: [{
        data: grant.last
      }]
    },
    options: options(grant)
  }
end

random = data["random"]
  .sort_by { |random| random.first }
  .reverse
  .map do |random|
  {
    meta: meta(random),
    chart: {
      labels: labels(random),
      series: [{
        data: random.last
      }]
    },
    options: options(random)
  }
end

class ChartRenderer
  include ERB::Util

  attr_accessor :template, :grants

  def initialize(template, grants, random)
    @template = template
    @grants = grants.zip(random)
  end

  def render()
    ERB.new(@template).result(binding)
  end
end

def render_charts(grants, random)
  path = File.join(File.dirname(__FILE__), "charts.erb")
  template = File.read(path)
  renderer = ChartRenderer.new(template, grants, random)
  renderer.render()
end

File.write("tether-effect.html", render_charts(grants, random))
