# Morningstar MC6 Pro Notes

This folder contains the working design for a Morningstar MC6 Pro setup focused on Strymon pedals.

The main structured planning file is [mc6pro_functional_design.json](/Users/scott/Sites/morningstar/prototype/mc6pro_functional_design.json).

There is also a clickable planning mockup at [mc6_layout_mockup.html](/Users/scott/Sites/morningstar/prototype/mc6_layout_mockup.html). It is a human-facing web representation of the current MC6 layout plus a few proposed multi-page bank ideas, especially for RC-500.

## Current Scope

Version 1 is focused on:

- Strymon Flint
- Strymon EC-1
- Strymon Deco Doubler
- Four core sound levels for the main effect families

The current four-level vocabulary is:

- `Light`
- `Medium`
- `Medium Heavy`
- `Heavy`

For now, `Medium` is treated as the default for most pedals and functions unless noted otherwise.

## MIDI Channel Plan

The current agreed MIDI channel plan is:

- `1` = Ableton
- `2-5` = reserved for future Ableton or software control
- `6` = Flint
- `7` = EC-1
- `8` = Deco
- `9` = RC-500 looper channel
- `10+` = future hardware expansion

Notes:

- Flint reverb and tremolo share channel `6` because they are two sides of one pedal.
- Starting the hardware pedals at channel `6` keeps channels `1-5` open for software routing.

## Controller Layout Rules

To reduce getting lost while navigating:

- The `3rd switch` on every visible page is `Tap Tempo`
- The `6th switch` on every visible page is the right-side navigation switch

Examples:

- Page 1: `C = Tap`, `F = Back / Home`
- Page 2: `I = Tap`, `L = Back / Home`
- Page 3: `O = Tap`, `R = Back / Home`
- Page 4: `U = Tap`, `X = Back / Home`

This leaves four variable slots per page for pedal or song functions.

Back / Home behavior:

- `Release` = go back using Morningstar's `Last used Bank Only` behavior
- `Long hold` = jump to global `Home`
- On non-home pages, the current generated file copies the latest manually verified Back/Home encoding from the Delay page in [Morningstar_MC6PRO_All_Banks_Backup_20260315_185523.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/Morningstar_MC6PRO_All_Banks_Backup_20260315_185523.json)
- Morningstar `Bank Jump` on `Long Press` executes when the switch is released, so it can feel like `Long Press Release`; that appears to be expected behavior rather than a bad export
- In the generated JSON, the Home buttons are templated at the generator level through one shared helper, not copied by hand
- Tap buttons now use the plain label `Tap`
- Back buttons now use the literal label `\- Back`

## Page Colors

The generated backup now uses page-level background colors to show context:

- `Home` uses `2` (`blue`)
- `Ableton` uses `49` (`darkkhaki`)
- `Songs` uses `127`
- `Pedals` uses `8` (`orange`)
- `RC500` uses `2` (`blue`)
- `Ableton Guitar` and `Ableton Voice` use `39`
- `Reverb` uses `39` (`teal`)
- `Tremolo` uses `58` (`darkred`)
- `Delay` uses `61` (`palevioletred`)
- `Doubler` uses `4` (`yellow`)

Pedals entry buttons should mirror the destination effect page color:

- `Reverb` entry button = `39`
- `Tremolo` entry button = `58`
- `Delay` entry button = `61`
- `Doubler` entry button = `4`

## Omniport Plan

The current MC6 Pro omniport configuration should be treated as part of the baseline controller setup:

- `Omniport 1` = `Expression`
- `Omniport 2` = `MIDI Out - Type A (Standard)`
- `Omniport 3` = `MIDI Out - Type A (Standard)`
- `Omniport 4` = `MIDI Out - Type A (Standard)`

The generator now preserves that layout explicitly, based on the re-exported Morningstar backup after those settings were adjusted in the editor.

Relay note:

- `Relay Port A / Relay 1` is now treated as the tap output for the JHS Unicorn-style tempo input
- The universal `Tap` buttons send Morningstar `Relay Sync Clock 8 Taps` to `Relay Port A Tip`

## Pedal Strategy

### Flint

- Use `CC macros` for live independent control of `Reverb` and `Tremolo`
- Use `Program Change` only for full-scene recalls like `Home`, `All Defaults`, or `Songs`
- Preferred reverb voice: `70s Plate`
- Preferred tremolo voice: `63 Tube`
- The live Flint scene buttons use true two-position controller toggles so the selected level can stay visually marked on the MC6
- The generated file enables remembered preset toggles and uses Toggle Reset Groups for the Flint banks so navigation switches do not clear the selected strip
- Position 1 sends the chosen sound macro
- Position 2 explicitly bypasses that Flint side
- The Tremolo bank now uses slot `A` as a Message Scroll preset labeled `Div %G`
- The Tremolo bank scroll order is `1 = 1/4`, `2 = 1/8`, `3 = Triplet`, `4 = 1/16`
- Tremolo scene buttons now occupy `B = Light`, `D = Medium`, and `E = Heavy`

