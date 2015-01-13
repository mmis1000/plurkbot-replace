{EventEmitter} = require 'events'
OAuth = require 'OAuth'
utils = require './utils'
request = require 'request'
querystring = require 'querystring'
Url = require 'url'

###
  event : response     # new_response
  event : plurk        # new_plurk
  event : notification # update_notification
###

class Plurk extends EventEmitter
  constructor: (@config)->
    @lang = @config.lang || "tr_ch"
    @qualifier = @config.qualifier || ":"
    
    @oauth = new OAuth.OAuth 'http://www.plurk.com/OAuth/request_token',
      'http://www.plurk.com/OAuth/access_token',
      config.appKey,
      config.appSecret,
      '1.0A',
      null,
      'HMAC-SHA1',
      
    @realtimeChannel = null
    @init_()
    
  init_: ()->
    @prepareRealTimeChannel_()

  prepareRealTimeChannel_: ()->
    @get_ 'Realtime/getUserChannel', {}, {}, (e, data, res)=>
      try
        if e
          throw e
        obj = JSON.parse(data)
        #console.log obj
        @startRealtimeChannel_ obj.comet_server
      catch e
        console.error e
        console.log 'fail to load realtime channel, retry after 5 seconds'
        setTimeout (@prepareRealTimeChannel_.bind @), 5000
  
  startRealtimeChannel_: (url)->
    console.log "pulling data from #{url}"
    request url, (error, response, body)=>
      try
        if error
          throw error
        if response.statusCode != 200
          throw new Error "unexpect http code #{response.statusCode}'"
        body = body.replace /CometChannel\.scriptCallback\((.+)\);/, '$1'
        obj = JSON.parse body
        #console.log obj # Print the google web page.
        
        if obj.data
          @handleRealTime obj
        
        if obj.new_offset < -1
          throw new Error 'channel desync'
        
        if obj.new_offset != -1
          parsedObject = Url.parse url, true
          parsedObject.query.offset = obj.new_offset
          parsedObject.search = querystring.stringify parsedObject.query
          url = Url.format parsedObject
        
        @startRealtimeChannel_ url
        
      catch e
        console.error e
        console.log 'fail to load realtime channel, retry after 5 seconds'
        setTimeout (@prepareRealTimeChannel_.bind @), 5000
          
    
  get_: (api, options, defaultOptions, callback)->
    @oauth.post "http://www.plurk.com/APP/#{api}",
      @config.clientToken,
      @config.clientSecret,
      (utils.mergeDefault options, defaultOptions),
      callback
  
  handleRealTime: (data)->
    console.log JSON.stringify data, null, 2

  plurk: (content, options)->
    
  response : (id, content, options)->
  
  getResponse : (id)->
  
  markAllAsReaded : ()->

module.exports = Plurk