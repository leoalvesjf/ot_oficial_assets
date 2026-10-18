# Melee hit visual: eight runtime directions

User approved the eight-direction animation. Assets are installed locally in `data/things/1525/`; server selection/activation and gameplay verification remain pending. Editor IDs are not runtime IDs. Client already draws ordinary magic effects; no client-side combat calculation or protocol change is required.

Use target position minus attacker position; Tibia Y increases southward.

| Direction | dx | dy | Runtime effect |
|---|---|---|---:|
| North | 0 | negative | 385 |
| East | positive | 0 | 386 |
| South | 0 | positive | 387 |
| West | negative | 0 | 388 |
| Northeast | positive | negative | 389 |
| Southeast | positive | positive | 390 |
| Southwest | negative | positive | 391 |
| Northwest | negative | negative | 392 |

Do not collapse diagonals when both deltas are nonzero. For coincident positions use an explicit logical-facing fallback or omit the effect. Emit exactly one slash at the target position after confirmed basic melee HP damage, after shields, armor, blocks and immunity. Exclude spells (including exori ico), ranged attacks, wands/rods, misses, zero damage, DoT, reflected and secondary/charm hits. Avoid duplicate primary/secondary emission. Preserve blood360/361 and critical173 and attacker metadata for client visibility filtering. Server must validate weapon path/type: ORIGIN_MELEE alone also covers paths that must be excluded. Explicitly validate the custom IDs in the server effect allowlist.

All effects use a64x64 transparent canvas, six60ms phases and one COUNTED playback. Cardinal variants use exact right-angle rotations; diagonals use nearest-neighbor45-degree rotations of the user-reduced editor87 (derived from Elderan71), without antialiasing. Diagonal source bounds fit the canvas. Native editable variants are in the Assets repository `sources/animations/`. Editor88..91 are cardinal editables, not runtime385..388; proposed diagonal editor93..96 do not define protocol IDs.

Client tile rendering draws creatures before top effects on the tile. The effect top flag orders effects and does not rotate them. Gameplay must still verify target anchors, moving and large outfits, all eight directions, visibility filters and one-shot timing. No gameplay activation is claimed by installing assets.

Other server demands: exori con impact384 and requested Knight/EliteKnight availability while preserving Paladin access; exori ico weapon selector362 sword/363 axe/364 club and investigation of the blocking gate. Keep damage, costs and cooldowns unchanged. Shared exori effect10 must remain intact.
