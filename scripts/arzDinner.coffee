# Description:
#   食事会関連の機能
#
# Commands:
#   hubot 出席
#   hubot 欠席
#   hubot 出欠
#
# Author:
#   @shokai
#   forked : https://github.com/masuilab/slack-hubot/blob/master/scripts/anonymous-post.coffee

cronRemind = require('cron').CronJob
cronNotice = require('cron').CronJob
cronDataReset = require('cron').CronJob

module.exports = (robot) ->
	robot.brain.data.dinner = [] if not robot.brain.data.dinner?
	#出席の人を返す
	getList = () ->
		return robot.brain.data.dinner or []

	#出席の人数を返す
	getNum = () ->
		list = getList()
		if list? 
			return list.length
		else
			return 0

	setList = (list) ->
		robot.brain.data.dinner = list
		robot.brain.save
		console.log list

	#出席の処理　いない時のみ追加
	attend = (name) ->
		list = getList()
		if list?
			if list.indexOf(name) is -1
				list[list.length] = name 
				setList list
		else
			l = [name] 
			setList l

	#欠席の処理　いる時のみ削除
	absent = (name) ->
		list = getList()
		if list? and list.indexOf(name) isnt -1
			list.splice(list.indexOf(name), 1)
			setList list

	robot.respond /出席(する|します)?$/i, (msg) ->
		msg.send "#{msg.message.user.name}を出席にしたアズ"
		attend msg.message.user.name

	robot.respond /(欠席(する|します)?|出席(しません|しない))$/i, (msg) ->
		msg.send "#{msg.message.user.name}を欠席にしたアズ"
		absent msg.message.user.name

	robot.respond /出欠$/i, (msg) ->
		list = getList()
		num = getNum()
		mem = list.join('\n')
		msg.send "現在出席するのは#{num}人アズ"
		if num isnt 0
			msg.send "#{mem}\nが出席するアズ"

	robot.respond /出血$/i, (msg) ->
		msg.send "もしかして: 出欠"

	#月-木12:50のリマインド
	new cronRemind '0 50 12 * * 1-4', () =>
		robot.send {room: "#random"}, "@channel: 今週の食事会の出欠を教えてほしいアズ！"
		robot.send {room: "#random"}, "現在は#{getNum()}人が出席の予定アズ"
	, null, true, "Asia/Tokyo"

	#金7時に食事係に通知する
	new cronRemind '0 0 19 * * 5', () =>
		robot.send {room: "@wat_shun"}, "今日の食事会は#{getNum()}人が出席する予定アズ"
	, null, true, "Asia/Tokyo"

	#食事会後にデータを消す&再リマインド
	new cronDataReset '0 0 0 * * 6', () =>
		robot.send {room: "#dev"}, "食事会のデータを消したアズ"
		robot.send {room: "#random"}, "来週の食事会の出欠を取り始めたアズ！"
		setList([])
	, null, true, "Asia/Tokyo"