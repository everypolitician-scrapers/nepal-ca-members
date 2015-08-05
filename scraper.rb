#!/bin/env ruby
# encoding: utf-8

require 'colorize'
require 'csv'
require 'json'
require 'nokogiri'
require 'scraperwiki'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def reprocess_csv(file)
  raw = open(file).read.force_encoding("UTF-8")
  csv = CSV.parse(raw.lines.drop(2).join)
  csv.each do |row|
    next if row[0].to_s.empty?
    next if row[8].to_s.empty?
    next if row[0].to_s.include? 'Development Region'
    data = { 
      name: row[2],
      name__en: row[8],
      area: row[1],
      area__en: row[7],
      email: row[6],
      party: row[5],
      mobile: (row[3] || "").lines.first,
      phone: (row[4] || "").lines.first,
      term: 'ca2',
    }
    puts data[:name]
    ScraperWiki.save_sqlite([:name, :term], data)
  end
end

csv_data = reprocess_csv('https://docs.google.com/spreadsheets/d/1yRtq9B81vgPJ373nwhjuwwdDp-FnlyI17QMOAQRrcVE/export?format=csv&gid=18')

