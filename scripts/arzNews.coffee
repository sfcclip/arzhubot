# Description:
# 	記事ネタを記録する		
#
# Commands:
#   hubot 記事ネタ 追加 <query>
#	hubot 記事ネタ 削除 <query>
#	hubot 記事ネタ 削除 <query>番
#	hubot 記事ネタ 全削除
#   hubot 記事ネタ 一覧
#
# Author:
#    @wat_shun

module.exports = (robot) ->
	robot.brain.data.news = [] if not robot.brain.data.news?

	hankaku_int = (text) ->
		text.replace(/[０-９]/g, (s)->
			String.fromCharCode(s.charCodeAt(0)-0xFEE0) )

	initNewsList = () ->
		robot.brain.data.news = []
		robot.brain.save

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

		console.log "記事データの更新が完了しました"
		console.log list

	addNewsList = (news)->
		list = getNewsList()

		#記事リストに追加
		if list?
			if list.indexOf(news) is -1
				list[list.length] = news
				setNewsList list
		else
			l = [news]
			setNewsList l

	deleteNewsList = (news)->
		list = getNewsList()
		console.log "#{news}の削除を試みます。"

		#記事リストから削除
		if list? and list.indexOf(news) isnt -1
			list.splice(list.indexOf(news), 1)
			console.log "#{news}を削除しました。"
			setNewsList list
		else
			console.log "#{news}はありませんでした。"

	robot.respond /記事ネタ( |　)追加( |　)(.*)/i, (msg) ->
		msg.send "#{msg.match[3]}を記事ネタに追加したっぷ"
		addNewsList msg.match[3]

	robot.respond /記事ネタ( |　)削除( |　)(.*)/i, (msg) ->
		if /([0-9０-９]+)番/g.test(msg.match[3])
			#正規表現で数字を抽出し、全角を半角に置換し、配列操作用に１個前にずらす		
			n = ( hankaku_int /([0-9０-９]+)番/g.exec(msg.match[3])[1] ) - 1
			console.log "削除クエリ「#{n + 1}」番の記事"
			list = getNewsList()
			if 0 <= n and n < list.length
				msg.send "#{list[n]}を記事ネタから削除したっぷ"
				deleteNewsList list[n]
			else if not (0 <= n and n < list.length)
				msg.send "その番号の記事はないっぷ"
			
		else 
			console.log "削除クエリ「#{msg.match[3]}」"
			list = getNewsList()
			if list.indexOf(msg.match[3]) isnt -1
				msg.send "#{msg.match[3]}を記事ネタから削除したっぷ"
				deleteNewsList msg.match[3]
			else
				msg.send "その記事はないっぷ"

	robot.respond /記事ネタ( |　)全削除/i, (msg) ->
		msg.send "記事ネタを全て削除したっぷ"
		initNewsList

	robot.respond /記事ネタ( |　)一覧/i, (msg) ->
		n = getNewsNum()
		msg.send "記事ネタは#{n}件あるっぷ"
		if n isnt 0
			list = getNewsList()
			ret = ""
			for news, i in list
				ret += "#{i+1}:#{news}"
				if i+1 isnt n 
					ret += "\n"
			msg.send "#{ret}"
