require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'nokogiri'
require 'open-uri'

class School
  attr_accessor :dbn
  attr_accessor :address, :phone, :principal

  def homepage_url
    url = "http://schools.nyc.gov/SchoolPortals/#{self.district_code}/#{self.loc_code}/default.htm"
  end

  def valid_url
    url = URI.parse(self.homepage_url)
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    res.code.to_i == 200
  end

  def district_code
    @dbn[0...2]
  end

  def loc_code
    @dbn[2...6]
  end

  def extract_html
    open(self.homepage_url) do |f|
      doc = Nokogiri::HTML(f)
      addr_phone = doc.at_css('[@class="schooladdress"]').content
      @address, @phone = addr_phone.split('Phone: ')
    end    
  end
end
