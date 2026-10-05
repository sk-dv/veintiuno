import React, {Component} from 'react'
import '../css/Naipes.css'
import Card from './Card'
import {NombreEditable} from './Nombre'
import swal from 'sweetalert'

const TITULOS = {jugador: 'ganaste', croupier: 'perdiste', empate: 'empate'}

class Naipes extends Component {
    constructor(props) {
        super(props)

        this.state = {bet: 10}
    }

    handleInputBet = (evt) => {
        this.setState({bet: evt.target.value === "" ? "" : parseFloat(evt.target.value)})
    }

    handleApostar = (evt) => {
        evt.preventDefault()

        const {vista, onApostar} = this.props
        const {bet} = this.state

        if (!Number.isInteger(bet) || bet < 1) swal('¡Ops!', 'Ingresa una apuesta de al menos 1', 'error')
        else if (bet > vista.credito) swal('¡Ops!', 'No puedes apostar un monto mayor al crédito', 'error')
        else onApostar(bet)
    }

    crearCartas = (rol) => rol.mano.map((carta, i) => (
        <Card key={i} value={carta.carta} visible={carta.visible}/>
    ))

    estado = () => {
        const {vista} = this.props
        const {estado, resultado, puntos_jugador: puntos} = vista

        if (estado === 'apuesta') return {titulo: 'haz tu apuesta', detalle: 'las cartas se reparten al apostar'}
        if (estado === 'jugando') return {titulo: 'tu turno', detalle: `${puntos} puntos`}
        return {
            titulo: TITULOS[resultado.ganador],
            detalle: `${resultado.motivo} · dealer ${resultado.score_croupier}, tú ${resultado.score_jugador}`
        }
    }

    render() {
        const {nombre, vista, onPedir, onPlantarse, onSeguir} = this.props
        const {bet} = this.state
        const {estado} = vista
        const {titulo, detalle} = this.estado()

        return (
            <>
                <main className="table">
                    <div className="seat">
                        <span className="seat-name serif">dealer</span>
                        <div className="hand">{this.crearCartas(vista.croupier)}</div>
                    </div>
                    <div className="status" aria-live="polite">
                        <div className="status-title serif">{titulo}</div>
                        <div className="status-detail">{detalle}</div>
                    </div>
                    <div className="seat">
                        <div className="hand">{this.crearCartas(vista.jugador)}</div>
                        <NombreEditable inicial={nombre || 'Jugador'}/>
                    </div>
                </main>
                <div className="controls">
                    {estado === 'apuesta' && (
                        <form className="bet" onSubmit={this.handleApostar}>
                            <label htmlFor="apuesta">tu apuesta ($)</label>
                            <input id="apuesta" className="bet-input" type="number" min="1" step="1"
                                   value={bet} onChange={this.handleInputBet}/>
                            <button type="submit" className="btn">apostar</button>
                        </form>
                    )}
                    {estado === 'jugando' && (
                        <>
                            <button type="button" className="btn" onClick={onPlantarse}>plantarse</button>
                            <button type="button" className="btn btn-ghost" onClick={onPedir}>pedir</button>
                        </>
                    )}
                    {estado === 'terminada' && (
                        <button type="button" className="btn" onClick={onSeguir}>seguir jugando</button>
                    )}
                </div>
            </>
        )
    }
}

export default Naipes
