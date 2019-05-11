# Description:
#   投票機能
#
# Commands:
#   hubot 投票　name
#   hubot 賛成
#   hubot 反対
#	hubot 開票
#
# Author:
#   Yuji Sasaki

module.exports = (robot) ->
	#robot.brain.data.attendance = [] if not robot.brain.data.attendance?
	#robot.brain.data.absence = [] if not robot.brain.data.absence?
	robot.brain.data.agree = [] if not robot.brain.data.agree?
	robot.brain.data.disAgree = [] if not robot.brain.data.disAgree?
	robot.brain.data.voteTitle = "" if not robot.brain.data.voteTitle?

	#賛成の人を返す
	getAgreeList = () ->
		return robot.brain.data.agree or []

	#反対の人を返す
	getDisAgreeList = () ->
		return robot.brain.data.disAgree or []

	#賛成の人数を返す
	getAgreeNum = () ->
		list = getAgreeList()
		if list? 
			return list.length
		else
			return 0

	#反対の人数を返す
	getDisAgreeNum = () ->
		list = getDisAgreeList()
		if list? 
			return list.length
		else
			return 0

	setAgreeList = (list) ->
		robot.brain.data.agree = list
		robot.brain.save
		console.log list

	setDisAgreeList = (list) ->
		robot.brain.data.disAgree = list
		robot.brain.save
		console.log list

	setVoteTitle = (text) ->
		robot.brain.data.voteTitle = text
		robot.brain.save
		console.log text

	#賛成の処理
	agree = (name) ->
		agreeList = getAgreeList()
		disAgreeList = getDisAgreeList()

		#賛成に追加
		if agreeList?
			if agreeList.indexOf(name) is -1
				agreeList[agreeList.length] = name 
				setAgreeList agreeList
		else
			l = [name]
			setAgreeList l

		#反対から削除
		if disAgreeList? and disAgreeList.indexOf(name) isnt -1
			disAgreeList.splice(disAgreeList.indexOf(name), 1)
			setDisAgreeList disAgreeList

	#反対の処理
	disAgree = (name) ->
		agreeList = getAgreeList()
		disAgreeList = getDisAgreeList()

		#賛成から削除
		if agreeList? and agreeList.indexOf(name) isnt -1
			agreeList.splice(agreeList.indexOf(name), 1)
			setAgreeList agreeList

		#反対に追加
		if disAgreeList?
			if disAgreeList.indexOf(name) is -1
				disAgreeList[disAgreeList.length] = name 
				setDisAgreeList disAgreeList
		else
			l = [name]
			setDisAgreeList l

	robot.respond /.*(賛成|異議なし).*/i, (msg) ->
		msg.send "#{msg.message.user.name}を賛成にしたアズ"
		agree msg.message.user.name

	robot.respond /.*(反対|異議あり).*/i, (msg) ->
		msg.send "#{msg.message.user.name}を反対にしたアズ"
		disAgree msg.message.user.name

	robot.respond /開票.*/i, (msg) ->
		agreeList = getAgreeList()
		disAgreeList = getDisAgreeList()
		agreeNum = getAgreeNum()
		disAgreeNum = getDisAgreeNum()

		if robot.brain.data.voteTitle == ""
			setAgreeList []
			setDisAgreeList []
			msg.send "まだ議題が設定されていないアズ"
		else
			msg.send "議案「#{robot.brain.data.voteTitle}」を開票するアズ"

			#賛成の出力
			agreeMember = agreeList.join('\n')
			msg.send "賛成は#{agreeNum}人アズ"
			if agreeNum isnt 0
				msg.send "#{agreeMember}\nが賛成したアズ"

			#反対の出力
			disAgreeMember = disAgreeList.join('\n')
			msg.send "反対は#{disAgreeNum}人アズ"
			if disAgreeNum isnt 0
				msg.send "#{disAgreeMember}\nが反対してるアズ"

			#グラフの表示                                                                                                                                                                                                    
			robot.emit 'slack.attachment',                                                                                                                                                                                                   
				channel: msg.envelope.message.room                                                                                                                                                                                             
				content:                                                                                                                                                                                                                       
					author_name: "Chart"                                                                                                                                                                                                         
					image_url: "https://quickchart.io/chart?c={type:%27pie%27,data:{labels:[%27賛成%27,%27反対%27],%20datasets:[{data:[#{agreeMember},#{disAgreeMember}]}]}}"

	robot.respond /(.*)(の|を)投票/i, (msg) ->
		msg.send "「#{msg.match[1]}」の投票を始めるアズ！"
		msg.send "賛成か反対か教えてほしいアズ"
		setAgreeList []
		setDisAgreeList []
		setVoteTitle msg.match[1]

	robot.respond /[\s　]投票/i, (msg) ->
		msg.send "「○○の投票」って言うと投票を始められるアズ！"