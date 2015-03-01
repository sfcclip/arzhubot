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
			eval("ret = " + msg.match[1] + ";");
			msg.send "#{ret}アズ！"
		catch error
			msg.send "計算できなかったアズ…"