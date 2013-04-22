#!/usr/bin/env ruby -wKU

require 'net/http'
require 'uri'
require 'json'
require 'date'

data = {
	:p_crimecodes => ["AOO","AR","AS","BUR","DC","DST","DG","DK","DUI","FF","HM","LQ","PS","RB","THF","VD","VTH","WO","SA","DV"],
	:minx => -153.08349609375,
	:miny => 59.905467573267195,
	:maxx => -146.66748046875,
	:maxy => 62.405640221642315,
	:p_startdate => "\/Date(1334649600000)\/",
	:p_enddate => "\/Date(1334649600000)\/"
}

# 4/17/2012

headers = {
	"Content-Type" => "application/json",               
    "Accept-Encoding" => "gzip,deflate",
    "Accept" => "application/json"
}

uri = URI.parse("http://crimemap.muni.org/CrimeService.svc/GetCrimeData")
http = Net::HTTP.new(uri.host,uri.port)


records = []
(1334649600000..(Date.today.to_time.to_i*1000)).step(86400000) do |day|
  data[:p_startdate] = data[:p_enddate] = "\/Date(#{day})\/"
  response = http.post(uri.path,data.to_json,headers)
  stuff = JSON.parse(response.body, {:symbolize_names => true})
  records += stuff[:d]
end

crimes = { :crimes => records}

puts JSON.generate(crimes)