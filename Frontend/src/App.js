import React, {Component} from 'react'
import {BrowserRouter, Route, Switch} from 'react-router-dom'
import 'materialize-css/dist/css/materialize.min.css'
import './App.css'
import Login from './components/js/Login'
import Start from './components/js/Start'
import Game from './components/js/Game'
import Error404 from './components/js/Error404'

class App extends Component {

    constructor(props) {
        super(props);

        this.state = {
            idPartida: "",
            idJugador: "",
            nombre: "",
            jugador: {},
            croupier: {}
        }
    }

    configurarVistaJugador = (idPartida, idJugador, nombre, jugador, croupier) => {
        this.setState({
            idPartida: idPartida,
            idJugador: idJugador,
            nombre: nombre,
            jugador: jugador,
            croupier: croupier
        })
        return jugador !== {} && croupier !== {}
    }


    render() {
        let loginProps = {
            configurarVistaJugador: this.configurarVistaJugador,
        }, gameProps = {
            game: this.state
        }

        return (
            <>
                <BrowserRouter>
                    <Switch>
                        <Route exact path="/" component={Start}/>
                        <Route exact
                               path="/crear"
                               render={() => <Login {...loginProps}/>}
                        />
                        <Route exact
                               path="/jugar-partida"
                               render={() => <Game {...gameProps}/>}
                        />
                        <Route component={Error404}/>
                    </Switch>
                </BrowserRouter>
            </>
        );
    }
}

export default App
