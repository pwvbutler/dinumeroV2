# Dinumero

A minimalist iOS habit tracker

<table align="center">
<tr>
<td align="center" valign="middle"><strong>Habit list</strong><br><br><img src="docs/screens/habit-list.svg" alt="Habit list screen" width="260"></td>
<td align="center" valign="middle"><strong>Habit detail</strong><br><br><img src="docs/screens/habit-detail.svg" alt="Habit detail screen" width="260"></td>
</tr>
</table>

## Features

* Custom Habit - Choose the title, length, and colour theme for each habit.

* Minimalist Tracking - Just tap the current day to indicate a complete habit

### Palette

| Role | Swatch | Hex |
|---|---|---|
| Background | ![](docs/swatches/background.svg) | `#0C141F` |
| Text | ![](docs/swatches/text.svg) | `#D8DAE7` |
| Secondary text | ![](docs/swatches/secondary-text.svg) | `#808080` |
| Accent | ![](docs/swatches/accent.svg) | `#E6FFFF` |
| Blue | ![](docs/swatches/blue.svg) | `#18CAE6` |
| Orange | ![](docs/swatches/orange.svg) | `#DF740C` |
| Yellow | ![](docs/swatches/yellow.svg) | `#FFE64D` |
| Green | ![](docs/swatches/green.svg) | `#59E817` |
| Purple | ![](docs/swatches/purple.svg) | `#7D12FF` |

## Requirements

* A device/simulator with iOS > 17

## Build
To compile with Xcode:

```sh
open Dinumero.xcodeproj          # then ⌘R
```

Or from the command line:

```sh
xcodebuild -scheme Dinumero -destination 'generic/platform=iOS Simulator' build
xcodebuild -scheme Dinumero -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Future Features
* Track current streak
* Customise the display to reduce further
* Multiple times per day habits
