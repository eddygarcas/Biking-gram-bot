require 'telegram/bot'
require_relative 'station_information'
require_relative 'bicing_stations'


TELEGRAM_BOT_TOKEN= "YOUR-TELEGRAM-BOT_KEY"

Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  bot.listen do |message|
    if message.location
      l = message.location
      remote_call = BicingStations.new
      station = remote_call.closest_station([l.latitude,l.longitude])
      bot.api.send_location(chat_id: message.chat.id, latitude: station.latitude, longitude: station.longitude)
      # id
      # empty_slots
      # free_bikes
      # latitude
      # longitude
      # name
      bot.api.send_message(chat_id: message.chat.id, text: %Q{Street #{station.name} \nEmpty Slots #{station.empty_slots} \nFree bikes  #{station.free_bikes}})
    end
    case message.text
      when '/station'
        kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Tap here to show me your location', request_location: true)]
        markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
        bot.api.send_message(chat_id: message.chat.id, text: 'Hey! Could you please share your location?', reply_markup: markup)
      else
        if (!message.text.nil? && !message.text.start_with?('Street'))
          bot.api.send_message(chat_id: message.chat.id, text: "Sorry, don't know what #{message.text} means, try typing /station instead.", reply_markup: markup)
        end
    end
  end
end
