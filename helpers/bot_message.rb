require_relative 'bot_message'
require 'gemoji'

module BotMessage

  START_BOT_MESSAGE = "Thanks for using Bikingram! #{Emoji.find_by_alias('bike').raw}\nAll data is provided by http://api.citybik.es/ \n#{Emoji.find_by_alias('robot').raw} Would you like to..."
  BOT_ERROR_MESSAGE = "#{Emoji.find_by_alias('hand').raw} Oops! Something went wrong, please press /start button again."
  BOT_HELP_MESSAGE = "Use inline buttons below #{Emoji.find_by_alias('point_down').raw} (PickUp or Drop) here or type the inline command @bikingram_bot in any chat to find out the closest sharing bike station.\nThe result will be according to your actual position.\nYou can also pin any location and this bot will show you the closest station from that point."
  BOT_ACTION_MESSAGE = "#{Emoji.find_by_alias('robot').raw} Would you like to..."

  def self.send_bot_message(bot, chatId, markup, text = nil)
    bot.api.send_message(chat_id: chatId,text: %Q{#{text.nil? ? START_BOT_MESSAGE : text }},reply_markup: markup)
  end

  def self.send_station_message(bot, chatId, station = nil, inline = false)
    return if station.nil?
    send_station_location(bot, chatId, station, inline)
  end

  protected

  def self.send_station_location(bot, chatId, station, inline = false)
    inline ? send_inline_station_location(bot, chatId, station) : send_callback_station_location(bot, chatId, station)
  end

  private

  def self.send_inline_station_location(bot, chatId, station)
    bot.api.answer_inline_query(
        inline_query_id: chatId,
        results: BotHelper.inline_result(station)
    )
  end

  def self.send_callback_station_location(bot, chatId, station)
    bot.api.send_venue(chat_id: chatId,
                       latitude: station.latitude,
                       longitude: station.longitude,
                       title: %Q{ #{Emoji.find_by_alias(station.company.country).raw} #{station.company.name} #{station.name}},
                       address: station.to_s
    )
  end

end