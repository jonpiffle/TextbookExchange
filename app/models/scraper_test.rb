require 'nokogiri'
require 'open-uri'
require 'pry'

def get_attr(div, attribute)
	title = div.search("b[text()='#{attribute}:']").first
	text = title.next.text[1..-1]
end

def parse_publisher(publisher_edition)
	publisher = publisher_edition.match(/^(.*);/)[1]
	edition = publisher_edition.match(/;\s(\w*)/)[1]
	return publisher, edition
end

raw_url = "http://www.amazon.com/Archaeology-Theories-Methods-Practice-Edition/dp/050028976X/ref=sr_1_3?ie=UTF8&qid=1388898455&sr=8-3&keywords=archaeology+textbook"
url = raw_url.gsub(/ref=.*/, "")
page = Nokogiri::HTML(open(url)) 
h2 = page.xpath("//h2[text()='Product Details']").first()
info_div = h2.next_element()
isbn_10 =  get_attr(info_div, "ISBN-10")
isbn_13 =  get_attr(info_div, "ISBN-13")
publisher_edition = get_attr(info_div, "Publisher")
publisher, edition = parse_publisher(publisher_edition)
title = page.xpath('//span[@id="btAsinTitle"]').text
author = page.xpath('//div[@class="buying"]')[3].children.search("a").map(&:text).join(", ")
img_url = page.xpath('//img[@id="main-image"]').first.attributes['src'].value
binding.pry