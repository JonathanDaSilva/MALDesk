ng.factory 'mal', ($q) ->
  http: require('http')
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
