module.exports = (robot) ->
	robot.hear /hoge/i, (msg)->
		msg.send 'huga'
		msg.send "@#{msg.message.user.name}, foo bar."
		msg.reply 'foo'