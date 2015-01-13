#OAuth = require 'OAuth'
Plurk = require './plurkHelper.coffee'

init = (config)->
  plurk = new Plurk(config)
  ###
  oauth = new OAuth.OAuth 'http://www.plurk.com/OAuth/request_token',
    'http://www.plurk.com/OAuth/access_token',
    config.appKey,
    config.appSecret,
    '1.0A',
    null,
    'HMAC-SHA1',
  
  #oauth.post 'http://www.plurk.com/APP/Timeline/markAsRead',
  #oauth.post 'http://www.plurk.com/APP/Timeline/getPlurks',
  #oauth.post 'http://www.plurk.com/APP/Responses/get',
  #oauth.post 'http://www.plurk.com/APP/Responses/responseAdd',
  oauth.post 'http://www.plurk.com/APP/Realtime/getUserChannel',
    config.clientToken,
    config.clientSecret,
    {},
    #{plurk_id : 1250339557, qualifier : 'says', content : '@mfish20012013 :測試'},
    #{plurk_id : 1250339557}#
    #{"ids":"[1250339557]",note_position:true},
    (e, data, res)->
      if e 
        console.error e
      try
        console.log JSON.stringify (JSON.parse data), null, 2
      catch
        console.log data
  ###
  ###
  oauth.get 'http://comet57.plurk.com:80/comet?channel=generic-10647034-c61d948e1d6caff0412895ad4361eb03ed304ecf&offset=2',
    config.clientToken,
    config.clientSecret,
    (e, data, res)->
      data = data.replace /^CometChannel\.scriptCallback\(/, ""
      data = data.replace /\);$/, ""
      if e 
        console.error e
      try
        console.log JSON.stringify (JSON.parse data), null, 2
      catch
        console.log data
  ###
module.exports = init