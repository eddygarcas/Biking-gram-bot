START_BOT_MESSAGE = "Thanks for using BikinGram.\nThis bot will filter out those stations with either empty spots or free bikes according to your location.\nWhat would you like to do? Pickup or Drop."

BOT_ERROR_MESSAGE = "Oops! Something went wrong, please press /start button again."

BOT_HELP_MESSAGE = "Use inline buttons below (PickUp or Drop) or type the inline command @bikingram_bot in any chat to find out the closest sharing bike station.\nThe result will be according from your actual position.\nYou can also pin any location and this bot will show you the closest station from that point."

BOT_ACTION_MESSAGE = "What would you like to do next?"

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

  def self.send_station_message (bot, chatId, station = nil)
    if station.nil?
      bot.api.send_message(chat_id: chatId, text: %Q{#{BOT_ERROR_MESSAGE}})
    else
      send_station_location(bot, chatId, station)
    end
  end



  protected

  def self.send_station_location(bot, chatId, station)
    bot.api.send_venue(chat_id: chatId,
        latitude: station.latitude,
        longitude: station.longitude,
        title: station.name,
        address: station.to_inline
    )
  end

 end