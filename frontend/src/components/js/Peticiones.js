import Axios from "axios"

const API = `http://${process.env.REACT_APP_LOCALHOST}`

/** Every call resolves to {data, error}; error is a message the player can read. */
const llamar = async (metodo, ruta, cuerpo) => {
    try {
        const res = await Axios({method: metodo, url: `${API}${ruta}`, data: cuerpo})
        return {data: res.data, error: null, status: res.status}
    } catch (err) {
        const mensaje = err.response && err.response.data && err.response.data.message
        return {data: null, error: mensaje || 'No se pudo conectar con el servidor', status: err.response ? err.response.status : 0}
    }
}

export const crearPartida = (nombre) => llamar('post', '/partidas', {nombre})

export const verPartida = (pin) => llamar('get', `/partidas/${pin}`)

export const apostar = (pin, idJugador, cantidad) =>
    llamar('post', `/partidas/${pin}/apostar`, {id_jugador: idJugador, cantidad})

export const pedir = (pin, idJugador) =>
    llamar('post', `/partidas/${pin}/pedir`, {id_jugador: idJugador})

export const plantarse = (pin, idJugador) =>
    llamar('post', `/partidas/${pin}/plantarse`, {id_jugador: idJugador})

export const reiniciar = (pin, idJugador) =>
    llamar('post', `/partidas/${pin}/reiniciar`, {id_jugador: idJugador})
