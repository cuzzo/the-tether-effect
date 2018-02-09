# The Tether Effect

I am not a statistician. Interpret at your own discretion.

I have compiled a list of all Tether grants. For each grant, I've collected the minute-by-minute price data to generate a chart of what happens in the 6 hours before and the 6 hours after.

[The Tether Report](https://www.tetherreport.com/) is a much better, more scientific version of this. But for the statistically disinclined, but it's also a little hard to digest. This is an attempt to make the data easier to digest for "the rest of us".

## Reproduction Instructions

### Prerequisites

* Install Ruby

### Download Coinbase Data

Historical CoinBase/GDAX ticker data can be found here: http://api.bitcoincharts.com/v1/csv/

* [Download the Coinbase USD ticker data](http://api.bitcoincharts.com/v1/csv/coinbaseUSD.csv.gz).
* Un-gzip it: `gunzip /path/to/coinbaseUSD.csv/gz`
* Move it into this repository's `./data` directory.

### Transform the Coinbase Ticker Data

The code needs minute-by-minute data. But not every minute in the GDAX data has a corresponding price.

Run `./minute-by-minute.rb` to generate `data/coinbaseUSD-mm.json`

### Genereate Tether-Effect.json

Run `./compare.rb`

Note that your randomly generated dates will be different from the ones published.

This generates a file: `Tether-Effect.json`.

It generates two objects: "grants", "random". The values in "grants" are associated with Tether grants. The values in "random" are associated with randomly selected times.

Each object is a list of data points. Each data point is an array with this structure:

```
0 => timestamp_of_grant,
1 => average_price_in_the_six_hours_before_grant,
2 => average_price_in_the_six_hours_after_grant,
3 => price_six_hours_before_grant,
4 => price_at_time_of_grant,
5 => price_six_hours_after_grant,
6 => price_high_in_the_six_hours_after_grant,
7 => average_slope_before_grant,
8 => average_slope_after_grant
9 => list_of_all_prices_from_six_hours_before_to_six_hours_after_grant
```

Feel free to change the code to get your signals.

### Make a pretty table

Run `./tableize.rb`

This will generate `Tether-Effect.tsv`. You can feed that data to: https://ozh.github.io/ascii-tables/ , to convert it into a pretty table.

## License

This code is free--as in BSD. Hack your heart out, hackers.

BTC: 19QK13CPNwNuzVcLgHxjqRWzGtAWv7SWwr
