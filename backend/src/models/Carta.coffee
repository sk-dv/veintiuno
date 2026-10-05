class Carta
  constructor: (@carta, @visible) ->

  revelar: ->
    @visible = true

module.exports = Carta