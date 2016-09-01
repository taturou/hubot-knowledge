#
# Description:
#   Webhook for Knowledge
#
# Commands:
#   hubot room_name - Return the real room name.
#
# Notes:
#   Set 'Webhook configuration' of Knowledge web size to the following:
#     * URL: http://(path-to-hubot)/webhook/knowledge/(mattermost-chatroom)
#
# Author:
#   taturou@gmail.com
#

# coding: UTF-8
module.exports = (robot) ->
  createMessageByKnowledge = (json) ->
    k_user  = json.update_user
    k_title = json.title
    k_link  = json.link
    k_statu = if json.status is "created" then "作成しました" else "更新しました"
    return "#{k_user}さんが「[#{k_title}](#{k_link})」を#{k_statu}。"

  createMessageByComment = (json) ->
    c_user  = json.update_user
    k_title = json.knowledge.title
    k_link  = json.knowledge.link
    k_user  = json.knowledge.insert_user
    return "@#{k_user} #{c_user}さんが「[#{k_title}](#{k_link})」にコメントしました。"

  # Tweeting to the specified channel.
  robot.router.post '/webhook/knowledge/:room', (req, res) ->
    room = req.params.room
    json = req.body
    # console.info json # for debug

    msg = ""
    if json.knowledge_id?
      msg = createMessageByKnowledge json
    else if json.comment_no?
      msg = createMessageByComment json
    else
      msg = ""

    robot.messageRoom(room, msg) unless msg is ""
    res.send 'OK'

  # Telling the channel name
  # Notes: In Mattermost, a showing channel name is not same as a inside channel name.
  robot.hear /room_?name/i, (msg) ->
    msg.reply msg.envelope.room

#
# Sample JSON for creating articles.
#
#  { comment_count: 0,
#    like_count: 0,
#    type_id: -100,
#    insert_date: '2016/09/01 02:34:23',
#    link: 'http://knowlege-server/open.knowledge/view/2',
#    groups: [],
#    insert_user: 'taturou',
#    title: 'test1 title',
#    content: 'test1 contents',
#    update_date: '2016/09/01 02:34:37',
#    tags: [ 'test1_tag' ],
#    update_user: 'taturou',
#    public_flag: 0,
#    knowledge_id: 2,
#    status: 'created' }

#
# Sample JSON for updating articles.
#
#  { comment_count: 0,
#    like_count: 0,
#    type_id: -100,
#    insert_date: '2016/09/01 02:34:23',
#    link: 'http://knowlege-server/open.knowledge/view/2',
#    groups: [],
#    insert_user: 'taturou',
#    title: 'test1 title',
#    content: 'test1 contents\r\ntest1 contents2',
#    update_date: '2016/09/01 02:39:44',
#    tags: [ 'test1_tag' ],
#    update_user: 'taturou',
#    public_flag: 0,
#    knowledge_id: 2,
#    status: 'updated' }

#
# Sample JSON for creating comments for a article.
#
# BTW, there is not 'updating' one.
#  { update_user: 'taturou',
#    comment_no: 2,
#    insert_date: '2016/09/01 03:47:28',
#    comment: 'comment1',
#    insert_user: 'taturou',
#    update_date: '2016/09/01 02:39:44',
#    knowledge:
#     { comment_count: 1,
#       like_count: 0,
#       type_id: -100,
#       insert_date: '2016/09/01 02:34:23',
#       link: 'http://knowlege-server/open.knowledge/view/2',
#       groups: [],
#       insert_user: 'taturou',
#       title: 'test1 title',
#       content: 'test1 contents\r\ntest1 contents2',
#       update_date: '2016/09/01 02:39:44',
#       tags: [ 'test1_tag' ],
#       update_user: 'taturou',
#       public_flag: 0,
#       knowledge_id: 2 } }
