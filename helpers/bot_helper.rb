require_relative'../bicing_stations'
require_relative '../data/location'

class BotHelper

  def self.get_stations_inline(data, size = 1)

    get_stations(data.location,data.query.downcase.include?('drop') ? 'd' : 'p', size)

  end

  def self.get_stations (data, action = 'p', size = 1)
    begin
      BicingStations.new.closest_station(Location.new(data, action), size)
    rescue StandardError
      return []
    end
  end

  def self.bot_markup
    kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Share my location', request_location: true)]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  def self.inline_markup (location = nil)
    kb = [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'PickUp', callback_data: Location.new(location).to_callback_loc),
    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Drop', callback_data: Location.new(location,'d').to_callback_loc)]]
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def self.inline_result (station)
    Telegram::Bot::Types::InlineQueryResultLocation.new(type: 'location', id: 1, latitude: station.latitude,
     longitude: station.longitude,
     title: 'Closest Station')
     #input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: station.to_s)

  end


end