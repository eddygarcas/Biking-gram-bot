# BotBicinGram

Bot Biking gram feeds from Citybikes API, getting data from there will allow you to search for the closest bike sharing station available. Citybikes API has data from more than 400 Cities bike sharing transportation projects.

If you are using any bike sharing transportation, you can try this out by adding this bot in your telegram app: https://telegram.me/bcnbicingbot

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
    
 
    


