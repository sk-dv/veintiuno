import React from 'react'
import '../css/Card.css'

// Classic pip layouts: [x%, y%] inside the card body (L=0, C=50, R=100)
const L = 0, C = 50, R = 100
const PIPS = {
    2: [[C, 0], [C, 100]],
    3: [[C, 0], [C, 50], [C, 100]],
    4: [[L, 0], [R, 0], [L, 100], [R, 100]],
    5: [[L, 0], [R, 0], [C, 50], [L, 100], [R, 100]],
    6: [[L, 0], [R, 0], [L, 50], [R, 50], [L, 100], [R, 100]],
    7: [[L, 0], [R, 0], [C, 25], [L, 50], [R, 50], [L, 100], [R, 100]],
    8: [[L, 0], [R, 0], [C, 25], [L, 50], [R, 50], [C, 75], [L, 100], [R, 100]],
    9: [[L, 0], [R, 0], [L, 33], [R, 33], [C, 50], [L, 67], [R, 67], [L, 100], [R, 100]],
    10: [[L, 0], [R, 0], [C, 17], [L, 33], [R, 33], [L, 67], [R, 67], [C, 83], [L, 100], [R, 100]],
}

const SIMBOLOS = {c: '♥', d: '♦', p: '♠', t: '♣'}

/** One playing card. Suit code: c=♥ d=♦ p=♠ t=♣; the rest of the code is the rank. */
function Card({value, visible}) {
    if (!visible) return <div className="card"><div className="card-back"/></div>

    const palo = value.charAt(0)
    const valor = value.substring(1)
    const icon = SIMBOLOS[palo]
    const red = palo === 'c' || palo === 'd'
    const pips = PIPS[valor]

    return (
        <div className="card">
            <div className={'card-face' + (red ? ' red' : '')}>
                <div className="card-index">
                    <span className="card-rank">{valor}</span>
                    <span className="card-suit">{icon}</span>
                </div>
                <div className="card-body">
                    {pips ? pips.map(([x, y], i) => (
                        <div key={i} className={'pip' + (y > 50 ? ' pip-flip' : '')}
                             style={{left: x + '%', top: y + '%'}}>{icon}</div>
                    )) : (
                        <div className="face-big">
                            {valor !== 'A' && <span className="face-big-value">{valor}</span>}
                            <span className="face-big-suit">{icon}</span>
                        </div>
                    )}
                </div>
            </div>
        </div>
    )
}

export default Card
