express = require('express')
partidaController = require('../controllers/partida')

router = express.Router()

router.post '/partidas', partidaController.crearPartida
router.get '/partidas/:pin', partidaController.verPartida
router.post '/partidas/:pin/apostar', partidaController.apostar
router.post '/partidas/:pin/pedir', partidaController.pedir
router.post '/partidas/:pin/plantarse', partidaController.plantarse
router.post '/partidas/:pin/reiniciar', partidaController.reiniciar

module.exports = router
