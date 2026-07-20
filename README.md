# veintiuno

Juego de **BlackJack (21) multijugador**. Monorepo con dos partes:

- **Backend/** — Node + Express escrito en **CoffeeScript**. API REST. Usa MongoDB
  **en memoria** (mongodb-memory-server): no necesitas instalar Mongo.
- **Frontend/** — React (Create React App) que consume la API vía Axios.

## Requisitos

- [nvm](https://github.com/nvm-sh/nvm) (para fijar Node 16, versión compatible).
  La versión se toma de `.nvmrc`.

## Puesta en marcha (2 comandos)

```bash
npm run setup   # instala Node 16 + dependencias de raíz, Backend y Frontend
npm run dev     # levanta Backend (:8080) y Frontend (:3000) juntos
```

Luego abre http://localhost:3000

> La primera vez, el Backend descarga el binario de MongoDB en memoria (~1 min).
> Los datos **no persisten** al reiniciar; es intencional para desarrollo local.

## Comandos útiles

| Comando            | Qué hace                                         |
| ------------------ | ------------------------------------------------ |
| `npm run setup`    | Instala todo (una sola vez).                     |
| `npm run dev`      | Levanta back + front a la vez.                   |
| `npm run backend`  | Solo el backend (puerto 8080).                   |
| `npm run frontend` | Solo el frontend (puerto 3000).                  |

## Arquitectura

```
Frontend (React :3000)  --REST/HTTP-->  Backend (Express :8080)  -->  Mongo en memoria
```

El frontend apunta al backend mediante `Frontend/.env` (`REACT_APP_LOCALHOST`).

## Notas

- El código del backend vive en `.coffee`; los `.js` compilados NO se versionan
  (ver `.gitignore`). CoffeeScript es la única fuente de verdad.
- Persistencia real (MongoDB Atlas), despliegue y roadmap: ver el plan de
  desarrollo (Notion).
