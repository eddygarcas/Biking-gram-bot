# Biking Gram Bot

Bot Biking gram feeds from Citybikes API, getting data from there will allow you to search for the closest bike sharing station available. Citybikes API has data from more than 400 Cities bike sharing transportation projects.

If you are using any bike sharing transportation, you can try this out by adding this bot in your telegram app: https://telegram.me/bikingram_bot

Please let me know if you find any issue using this bot.

# 1. Installing external ruby gems

The file *bot_bicing_gram.rb* requires Telegram Bot

    require 'telegram/bot'

On the other hand, *bicing_stations.rb imports citybik API

    require 'citybikes_api'

#### Versions

    gem 'telegram-bot-ruby', '~> 0.7.2'
    gem 'citybikes_api', '~> 2.0', '>= 2.0.1'
    
### Procfile

In order to run this application in Heroku must include a Procfile adding the following config line

    Web: bundle exec ruby bot_bicing_gram.rb

# 2. Testing BotBicinGram

Before starting this app in Heroku it's imperative adding a couple of environment variables. First one would be the Telegram Token string generated at creating the bot, and the other one would be the number of closest stations to retrieve from Citybike API.

    TELEGRAM_BOT_TOKEN 
    N_OF_STATIONS
    
### Starting the bot
Typing /start will show you the Keyboard markup used to share the current location or jumping to the next closest biking station

<img src="https://github.com/eddygarcas/BotBicingGram/blob/master/docs/Fitxer_004.png" height="30%" width="30%"/>

### Sharing current location
Clicking over "Share my location" Telegram will ask the allowance to share the current location.

<img src="https://github.com/eddygarcas/BotBicingGram/blob/master/docs/Fitxer_003.png" height="30%" width="30%"/>

### Show the results
BotBicinGram will use device position, looking for the closest stations acorss all bike sharing transportation systems around the world.

<img src="https://github.com/eddygarcas/BotBicingGram/blob/master/docs/Fitxer_002.png" height="30%" width="30%"/>

Clicking on Next stations will show the next closest station, it may be useful if the closest one has no free bikes or empty spots.

<img src="https://github.com/eddygarcas/BotBicingGram/blob/master/docs/Fitxer_001.png" height="30%" width="30%"/>

### Final considerations

This bot is not storing or persisting any user information so it will require another location request to refresh the data. 
