import React, {useState} from 'react'
import Card from './Card'

const VALOR = {A: 11, K: 10, Q: 10, J: 10}
const puntos = (cartas) => {
    let total = 0, ases = 0
    cartas.forEach(c => {
        const v = c.substring(1)
        total += VALOR[v] || Number(v)
        if (v === 'A') ases++
    })
    while (total > 21 && ases-- > 0) total -= 10
    return total
}

const Mano = ({cartas}) => (
    <div className="demo-hand" style={{'--cw': '64px'}}>
        {cartas.map((c, i) => <Card key={i} value={c} visible/>)}
    </div>
)

// Step 1: tap a card to see what it is worth
function Valores() {
    const cartas = [['p7', '7 vale 7'], ['cK', 'J, Q y K valen 10'], ['dA', 'El As vale 11, o 1 si te pasarías']]
    const [nota, setNota] = useState('Toca una carta')
    return (
        <>
            <div className="demo-hand" style={{'--cw': '64px'}}>
                {cartas.map(([c, texto]) => (
                    <button key={c} className="demo-tap" onClick={() => setNota(texto)}>
                        <Card value={c} visible/>
                    </button>
                ))}
            </div>
            <p className="demo-note">{nota}</p>
        </>
    )
}

// Step 2: a tiny hand against a fixed deck
function TuTurno() {
    const MAZO = ['t4', 'cK']
    const [mano, setMano] = useState(['p9', 'd5'])
    const [fin, setFin] = useState(false)
    const total = puntos(mano)
    const perdiste = total > 21
    const pedir = () => {
        const nueva = [...mano, MAZO[mano.length - 2]]
        setMano(nueva)
        if (puntos(nueva) > 21) setFin(true)
    }
    const nota = perdiste ? `${total}: te pasaste de 21 y pierdes.`
        : fin ? `Te plantas con ${total}.` : `Llevas ${total}. ¿Pides otra o te plantas?`
    return (
        <>
            <Mano cartas={mano}/>
            <p className="demo-note">{nota}</p>
            <div className="demo-actions">
                {!fin && mano.length < 4 && <button className="btn btn-ghost" onClick={pedir}>pedir</button>}
                {!fin && <button className="btn btn-ghost" onClick={() => setFin(true)}>plantarse</button>}
                {fin && <button className="btn btn-ghost" onClick={() => {setMano(['p9', 'd5']); setFin(false)}}>otra vez</button>}
            </div>
        </>
    )
}

// Step 3: the dealer draws on its own until 17
function Dealer() {
    const MAZO = ['c6', 't5', 'p4', 'd3']
    const [n, setN] = useState(2)
    const mano = MAZO.slice(0, n)
    const total = puntos(mano)
    const planta = total >= 17
    return (
        <>
            <Mano cartas={mano}/>
            <p className="demo-note">{planta ? `${total}: el dealer se planta.` : `${total}: menos de 17, el dealer pide.`}</p>
            <div className="demo-actions">
                {planta
                    ? <button className="btn btn-ghost" onClick={() => setN(2)}>otra vez</button>
                    : <button className="btn btn-ghost" onClick={() => setN(n + 1)}>siguiente carta</button>}
            </div>
        </>
    )
}

// Step 4: blackjack and payouts
function Pagos() {
    return (
        <>
            <Mano cartas={['dA', 'pK']}/>
            <p className="demo-note">
                Blackjack: As + 10 con tus dos primeras cartas. Paga 3 a 2.<br/>
                Ganas lo apostado. Si empatas, te lo devuelven.
            </p>
        </>
    )
}

const PASOS = [
    {titulo: 'Las cartas', meta: 'Suma más que el dealer sin pasarte de 21.', Demo: Valores},
    {titulo: 'Tu turno', meta: 'Pide cartas o plántate.', Demo: TuTurno},
    {titulo: 'El dealer', meta: 'Pide hasta llegar a 17.', Demo: Dealer},
    {titulo: 'Los pagos', meta: 'Así se gana.', Demo: Pagos},
]

const CLAVE = 'blackjack-tutorial'

/** True once the player has closed the tutorial at least once. */
export const tutorialVisto = () => {
    try {
        return localStorage.getItem(CLAVE) === '1'
    } catch (e) {
        return true
    }
}

const marcarVisto = () => {
    try {
        localStorage.setItem(CLAVE, '1')
    } catch (e) {
        /* it just shows again next visit */
    }
}

/** Interactive tutorial in a modal. The parent decides when it is mounted. */
function HowToPlay({onClose}) {
    const [paso, setPaso] = useState(0)
    const {titulo, meta, Demo} = PASOS[paso]
    const cerrar = () => {
        marcarVisto()
        onClose()
    }
    return (
        <div className="modal-backdrop" onClick={cerrar}>
            <div className="modal how-to-play" role="dialog" aria-label="Cómo se juega"
                 onClick={(e) => e.stopPropagation()}>
                <button className="modal-close" aria-label="Cerrar" onClick={cerrar}>×</button>
                <div className="how-dots">
                    {PASOS.map((p, i) => (
                        <button key={p.titulo} aria-label={p.titulo} className={i === paso ? 'dot on' : 'dot'}
                                onClick={() => setPaso(i)}/>
                    ))}
                </div>
                <h3 className="serif">{titulo}</h3>
                <p className="demo-meta">{meta}</p>
                <Demo key={paso}/>
                <div className="demo-actions">
                    <button className="btn btn-ghost" disabled={paso === 0} onClick={() => setPaso(paso - 1)}>atrás</button>
                    {paso < PASOS.length - 1
                        ? <button className="btn" onClick={() => setPaso(paso + 1)}>siguiente</button>
                        : <button className="btn" onClick={cerrar}>listo</button>}
                </div>
            </div>
        </div>
    )
}

export default HowToPlay
