require 'rails_helper'

RSpec.describe Link, type: :model do

	include LinkHelper

	before(:each) do
		@link = Link.create(
			url: "http://www.baidu.com"
		)
	end
	
	describe "validation" do

		it "validate http://" do
			link = Link.new(url: "www.google.com")
			expect(link.save).to eq(false)
			expect(link.errors.full_messages).to eq(["url format error"])
		end

		it "validate link_type" do
			expect(@link.link_type).to eq(0)
			link = Link.create(
				url: "http://www.google.com",
				keyword: "abcdef"
			)
			expect(link.link_type).to eq(1)
		end

		it "validate keyword present" do
			expect(@link.keyword.present?).to	eq(true)
		end

		it "set length" do
			link = Link.new
			link.url = "http://www.google.com"
			link.length = 10
			link.save

			data = true
			link.keyword.each_char do |k|
				if not [0..9].map { |range| range.to_a }.flatten.include?(k.to_i)
					data = false
				end
			end
			expect(data).to eq(true)
		end

		it "set is_number" do
			link = Link.new
			link.url = "http://www.google.com"
			link.is_number = true
			link.save
			expect(link.keyword.to_i.to_s.length).to eq(link.keyword.length)

			link_1 = Link.new
			link_1.url = "http://www.google.com"
			link_1.is_number = false
			link_1.save
			expect(link_1.keyword.to_i.to_s.length).not_to eq(link_1.keyword.length)
		end

	end


end