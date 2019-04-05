class Link < ApplicationRecord

	attr_accessor :length, :is_number

	include LinkHelper

	before_validation :default_value

	before_save :set_link_type

	before_save :set_keyword

	validates_presence_of :url

	validate :url_format

	validates_uniqueness_of :keyword

	enum type: {
		system: 0,
		custom: 1,
	}

	private

	def default_value
		self.length = 6 if length.blank?
		self.is_number = false if is_number.blank? or is_number == "false"
		self.is_number = true if is_number == "true"
	end

	def set_link_type
		if self.link_type.blank?
			if self.keyword.blank?
				self.link_type = Link::types[:system]
			else
				self.link_type = Link::types[:custom]
			end
		end
		
	end

	def set_keyword
		if self.keyword.blank?
			keyword = get_keyword(length, is_number)

			while Link.find_by_keyword(keyword).present?
				keyword = get_keyword(length, is_number)
			end

			self.keyword = keyword
		end
	end

	def url_format
		if not self.url.include?("http")
			errors[:base] << "url format error"
		end
	end

end
