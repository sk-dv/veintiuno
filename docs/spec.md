# veintiuno — Spec

Single-player blackjack against the dealer. This file is the source of truth: the QA agent tests against it.

## Scope

One player vs. the dealer. Multiplayer is out of scope until this works end to end.

## Rules

- Cards: 2–10 face value, J/Q/K = 10, Ace = 11 or 1 (whichever is best without busting).
- Blackjack: Ace + 10-value card on the first two cards. Pays 3:2 (rounded down to a whole credit on odd bets). Beats any other 21.
- Bust: over 21 loses immediately.
- Dealer stands on 17 or more, hits below 17. Hole card stays hidden until the dealer plays.
- Push (same score, or both blackjack): the bet is returned.
- No split, no double down.

## Bets

- Whole numbers only. Minimum 1, maximum the player's credit.
- Only before the hand is dealt.

## Games

- Each player has their own game; games never share state.
- An unknown game pin returns an error and never stops the server.
- Hit and stand are rejected once the hand is over.

## Screen

Home: the number and a play button. Play creates a game and opens the table directly.

Table: Bet → deal → Hit / Stand → result → new hand. No "wait for your turn" message when playing alone.

- The player's name is shown under their cards, defaults to "Jugador", is edited in place and remembered.
- An interactive tutorial (modal) opens on the first game and from "cómo se juega" in the top bar.
- The bet field has no up/down arrows.

## Done when

1. Rule tests pass (Ace math, blackjack, bust, push, payouts).
2. One full hand is played in the browser.
3. The QA agent re-run reports no critical or high issues.

## Order of work

Rules and payouts → separate games → screen → QA re-run.
