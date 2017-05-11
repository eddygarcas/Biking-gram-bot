
class StationInformation

  VALID_FIELDS = ['id','empty_slots','free_bikes','latitude','longitude','name']

  @distance = 0

  # id
  # empty_slots
  # free_bikes
  # latitude
  # longitude
  # name
  def initialize(sta)

    sta.each do |k,v|
      if VALID_FIELDS.include?(k)
        #First will create a new instance variable, value if it wasn't a Hash or Hash type instead.
        self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hash.new(v) : v)
        #Secondly will define a get instance method for the given value
        self.class.send(:define_method, "#{k}", proc{self.instance_variable_get("@#{k}")})
        #Finally will define a set instance method for the given value. Notice the proc block
        # to be called every time the set method is called.
        self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
      end
    end
  end

  def distance=dist
    @distance = (result = dist.round / 1000) > 1 ? "#{result}Km." : "#{dist.round}m."
  end

  def distance
    @distance
  end

  def to_s
    %Q{At #{distance} in #{name} street, you'll find \nEmpty Slots #{empty_slots} \nFree bikes  #{free_bikes}}
  end

  def self.suitable_station?(elem, action = nil)
    return true if action.nil?
    ( (action.eql?('p') &&
        elem['free_bikes'].eql?(0)) ||
        (action.eql?('d') &&
            elem['empty_slots'].eql?(0)) ) ? false : true
  end

end