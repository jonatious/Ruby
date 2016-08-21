require 'net/http'
require 'uri'

def print_stocks(stocks)
	printf "%-10s %s\n", "Ticker","Price"
	stocks.each {|key,value| printf "%-10s %s\n", key, value}
end

def read_tickers(inputFile)
	(IO.readlines(inputFile)).map(&:chomp)
end

def parse_stock_price(ticker)
	data = Net::HTTP.get(URI.parse("http://ichart.finance.yahoo.com/table.csv?s=#{ticker}"))
	(data.include? '404 Not Found')? 'Invalid Ticker' : '$' + data.lines[1].split(',').last.to_f.round(2).to_s
end

def read_stock_details(tickers)
  Hash[tickers.map{|symbol| [symbol, parse_stock_price(symbol)] }].sort.to_h
end

print_stocks(read_stock_details(read_tickers('./tickers.txt')))