
class BotMessage

  def self.send_start_message(bot, chatId, markup)
    bot.api.send_message(chat_id: chatId,
                         text: %Q{Thanks for using BotBicingram. Share your location and I'll show you the closest station} ,
                         reply_markup: markup)
  end

  def self.send_station_message (bot, chatId, station = nil)
    if station.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{Oops! Something went worng, please either share your location or type /start again.})
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