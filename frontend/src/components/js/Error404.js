import React from "react"
import {Link} from "react-router-dom"
import Nav from './Nav'

function Error404() {
    return (
        <div className="app">
            <Nav/>
            <main className="center-screen" style={{gap: 20}}>
                <div className="serif" style={{fontSize: 34}}>página no encontrada</div>
                <Link to="/" className="btn">volver al inicio</Link>
            </main>
        </div>
    )
}

export default Error404
