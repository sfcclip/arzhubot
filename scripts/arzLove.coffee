# Description:
#   arzの好感度が関わるヤツ
# Author:
#   @wat_shun


module.exports = (robot) ->

	addLove = (point) ->
		userScore = robot.brain.get("score") ? 50
		newScore = userScore + point
		newScore = 100 if newScore > 100
		newScore = 0 if newScore < 0
		robot.brain.set("score", newScore)
		return newScore


	robot.hear /くりっぷちゃん?/i, (msg) ->
		msg.send msg.random [
			"?",
			"呼んだっぷ?"
			"#{msg.message.user.name}、何か用っぷ?"
		]
		addLove 1
		

	robot.respond /(ベシベシ|バシバシ|ボコ)/i, (msg) ->
		msg.send msg.random [
			"痛いっぷ?",
			"やめてほしいっぷー!"
		]
		addLove -10

	robot.respond /いじめ/i, (msg) ->
		msg.send msg.random [
			"ビクッ",
			"！"
		]
		addLove -5

	robot.respond /よしよし/i, (msg) ->
		msg.send msg.random [
			"照れるっぷ〜"
		]
		addLove 3
		
	robot.respond /好き/i, (msg) ->
		msg.send msg.random [
			"僕も#{msg.message.user.name}のこと好きっぷ！",
			"❤️"
		]
		addLove 5

	robot.respond /好感度/i, (msg)->
		msg.send "#{msg.message.user.name}への好感度は#{addLove 0}っぷ！"
