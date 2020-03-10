require 'telegram/bot'
require_relative 'data/station_information'
require_relative 'helpers/bot_helper'
require_relative 'helpers/bot_message'

TELEGRAM_BOT_TOKEN = ENV['TELEGRAM_BOT_TOKEN']
SIZE_OF_CLOSEST_STATIONS = ENV['N_OF_STATIONS']

Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      station = BotHelper.get_stations(message.data, SIZE_OF_CLOSEST_STATIONS.to_i)
      BotMessage.send_station_message(bot, message.from.id, station.reverse!.pop)

    when Telegram::Bot::Types::InlineQuery
      station = BotHelper.get_stations_inline(message, SIZE_OF_CLOSEST_STATIONS.to_i)
      BotMessage.send_station_message(bot, message.id, station, true)

    when Telegram::Bot::Types::Message
      if message.venue && message.venue.location
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BotMessage::BOT_ACTION_MESSAGE)
      elsif message.location
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup(message.location), BotMessage::BOT_ACTION_MESSAGE)
      end
      case message.text
      when 'Help'
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup, BotMessage::BOT_HELP_MESSAGE)
      when 'Start'
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup)
      when '/start'
        BotMessage.send_bot_message(bot, message.chat.id, BotHelper.inline_markup)
      else
        unless (message.text.nil? || message.text.downcase.start_with?('in'))
          BotMessage.send_bot_message(bot, message.chat.id, BotHelper.bot_markup, BotMessage::BOT_ERROR_MESSAGE)
        end
      end
    end
  end
end


