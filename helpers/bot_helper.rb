require_relative'../bicing_stations'
require_relative '../data/location'

module BotHelper

  def self.get_stations_inline(data, size = 1)
    get_stations(data.location,data.query&.downcase&.include?('drop') ? 'd' : 'p', size) if ['pickup','drop'].include? data.query&.downcase
  end

  def self.get_stations (data, action = 'p', size = 1)
    begin
      BicingStations.new.closest_station(Location.new(data, action), size)
    rescue StandardError
      return []
    end
  end

  def self.bot_markup
    kb = [[Telegram::Bot::Types::KeyboardButton.new(text: 'Start'),
           Telegram::Bot::Types::KeyboardButton.new(text: 'Help')],
          [Telegram::Bot::Types::KeyboardButton.new(text: 'Share location', request_location: true)]]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  # shared_inline_location_markup(location) it's used when a user sends a location on the map or shares actual location again.
  def self.inline_markup (location = nil)
    kb = location.nil? ? chat_inline_location_markup : shared_inline_location_markup(location)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def self.inline_result(station)
    result = []
    if arr = Array.try_convert(station)
      count = 0
      result = arr.map { |elem| create_inline_station_result(elem, count+=1) }
    else
      result << create_inline_station_result(station)
    end
    return result
  end

  def self.create_inline_station_result(station, count = 1)
    Telegram::Bot::Types::InlineQueryResultLocation.new(
        id: count.to_s,
        latitude: station.latitude,
        longitude: station.longitude,
        title: %Q{ #{Emoji.find_by_alias(station.company.country).raw} #{station.company.name} #{station.to_inline_title}},
        input_message_content: Telegram::Bot::Types::InputVenueMessageContent.new(
            latitude: station.latitude,
            longitude: station.longitude,
            title: %Q{ #{Emoji.find_by_alias(station.company.country).raw} #{station.company.name} #{station.name}},
            address: station.to_s
        ))
  end

  private

  def self.shared_inline_location_markup(location)
    [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'PickUp', callback_data: Location.new(location).to_callback_loc),
           Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Drop', callback_data: Location.new(location,'d').to_callback_loc)]]
  end

  def self.chat_inline_location_markup
    [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'PickUp', switch_inline_query_current_chat: 'pickup'),
           Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Drop', switch_inline_query_current_chat: 'drop')]]
  end
end