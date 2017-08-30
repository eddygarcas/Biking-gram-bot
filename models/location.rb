
class Location

  attr_accessor :latitude, :longitude, :action

  def initialize (element, action = 'p')

    case element
      when String
        loc = eval(element)
        @latitude = loc[:latitude]
        @longitude = loc[:longitude]
        @action = loc[:a]
      when Telegram::Bot::Types::Location
        @latitude = element.latitude
        @longitude = element.longitude
        @action = action
    end
  end

  def to_s
    %Q{"Latitude: {#@latitude} Longitude: {#@longitude}"}
  end

  def to_a
    [@latitude, @longitude]
  end

  def to_callback_loc
    {:latitude => @latitude , :longitude => @longitude, :a => @action}.to_s
  end

end