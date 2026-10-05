import React, {Component} from 'react'
import {Link, Redirect} from "react-router-dom"
import swal from 'sweetalert'
import Nav from './Nav'
import Naipes from './Naipes'
import HowToPlay, {tutorialVisto} from './HowToPlay'
import {apostar, pedir, plantarse, reiniciar, verPartida} from './Peticiones'

class Game extends Component {

    constructor(props) {
        super(props)

        this.state = {
            vista: null,
            irMenu: false,
            ayuda: !tutorialVisto()
        }
    }

    componentDidMount() {
        const {partida} = this.props

        verPartida(partida.idPartida).then(({data, error, status}) => {
            if (error) this.avisarError(error, status)
            else this.setState({vista: data})
        })
    }

    /** Runs a server action and shows the new table, or the reason it was rejected. */
    ejecutar = (accion, ...args) => {
        const {partida} = this.props

        return accion(partida.idPartida, partida.idJugador, ...args).then(({data, error, status}) => {
            if (error) return this.avisarError(error, status)

            this.setState({vista: data})

            if (data.estado === 'terminada' && data.credito < 1) {
                swal('¡Ops!', 'Perdiste todo tu crédito', 'error').then(() => this.terminar())
            }
        })
    }

    /** A 404 means the server no longer has this game (it was restarted): go back to the start. */
    avisarError = (error, status) => {
        if (status === 404) {
            return swal('Tu partida ya no existe', 'El servidor se reinició y se perdió la partida. Crea una nueva.', 'info')
                .then(() => this.terminar())
        }
        return swal('¡Ops!', error, 'error')
    }

    terminar = () => {
        this.props.onTerminar()
        this.setState({irMenu: true})
    }

    apostar = (cantidad) => this.ejecutar(apostar, cantidad)
    pedir = () => this.ejecutar(pedir)
    plantarse = () => this.ejecutar(plantarse)
    seguirJugando = () => this.ejecutar(reiniciar)

    render() {
        const {partida} = this.props
        const {vista, irMenu, ayuda} = this.state

        if (irMenu) return <Redirect to="/"/>
        if (!vista) return null

        return (
            <div className="app">
                <Nav>
                    <button type="button" className="link-button" onClick={() => this.setState({ayuda: true})}>cómo se juega</button>
                    <span>pin {partida.idPartida}</span>
                    <span>créditos <strong>{vista.credito}</strong></span>
                    <Link to="/" className="link-button" onClick={this.props.onTerminar}>terminar</Link>
                </Nav>
                <Naipes
                    nombre={partida.nombre}
                    vista={vista}
                    onApostar={this.apostar}
                    onPedir={this.pedir}
                    onPlantarse={this.plantarse}
                    onSeguir={this.seguirJugando}
                />
                {ayuda && <HowToPlay onClose={() => this.setState({ayuda: false})}/>}
            </div>
        )
    }
}

export default Game
