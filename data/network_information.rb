require_relative 'information'

class NetworkInformation < Information

  VALID_FIELDS = ['id','location']

  attr_accessor :distance

  def initialize(net)
    net.each do |k,v|
      if VALID_FIELDS.include?(k)
        if v.is_a?(Hash)
          v.each do |k,v|
            accesor_builder k,v
          end
        else
          accesor_builder k,v
        end
      end
    end
  end
end
