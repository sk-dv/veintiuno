Carta = require './Carta'

pinesEnUso = new Set()

# 4-digit PIN (1000-9999), unique among the games created by this server.
generarPin = ->
  throw new Error('No hay PINs disponibles') if pinesEnUso.size >= 9000
  loop
    pin = String(Math.floor(1000 + Math.random() * 9000))
    break unless pinesEnUso.has(pin)
  pinesEnUso.add(pin)
  return pin

fallar = (mensaje, status) ->
  error = new Error(mensaje)
  error.status = status
  throw error

CARTAS_MINIMAS = 15

# Single-player game. States: 'apuesta' (waiting for a bet) -> 'jugando' -> 'terminada'.
class Partida
  constructor: (@croupier, @jugador, @baraja) ->
    @id = generarPin()
    @olla = 0
    @estado = 'apuesta'
    @resultado = null

    if @baraja == undefined
      @baraja = this.barajear()

  barajear: ->
    palos = ['c', 'd', 'p', 't']
    valores = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

    baraja = []

    for palo in palos
      for valor in valores
        baraja.push(palo + valor)

    return baraja.sort(() -> Math.random() - 0.5)

  # Deals the opening hands: dealer hole card hidden, everything else face up.
  repartir: () ->
    @baraja = this.barajear() if @baraja.length < CARTAS_MINIMAS
    @croupier.mano = [new Carta(@baraja.pop(), false), new Carta(@baraja.pop(), true)]
    @jugador.mano = [new Carta(@baraja.pop(), true), new Carta(@baraja.pop(), true)]

  evaluarMano: (mano) ->
    valores = (this.obtenerValorNumerico(cartas.carta) for cartas in mano)
    total = valores.reduce ((suma, valor) -> suma + valor), 0
    hayUnAs = mano.some (cartas) -> cartas.carta.substr(1) == 'A'
    return if hayUnAs && total + 10 <= 21 then total + 10 else total

  esBlackjack: (mano) ->
    return mano.length == 2 && this.evaluarMano(mano) == 21

  obtenerValorNumerico: (carta) ->
    valor = carta.substr(1, carta.length - 1)
    return 10 if valor in ['J', 'Q', 'K']
    return 1 if valor == 'A'
    return parseInt(valor)

  verificarJugador: (id) ->
    fallar('Ese jugador no pertenece a esta partida', 403) unless id == @jugador.id

  # Places the bet and deals the hand. A natural blackjack ends the hand at once.
  apostar: (id, monto) ->
    this.verificarJugador(id)
    fallar('Ya apostaste en esta mano', 409) unless @estado == 'apuesta'
    monto = if typeof monto == 'number' || (typeof monto == 'string' && monto.trim() != '') then Number(monto) else NaN
    fallar('La apuesta debe ser un número entero de al menos 1', 400) unless Number.isInteger(monto) && monto >= 1
    fallar('No puedes apostar más que tu crédito', 400) if monto > @jugador.cartera

    @jugador.apostar(monto)
    @olla += monto
    this.repartir()
    @estado = 'jugando'

    if this.esBlackjack(@jugador.mano) || this.esBlackjack(@croupier.mano)
      this.evaluarPartida()

  pagarAlCasino: ()->
    @olla = 0

  pagarAlJugador: (blackjack = false) ->
    @jugador.cartera += if blackjack then @olla * 2 + Math.floor(@olla / 2) else @olla * 2
    @olla = 0

  devolverApuesta: () ->
    @jugador.cartera += @olla
    @olla = 0

  pedir: (id) ->
    this.verificarJugador(id)
    fallar('No puedes pedir carta ahora', 409) unless @estado == 'jugando'
    @jugador.mano.push(new Carta(@baraja.pop(), true))

    this.evaluarPartida() if this.evaluarMano(@jugador.mano) > 21

  plantarse: (id) ->
    this.verificarJugador(id)
    fallar('No puedes plantarte ahora', 409) unless @estado == 'jugando'
    this.evaluarPartida()

  evaluarPartida: ->
    jugadorBlackjack = this.esBlackjack(@jugador.mano)
    croupierBlackjack = this.esBlackjack(@croupier.mano)
    puntosJugador = this.evaluarMano(@jugador.mano)
    ganador = ''
    motivo = ''

    if puntosJugador > 21
      this.pagarAlCasino()
      ganador = 'croupier'
      motivo = 'Te pasaste de 21'

    else if jugadorBlackjack || croupierBlackjack
      if jugadorBlackjack && croupierBlackjack
        this.devolverApuesta()
        ganador = 'empate'
        motivo = 'Blackjack para los dos: te devolvemos tu apuesta'
      else if jugadorBlackjack
        this.pagarAlJugador(true)
        ganador = 'jugador'
        motivo = 'Blackjack: pagas 3 a 2'
      else
        this.pagarAlCasino()
        ganador = 'croupier'
        motivo = 'El dealer tiene blackjack, que gana a cualquier otro 21'

    else
      while this.evaluarMano(@croupier.mano) < 17
        @croupier.mano.push(new Carta(@baraja.pop(), true))

      puntosCroupier = this.evaluarMano(@croupier.mano)

      if puntosCroupier > 21 || puntosJugador > puntosCroupier
        this.pagarAlJugador()
        ganador = 'jugador'
        motivo = if puntosCroupier > 21 then 'El dealer se pasó de 21' else 'Tienes más puntos que el dealer'
      else if puntosJugador == puntosCroupier
        this.devolverApuesta()
        ganador = 'empate'
        motivo = 'Mismos puntos: te devolvemos tu apuesta'
      else
        this.pagarAlCasino()
        ganador = 'croupier'
        motivo = 'El dealer tiene más puntos'

    @estado = 'terminada'
    @resultado = {
      'ganador': ganador
      'motivo': motivo
      'score_croupier': this.evaluarMano(@croupier.mano)
      'score_jugador': this.evaluarMano(@jugador.mano)
    }
    return this.vista()

  mostrarCartas: ->
    for carta in @croupier.mano
      carta.visible = true

    return @croupier.mano

  # New hand: back to betting with empty tables.
  reiniciar: (id) ->
    this.verificarJugador(id)
    fallar('La mano todavía no termina', 409) unless @estado == 'terminada'
    @croupier.mano = []
    @jugador.mano = []
    @resultado = null
    @estado = 'apuesta'

  # What the player is allowed to see: the dealer hole card stays hidden while playing.
  vista: ->
    this.mostrarCartas() if @estado == 'terminada'

    croupierMano = for carta in @croupier.mano
      if carta.visible then {carta: carta.carta, visible: true} else {carta: '', visible: false}

    return {
      'id_partida': @id
      'estado': @estado
      'credito': @jugador.cartera
      'puntos_jugador': if @jugador.mano.length then this.evaluarMano(@jugador.mano) else null
      'jugador': {'id': @jugador.id, 'mano': @jugador.mano}
      'croupier': {'id': @croupier.id, 'mano': croupierMano}
      'resultado': @resultado
    }

module.exports = Partida
