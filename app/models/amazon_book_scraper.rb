require 'nokogiri'
require 'open-uri'
require_relative 'string'

class AmazonBookScraper
	# returns a hash containing the book attributes
	def self.scrape url
		page = Nokogiri::HTML(open(url))

		title = title(page)
		author = author(page)
		book_details = book_details(page)
		img_url = image_url(page)

		book = {
			:title     => title,
			:publisher => book_details[:publisher],
			:edition   => book_details[:edition],
			:author    => author,
			:isbn_10   => book_details[:isbn_10],
			:isbn_13   => book_details[:isbn_13],
			:img_url   => img_url
		}
	end

	private

	def self.author page
		authors = []
		author_spans = page.css('div#booksTitle div#byline span.author')
		author_spans.each do |span|
			contributor_anchor = span.css('a.contributorNameID')
			if contributor_anchor.empty?
				author_anchor = span.css('a')[0] # the first link after the author span
				authors << author_anchor.text
			else
				# get text from the anchor
				authors << contributor_anchor[0].text
			end
		end
		authors.join(', ')
	end

	def self.book_details page
		book_details = {}
		details_div = page.xpath("//h2[text() = 'Product Details']").first().next_element()
		details_div.css('li').each do |list_element|
			if list_element.text.start_with? "Publisher: "
				book_details[:publisher], book_details[:edition] = publisher_edition_parse(list_element.text.gsub("Publisher: ", ""))
			elsif list_element.text.start_with? "ISBN-10: "
				book_details[:isbn_10] = list_element.text.gsub("ISBN-10: ", "")
			elsif list_element.text.start_with? "ISBN-13: "
				book_details[:isbn_13] = list_element.text.gsub("ISBN-13: ", "")
			end
			if book_details.count == 4
				break
			end
		end
		book_details
	end

	def self.image_url page
		image = page.css('div#main-image-container img')[0]
		image['src']
	end

	# publisher_edition -> <publisher>; <edition> edition <publish-date>
	def self.publisher_edition_parse publisher_edition
		sections = publisher_edition.split('; ')
		if sections.size > 1
			publisher, edition = sections[0], sections[1].split(' ')[0].ordinate
		else
			publisher, edition = sections[0], ""
		end
	end

	def self.title page
		title_spans = page.css('h1#title span')
		title, first_span, first_attr = [], true, true
		title_spans.each do |span|
			if first_span
				title << span.text
				first_span = false
			elsif first_attr
				title << "[#{span.text}]" # place attributes in brackets
				first_attr = false
			else
				text = span.text
				title << "[#{text[2, text.length]}]" # ignore the dash and space separating the remaining attributes
			end
		end
		title.join(' ')
	end
end
