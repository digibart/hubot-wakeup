path = require 'path'
Robot = require 'hubot/src/robot'
messages = require 'hubot/src/message'

describe 'wakeup', ->

	robot = null
	adapter = null
	user = null

	say = (msg) ->
		adapter.receive new messages.TextMessage(user, msg)

	expectHubotToSay = (msg, done) ->
		adapter.on 'send', (envelope, strings) ->
			(expect strings[0]).toMatch msg
			done()

	expectHubotToReply = (msg, done) ->
		adapter.on 'reply', (envelope, strings) ->
			(expect strings[0]).toMatch msg
			done()

	captureHubotOutput = (captured, done) ->
		adapter.on 'send', (envelope, strings) ->
			unless strings[0] in captured
				captured.push strings[0]
				done()

	beforeEach ->
		ready = false

		runs ->
			robot = new Robot(null, 'mock-adapter', false, 'Hubot')

			robot.adapter.on 'connected', ->
				process.env.HUBOT_AUTH_ADMIN = '1'
				robot.loadFile (path.resolve path.join 'node_modules/hubot/src/scripts'), 'auth.coffee'

				(require '../src/wakeup')(robot)

				user = robot.brain.userForId('1', name: 'jasmine', room: '#jasmine')
				adapter = robot.adapter
				ready = true

			robot.run()

		waitsFor -> ready

	afterEach ->
		robot.shutdown()

	it 'should store machines mac adres', (done) ->
		expectHubotToReply 'got it', done
		say 'hubot machine foobar has mac 4E:93:48:4D:79:FD'

		machineList = robot.brain.get "wakeup"
		expect(machineList.foobar).toBe('4E:93:48:4D:79:FD')


	it 'should *not* store machines invalid mac adres', (done) ->
		expectHubotToReply 'not a valid', done
		say 'hubot machine foobar has mac ab-cd-ef-gh-ij-kl'

		machineList = robot.brain.get("wakeup") or {}
		expect(machineList.foobar).toBeUndefined()


	it 'should show a hint when machinelist is empty', (done) ->
		expectHubotToReply 'hint', done
		say 'hubot show the machine list'


	it 'should show a list of machines', (done) ->
		machineList =
			foobar: 'A3:D3:00:10:31:E7'

		robot.brain.set "wakeup", machineList

		expectHubotToReply 'foobar', done
		say 'hubot show the machine list'


	it 'should kick machines by mac-address', (done) ->
		expectHubotToReply 'kicked B2:26:53:6D:AC:15 his shiny metal ass', done
		say 'hubot kick B2:26:53:6D:AC:15'


	it 'should kick machines by machine name', (done) ->
		machineList =
			foobar: '7E:94:3F:C8:26:B3'

		robot.brain.set "wakeup", machineList
		
		expectHubotToReply 'kicked 7E:94:3F:C8:26:B3 his shiny metal ass', done
		say 'hubot kick foobar'


	it 'should be able to forget a machine', (done) ->
		machineList =
			foobar: '8D:18:AD:07:4F:D9'

		robot.brain.set "wakeup", machineList

		expectHubotToReply 'erased', done
		say 'hubot forget machine foobar'

		machineList = robot.brain.get("wakeup") or {}
		expect(machineList.foobar).toBeUndefined()


