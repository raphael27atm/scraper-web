require 'open-uri'
require 'nokogiri'
require 'csv'

# Store url
url = "http://centrodosuplemento.com.br/suplementos"
# Parse page Nokogori
page = Nokogiri::HTML(open(url))

page_numbers = []
page.css(".toolbar-bottom .pager .pages ol li").each do |line|
  page_numbers << line.text
end

max_page = page_numbers.max

# Initialize Arrays
name = []
price = []
details = []

# Search results
max_page.to_i.times do |i|
  # Open search results page
  url = "http://centrodosuplemento.com.br/suplementos?p=#{i+1}"
  page = Nokogiri::HTML(open(url))

  # Store data in Arrays
  page.css('.product-name a').each do |line|
    name << line.text.strip
  end

  page.css('.price-box .price').each do |line|
    price << line.text
  end

  page.css('.products-list .desc').each do |line|
    details << line.text.strip.split(/ . /)
  end
end

CSV.open("cds_list.csv", "w") do |file|
  file << ["Listing Name", "Price", "Details",]

  name.length.times do |i|
    file << [name[i], price[i], details[i]]
  end
end