This is necessary because a Flint preset recall changes both sides together.

### Delay

- Use `Program Change` for the main delay sounds
- Reserve EC-1 presets `1-16` for MC6 use
- Use `1-4` now for the core sounds
- `1 = Light`
- `2 = Medium`
- `3 = Medium Heavy`
- `4 = Heavy`
- Leave `5-16` open for future custom presets

This is simpler than Flint because EC-1 is a single effect.

The generated delay buttons now behave as:

- Position 1 = recall the chosen delay preset and explicitly engage the pedal
- Position 2 = explicitly bypass the pedal
- `Long hold` on the `Delay` button in `Pedals` now jumps to `Delay Manual`

Additional EC-1 rule:

- `Delay Slapback` now sends `CC63 = 0` on Position 1 so MIDI Clock follow is off
- `Delay Slapback` sends `CC63 = 127` on Position 2 so clock follow is restored when the toggle is turned off
- `Delay Medium`, `Delay Med Heavy`, and `Delay Heavy` each send `CC63 = 127` on Position 1 so selecting another delay sound restores clock follow
- The universal `Tap` buttons no longer send direct `CC93` tap to the EC-1
- Tap now updates the MC6 internal MIDI clock instead, so clock-following delay presets move with tempo while `Delay Slapback` can stay fixed

### RC-500

- `RC500` is now a dedicated looper bank that started as a MIDI wiring test and is now moving toward real live use
- Access path: `Home -> RC500`
- The current generated RC500 bank uses display bank `58`
- Page 1 currently uses:
- `A = Tmp -`
- `B = Tmp +`
- `C = Tap`
- `D = Arm`
- `E = Start`
- `F = Back`
- MIDI clock itself is channel-free, but the RC-500 preset and CC buttons assume the looper is set to receive on channel `9`
- `Tmp -` and `Tmp +` are momentary tempo nudges:
- short press changes by `1 BPM`
- they now use the exact working Morningstar utility-style message from the April 2 backup instead of RC-500 CC assigns
- `Tap` is the same global tap macro used elsewhere on the controller
- `Arm` is a true toggle: Position 1 arms rhythm, Position 2 unarms it
- `Start` is a separate transport toggle: Position 1 starts transport, Position 2 stops it
- The RC500 bank expression preset sends `CC26` on channel `9` for click volume control
- The generated `Arm` and `Start` buttons still send Boss-style momentary CC pulses: `127` followed by `0`
- RC-500 ASSIGN settings are memory-specific, so if one memory ignores these buttons, copy or save the ASSIGN template into that memory

Suggested RC-500 ASSIGN map for the current generated bank:

- `CC20` -> `RHYTHM PLAY`
- `CC21` -> `RHYTHM STOP`
- `CC22` -> transport `START/STOP` style target
- `CC26` -> `RHYTHM LEV2`

Recommended RC-500 settings for this bank:

- `SYNC CLOCK = MIDI` or `AUTO`
- choose a `RHYTHM PATTERN` that behaves as your click, such as one of the metronome patterns
- for the CC-based controls, set `SRC MODE = MOMENTARY` on the RC-500 ASSIGN entries
- enable the RC-500 ASSIGNs above so the generated `Arm` and `Start` buttons work as intended
- `Tmp -` and `Tmp +` now change the MC6 clock directly, so they do not need RC-500 ASSIGN targets
- the RC500 bank expression preset sends `CC26` on channel `9`, so assigning `CC26 -> RHYTHM LEV2` lets the MC6 expression pedal control click volume

### Proposed Delay Manual Bank

If you want a dedicated `Delay Manual` bank later, the cleanest version is:

- Page 1:
- `A = Mix %G` scroll
- `B = Repeats %G` scroll
- `C = Tap`
- `D = Age %G` scroll
- `E = Mech %G` scroll
- `F = Back / Home`

- Page 2:
- `G = RecLvl %G` scroll
- `H = Preamp %G` scroll
- `I = Tap`
- `J = Div %G` scroll
- `K = Prst %F0` preset scroll
- `L = Back / Home`

Recommended scroll jobs:

- `Mix` = a short musical range from dry-ish to fairly wet
- `Repeats` = short range from one slap to more sustaining repeats
- `Age` = cleaner to darker / older tape
- `Mechanics` = stable to more warble / machine texture
- `Rec Level` = `Low`, `Med`, `High`
- `Preamp` = `Voice A`, `Voice B`, `Boost On`, `Boost Off`
- `Div` = `1/4`, `dotted 8th`, `1/8`, `triplet`
- `Prst %F0` = a bounded PC scroll through a curated preset range, ideally `1-16`

