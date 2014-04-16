class AmazonBookScraper
	def self.author page
		authors = []
		page.css('div#booksTitle div#byline span.author').each do |span|
			contributorAnchor = span.css('a.contributorNameID')
			if contributorAnchor.empty?
				# if no contributor anchor exists in this span, the author is in the first link in this span
				authorAnchor = span.css('a')[0]
				authors << authorAnchor.text
			else
				# get text from the contributor anchor
				authors << contributorAnchor[0].text
			end
		end
		authors.join(', ')
	end
end
