# Description:
#   arzに好きな名前で呼んでもらえるようにするもの
#
# Commands:
#   hubot #{nickname}って呼んで
#   hubot 私の名前は
#
# Author:
#   @wat_shun

	#名前の確認
	robot.respond /名簿見せて/i, (msg) ->
		list = getNicknamelist()
		for u, n of list
			msg.send "#{u} : #{n}"
module.exports = (robot) ->

	robot.respond /私の名前は/i, (msg) ->
		msg.send "#{robot.brain.get("nickname") or msg.message.user.name}！"

	robot.respond /(.*)って呼んで/i, (msg) ->
		msg.send "じゃあこれから#{msg.message.user.name}のことは#{msg.match[1]}って呼ぶアズ！"
		robot.brain.set("nickname", msg.match[1])
