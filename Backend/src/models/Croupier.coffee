uniqid = require 'uniqid'

class Croupier
    constructor: () ->
        @id = uniqid()
        @mano = []
        @accion = -1

module.exports = Croupier