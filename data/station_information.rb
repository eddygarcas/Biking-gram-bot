require_relative 'information'

class StationInformation < Information

  VALID_FIELDS = ['id','empty_slots','free_bikes','latitude','longitude','name']

  @distance = 0

  def distance=dist
    @distance = (result = dist.round / 1000) > 1 ? "#{result}Km." : "#{dist.round}m."
  end

  def distance
    @distance
  end

  # id
  # empty_slots
  # free_bikes
  # latitude
  # longitude
  # name
  def initialize(sta)
    sta.each do |k,v|
      if VALID_FIELDS.include?(k)
        accesor_builder k,v
      end
    end
  end


  def self.suitable_station?(elem, action = nil)
    return true if action.nil?
    ( (action.eql?('p') &&
    elem['free_bikes'].eql?(0)) ||
    (action.eql?('d') &&
    elem['empty_slots'].eql?(0)) ) ? false : true
  end

  def to_inline_title
    %Q{At #{distance} in #{name} street}
  end

  def to_s
    %Q{At #{distance} in #{name} street, you'll find \nEmpty Slots #{empty_slots} \nFree bikes  #{free_bikes}}
  end

  def to_inline
    %Q{At #{distance}\n Empty #{empty_slots}\n Free #{free_bikes}}
  end

end