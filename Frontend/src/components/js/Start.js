import React from 'react'
import {Link} from 'react-router-dom'
import Nav from './Nav'

function Start() {
    return (
        <div className="app">
            <Nav/>
            <main className="center-screen" style={{paddingBottom: "12vh"}}>
                <div className="hero-number">21</div>
                <Link to="/crear" className="play-btn" aria-label="jugar">
                    <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true"><path d="M8 5.5v13l11-6.5z" fill="currentColor"/></svg>
                </Link>
            </main>
        </div>
    )
}

export default Start
