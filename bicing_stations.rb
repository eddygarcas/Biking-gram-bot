require 'citybikes_api'
require 'logger'
require_relative 'data/station_information'
require_relative 'data/network_information'


class BicingStations

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  def initialize

  end

  def closest_station(location= [], action = nil, taken = 2)
    raise ArgumentError.new("Missing mandatory parameter location: #{location}") if location.empty?
    @@logger.info("BicingStations.closest_station location:#{location}")
    nearby_stations(location, action).sort_by{ |station| distance(location,station)}.take(taken)
  end

  def nearby_network(location = [])
    raise ArgumentError.new("Missing mandatory parameter location: #{location}") if location.empty?
    parse_factory(CitybikesApi.networks({:fields => "id,location"})).
    sort_by{ |network| distance(location,network)}.first.id.downcase
  end


  protected

  def nearby_stations(location, action = nil)
    parse_factory(CitybikesApi.network(nearby_network(location)), action)
  end

  def parse_factory(data, action = nil)
    case data.code
      when 200
        if data.has_key?('network')
            parse data.parsed_response['network']['stations'], StationInformation, action
          else
            parse data.parsed_response['networks'], NetworkInformation
        end
      else
         raise StandardError.new('Cannot connect with the remote service, please try it later.')
    end
  end

  private

  def parse (data, class_instance, action = nil)
    begin
      elements = data.map { |elem|
        class_instance.new(elem) if class_instance.suitable_station?(elem, action)
      }
    rescue Exception
      raise StandardError.new('Cannot parse the service response')
    end
    #Won't use compact! here due to will retrun a nil array rather than a copy of the array without the nil values
    elements.compact
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

end

