express = require('express')
partidaController = require('../controllers/partida')

router = express.Router()

router.get '/partidas', partidaController.getModelo
router.get '/iniciar', partidaController.getIniciarPartida
router.get '/evaluar-partida', partidaController.getEvaluarPartida
router.get '/reiniciar', partidaController.getReiniciarPartida
router.get '/turno' , partidaController.getTurno

router.post '/crear-partida', partidaController.postCrearPartida
router.post '/unirse-partida', partidaController.postUnirsePartida
router.post '/cargar-partida', partidaController.postCargarPartida
router.post '/agregar-jugador', partidaController.postAgregarJugador
router.post '/evaluar-mano', partidaController.postEvaluarMano
router.post '/apostar', partidaController.postApostar
router.post '/pedir', partidaController.postPedir

module.exports = router