Expression note for a future `Delay Manual` bank:

- Because the current MC6 expression setup is bank-wide, one manual page should only have one expression job at a time
- If you want expression in a manual workflow, the best pattern is separate sub-pages like `Delay Mix`, `Delay Repeats`, `Delay Age`, and `Delay Mechanics`, each with its own expression assignment on Omniport 1
- For a first pass, `Delay Manual` should probably stay button-and-scroll based, while the normal `Delay` bank keeps expression on `Mix + Repeats`

Important EC-1 constraint:

- `Dry Mode` (`Digital`, `Analog`, `Kill Dry`) and `Spillover` are global EC-1 settings, not normal live MIDI-scrolled parameters
- They should be treated as pedal setup choices rather than part of the live `Delay Manual` bank

Current generated implementation:

- `Delay Manual` is now its own bank
- `Delay More` is now a second bank for the discrete options
- `Long hold` on the `Delay` button from `Pedals` jumps to `Delay Manual`
- `Long hold` on `Mech %G` inside `Delay Manual` jumps to `Delay More`
- `Back` from `Delay More` returns to `Delay Manual`

## Expression

The current generated file uses controller-side expression on `Omniport 1`, on a per-bank basis:

- `Reverb` bank expression = Flint `Mix` and `Decay`
- `Tremolo` bank expression = Flint `Intensity`
- `Delay` bank expression = EC-1 `Mix` and `Repeats`
- `Doubler` bank expression = Deco `Lag Time`, `Blend`, and `Wobble`

This means expression behavior changes automatically when you enter a different pedal bank, without needing separate expression-selection presets for v1.

Current musical intent:

- `Reverb` is tuned so the treadle feels biggest on `Heavy`, moving from a large plate into a much bigger ambient wash
- `Tremolo` is tuned so `Heavy` can go from a solid pulse to a very deep throb, with a slight level lift
- `Delay` is tuned so `Heavy` blooms into a wetter, more repeat-heavy lead texture
- `Doubler` is tuned as the most dramatic expression page, moving from width into a more obvious ADT / woozy double feel

Important note:

- This expression behavior is currently `bank-wide`, not per individual level button
- In practice that means the ranges are tuned to shine on the heavier sounds, but they will still affect the lighter sounds on the same bank

## Visual Theme

Effect level buttons now share one style system across `Reverb`, `Tremolo`, and `Delay`:

- `Light` background = `5`
- `Medium` background = `44`
- `Medium Heavy` background = `46`
- `Heavy` background = `3`
- level-button text color = `7` (`white`)
- effect off strip color = `9` (`red`)
- effect on strip color = `1` (`lime`)

Navigation button styling:

- `Tap` = tan background `34`, black text `0`, lime strip `1`, label `Tap`
- `Back` = green background `28`, white text `7`, label `\- Back`
- `Home` uses the same green/white styling on the Home page

## Always On

Start tracking pedals or sounds that should normally stay engaged:

- `Delay Slapback` is the first current `always on` sound

### Deco

- Current V1 focus is the `Doubler` side only
- `Doubler` uses pedal-stored presets recalled with `Program Change`
- The current generated bank uses `PC 1-4` for `Light`, `Medium`, `Medium Heavy`, and `Heavy`
- Position 1 recalls the chosen Doubler preset, forces the overall Deco path on with `CC33 = 127`, and then explicitly turns the `Doubletracker` side on with `CC16 = 127`
- Position 2 explicitly turns the `Doubletracker` side off with `CC16 = 0`
- `Long hold` on the same Doubler button sends `CC97 = 127` for `Auto-Flange`
- `Long hold release` on the same Doubler button sends `CC97 = 0` so the flange drops out when the hold ends
- The current expression pass also adds `Wobble` to the Doubler bank so the treadle can move from subtle widening toward a more animated and strange double effect

### Deco Tape

- `Tape` is now a dedicated live-control bank
- Access path: `Pedals -> long hold Doubler`
- The current generated Tape bank uses side-specific Deco `CC` macros instead of preset recall, so Tape changes can stay independent from Doubler
- `Light`, `Medium`, and `Heavy` explicitly force the overall Deco path on with `CC33 = 127` and then turn the Tape side on with `CC10 = 127`
- Toggle-off uses `CC10 = 0`, so it only disables the Tape side
- `Mode %G` currently scrolls between `Classic` and `Cassette`
- Tape expression currently uses `Saturation + Tone`

Tremolo division note:

- The current `Div %G` scroll preset changes Flint tap subdivision messages, but that may not produce an obvious change with the current rig because Flint is still using `Remote Tap` rather than following MIDI clock directly
- If we want a scroll that is immediately obvious in the current setup, `Trem Type` is probably a better candidate than `Div`

## Bank Philosophy

The current generated test layout uses a contextual hierarchy:

