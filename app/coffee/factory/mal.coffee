ng.factory 'mal', ($q, $http, $rootScope) ->
  http: require('http')
  hostname: 'api.atarashiiapp.com'
  username: ''
  password: ''

  connect: (username, password)->
    defer = $q.defer()

    options =
      method: 'GET'
      hostname: 'myanimelist.net'
      path: '/api/account/verify_credentials.xml'
      port: 80
      auth: "#{username}:#{password}"
      headers:
        accept: '*/*'

    req = @http.request options, (res)->
      if res.statusCode == 200
        defer.resolve()
      else
        defer.reject(res.statusCode)

    req.on 'error', ()->
      defer.reject()

    req.end()

    return defer.promise

  setAccount: (account)->
    @username = account.username
    @password = account.password
  getAnimeList: ()->
    return @getList('anime')

  getMangaList: ()->
    return @getList('manga')

  getList: (type)->
    defer = $q.defer()

    path = "/#{type}list/#{@username}"

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
        if type == 'anime' and (item.episodes == null or item.episodes == 0)
            lists[i].episodes='-'
        # If the maximum number of chapters is not already set put a dash
        if type == 'manga' and (item.chapters == null or item.chapters == 0)
          lists[i].chapters='-'

      defer.resolve(lists)

    ).error( ->
      defer.reject()
    )

    return defer.promise
