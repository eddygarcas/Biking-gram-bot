require 'telegram/bot'
require_relative 'station_information'
require_relative 'helpers/bot_helper'
require_relative'bot_message'


TELEGRAM_BOT_TOKEN= ENV['TELEGRAM_BOT_TOKEN']


Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  station = Array.new
  bot.listen do |message|
    if message.location
      station = BotHelper.get_stations(message.location)
      BotMessage.send_station_message(bot, message.chat.id, station.first)
    end
    case message.text
      when '/start'
        BotMessage.send_start_message(bot, message.chat.id, BotHelper.bot_markup)
      when 'Closest station'
        BotMessage.send_station_message(bot, message.chat.id, station.first)
      when 'Next station'
        BotMessage.send_station_message(bot, message.chat.id, station.last)
      else
        unless (message.text.nil? || message.text.start_with?('At'))
          bot.api.send_message(chat_id: message.chat.id,
                               text: "Sorry, don't know what #{message.text} means, try typing /start instead.")
        end
    end
  end
end


