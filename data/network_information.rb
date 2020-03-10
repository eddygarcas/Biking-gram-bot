require_relative 'information'
class NetworkInformation < Information

  VALID_FIELDS = ['id','longitude','latitude','company','name','city','country']

  attr_accessor :distance

  def initialize(net)
    VALID_FIELDS.each do |elm|
      v = nested_hash_value(net, elm.to_s)
      accesor_builder elm, v.to_s
    end
  end

  def self.parse data
    begin
      data.map {|elem| NetworkInformation.new(elem) }.compact
    rescue Exception
      raise StandardError.new('Cannot parse the service response')
    end
  end

end
