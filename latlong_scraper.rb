require './spike'
require 'json'
require 'net/http'

NOBIRTHPLACE = {lat: "", lon: ""}

def location(city, region)
  uri = URI(URI.encode("http://nominatim.openstreetmap.org/search?q=#{city}, #{region}&format=json"))
  response = Net::HTTP.get(uri)
  parsed_response = JSON.parse(response)
  if parsed_response.count > 0
    [
      parsed_response.first["lat"],
      parsed_response.first["lon"]
    ]
  else
    NOBIRTHPLACE
  end
end

def birthplace_coordinates
  players.each do |player|
    p player
    if player[:birthplace] and not player[:longitude]
      location = location(*parse_birthplace(player[:birthplace]))
      player[:latitude] = location[0]
      player[:longitude] = location[1]
    end
  end
end

def parse_birthplace(birthplace)
  splits = birthplace.split(?,)
  city = splits[0].strip
  region = splits[1].strip
  return city, region
end

def run
  birthplace_coordinates
  save_rosters
end

run
