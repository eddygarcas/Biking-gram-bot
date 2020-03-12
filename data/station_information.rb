require_relative 'information'

class StationInformation < Information

  VALID_FIELDS = ['id', 'empty_slots', 'free_bikes', 'latitude', 'longitude', 'name','timestamp','ebikes','extra']

  attr_accessor :company, :action
  @distance = 0

  def distance= dist
    @distance = (result = dist.round / 1000) > 1 ? "#{result}Km." : "#{dist.round}m."
  end

  def distance
    @distance
  end

  def initialize(sta, action, net)
    VALID_FIELDS.each do |elm|
      v = nested_hash_value(sta, elm.to_s)
      accesor_builder elm, v.to_s
    end
    self.company = net
    self.action = action
  end

  def self.parse data, action = nil
    begin
      net = NetworkInformation.new(data.parsed_response['network'])
      data.parsed_response['network']['stations'].map { |elem| StationInformation.new(elem, action, net) if StationInformation.suitable_station?(elem, action) }.compact
    rescue Exception
      raise StandardError.new('Cannot parse the service response')
    end
  end

  def self.suitable_station?(elem, action = nil)
    return true if action.nil?
    ((action.eql?('p') &&
        elem['free_bikes'].eql?(0)) ||
        (action.eql?('d') &&
            elem['empty_slots'].eql?(0))) ? false : true
  end

  def to_inline_title
    return %Q{in #{distance} #{empty_slots} empty slots } unless action.to_s.eql?('p')
    return %Q{in #{distance} has #{free_bikes} bikes } unless action.to_s.eql?('d')
  end

  def to_s
    %Q{in #{distance}\n #{empty_slots} empty\n #{Emoji.find_by_alias('bike').raw} #{free_bikes} bikes\n #{Emoji.find_by_alias('electric_plug').raw} #{ebikes || 0} e-bikes }
  end

  def to_html
    %Q{<pre>in #{distance}\n <b>#{empty_slots}</b> empty slots\n and <b>#{free_bikes}</b> bikes</pre>}
  end

end