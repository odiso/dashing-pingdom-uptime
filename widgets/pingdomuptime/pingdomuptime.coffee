class Dashing.Pingdomuptime extends Dashing.Widget
  @accessor 'current', Dashing.AnimatedValue

  @accessor 'last', Dashing.AnimatedValue

  @accessor 'arrow', ->
    if @get('last')
      if (@get('current') is @get('last')) then 'icon-arrow-right'
      else if (@get('current') > @get('last')) then 'icon-arrow-up' else 'icon-arrow-down'

  onData: (data) ->
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"
