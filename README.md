# pilbot

IRC bot for picolisp

# Usage

- Edit irc.l for configuration
- Run bot.l

# scripts

The bot can run scripts and replies with the content of STDOUT.
WARNING: This is almost certainly a bad idea, dont come cryng to me when some troll bricks your computer.
Each script and the associated trigger will have to be added manually at `handle_privmsg`
To trigger a script just send a message to the bot with the trigger.

```
..
  ("test1" (reply sock S (run-script "test1.sh")))
..
```

Then just send the bot a message `pilbot: test1`
