require_relative'../bicing_stations'

class BotHelper

  def self.bot_markup
    kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Share my location', request_location: true)]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, resize_keyboard: true)
  end

  def self.inline_markup (location = nil)
    kb = [[Telegram::Bot::Types::InlineKeyboardButton.new(text: 'PickUp', callback_data: builder_locations(location)),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Drop', callback_data: builder_locations(location,'d'))]]
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def self.get_stations (data, size = 2)
    begin
      location = [eval(data)[:latitude],eval(data)[:longitude]]
      action = eval(data)[:a]
      return BicingStations.new.closest_station(location, action, size)
    rescue StandardError
      return []
    end
  end

  private

  def self.builder_locations (location, action = 'p')
    loc = location.to_h
    loc.store(:a,action)
    loc.to_s
  end
end