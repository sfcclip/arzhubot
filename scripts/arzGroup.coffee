# Description
#   ユーザーをグルーピングしていろいろする
#
# Commands:
#   hubot 乱択 <query> <query> ...-- 引数からランダムにchoice
#   hubot 乱択 $<groupname> -- 登録されたグループの要素の中からランダムにchoice
#   hubot グループ 登録 <group name> <group elements> -- グループを設定
#   hubot グループ 削除 <group name> -- グループを削除
#   hubot グループ 一覧 -- 登録されているグループ一覧を表示
#
# Author:
#   @wat_shun
#
# Thanks:
#   https://github.com/masuilab/slack-hubot/blob/master/scripts/choice.coffee
#   http://sota1235.hatenablog.com/entry/2015/06/15/001400

_ = require 'lodash'

module.exports = (robot) ->
    GROUP = 'group_data'

    # データ取得
    getData = () ->
        data = robot.brain.get(GROUP) or {}
        return data

    # データセット
    setData = (data) ->
        robot.brain.set GROUP, data

    # グループをセット
    setGroup = (groupName, groupElement) ->
        data = getData()
        data[groupName] = groupElement
        setData(data)
        return

  # グループを削除
    deleteGroup = (groupName) ->
        data = getData()
        if data[groupName] is undefined
            return false
        delete data[groupName]
        return true

    # グループ要素を取得
    getGroupElem = (groupName) ->
        data = getData()
        if data[groupName] is undefined
            return false
        else
            return data[groupName]

    #ランダムに一人選ぶ
    robot.respond /乱択 (.+)/i, (msg) ->
        items = msg.match[1].split(/\s+/)

        # 第一引数がグループ名指定の場合
        if /\$(.+)/.test items[0]
            items = getGroupElem items[0].substring(1)
            if not items
                msg.send "そんなグループ知らないアズ"
            return

        choice = _.sample items
        msg.send "「#{choice}」に決めたアズ！"

    robot.respond /リプ (.+)/i, (msg) ->
        items = getGroupElem msg.match[1]

        if not items
            msg.send "そんなグループ知らないアズ"
            return

        robot.send {link_names: 1},"#{items.join(',')}! #{msg.message.user.name}が呼んでるアズ！"

    # グループを設定
    robot.respond /グループ 登録 (.+)/i, (msg) ->
        items = msg.match[1].split(/\s+/)
        groupName = items[0]
        items.shift()
        groupElement = items
        setGroup groupName, groupElement
        msg.send "グループ：#{groupName}を覚えたアズ"

    # グループを削除
    robot.respond /グループ 削除 (.+)/i, (msg) ->
        groupName = msg.match[1].split(/\s+/)[0]
        if deleteGroup groupName
            msg.send "グループ：#{groupName}を忘れたアズ。"
        else
            msg.send "グループ：#{groupName}なんて知らないアズ。"

    # for debug
    robot.respond /グループ 一覧/i, (msg) ->
        data = getData()
        if _.size(data) is 0
            msg.send "知ってるグループはないアズ"
            return
        for gname, gelm of data
            msg.send "#{gname}: #{gelm.join()}"