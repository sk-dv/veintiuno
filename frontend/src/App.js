import React, {Component} from 'react'
import {BrowserRouter, Redirect, Route, Switch} from 'react-router-dom'
import './App.css'
import Login from './components/js/Login'
import Start from './components/js/Start'
import Game from './components/js/Game'
import Error404 from './components/js/Error404'

const CLAVE = 'blackjack-partida'

const leerPartida = () => {
    try {
        return JSON.parse(sessionStorage.getItem(CLAVE)) || {}
    } catch (e) {
        return {}
    }
}

const guardarPartida = (partida) => {
    try {
        sessionStorage.setItem(CLAVE, JSON.stringify(partida))
    } catch (e) {
        /* the game still works without storage; it just can't survive a refresh */
    }
}

class App extends Component {

    constructor(props) {
        super(props)

        this.state = {partida: leerPartida()}
    }

    configurarPartida = (idPartida, idJugador, nombre) => {
        const partida = {idPartida, idJugador, nombre}
        guardarPartida(partida)
        this.setState({partida})
    }

    limpiarPartida = () => {
        guardarPartida({})
        this.setState({partida: {}})
    }

    render() {
        const {partida} = this.state

        return (
            <BrowserRouter>
                <Switch>
                    <Route exact path="/" component={Start}/>
                    <Route exact path="/crear" render={() => <Login configurarPartida={this.configurarPartida}/>}/>
                    <Route exact path="/jugar-partida" render={() => (
                        partida.idPartida ? <Game partida={partida} onTerminar={this.limpiarPartida}/> : <Redirect to="/"/>
                    )}/>
                    <Route component={Error404}/>
                </Switch>
            </BrowserRouter>
        )
    }
}

export default App
