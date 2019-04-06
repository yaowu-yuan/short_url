require 'rails_helper'

RSpec.describe LinksController, type: :controller do
	# before(:each) do
	# 	post 'create', params: {
	# 		link: {
	# 			url: "http://www.baidu.com"
	# 		}
	# 	}
	# end

	# 测试创建短链接
	it "create" do
		post 'create', params: {
			link: {
				url: "http://www.baidu.com"
			}
		}

		expect(Link.count).to eq(1)
		expect(Link.first.keyword.present?).to eq(true)
	end

	# 测试创建短链接长度
	it "create_with_length" do
		post 'create', params: {
			link: {
				url: "http://www.baidu.com"
			},
			length: "10"
		}

		expect(Link.count).to eq(1)
		expect(Link.first.keyword.length).to eq(10)
	end
  
  # 测试创建短链接为纯数字
	it "create_with_number" do
		post 'create', params: {
			link: {
				url: "http://www.baidu.com"
			},
			is_number: "true"
		}

		expect(Link.count).to eq(1)
		keyword = Link.first.keyword
		data = true
		keyword.each_char do |k|
			if not [0..9].map { |range| range.to_a }.flatten.include?(k.to_i)
				data = false
			end
		end
		expect(data).to eq(true)
	end

	# 测试跳转
	it "redirect_short_url" do
		post 'create', params: {
			link: {
				url: "http://www.baidu.com"
			}
		}

		get 'redirect_short_url', params: {
			path: Link.first.keyword
		}

		expect(response.status).to eq(302)
		expect(Link.first.hits).to eq(1)
	end

	# 测试短链接不存在
	it "redirect_short_url_fail" do
		get 'redirect_short_url', params: {
			path: "xxxxx"
		}

		expect(response.status).to eq(404)
	end

end