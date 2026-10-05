test = require 'node:test'
assert = require 'node:assert'
Partida = require '../src/models/Partida'
Jugador = require '../src/models/Jugador'
Croupier = require '../src/models/Croupier'

mano = (cartas...) -> ({carta, visible: true} for carta in cartas)

# Builds a game with fixed hands, a bet already placed and a rigged deck.
partida = (jugador, croupier, apuesta = 10, baraja = []) ->
  p = new Partida(new Croupier(), new Jugador('Test'), baraja)
  p.jugador.mano = mano(jugador...)
  p.croupier.mano = mano(croupier...)
  p.jugador.apostar(apuesta)
  p.olla = apuesta
  p.estado = 'jugando'
  p

score = (cartas...) -> new Partida(new Croupier(), new Jugador("T")).evaluarMano(mano(cartas...))

test 'Ace counts 11 or 1, whichever is best', ->
  assert.strictEqual score('cA', 'd5', 'p6'), 12
  assert.strictEqual score('cA', 'dK'), 21
  assert.strictEqual score('cA', 'cA', 'd9'), 21
  assert.strictEqual score('cA', 'dK', 'p5'), 16
  assert.strictEqual score('cA', 'cA', 'dK'), 12
  assert.strictEqual score('cK', 'dQ', 'pJ'), 30

test 'blackjack pays 3:2', ->
  p = partida(['cA', 'dK'], ['p9', 't8'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'jugador'
  assert.strictEqual r.credito, 115

test 'three-card 21 is not a blackjack', ->
  p = partida(['cA', 'd5', 'p5'], ['p9', 't8', 'd4'], 10, [])
  assert.strictEqual p.esBlackjack(p.jugador.mano), false

test 'blackjack against blackjack is a push and returns the bet', ->
  p = partida(['cA', 'dK'], ['pA', 't10'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'empate'
  assert.strictEqual r.credito, 100

test 'dealer blackjack beats a player 21 of three cards', ->
  p = partida(['cA', 'd5', 'p5'], ['pA', 'tK'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'croupier'
  assert.strictEqual r.credito, 90

test 'player bust loses immediately without the dealer drawing', ->
  p = partida(['cK', 'dQ', 'p5'], ['p6', 't5'], 10, ['c2'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'croupier'
  assert.strictEqual r.credito, 90
  assert.strictEqual p.croupier.mano.length, 2

test 'dealer stands on 17 and hits below 17', ->
  p = partida(['cK', 'd8'], ['p10', 't7'])
  assert.strictEqual p.evaluarPartida().resultado.ganador, 'jugador'
  assert.strictEqual p.croupier.mano.length, 2
  p = partida(['cK', 'd9'], ['p10', 't6'], 10, ['d2'])
  r = p.evaluarPartida()
  assert.strictEqual p.croupier.mano.length, 3
  assert.strictEqual r.resultado.ganador, 'jugador'

test 'dealer bust pays the player 1:1', ->
  p = partida(['cK', 'd8'], ['p10', 't6'], 10, ['dK'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'jugador'
  assert.strictEqual r.credito, 110

test 'equal scores are a push and return the bet', ->
  p = partida(['cK', 'd8'], ['p10', 't8'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'empate'
  assert.strictEqual r.credito, 100

test 'dealer wins with a higher score', ->
  p = partida(['cK', 'd7'], ['p10', 't9'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'croupier'
  assert.strictEqual r.credito, 90

test 'deck has 52 unique cards', ->
  b = new Partida(new Croupier(), new Jugador("T")).baraja
  assert.strictEqual b.length, 52
  assert.strictEqual new Set(b).size, 52

test 'game PIN is a unique 4-digit number', ->
  pines = (new Partida(new Croupier(), new Jugador("T")).id for i in [1..200])
  assert.ok pines.every((pin) -> /^\d{4}$/.test(pin))
  assert.strictEqual new Set(pines).size, 200

test 'bet is validated: integer, at least 1, within credit', ->
  p = new Partida(new Croupier(), new Jugador('T'))
  id = p.jugador.id
  assert.throws (-> p.apostar(id, -5)), /al menos 1/
  assert.throws (-> p.apostar(id, 0)), /al menos 1/
  assert.throws (-> p.apostar(id, 2.5)), /entero/
  assert.throws (-> p.apostar(id, 101)), /crédito/
  assert.throws (-> p.apostar('otro', 10)), /no pertenece/

test 'betting deals the hand; a second bet is rejected', ->
  p = new Partida(new Croupier(), new Jugador('T'))
  id = p.jugador.id
  p.apostar(id, '10')
  if p.estado == 'jugando'
    assert.strictEqual p.jugador.mano.length, 2
    assert.strictEqual p.croupier.mano.length, 2
    assert.strictEqual p.jugador.cartera, 90
    assert.throws (-> p.apostar(id, 5)), /Ya apostaste/

test 'hole card is hidden from the player view while playing', ->
  p = partida(['cK', 'd7'], ['p10', 't9'])
  p.croupier.mano[0].visible = false
  assert.strictEqual p.vista().croupier.mano[0].carta, ''
  p.evaluarPartida()
  assert.strictEqual p.vista().croupier.mano[0].carta, 'p10'

test 'cannot hit or stand once the hand is over, hitting to bust ends it', ->
  p = partida(['cK', 'd6'], ['p10', 't9'], 10, ['d9'])
  id = p.jugador.id
  p.pedir(id)
  assert.strictEqual p.estado, 'terminada'
  assert.strictEqual p.resultado.ganador, 'croupier'
  assert.throws (-> p.pedir(id)), /No puedes pedir/
  assert.throws (-> p.plantarse(id)), /No puedes plantarte/

test 'new hand only after the previous one ends', ->
  p = partida(['cK', 'd7'], ['p10', 't9'])
  id = p.jugador.id
  assert.throws (-> p.reiniciar(id)), /todavía no termina/
  p.plantarse(id)
  p.reiniciar(id)
  assert.strictEqual p.estado, 'apuesta'
  assert.strictEqual p.jugador.mano.length, 0

test 'blackjack on an odd bet keeps credit a whole number (rounded down)', ->
  p = partida(['cA', 'dK'], ['p9', 't8'], 5)
  assert.strictEqual p.evaluarPartida().credito, 107

test 'bet must be a real number, not true or a list', ->
  p = new Partida(new Croupier(), new Jugador('T'))
  assert.throws (-> p.apostar(p.jugador.id, true)), /entero/
  assert.throws (-> p.apostar(p.jugador.id, [5])), /entero/

test 'result explains why: dealer natural beats a three-card 21', ->
  p = partida(['cA', 'd5', 'p5'], ['pA', 'tK'])
  r = p.evaluarPartida()
  assert.strictEqual r.resultado.ganador, 'croupier'
  assert.match r.resultado.motivo, /blackjack/

test 'all-in: losing leaves 0 credit, winning doubles it', ->
  p = partida(['cK', 'd7'], ['p10', 't9'], 100)
  assert.strictEqual p.jugador.cartera, 0
  assert.strictEqual p.evaluarPartida().credito, 0
  p = partida(['cK', 'd9'], ['p10', 't7'], 100)
  assert.strictEqual p.evaluarPartida().credito, 200

test 'cannot bet again until the finished hand is restarted', ->
  p = partida(['cK', 'd7'], ['p10', 't9'])
  p.plantarse(p.jugador.id)
  assert.throws (-> p.apostar(p.jugador.id, 5)), /Ya apostaste/
  p.reiniciar(p.jugador.id)
  p.apostar(p.jugador.id, 5)
  assert.ok p.estado in ['jugando', 'terminada']
