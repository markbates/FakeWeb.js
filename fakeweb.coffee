class @FakeWeb
  
  @mappings: 
    'GET': {}
    'POST': {}
    'PUT': {}
    'DELETE': {}
  
  @maps: (type)->
    FakeWeb.mappings[type]
  
  @get: (url, options = {}) ->
    FakeWeb.mappings['GET'][url] = options
    
  @post: (url, options = {}) ->
    FakeWeb.mappings['POST'][url] = options
    
  @put: (url, options = {}) ->
    FakeWeb.mappings['PUT'][url] = options
    
  @delete: (url, options = {}) ->
    FakeWeb.mappings['DELETE'][url] = options
  
  @fetch: (type, url) ->
    type ||= 'GET'
    type = type.toUpperCase()
    verb = FakeWeb.maps(type)
    return null unless verb
    fw = verb[url]
    return fw

  @suspend: ->
    $.ajax = $._ajax
    
  @resume: ->
    $._ajax = $.ajax
    $.ajax = FakeWeb.ajax
    
  @ajax = (settings) ->
    for key, value of $.ajaxSettings
      unless settings[key]?
        settings[key] = $.ajaxSettings[key]

    fw = FakeWeb.fetch(settings.type, settings.url)
    throw new Error("FakeWebError: #{settings.url} not mapped!") unless fw?

    try
      settings.beforeSend({
        setRequestHeader: (key, value) ->
      }) if settings.beforeSend
      if fw.success
        data = fw.success()
        data['status'] ||= 200
        settings.success data
      else if fw.error
        data = fw.error()
        data['status'] ||= 500
        settings.error data
    finally
      settings.complete() if settings.complete

FakeWeb.resume()