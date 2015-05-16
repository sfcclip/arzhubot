# Description:
#   evalによる計算モドキ
#
# Commands:
#   hubot <query>計算
#
# Author:
#   @wat_shun

module.exports = (robot) ->
	robot.respond /(.*)計算/i, (msg)->
		ret =  0;
		try
			msg.send "わからないアズ！"
		catch error
			msg.send "計算できなかったアズ…"
