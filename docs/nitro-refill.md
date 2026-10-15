# Auto Buy Nitro

Optional/default **OFF** toggle in **Pets → Mutation**. This extends the
user-live-confirmed Auto Mutate delivered in `1043562`; it does not replace its
movement, target selection, equip, RPC or cleanup logic.

## Source and activation

Chili V2 lines **54473–54536** check for an owned Nitro consumable, read the
RaceRally shop/Save, compare race tokens with the price, then invoke
`RF/RaceRally/AskBuy` with **`"MutationToken"`** and briefly observe the grant.
The bundled reference and Library are unchanged. N3 also validates the official
shop limit/count and coordinates with its already-existing race shop.

Refill requires all of these:

- Auto Buy Nitro ON, Auto Mutate ON and Nitro selected in Mutations;
- mutation settings settled for the existing three-second configuration window;
- no Nitro MutationConsumable Tool with positive uses in Character/Backpack;
- valid, finite shop price/limit and Save token/purchase data, remaining limit,
  and sufficient conservatively available race tokens.

It does not require Auto Race or the native race-shop checkbox to be ON. It buys
one missing consumable, not a target quantity, and does not require an eligible
egg to exist before refilling (matching Chili's buy-before-target order).
Nothing in this feature buys race tokens, changes race-shop selections or forces
Nitro into the Mutations selection. Existing tokens are spent automatically when
these conditions hold; enable deliberately.

## One shared shop lane

Four bounded insertion sites: controller, compact UI call, mutation-worker tick
and an **AskBuy-only hook** in the existing race `InvokeRace` helper. All other
race remote calls still take their original path. The native five-item buyer
and optional Nitro refill share `Tasks.InvokeRaceShopPurchase`; neither adds a
second worker. A Busy lock is taken before potentially yielding module/Save
reads and released through the outer protected-call cleanup.

Each item has a two-second attempt throttle, including failed reads/affordability.
The adapter rechecks current preferences/cancellation after yielding reads and
before dispatch, uses the exact RemoteFunction name, preserves the original
packed `pcall` return shape and reserves the price against a local token budget.
Unchanged replicated token balances do not make already-reserved tokens spendable
again. Only explicit server `false` refunds a reservation; transport errors or
ambiguous replies do not prove that a purchase failed. Server validation remains
authoritative; local Save reads cannot guarantee server acceptance.

When refill is active, the native Nitro buyer also obeys out-of-stock-only policy.
With refill inactive, native shop selections/stock-buying policy are retained,
subject to the shared affordability/limit checks and pending-grant protection.
Out-of-stock Nitro purchases from either caller set pending **before** dispatch.
A usable Nitro Tool or explicit server `false` clears pending; toggling refill
OFF/ON does not clear it. The refill caller observes accepted grants for up to
1.5 seconds. **The native race caller gets no additional grant-wait loop.**
Other native shop items use their original IDs and never force selections.

Unknown/late grants deliberately remain pending, including while refill is OFF.
If the server never supplies a tool or definite refusal, automatic Nitro buying
can remain blocked for the rest of this hub run. This is a fail-closed tradeoff,
not a purchase-success status: check the actual inventory/tokens and resolve the
server state before restarting the hub. There is no blind timed retry or toggle
reset that could duplicate an unresolved purchase. Other shop items are not
blocked by PendingNitro after the in-flight request returns.

Settings/unload cancel unsent work and stop grant waiting. A sent InvokeServer
cannot be recalled; its lock remains held until it returns. No new movement,
rig, race-drive, priority, farm-toggle or Anti Guard behavior is introduced.

## Validation and live checklist

Run `check_nitro_refill_source.py`, the six prior source checkers, and the full
production Luau compiler. Removing exactly the four Nitro insertions restores
**byte-for-byte** the published `1043562` runtime. Existing reverse-delta proofs
strip Nitro before their historical scopes; the race checker strips **only the
small shop hook**, retaining the old full-race fingerprint. No historical expected
hash was replaced. Library and bundled Chili checksums must remain unchanged.

These are static/compile checks, not Roblox execution, server acceptance or FPS
measurements. The agent has not purchased anything or spent game tokens.

Live-test with a small expendable token balance:

1. OFF: no refill. Auto Mutate OFF or Nitro unselected: no refill either.
2. ON + Auto Mutate/Nitro: an existing usable Nitro Tool prevents buying; empty
   stock buys only if tokens and official limit permit it. Confirm actual token
   change and tool grant, then Auto Mutate's normal use.
3. Insufficient tokens, exhausted official limit, missing data: no request.
4. Native race Auto Buy + Nitro selected: verify coordinated buying rather than
   two out-of-stock requests. Native selections must remain unchanged.
5. Disable/change settings while waiting; verify no unsent continuation. A sent
   request may still complete. Delayed/unknown grant must not cause retry spam.
6. Check race join/finish/leave, normal/Instant farm, mutation movement, respawn
   and unload retain their behavior. User's previous Auto Mutate approval does
   not count as live acceptance of this new shop integration.
