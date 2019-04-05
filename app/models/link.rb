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

	# 给可配置项设置默认值
	def default_value
		self.length = 6 if length.blank?
		self.is_number = false if is_number.blank? or is_number == "false"
		self.is_number = true if is_number == "true"
	end

	# 设置短链的生成类型
	def set_link_type
		if self.link_type.blank?
			if self.keyword.blank?
				self.link_type = Link::types[:system]
			else
				self.link_type = Link::types[:custom]
			end
		end
		
	end

	# 用户没有设置短链，则自动生成短链
	def set_keyword
		if self.keyword.blank?
			keyword = get_keyword(length, is_number)

			# 检查短链是否重复，若重复，则重新生成短链，直到不重复
			while Link.find_by_keyword(keyword).present?
				keyword = get_keyword(length, is_number)
			end

			self.keyword = keyword
		end
	end

	# 检查长链是否以http开头
	def url_format
		if not self.url.include?("http")
			errors[:base] << "url format error"
		end
	end

end
