# Description:
#   画像投稿のスクリプト
#

module.exports = (robot) ->
	
	robot.respond /(.*)の画像/i, (msg) ->
		imageMe msg, msg.match[1], (url) ->
			msg.send "見つけてきたアズー！"
			msg.send url

	robot.hear /(おなか|お腹)(減った|へった|空いた|すいた|ぺこぺこ|ペコペコ)/i, (msg)->
		imageMe msg, "飯テロ", (url) ->
			msg.send "飯テロアズ！"
			msg.send url

	robot.respond /飯テロ/i, (msg)->
		imageMe msg, "飯テロ", (url) ->
			msg.send "わかったアズ！"
			msg.send url.replace(":large","")

imageMe = (msg, query, animated, faces, cb) ->
	cb = animated if typeof animated == 'function'
	cb = faces if typeof faces == 'function'
	q = v: '1.0', rsz: '8', q: query, safe: 'active'
	q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
	q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
	msg.http('http://ajax.googleapis.com/ajax/services/search/images')
		.query(q)
		.get() (err, res, body) ->
			images = JSON.parse(body)
			images = images.responseData?.results
			if images?.length > 0
				image  = msg.random images
				cb "#{image.unescapedUrl}"