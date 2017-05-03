require 'telegram/bot'
require_relative 'station_information'
require_relative 'bicing_stations'


TELEGRAM_BOT_TOKEN= ENV['TELEGRAM_BOT_TOKEN']

class BotHelper
  def self.bot_markup
    kb = [Telegram::Bot::Types::KeyboardButton.new(text: 'Share my location', request_location: true),
          [Telegram::Bot::Types::KeyboardButton.new(text: 'Closest station'),Telegram::Bot::Types::KeyboardButton.new(text: 'Next station')]]
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
  end
end

class BotMessage

  def self.send_station_information (bot, chatId, station)
    if station.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{Sorry! I've lost your position, could you please share it again?})
    else
      send_station_location( bot, chatId, station)
      send_bot_text_message(bot, chatId, station)
    end
  end

  protected

  def self.send_station_location(bot,chatId, station)
    bot.api.send_location(chat_id: chatId, latitude: station.latitude, longitude: station.longitude)
  end

  def self.send_bot_text_message(bot, chatId, station)
    bot.api.send_message(chat_id: chatId, text: station.to_s)
    if station.free_bikes== 0
      bot.api.send_message(chat_id: chatId, text: %Q{Ups! there aren't free bikes there try another station see if anyone available there})
    end
  end
end

Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  station = Array.new
  bot.listen do |message|
    if message.location
      l = message.location
      station = BicingStations.new.closest_station([l.latitude,l.longitude])
      BotMessage.send_station_information(bot, message.chat.id, station.first)
    end
    case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id,
                             text: "Thanks for using BotBicingram. Share your location and I'll show you the closest station" ,
                             reply_markup: BotHelper.bot_markup)
      when '/station'
        bot.api.send_message(chat_id: message.chat.id,
                             text: 'Hey! Could you please share your location?',
                             reply_markup: BotHelper.bot_markup)
      when 'Closest station'
        BotMessage.send_station_information(bot, message.chat.id, station.first)
      when 'Next station'
        BotMessage.send_station_information(bot, message.chat.id, station.last)
      else
        unless (message.text.nil? || message.text.start_with?('At'))
          bot.api.send_message(chat_id: message.chat.id,
                               text: "Sorry, don't know what #{message.text} means, try typing /station instead.",
                               reply_markup: BotHelper.bot_markup)
        end
    end
  end
end


