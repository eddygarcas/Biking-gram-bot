
class BotMessage

  def self.send_start_message(bot, chatId, markup, text = nil)
    if text.nil?
      bot.api.send_message(chat_id: chatId,
                           text: %Q{Thanks for using BotBikinGram. This bot will filter out those stations with either empty spots or free bikes according to your selection. Share your location and I'll show you the closest station.} ,
                           reply_markup: markup)
    else
      bot.api.send_message(chat_id: chatId,
                           text: %Q{#{text}} ,
                           reply_markup: markup)
    end
  end

  def self.send_station_message (bot, chatId, station = nil)
    if station.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{Oops! Something went wrong, please either share your location or type /start again.})
    else
      send_station_location(bot, chatId, station)
      send_bot_text_message(bot, chatId, station)
    end
  end

  def self.send_inline_markup (bot, chatId, results)


  end

  protected

  def self.send_station_location(bot,chatId, station)
    bot.api.send_location(chat_id: chatId, latitude: station.latitude, longitude: station.longitude)
  end

  def self.send_bot_text_message(bot, chatId, station)
    bot.api.send_message(chat_id: chatId, text: station.to_s)
  end
end