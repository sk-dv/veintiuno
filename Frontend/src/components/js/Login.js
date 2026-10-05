import React, {Component} from 'react'
import {Redirect} from 'react-router-dom'
import swal from 'sweetalert'
import Nav from './Nav'
import {crearPartida} from './Peticiones'
import {nombreOPorDefecto} from './Nombre'

/** Opening this route creates the game with the saved nickname and goes straight to the table. */
class Login extends Component {

    state = {redirect: false, volver: false}

    componentDidMount() {
        const nombre = nombreOPorDefecto()
        crearPartida(nombre).then(({data, error}) => {
            if (error) {
                swal('¡Ops!', error, 'error')
                return this.setState({volver: true})
            }
            this.props.configurarPartida(data.id_partida, data.id_jugador, nombre)
            this.setState({redirect: true})
        })
    }

    render() {
        const {redirect, volver} = this.state
        return (
            <div className="app">
                <Nav/>
                <main className="center-screen"/>
                {redirect && <Redirect to="/jugar-partida"/>}
                {volver && <Redirect to="/"/>}
            </div>
        )
    }
}

export default Login
