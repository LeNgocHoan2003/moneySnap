# Prompt: Show Vietnamese Money Suggestions Above Keyboard (Flutter)

You are a senior Flutter engineer.

Build a smart amount input experience for a finance app. When the user types a number into the amount field, show quick suggestion chips above the keyboard with formatted Vietnamese currency values.

## Goal

Create a smooth UX similar to banking apps:

* User types amount
* Suggestions appear above keyboard
* Tap a suggestion → auto fill the amount field

## Behavior

### 1) Input Field

* Numeric keyboard only
* Accept raw numbers (no formatting while typing)
* Example typing:

  * 1 → suggest 1.000đ, 10.000đ, 100.000đ
  * 50 → suggest 50.000đ, 500.000đ, 5.000.000đ
  * 120 → suggest 120.000đ, 1.200.000đ

### 2) Suggestion Bar

Position:

* Fixed above keyboard
* Horizontal scroll row

Style:

* Rounded chips
* Soft background using theme primary color with low opacity
* Bold formatted money text

Example suggestions:

* 10.000đ
* 20.000đ
* 50.000đ
* 100.000đ
* 200.000đ
* 500.000đ

Dynamic suggestions based on user input:

* Multiply current value by:

  * 1.000
  * 10.000
  * 100.000

### 3) Format Rules (Vietnamese Currency)

* Use dot as thousand separator
* Add "đ" suffix
* Examples:

  * 10000 → 10.000đ
  * 1200000 → 1.200.000đ

### 4) Interaction

When user taps a chip:

* Fill TextField with the raw numeric value
* Keep cursor at end
* Optionally format display after focus lost

### 5) Technical Requirements

Use:

* TextEditingController listener
* ValueListenableBuilder / MobX / Stream
* SafeArea(bottom: true)
* Positioned widget above keyboard
* MediaQuery.viewInsets.bottom to detect keyboard height

### 6) UI Structure

```
Column
 ├─ Amount TextField
 ├─ Expanded(content)
 └─ SuggestionBar (visible only when keyboard open)
```

SuggestionBar:

* Height: 48–56
* Horizontal ListView
* Chip spacing: 8px
* Padding: 12–16 horizontal

### 7) Smart Defaults (when empty input)

Show common amounts:

* 10.000đ
* 20.000đ
* 50.000đ
* 100.000đ
* 200.000đ
* 500.000đ

### 8) Extra UX Polish

* Animate chips fade in/out
* Highlight tapped chip briefly
* Keep performance smooth

### 9) Output

Provide:

* Flutter widget structure
* Suggestion generation logic
* Vietnamese money formatter function
* Clean, reusable component (AmountSuggestionBar)
