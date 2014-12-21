# Description:
#   arzの好感度が関わるヤツ
# Author:
#   @wat_shun


module.exports = (robot) ->
	robot.brain.data.love = {} if not robot.brain.data.love?
	getLove = (username) ->
		return robot.brain.data.love[username] or 50

	changeLove = (username,diff) ->
		score = robot.brain.data.love[username] or 50
		new_score = score + diff
		new_score = 100 if new_score > 100
		new_score = 0 if new_score < 0
		robot.brain.data.love[username] = new_score
		robot.brain.save
		console.log robot.brain.data.love

	robot.hear /アーズ？/i, (msg) ->
		msg.send msg.random [
			"？",
			"呼んだアズ？"
			"#{msg.message.user.name}、何か用アズ？"
		]
		changeLove msg.message.user.name,1
		

	robot.respond /(ベシベシ|バシバシ|ボコ)/i, (msg) ->
		msg.send msg.random [
			"痛いアズー！",
			"やめてアズー！"
		]
		changeLove msg.message.user.name,-10

	robot.respond /いじめ/i, (msg) ->
		msg.send msg.random [
			"ビクッ",
			"！"
		]
		changeLove msg.message.user.name,-5

	robot.respond /よしよし/i, (msg) ->
		msg.send msg.random [
			"照れるアズ〜"
		]
		changeLove msg.message.user.name,3
		
	robot.respond /好き/i, (msg) ->
		msg.send msg.random [
			"僕も#{msg.message.user.name}のこと好きアズ！",
			"❤️"
		]
		changeLove msg.message.user.name,5

	robot.respond /好感度/i, (msg)->
		username = msg.message.user.name
		changeLove username,0
		msg.send "#{username}への好感度は#{getLove(username)}アズ！"
