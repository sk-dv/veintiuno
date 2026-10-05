# Betting — use cases

Each case has a test in `backend/test/reglas.test.coffee` (`npm test` in `backend`).

| # | Case | Expected |
|---|---|---|
| B1 | Valid bet (1 to credit) | Credit drops by the bet, hand is dealt, state "jugando" |
| B2 | Bet of 0, negative, decimal, text, `true` or a list | Rejected (400), credit untouched |
| B3 | Bet above credit | Rejected (400) |
| B4 | Second bet in the same hand, or bet after the hand ended | Rejected (409) until "Seguir jugando" |
| B5 | Wrong player id / unknown PIN | 403 / 404 |
| B6 | Win, loss, push | +bet, −bet, bet returned |
| B7 | Player blackjack | +1.5×bet, rounded down; dealer blackjack wins; both = push |
| B8 | All-in | Lose → 0 credit, game over; win → double |
| B9 | Credit below 1 after a hand | Game over, saved game cleared |
