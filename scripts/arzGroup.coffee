# Description
#   ユーザーをグルーピングしていろいろする
#
# Commands:
#   hubot ランダム <groupname> -- 登録されたグループのメンバーの中からランダムに選ぶ
#   hubot ランダム <query>...-- 引数からランダムに選ぶ
#   hubot <groupname> 登録 <group member>... -- グループを設定
#   hubot <groupname> 削除 -- グループを削除
#   hubot グループ -- 登録されているグループ一覧を表示
#
# Author:
#   @akkyie
#

module.exports = (robot) ->
    GROUP = 'group_data'

    # データ取得
    getGroupData = () ->
        return robot.brain.get(GROUP) or {}

    # データセット
    setGroupData = (data) ->
        robot.brain.set(GROUP, data)

    # グループをセット
    setGroup = (groupName, groupMembers) ->
        data = getGroupData()
        data[groupName] = groupMembers
        setGroupData(data)

    # グループを削除
    deleteGroup = (groupName) ->
        data = getGroupData()
        if data[groupName] is undefined
            return false
        delete data[groupName]
        return true

    # グループ要素を取得
    getGroupMembers = (groupName) ->
        data = getGroupData()
        if data[groupName] is undefined
            return false
        else
            return data[groupName]

    #ランダムに一人選ぶ
    robot.respond /ランダム[\s　](.+)/i, (msg) ->
        items = msg.match[1].split(/[\s　]+/)

        # 引数が1個のみの場合
        if items.length is 1
            items = getGroupMembers(items[0])
            if not items
                msg.send "そんなグループ知らないっぷ"
                return

        msg.send "#{msg.random(items)}に決めたっぷ"

    robot.hear /.*@([^\s　]+)/i, (msg) ->
        items = getGroupMembers msg.match[1]

        if items
          msg.send "#{items.map( (name) -> "<@#{name}>" ).join(' 、 ')}! #{msg.message.user.name}が呼んでるアズ！"

    # グループを設定
    robot.respond /(.+)[\s　]登録[\s　](.+)/i, (msg) ->
        groupName = msg.match[1]
        groupElement = msg.match[2].split(/[\s　]+/)
        setGroup groupName, groupElement
        msg.send "グループ：#{groupName}を覚えたっぷ!"

    # グループを削除
    robot.respond /(.+)[\s　]削除/i, (msg) ->
        groupName = msg.match[1]
        if deleteGroup groupName
            msg.send "グループ：#{groupName}を忘れたっぷ。"
        else
            msg.send "グループ：#{groupName}なんて知らないっぷ。"

    # グループの一覧
    robot.respond /グループ/i, (msg) ->
        data = getGroupData()
        if Object.keys(data).length is 0
            msg.send "知ってるグループはないっぷ"
            return
        for groupName, groupMembers of data
            msg.send "#{groupName}: #{groupMembers.join()}"
