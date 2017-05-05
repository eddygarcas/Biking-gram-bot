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
    
