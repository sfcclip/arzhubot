# Description:
#   arzに好きな名前で呼んでもらえるようにするもの
#	他の部分でそうしたいときは robot.brain.data.nickname[user]使うこと	
#
# Commands:
#   hubot #{nickname}って呼んで
#   hubot 私の名前は
#
# Author:
#   @wat_shun
module.exports = (robot) ->
	robot.brain.data.nickname = {} if not robot.brain.data.nickname?
	getNickname = (username) ->
		if robot.brain.data.nickname[username]?
			return robot.brain.data.nickname[username]
		else
			return username

	setNickname = (username,nickname) ->
		robot.brain.data.nickname[username] = nickname
		robot.brain.save
		console.log robot.brain.data.nickname

	#名前の確認
	robot.respond /名簿見せて/i, (msg) ->
		list = getNicknamelist()
		for u, n of list
			msg.send "#{u} : #{n}"

	robot.respond /私の名前は/i, (msg) ->
		msg.send "#{getNickname(msg.message.user.name)}！"

	#名前を指定
	robot.respond /(.*)って呼んで/i, (msg) ->
		username = msg.message.user.name
		nickname = msg.match[1]
		msg.send "じゃあこれから#{getNickname(username)}のことは#{nickname}って呼ぶアズ！"
		setNickname username,nickname
