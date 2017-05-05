
class NetworkInformation

  VALID_FIELDS = ['id','location']

  attr_accessor :distance

  def initialize(net)
    net.each do |k,v|
      if VALID_FIELDS.include?(k)
        if v.is_a?(Hash)
          v.each do |key,value|
            create_method(key,value)
          end
        else
          create_method(k,v)
        end

      end
    end
  end

  private

  def create_method(key,value)
    #First will create a new instance variable, value if it wasn't a Hash or Hash type instead.
    self.instance_variable_set("@#{key}", value.is_a?(Hash) ? Hash.new(value) : value)
    #Secondly will define a get instance method for the given value
    self.class.send(:define_method, "#{key}", proc{self.instance_variable_get("@#{key}")})
    #Finally will define a set instance method for the given value. Notice the proc block
    # to be called every time the set method is called.
    self.class.send(:define_method, "#{key}=", proc{|value| self.instance_variable_set("@#{key}", value)})
  end
end
