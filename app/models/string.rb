class String
	def number?
		case self.length
		when 0
			false
		when 1
			if self =~ /\d/
				true
			else
				false
			end
		else
			bool = true
			self.each_char do |char|
				bool &&= char.number?
			end
			bool
		end
	end

	def ordinate
		if self.number?
			case self[self.length - 1].to_i
			when 1
				unless self.end_with? "11"
					"#{self}st"
				else
					"#{self}th"
				end
			when 2
				unless self.end_with? "12"
					"#{self}nd"
				else
					"#{self}th"
				end
			when 3
				unless self.end_with? "13"
					"#{self}rd"
				else
					"#{self}th"
				end
			else
				"#{self}th"
			end
		else
			self
		end
	end
	
	def truncate(truncate_at, options = {})
	  return dup unless length > truncate_at

	  options[:omission] ||= '...'
	  length_with_room_for_omission = truncate_at - options[:omission].length
	  stop =        if options[:separator]
	      rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
	    else
	      length_with_room_for_omission
	    end

	  "#{self[0...stop]}#{options[:omission]}"
	end
end