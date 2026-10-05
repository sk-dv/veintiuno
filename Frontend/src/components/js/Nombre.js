import React, {useState} from 'react'

const CLAVE = 'blackjack-nombre'
const POR_DEFECTO = 'Jugador'

/** The player's nickname, remembered between visits. Falls back to a default. */
export const leerNombre = () => {
    try {
        return localStorage.getItem(CLAVE) || ''
    } catch (e) {
        return ''
    }
}

export const guardarNombre = (nombre) => {
    try {
        localStorage.setItem(CLAVE, nombre)
    } catch (e) {
        /* the name just won't be remembered */
    }
}

export const nombreOPorDefecto = () => leerNombre().trim() || POR_DEFECTO

/** The player's name under their cards: reads as plain text, edits in place, remembers the change. */
export function NombreEditable({inicial}) {
    const [nombre, setNombre] = useState(inicial)
    const cambiar = (e) => {
        setNombre(e.target.value)
        guardarNombre(e.target.value)
    }
    return (
        <input className="seat-name serif seat-input" value={nombre} maxLength={30} size={Math.max(nombre.length, 6)}
               aria-label="Tu nombre" placeholder="jugador" onChange={cambiar}/>
    )
}
