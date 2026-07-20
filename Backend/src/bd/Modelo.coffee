mongoose = require ('mongoose')
bjSchema = require ('./Conexion')

bjSchema = new mongoose.Schema({
  
    _id: {type: 'String', requied: true},
    estado: {type: 'String'},
    multijugador: {type: 'String'},
    olla: {type: 'Number'},
    turno: {type: 'Number'},
    baraja: [
      type: 'String'
    ],
    croupier: {
      id: {type: 'String'},
      mano: [
        carta: {type: 'String'},
        visible: {type: 'String'}
      ],
      oculta: {
        palo: {type: 'String'},
        valor: {type: 'Number'}
      }
    },
    jugadores: [
      nombre_jugador: {type: 'String'},
      mano: [
        carta: {type: 'String'},
        visible: {type: 'String'}
      ],
      score_player: {type: 'Number'},
      cartera: {type: 'Number'}
    ],
    jugador: {
      nombre_jugador: {type: 'String'},
      cartera: {type: 'Number'},
      mano: [
        carta: {type: 'String'},
        visible: {type: 'String'}
      ]
    }
  })
  

class BD

  constructor: ->
    @Schema = mongoose.model('partida', bjSchema)

  crearEsquema: (req) ->
    partida = new @Schema(
      _id: req.id,
      multijugador: req.multijugador
    )
    partida.save( fun = (err) -> console.log err if err)
    
  guardarPartida: (req) ->
    @Schema.findByIdAndUpdate(req.id,
      {olla: req.olla, 
      baraja: req.baraja,
      croupier: req.croupier,
      jugadores: req.jugadores,
      jugador: req.jugador
      },
      fun=(err) -> 
        if err
          console.log err
      )
  cargarPartida: (id) ->
    doc = await @Schema.findById(id).select()
    return doc
    
    
module.exports = BD
