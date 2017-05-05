require 'citybikes_api'
require 'logger'
require_relative 'station_information'
require_relative'network_information'


class BicingStations

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  def initialize

  end

  def closest_station(location= [], taken = 2)
    raise ArgumentError.new("Missing mandatory parameter location: #{location}") if location.empty?
    @@logger.info("BicingStations.closest_station location:#{location}")
    nearby_stations(location).sort_by{ |station| distance(location,station)}.take(taken)
  end

  def nearby_network(location = [])
    raise ArgumentError.new("Missing mandatory parameter location: #{location}") if location.empty?
    parse_networks(CitybikesApi.networks({:fields => "id,location"})).
    sort_by{ |network| distance(location,network)}.first
  end

  protected

  def nearby_stations(location)
    parse_stations(CitybikesApi.network(nearby_network(location).id.downcase))
  end

  private

  def parse_stations(data)
    data.parsed_response['network']['stations'].map {
        |station|
      StationInformation.new(station)
    }
  end

  def parse_networks(data)
    data.parsed_response['networks'].map {
        |network|
     NetworkInformation.new(network)
    }
  end


  def distance location, station
    station_loc = [station.latitude,station.longitude]
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (station_loc[0]-location[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (station_loc[1]-location[1]) * rad_per_deg

    lat1_rad, lon1_rad = location.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = station_loc.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    station.distance=(rm*c)
    rm*c
  end

  #private_class_method :new
end

