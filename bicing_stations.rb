require 'citybikes_api'
require 'logger'
require_relative 'data/station_information'
require_relative 'data/network_information'
require_relative 'data/location'


class BicingStations

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  def initialize; end

  def closest_station(location, taken = 1)
    raise ArgumentError.new("Missing mandatory parameter location: #{location}") if location.nil?
    @@logger.info("BicingStations.closest_station location:#{location.to_s}")
    stations = nearby_stations(location).sort_by{ |station| distance(location,station)}.take(taken)
    @@logger.info("BicingStations.closest_station info:#{stations.to_s}")
    stations
  end

  def nearby_network(location)
    raise ArgumentError.new("Missing mandatory parameter location: #{location}") if location.nil?
    parse_factory(CitybikesApi.networks({:fields => "id,location,company,name"})).
    sort_by{ |network| distance(location,network)}.first.id.downcase
  end


  protected

  def nearby_stations(location)
    parse_factory(CitybikesApi.network(nearby_network(location)), location.action)
  end

  def parse_factory(data, action = nil)
    case data.code
      when 200
        if data.has_key?('network')
          StationInformation.parse(data,action)
        else
          NetworkInformation.parse(data.parsed_response['networks'])
        end
      else
         raise StandardError.new('Cannot connect with the remote service, please try it later.')
    end
  end

  private

  def distance location, station
    station_loc = [station.latitude,station.longitude]
    user_loc = location.to_a
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (station_loc[0].to_f-user_loc[0].to_f) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (station_loc[1].to_f-user_loc[1].to_f) * rad_per_deg

    lat1_rad, lon1_rad = user_loc.map {|i| i.to_f * rad_per_deg }
    lat2_rad, lon2_rad = station_loc.map {|i| i.to_f * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    station.distance=(rm*c)
    rm*c
  end

end

