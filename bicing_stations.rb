require 'citybikes_api'
require_relative 'station_information'

NETWORK_ID = 'bicing'

class BicingStations

  def initialize
  end

  def closest_station(telegram_loc)
    nearby_stations.sort_by{ |station| distance(telegram_loc,station)}.take(2)
  end

  private

  def nearby_stations
    parse_stations(CitybikesApi.network(NETWORK_ID))
  end

  def parse_stations(data)
    data.parsed_response['network']['stations'].map {
        |station|
      StationInformation.new(station)
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
    station.distance
  end

end