- global or contextual home pages in the low bank numbers
- deeper pedal or function pages higher up
- room left for future hidden macro or library banks later

Current contextual bank map in the generated test file:

- Display `1` = `Home`
- Display `2` = `Ableton`
- Display `3` = `Pedals`
- Display `4` = `Songs`
- Display `11` = `Ableton Guitar`
- Display `12` = `Ableton Voice`
- Display `51` = `Reverb`
- Display `52` = `Tremolo`
- Display `53` = `Delay`
- Display `54` = `Doubler`
- Display `55` = `Delay Manual`
- Display `56` = `Delay More`
- Display `57` = `Tape`
- Display `58` = `RC500`

This creates a navigation flow like:

- `Home -> Ableton -> Guitar Looper or Voice Looper`
- `Home -> Pedals -> Reverb or Tremolo or Delay or Doubler`
- `Home -> Pedals -> Delay (long hold) -> Delay Manual -> Delay More`
- `Home -> Pedals -> Doubler (long hold) -> Tape`
- `Home -> RC500`
- `Home -> Songs`

Future hidden or utility banks can still live higher up later if we want reusable macro libraries.

## Songs

Song presets should be explicit and deterministic.

That means a song preset should:

- set the Flint state it needs
- call the EC-1 preset it needs
- set the Deco state it needs
- send tempo if needed

If a pedal should remain at its default sound, the song should explicitly call that default rather than relying on previous pedal state.

## Toggle Lessons

These are the main Morningstar toggle lessons learned so far and should be treated as durable implementation notes for both humans and future AI edits:

- `Pos: Both` does not create a true on/off toggle by itself. It only sends the same message in both toggle positions.
- To make a preset behave as a real toggle, `Toggle Mode` must be on and the messages must be split between `Position 1` and `Position 2`.
- For scene-style sound buttons, `Position 1` should be the explicit `on / selected` macro.
- `Position 2` should explicitly undo or bypass what `Position 1` turned on.
- For the current Strymon setup:
- Flint Reverb buttons use `Position 2 -> CC16 = 0`
- Flint Tremolo buttons use `Position 2 -> CC10 = 0`
- Delay buttons use `Position 2 -> CC102 = 0`
- For Delay, `Position 1` should not rely on preset recall alone. It is safer to recall the preset and explicitly send engage.
- Remembered preset toggles should stay enabled in controller settings if we want the MC6 to keep showing active state when moving between banks.
- Bank-level `Clear Preset Toggles` is not suitable for these effect banks because pressing non-toggle switches like `Tap` or `Back` can clear the remembered strip state.
- Use Toggle Reset Groups instead so only the level buttons clear each other.
- Future Home or Main page bank presets should be treated separately from navigation. If a navigation button should not trigger destination-bank preset messages, the Bank Jump must use the ignore-presets variant.
- For this project, the current visual toggle convention is `LED off = 9 red` and `LED on = 1 lime`, based on the manually adjusted Reverb Light sample in the latest backup.
- The current effect-button background convention is `Light = 5`, `Medium = 44`, `Med Heavy = 46`, `Heavy = 3`, with white text.

## Preset Export Workflow

This folder currently includes a Flint preset export:

- [1 Preset 1 (1).syx](/Users/scott/Library/CloudStorage/Dropbox/morningstar/1%20Preset%201%20%281%29.syx)

That file confirms we can inspect Flint preset data exported from Strymon.

Important note:

- exported Strymon preset values are useful reference data
- they are not always a direct 1:1 copy of the exact CC values we will send from the MC6

## Other Files

- [Morningstar_MC6PRO_Contextual_V1_Test_20260314.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/Morningstar_MC6PRO_Contextual_V1_Test_20260314.json)
- [Morningstar_MC6PRO_All_Banks_Backup_20260315_185523.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/Morningstar_MC6PRO_All_Banks_Backup_20260315_185523.json)
- [Morningstar_MC6PRO_All_Banks_Backup_20260314_175939.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/Morningstar_MC6PRO_All_Banks_Backup_20260314_175939.json)
- [build_mc6_v1_test.rb](/Users/scott/Library/CloudStorage/Dropbox/morningstar/build_mc6_v1_test.rb)
- [flint_cc_test_macros.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/flint_cc_test_macros.json)
- [Morningstar_MC6PRO_All_Banks_Backup_20260314_094139.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/Morningstar_MC6PRO_All_Banks_Backup_20260314_094139.json)
- [MorningstarEngineering_Editor_Profile.json](/Users/scott/Library/CloudStorage/Dropbox/morningstar/MorningstarEngineering_Editor_Profile.json)

## Next Steps

The most useful next implementation step is:

- test the contextual bank layout in the generated backup file and adjust naming, jumps, and Flint CC values by ear

After that:

- add Deco
- add Songs
- add custom presets beyond the core 4 levels
