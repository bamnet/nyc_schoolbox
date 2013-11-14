require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

module AttendanceList

  FEED_URL = 'http://schools.nyc.gov/aboutus/data/attendancexml/'

  def AttendanceList.latest_data
    open(AttendanceList::FEED_URL) do |f|
      doc = Nokogiri::XML(f)
      items = doc.xpath('//schooldailyattendance/item').collect do |i|
        {'school_name' => i.xpath('SCHOOL_NAME').first.content,
         'dbn' => i.xpath('DBN').first.content,
         'borough' => i.xpath('Borough').first.content,
         'district_code' => i.xpath('DistrictCode').first.content,
         'loc_code' => i.xpath('LOC_CODE').first.content,
         'attn_date' => i.xpath('ATTN_DATE_YMD').first.content,
         'attn_pct' => i.xpath('ATTN_PCT').first.content,
        }
      end
      items.map! do |item|
        item['attn_date'] = Date.parse(item['attn_date'])
        item['attn_pct'] = item['attn_pct'].to_f
        item
      end
      items.delete_if do |item|
        item['dbn'] == 'TOTAL'
      end
      return items
    end
  end
end
