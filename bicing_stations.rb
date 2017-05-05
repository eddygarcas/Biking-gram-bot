require 'citybikes_api'
require_relative 'station_information'
require_relative'network_information'


class BicingStations

  def initialize
  end

  def closest_station(telegram_loc, taken = 2)
    nearby_stations(telegram_loc).sort_by{ |station| distance(telegram_loc,station)}.take(taken)
  end

  def nearby_network(telegram_loc)
    parse_networks(CitybikesApi.networks({:fields => "name,location"})).
    sort_by{ |network| distance(telegram_loc,network)}.first
  end

  protected

  def nearby_stations(telegram_loc)
    parse_stations(CitybikesApi.network(nearby_network(telegram_loc).name.downcase))
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


  def distance telegram_loc, station
    station_loc = [station.latitude,station.longitude]
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (station_loc[0]-telegram_loc[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (station_loc[1]-telegram_loc[1]) * rad_per_deg

    lat1_rad, lon1_rad = telegram_loc.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = station_loc.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    station.distance=(rm*c)
    rm*c
  end
end

