# hubot-wakeup

[![Build Status](https://travis-ci.org/digibart/hubot-wakeup.svg)](https://travis-ci.org/digibart/hubot-wakeup)

A hubot script that kicks bare metal machines by sending WOL packages

See [`src/wakeup.coffee`](src/wakeup.coffee) for full documentation.

## Installation

1. In hubot project repo, run:

	`npm install hubot-wakeup --save`

2. Then add **hubot-wakeup** to your `external-scripts.json`:

	```json
	["hubot-wakeup"]
	```

## Sample Interaction

```
aaron > hubot machine CI-Runner has mac B8:E5:D0:57:B4:DD
hubot > aaron: got it, CI-Runner has mac address B8:E5:D0:57:B4:DD
...
aaron > hubot kick machine CI-Runner
hubot > aaron: kicked B8:E5:D0:57:B4:DD his shiny metal ass
```
