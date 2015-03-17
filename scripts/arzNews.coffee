# Description:
# 	記事ネタを収集する		
#
# Commands:
#   hubot 記事ネタ 追加 <query>
#	hubot 記事ネタ 削除 <query>
#   hubot 記事ネタ 一覧
#
# Author:
#    @wat_shun
module.exports = (robot) ->
	robot.brain.data.news = [] if not robot.brain.data.news?

	getNewsList = () ->
		return robot.brain.data.news or []

	getNewsNum = () ->
		list = getNewsList()
		if list? 
			return list.length
		else
			return 0

	setNewsList = (list) ->
		robot.brain.data.news = list
		robot.brain.save
		console.log list

	addNewsList = (news)->
		list = getNewsList()

		#出席に追加
		if list?
			if list.indexOf(news) is -1
				list[list.length] = news
				setNewsList list
		else
			l = [news]
			setNewsList l

	deleteNewsList = (news)->
		list = getNewsList()

		#出席に追加
		if list? and list.indexOf(news) isnt -1
			list.splice(list.indexOf(news), 1)
			setNewsList list


	robot.respond /記事ネタ 追加 (.*)/i, (msg) ->
		msg.send "#{msg.match[1]}を記事ネタに追加したアズ"
		addNewsList msg.match[1]

	robot.respond /記事ネタ 削除 (.*)/i, (msg) ->
		msg.send "#{msg.match[1]}を記事ネタから削除したアズ"
		deleteNewsList msg.match[1]

	robot.respond /記事ネタ 一覧/i, (msg) ->
		list = getNewsList().join('\n')
		msg.send "記事ネタは#{getNewsNum()}件あるアズ"
		if getNewsNum() isnt 0
			msg.send "#{list}"
