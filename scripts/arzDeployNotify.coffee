# Description:
#   デプロイ通知
#
# Author:
#	@shokai
#	cloned : https://github.com/masuilab/slack-hubot/blob/master/scripts/deploy-notify.coffee

module.exports = (robot) ->
	robot.send {room: "#dev"}, "むにゃむにゃ、おはようアズ"