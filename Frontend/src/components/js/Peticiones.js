import Axios from "axios";

export const iniciar = async () => {
    let players = {}

    await Axios.get(`http://${process.env.REACT_APP_LOCALHOST}/iniciar`).then((res) => {
        players.croupier = res.data.croupier
        players.jugador = res.data.jugador
    })

    return players
}

export const apostar = async (jugador, bet, partida) => {
    let credit = 0

    await Axios.post(`http://${process.env.REACT_APP_LOCALHOST}/apostar`, {
        id_partida: partida,
        id_jugador: jugador.id,
        cantidad: bet
    }).then((res) => {
        credit = res.data.credito
        bet = ""
    }).catch((err) => {
        console.log(err)
    })

    return credit
}

export const evaluarMano = async (rolID) => {
    let valor = -1

    await Axios.post(`http://${process.env.REACT_APP_LOCALHOST}/evaluar-mano`, {
        id: rolID
    }).then((res) => {
        valor = res.data.valor
    }).catch((err) => {
        console.log(err)
    })

    return valor
}

export const peticionPedir = async (rol, rolID, partida) => {
    let mano = []

    await Axios.post(`http://${process.env.REACT_APP_LOCALHOST}/pedir`, {
        id_jugador: rolID,
        id_partida: partida
    }).then((res) => {
        // console.log("Peticion pedir con id", res.data, rolID)
        mano = res.data.mano
    }).catch((err) => {
        console.log(err)
    })

    return mano
}

export const finalizarPartida = async (idJugador) => {
    let partida = {}

    await Axios.post(`http://${process.env.REACT_APP_LOCALHOST}/evaluar-partida`, {id: idJugador})
    .then((res) => {
        // console.log(res)
        partida = res
    }).catch((err) => {
        console.log(err)
    })

    return partida
}

