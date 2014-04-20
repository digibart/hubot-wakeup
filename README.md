# hubot-wakeup

[![build status](http://gitlab-ci.pixelbak.nl/projects/19/status.png?ref=master)](http://gitlab-ci.pixelbak.nl/projects/19?ref=master)

A hubot script that kicks bare metal machines by sending WOL packages

See [`src/wakeup.coffee`](src/wakeup.coffee) for full documentation.

## Installation

1. In hubot project repo, run:

	`npm install git+ssh://git@gitlab.pixelbak.nl:npm/hubot-wakeup.git --save`
	
	or if you don't have GIT access:
	
	`npm install https://gitlab.pixelbak.nl/npm/hubot-wakeup/repository/archive.tar.gz?ref=master --save`

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

## Testing

If you've got Grunt, you can run `grunt test` or `grunt test:watch`
If not, you're stuck with `npm test`