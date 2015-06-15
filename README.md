# emt-valencia-tgbot
A telegram bot for [Yagop's telegram-bot](https://github.com/yagop/telegram-bot)

Installation
------------
Put the plugins/ content into your telegram-bot/plugins/ and add the bot "emt" to the config file

Dependences
------------
* [Yagop's telegram-bot](https://github.com/yagop/telegram-bot)
* Python

Usage
-----
    NAME
      emt - Valence EMT public transport information

    SYNOPSIS
      /emt [-t STOP-NUMBER] [-v]
      /emt [-s] STRING [-v]
      /emt -h
    
    DESCRIPTION
      -t=STOP-NUMBER
        display stop timetable
    
      -s=STRING
        search and show stops that match the STRING
    
      -h
        display this help
    
      no options
        search and display stops that matches the STRING, if there is a single stop that matches, display its timetable

Use it!
------------
This bot is running 24h a day as the user [@EMTValencia](https://telegram.me/emtvalencia)