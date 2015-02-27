# Description:
#   arzに好きな名前で呼んでもらえるようにするもの
#
# Commands:
#   hubot <query>って呼んで
#   hubot 私の名前は
#
# Author:
#   @wat_shun

module.exports = (robot) ->

	robot.respond /私の名前は/i, (msg) ->
		msg.send "#{robot.brain.get("nickname") or msg.message.user.name}！"

	robot.respond /(.*)って呼んで/i, (msg) ->
		msg.send "じゃあこれから#{msg.message.user.name}のことは#{msg.match[1]}って呼ぶアズ！"
		robot.brain.set("nickname", msg.match[1])
