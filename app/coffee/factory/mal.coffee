ng.factory('mal', ($q, $http, $rootScope) ->
  hostname: 'api.atarashiiapp.com'
  username: null
  password: null

  connect: (username, password)->
    http = require('http')
    defer   = $q.defer()
    options =
      method: 'GET'
      hostname: 'myanimelist.net'
      path: '/api/account/verify_credentials.xml'
      port: 80
      auth: "#{username}:#{password}"
      headers:
        accept: '*/*'

    http.request(options, (res)->
      if res.statusCode == 200
        defer.resolve()
      else
        defer.reject(res.statusCode)
    ).on('error', ()->
      defer.reject()
    ).end()

    return defer.promise

  setAccount: (account)->
    @username = account.username
    @password = account.password

  isConnect: () ->
    if @username? and @password? then return true else return false

  getAnimeList: ()->
    if @isConnect()
      return @getList('anime')

  getMangaList: ()->
    if @isConnect()
      return @getList('manga')

  getList: (type)->
    defer = $q.defer()
    path  = "/#{type}list/#{@username}"

    $http.get("http://#{@hostname}#{path}")
    .success( (data) ->
      if type == "anime"
        lists = data.anime
      else if type == "manga"
        lists = data.manga
      else
        defer.reject()

      for item, i in lists
        # If the maximum number of chapters is not already set put a dash
        if type == 'anime'
          if item.episodes == null or item.episodes == 0
            lists[i].episodes='-'
          # Normalize the status variable
          item.watched_status = item.watched_status.replace(/[- ]+/, '').replace(/[ ]+/, '')

        # If the maximum number of chapters is not already set put a dash
        if type == 'manga'
          if item.chapters == null or item.chapters == 0
            lists[i].chapters='-'
          # Normalize the status variable
          item.read_status = item.read_status.replace(/[- ]/, '').replace(/[ ]+/, '')

      defer.resolve(lists)
    ).error( ->
      defer.reject()
    )

    return defer.promise

  getByID: (type, id)->
    if @isConnect()
      path = "/#{type}/#{id}"
      return $http.get("http://#{@username}:#{@password}@#{@hostname}#{path}?mine=1")
    else
      return false

  getByIDFromCache: (type, id) ->
    defer = $q.defer()

    # Si id est un chiffre
    if !isNaN(id)
      id = parseInt(id)
    else
      return false

    # Initialize
    result = null
    index  = null

    # Get the right list
    if type == 'anime'
      items = $rootScope.$storage.animelist
    else if type == 'manga'
      items = $rootScope.$storage.mangalist

    # If the anime/manga is in the list
    if items? and items != undefined
      for item, i in items
        if item.id == id
          result   = item
          index    = i
          break

    # If not we have all the informations
    if result? and result.synopsis?
      defer.resolve(result)
    else
      @getByID(type, id).success (data)->
        # If the maximum number of episodes is not already set put a dash
        if data.episodes == null or data.episodes == 0
          data.episodes = '-'
        # If the maximum number of chapters is not already set put a dash
        if data.chapters == null or data.chapters == 0
          data.chapters = '-'
        if index? and type == 'anime'
          # Update the AnimeList with the full data for the next time
          $rootScope.$storage.animelist[index] = data

        # Normalize the status variable
        if item.watched_status != undefined and item.watched_status?
          item.watched_status = item.watched_status.replace(/[- ]+/, '').replace(/[ ]+/, '')
        if item.read_status != undefined and item.read_status?
          item.read_status = item.read_status.replace(/[- ]+/, '').replace(/[ ]+/, '')

        if index? and type == 'manga'
          # Update the MangaList with the full data for the next time
          $rootScope.$storage.mangalist[index] = data

        # Send the data
        defer.resolve(data)

    return defer.promise

  search: (type, search)->
    if @isConnect()
      path = "/#{type}/search?q=#{search}"
      $http.get("http://#{@username}:#{@password}@#{@hostname}#{path}")
    else
      return false

  update: (type, id, data)->
    if @isConnect()
      path  = "/#{type}list/#{type}/#{id}"
      defer = $q.defer()

      data = data.replace('onhold', 'on-hold')
      $http.put("http://#{@username}:#{@password}@#{@hostname}#{path}?#{data}").success( (data) ->
        defer.resolve(data)
      )

      return defer.promise
    else
      return false
)
