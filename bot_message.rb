START_BOT_MESSAGE = "Thanks for using BikinGram.\nThis bot will filter out those stations with either empty spots or free bikes according to your location.\nWould you like to..."

BOT_ERROR_MESSAGE = "Oops! Something went wrong, please press /start button again."

BOT_HELP_MESSAGE = "Use inline buttons below (PickUp or Drop) here or type the inline command @bikingram_bot in any chat to find out the closest sharing bike station.\nThe result will be according to your actual position.\nYou can also pin any location and this bot will show you the closest station from that point."

BOT_ACTION_MESSAGE = "Would you like to..."

require_relative 'helpers/bot_helper'

class BotMessage


  def self.send_bot_message(bot, chatId, markup, text = nil)
    if text.nil?
      bot.api.send_message(chat_id: chatId,
                           text: %Q{#{START_BOT_MESSAGE}},
                           reply_markup: markup)
    else
      bot.api.send_message(chat_id: chatId,
                           text: %Q{#{text}},
                           reply_markup: markup)
    end
  end

  def self.send_station_message(bot, chatId, station = nil, inline = false)
    if station.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{#{BOT_ERROR_MESSAGE}})
    else
      send_station_location(bot, chatId, station, inline)
    end
  end


  protected

  def self.send_station_location(bot, chatId, station, inline = false)
    if inline
      send_inline_station_location(bot, chatId, station)
    else
      send_callback_station_location(bot, chatId, station)
    end

  end

  private

  def self.send_inline_station_location(bot, chatId, station)
    bot.api.answer_inline_query(
        inline_query_id: chatId,
        results: [BotHelper.inline_result(station)]
    )
  end

  def self.send_callback_station_location(bot, chatId, station)
    bot.api.send_venue(chat_id: chatId,
                       latitude: station.latitude,
                       longitude: station.longitude,
                       title: station.name,
                       address: station.to_inline
    )
  end

end