require 'telegram/bot'
require_relative 'station_information'
require_relative 'helpers/bot_helper'
require_relative'bot_message'


TELEGRAM_BOT_TOKEN= ENV['TELEGRAM_BOT_TOKEN']
SIZE_OF_CLOSEST_STATIONS= ENV['N_OF_STATIONS']

Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  station = Array.new
  bot.listen do |message|
    if message.location
      station = BotHelper.get_stations(message.location, SIZE_OF_CLOSEST_STATIONS.to_i)
      BotMessage.send_station_message(bot, message.chat.id, station.reverse!.pop)
    end
    case message.text
      when '/start'
        BotMessage.send_start_message(bot, message.chat.id, BotHelper.bot_markup)
      when 'Next station'
        BotMessage.send_station_message(bot, message.chat.id, station.pop)
      else
        unless (message.text.nil? || message.text.start_with?('At'))
          BotMessage.send_station_message(bot, message.chat.id)
        end
    end
  end
end


