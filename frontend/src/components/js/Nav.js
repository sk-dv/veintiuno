import React, {Component} from 'react'
import {Link} from 'react-router-dom'

const CLAVE = 'blackjack-tema'

const leerTema = () => {
    try {
        return localStorage.getItem(CLAVE) === 'light' ? 'light' : 'dark'
    } catch (e) {
        return 'dark'
    }
}

/** Top bar shared by every screen; also owns the light/dark switch. */
class Nav extends Component {

    constructor(props) {
        super(props)

        this.state = {tema: leerTema()}
    }

    componentDidMount() {
        document.documentElement.dataset.theme = this.state.tema
    }

    cambiarTema = () => {
        const tema = this.state.tema === 'dark' ? 'light' : 'dark'

        document.documentElement.dataset.theme = tema
        try {
            localStorage.setItem(CLAVE, tema)
        } catch (e) {
            /* the theme still changes for this visit */
        }
        this.setState({tema})
    }

    render() {
        const {children} = this.props
        const {tema} = this.state

        return (
            <nav className="nav">
                <Link to="/" className="nav-brand serif">veintiuno</Link>
                <div className="nav-right">
                    {children}
                    <button type="button" className="link-button" onClick={this.cambiarTema}
                            aria-label={tema === 'dark' ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro'}>
                        ◐
                    </button>
                </div>
            </nav>
        )
    }
}

export default Nav
