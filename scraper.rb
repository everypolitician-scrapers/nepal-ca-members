#!/bin/env ruby
# encoding: utf-8

require 'colorize'
require 'csv'
require 'json'
require 'nokogiri'
require 'scraperwiki'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'

def reprocess_csv(file)
  raw = open(file).read.force_encoding("UTF-8")
  csv = CSV.parse(raw.lines.drop(2).join)
  csv.each_with_index do |row, i|
    next if row[0].to_s.empty?
    next if row[9].to_s.empty?
    next if row[0].to_s.include? 'Development Region'
    data = {
      name: row[9].to_s.strip,
      name__ne: row[2].to_s.strip,
      area: row[8].to_s.strip,
      area__ne: row[1].to_s.strip,
      party: row[12].to_s.strip,
      party__ne: row[6].to_s.strip,
      email: row[7].to_s.strip,
      mobile: (row[3] || "").lines.first.to_s.strip,
      phone:  (row[5] || "").lines.first.to_s.strip,
      term: 'ca2',
    }
    ScraperWiki.save_sqlite([:name, :area, :term], data)
  end
end

csv_data = reprocess_csv('https://docs.google.com/spreadsheets/d/1yRtq9B81vgPJ373nwhjuwwdDp-FnlyI17QMOAQRrcVE/export?format=csv&gid=18')
