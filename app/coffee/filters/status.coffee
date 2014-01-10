ng.filter 'status', ->
  return (items, value) ->
    results = []

    if items == undefined or item?
      return []

    if value == 'all' or value == 'search'
      return items
    else
      for item in items
        if value == 'plantowatch'
          value = 'plan to watch'
        else if value == 'onhold'
          value = 'on-hold'
        else if value == 'plantoread'
          value = 'plan to read'

        if item.watched_status? and item.watched_status == value
          results.push(item)
        else if item.read_status? and item.read_status == value
          results.push(item)

    return results
