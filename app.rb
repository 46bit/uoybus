require "sinatra"
require "httparty"
require "json"
require "tzinfo"
require "yaml"

begin
  CREDENTIALS = YAML::load_file "credentials.yml"
rescue Errno::ENOENT
  puts "No credentials.yml file found. Use credentials.sample.yml as a template."
  exit
end

begin
  ROUTE = YAML::load_file "route.yml"
rescue Errno::ENOENT
  puts "No route.yml file found. Use route.sample.yml as a template."
  exit
end

before do
  @typekit = CREDENTIALS[:typekit]

  @site_name = ROUTE[:site_name]
  @buses = ROUTE[:buses]
  @directions = ROUTE[:directions]
  @areas = ROUTE[:areas]
end

def get_area area_code
  as = @areas.select {|a| a[:code] == area_code}
  return as.first
end

def get_direction direction
  ds = @directions.select {|d| d == direction}
  return ds.first
end

def get_departure_times area, direction
  departures = get_departures area, direction
  departure_times = {}

  departures.each_pair do |bus, bus_departures|
    if !@buses.include?(bus)
      next
    end

    departure_times[bus] = []
    bus_departures.each do |bus_departure|
      # Localise Europe/London times from TransportAPI (ie: account for BSD)
      # then work out minutes-until-arrival in UTC.
      # @TODO: Can just be done in Europe/London using tz.now/similar?
      tz = TZInfo::Timezone.get("Europe/London")
      local_departure = DateTime.parse(bus_departure["best_departure_estimate"])
      utc_departure = tz.local_to_utc(local_departure).to_time

      arrival_in = ((utc_departure - Time.new.utc) / 60).ceil
      if arrival_in < 0
        next
      end
      if bus_departure["expected_departure_time"]
        arrival_in = "(#{arrival_in.to_s})"
      end

      departure_times[bus] << arrival_in.to_s
    end
  end

  return departure_times
end

def get_departures area, direction
  if area[:atcocodes][direction].nil?
    puts "ERROR: Requesting non-existent direction #{direction} for #{@area[:code]}."
    return {}
  end

  atcocode_departures = area[:atcocodes][direction].map do |atcocode|
    get_atcocode_departures atcocode
  end
  return atcocode_departures.inject(:merge)
end

def get_atcocode_departures atcocode
  path = "/v3/uk/bus/stop/#{atcocode.to_s}/live.json?group=route&#{transportapi_keystring}"
  result = get_transportapi path

  if result.nil? || result["departures"].nil?
    puts "ERROR: Empty result from TransportAPI for path #{path}."
    return {}
  end

  return result["departures"]
end

def get_transportapi path
  url = "http://transportapi.com#{path}"
  response = HTTParty.get url

  if response.code != 200
    puts "ERROR: TransportAPI #{response.code} status for #{url}."
    return nil
  end

  return JSON.parse(response.body)
end

def transportapi_keystring
  "api_key=#{CREDENTIALS[:transportapi][:api_key]}&app_id=#{CREDENTIALS[:transportapi][:app_id]}"
end

get "/" do # departing from where?
  erb :departing
end

get "/:area" do |area|
  @area = get_area area.to_s

  if @area.nil?
    redirect "/"
  elsif @area == @areas.first
    redirect "/#{@area[:code]}/#{@directions.first}"
  elsif @area == @areas.last
    redirect "/#{@area[:code]}/#{@directions.last}"
  end

  erb :where_to
end

get "/:area/:direction" do |area, direction|
  @area = get_area area.to_s
  @direction = get_direction direction.to_s

  if @area.nil? || @direction.nil?
    redirect "/"
  end

  if @direction == @directions.last
    @end_area = @areas.first
  else
    @end_area = @areas.last
  end

  @departure_times = get_departure_times @area, @direction

  erb :result
end
