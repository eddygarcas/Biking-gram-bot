require_relative'../bicing_stations'

class BotHelper

  def self.bot_markup
    kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Share my location', request_location: true),
          Telegram::Bot::Types::KeyboardButton.new(text: 'Next station')]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
  end

  def self.get_stations (location, size = 2)
    begin
      return BicingStations.new.closest_station([location.latitude,location.longitude], size)
    rescue StandardError
      return []
    end
  end
end