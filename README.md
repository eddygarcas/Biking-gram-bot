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
    
### Starting the bot
Typing /start will show you the Keyboard markup used to share the current location or jumping to the next closest biking station. Two inline buttons will be prompt to know whether want to pick up a bike or drop it. Both buttons are using inline functionality so the bot won't ask to share user's location due to it will be send as part of the InlineQuery.

<img src="/docs/Start.PNG" height="30%" width="30%"/>

A list of stations will be display so the user can choose which one fits better although the bot already filters out those stations without either free spots or bike according to previous selection (PickUp or Drop)

<img src="/docs/Inline.PNG" height="30%" width="30%"/>

### Sharing current location
User may also want to share a custom location to share the result with other user later on. 
To do that just share a location and the bot will prompt the follwing screen.

<img src="/docs/Custom_location.PNG" height="30%" width="30%"/>

It's basically the same as inline callback although this time it's using a CallbackQuery instead. The result of this will be the same.

<img src="/docs/Result_custom_location.PNG" height="30%" width="30%"/>

### Help

This bot has a KeyboardMarkup containing just two buttons as well. The first one called 'Start' will reset the bot to the initial stage and the other one 'Help' will show a message with a list of available functionality.

<img src="/docs/Help.PNG" height="30%" width="30%"/>

### Final considerations

This bot is not storing or persisting any user information so it will require another location request to refresh the data. 
