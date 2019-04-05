module LinkHelper

	def get_keyword length = 6, is_number = false
		list = [0..9, 'A'..'Z', 'a'..'z']
		list = [0..9] if is_number
		chars = list.map { |range| range.to_a }.flatten
		length.to_i.times.map { chars.sample }.join
	end
end
