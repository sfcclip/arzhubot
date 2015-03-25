# Description:
#   編集会関連の機能
#
# Commands:
#   hubot 出席
#   hubot 欠席
#   hubot 出欠
#
# Author:
#   @wat_shun

cronRemind = require('cron').CronJob
cronNotice = require('cron').CronJob
cronDataReset = require('cron').CronJob

module.exports = (robot) ->
	robot.brain.data.attendance = [] if not robot.brain.data.attendance?
	robot.brain.data.absence = [] if not robot.brain.data.absence?
	
	#出席の人を返す
	getAttendanceList = () ->
		return robot.brain.data.attendance or []

	#欠席の人を返す
	getAbsenceList = () ->
		return robot.brain.data.absence or []

	#出席の人数を返す
	getAttendanceNum = () ->
		list = getAttendanceList()
		if list? 
			return list.length
		else
			return 0

	#欠席の人数を返す
	getAbsenceNum = () ->
		list = getAbsenceList()
		if list? 
			return list.length
		else
			return 0

	setAttendanceList = (list) ->
		robot.brain.data.attendance = list
		robot.brain.save
		console.log list

	setAbsenceList = (list) ->
		robot.brain.data.absence = list
		robot.brain.save
		console.log list

	#出席の処理
	attend = (name) ->
		attendanceList = getAttendanceList()
		absenceList = getAbsenceList()

		#出席に追加
		if attendanceList?
			if attendanceList.indexOf(name) is -1
				attendanceList[attendanceList.length] = name 
				setAttendanceList attendanceList
		else
			l = [name]
			setAttendanceList l

		#欠席から削除
		if absenceList? and absenceList.indexOf(name) isnt -1
			absenceList.splice(absenceList.indexOf(name), 1)
			setAbsenceList absenceList

	#欠席の処理
	absent = (name) ->
		attendanceList = getAttendanceList()
		absenceList = getAbsenceList()

		#出席から削除
		if attendanceList? and attendanceList.indexOf(name) isnt -1
			attendanceList.splice(attendanceList.indexOf(name), 1)
			setAttendanceList attendanceList

		#欠席に追加
		if absenceList?
			if absenceList.indexOf(name) is -1
				absenceList[absenceList.length] = name 
				setAbsenceList absenceList
		else
			l = [name]
			setAbsenceList l

	robot.respond /出席(する|します)?$/i, (msg) ->
		msg.send "#{msg.message.user.name}を出席にしたアズ"
		attend msg.message.user.name

	robot.respond /(欠席(する|します)?|出席(しません|しない))$/i, (msg) ->
		msg.send "#{msg.message.user.name}を欠席にしたアズ"
		absent msg.message.user.name

	robot.respond /出欠$/i, (msg) ->
		attendanceList = getAttendanceList()
		absenceList = getAbsenceList()
		attendanceNum = getAttendanceNum()
		absenceNum = getAbsenceNum()

		#出席の出力
		attendanceMember = attendanceList.join('\n')
		msg.send "出席するのは#{attendanceNum}人アズ"
		if attendanceNum isnt 0
			msg.send "#{attendanceMember}\nが出席するアズ"

		#欠席の出力
		absenceMember = absenceList.join('\n')
		msg.send "欠席するのは#{absenceNum}人アズ"
		if absenceNum isnt 0
			msg.send "#{absenceMember}\nが欠席するアズ"


	#月-木12:50のリマインド
	new cronRemind '0 50 12 * * 1-4', () =>
		robot.send {room: "#random"}, "今週の編集会の出欠を教えてほしいアズ！"
	, null, true, "Asia/Tokyo"

	#編集会後にデータを消す&再リマインド
	new cronDataReset '0 0 0 * * 6', () =>
		robot.send {room: "#dev"}, "出欠のデータを消したアズ"
		robot.send {room: "#random"}, "来週の編集会の出欠を取り始めたアズ！"
		setList([])
	, null, true, "Asia/Tokyo"