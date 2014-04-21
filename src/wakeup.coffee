# Description
#   A hubot script that kicks by sending WOL packages
#
# Configuration:
#   None
#
# Commands:
#   hubot kick <machine> - Send a WOL package to `<machine>`
#   hubot machine <name> has mac <mac> - store `<mac>` for machine `<name>`
#   hubot forget machine <name> - remove a machine from memory
#   hubot show machines - returns a list of machines with their mac adres
#
# Notes:
#   None
#
# Author:
#   PixelBakkerij

module.exports = (robot) ->

	wol = require 'wake_on_lan'

	#
	# Check if <mac> is a valid mac address
	# 
	isValidMac = (mac) ->
		return sanitizeMac(mac).match /([a-f0-9: -]{12,})/i


	#
	# Replace ` `, `-` and `.` with a semicon
	# 
	sanitizeMac = (mac) ->
		return mac.replace /([ -.])/g, ":"


	#
	# Remember a machine's mac address
	# 
	robot.respond /machine (.*) has mac (.*)/i, (msg) ->
		machineList = robot.brain.get('wakeup') or {}

		machine = msg.match[1]
		mac = sanitizeMac msg.match[2]

		if isValidMac mac
			machineList[machine] = mac
			robot.brain.set "wakeup", machineList

			msg.reply "got it, #{machine} has mac address #{mac}"
		else
			msg.reply "hmzz.. #{mac} is not a valid mac address"


	#
	# Show a list of all machines I know
	# 
	robot.respond /show (?:the )?machine list|show machines/i, (msg) ->
		machineList = robot.brain.get('wakeup') or null

		machineReply = ""

		if machineList == null
			msg.reply "I don't know any machines... (hint: hubot machine <name> has mac <mac>)"
		else 
			machineReply = "#{machineReply}\n `#{mac}` | #{machine}" for machine, mac of machineList
			
			msg.reply machineReply


	#
	# Delete a machine from memory
	# 
	robot.respond /forget machine (.*)/i, (msg) ->
		machine = msg.match[1]
		machineList = robot.brain.get('wakeup') or null

		if machineList? && machineList[msg.match[1]]?
			delete machineList[machine]
			robot.brain.set "wakeup", machineList
			msg.reply "erased #{machine} from my memory"
		else
			msg.reply "I don't know a machine called #{machine}"


	#
	# Send a WOL package
	# 
	robot.respond /kick (.*)/i, (msg) ->
		machineList = robot.brain.get('wakeup') or null

		# Is it a machine we know?
		if machineList? && machineList[msg.match[1]]?
			mac = machineList[msg.match[1]]
		else 
			mac = msg.match[1]

		if isValidMac mac

			# This is the magical line, that sends the packages
			wol.wake mac, (error) ->
				if error
					msg.reply "shoot! #{error}"
				else 
					msg.reply "kicked #{mac} his shiny metal ass"
		else
			msg.reply "#{mac} is not a mac adres, nor a machine I know"
			return


