# BotBicinGram
By this Telegram Bot,Barcelona Bicing users can look for the closest bicing station to their current localtion

If you are a Bicing user in Barcelona, you can try this out by following URL: https://telegram.me/bcnbicingbot

Please let me know if you find any issue using this bot.

# 1. Installing external ruby gems

The file *bot_bicing_gram.rb* requires Telegram Bot

    require 'telegram/bot'

On the other hand, *bicing_stations.rb imports citybik API

    require 'citybikes_api'

#### Versions

    gem 'telegram-bot-ruby', '~> 0.7.2'
    gem 'citybikes_api', '~> 2.0', '>= 2.0.1'
    
###Install RubyGems
