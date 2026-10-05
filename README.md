# veintiuno

Single-player blackjack (21) against the dealer. Monorepo:

- **Backend/** — Node + Express in **CoffeeScript**. REST API; games live in memory (no database).
- **Frontend/** — React (Create React App), talks to the API with Axios.

## Run it

Needs [nvm](https://github.com/nvm-sh/nvm); the Node version comes from `.nvmrc` (16).

```bash
npm run setup   # installs Node 16 and all dependencies (once)
npm run dev     # Backend :8080 + Frontend :3000
```

Open http://localhost:3000. Games are lost when the Backend restarts; that is intentional.

## Commands

| Command            | What it does                                   |
| ------------------ | ---------------------------------------------- |
| `npm run setup`    | Installs everything (`scripts/setup.sh`).      |
| `npm run dev`      | Starts Backend and Frontend together.          |
| `npm run backend`  | Backend only.                                  |
| `npm run frontend` | Frontend only.                                 |
| `npm --prefix Backend test` | Runs the rule tests.                  |

## How it fits together

```
Frontend (React :3000)  --REST-->  Backend (Express :8080)  -->  games in memory
```

The Frontend finds the API through `Frontend/.env` (`REACT_APP_LOCALHOST`).

- Pressing play creates a game; the player's name is edited on the table and remembered.
- The interactive tutorial opens on the first game and from "cómo se juega" in the top bar.
- Backend source is `.coffee`; compiled `.js` is not versioned (see `.gitignore`).

## Docs

- [`docs/spec.md`](docs/spec.md) — rules, bets and screen flow; the source of truth for QA.
- [`docs/bet-use-cases.md`](docs/bet-use-cases.md) — bet and payout cases.
