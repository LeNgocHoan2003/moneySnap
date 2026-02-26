# 📸 MoneySnap – Camera Capture Screen UI Spec (Flutter)

## 🎯 Goal

Build a premium camera capture screen similar to the reference image:

* Fullscreen camera preview
* Centered square scanning frame
* Darkened overlay outside the frame
* Floating top bar
* Locket-style capture button
* Hint text above the shutter

This screen is used to take photos of receipts for expense tracking.

---

## 🧱 Layout Structure (Stack-based)

Use a `Stack` as the root to layer elements:

```
Stack
 ├─ CameraPreview (full screen)
 ├─ Dark gradient overlay (top & bottom)
 ├─ Center square capture frame
 ├─ Top bar (back + title + flash)
 ├─ Hint text
 └─ Bottom controls (gallery + capture + switch camera)
```

---

## 🎥 1) Camera Background

* Fullscreen live camera preview
* Slight blur/dark overlay for readability

Flutter idea:

* `Positioned.fill(child: CameraPreview())`
* Add gradient overlay using `Container + BoxDecoration.gradient`

---

## 🟦 2) Square Capture Frame (Main Focus)

Centered 1:1 ratio frame.

### Style

* Width: 75–85% screen width
* Height: same as width
* Border radius: 20–24
* Border: thin white with low opacity
* Area outside frame: dimmed

### Visual Purpose

Guide user to align the receipt.

### Flutter idea

```
Center(
  child: Container(
    width: size.width * 0.8,
    height: size.width * 0.8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white70, width: 2),
    ),
  ),
)
```

Optional improvement:

* Add shadow glow to feel premium.

---

## 🧭 3) Top Bar (Floating)

Positioned at the top inside SafeArea.

### Layout

```
[ Close ]     Capture Expense     [ Flash ]
```

### Style

* Glassmorphism background
* Rounded pill container
* Semi-transparent black
* White icons/text

### Elements

* Left: Close button (circle)
* Center: Title text
* Right: Flash toggle

### Flutter structure

Use:

* `SafeArea`
* `Padding(horizontal: 16)`
* `Container` with `borderRadius: 30`
* `Row(mainAxisAlignment: spaceBetween)`

---

## 💬 4) Hint Text Bubble

Position: below the square frame.

Text:

```
Align receipt inside the square
```

### Style

* Small rounded pill
* Dark translucent background
* White text
* Soft shadow

### Purpose

Guide first-time users.

---

## 🔘 5) Bottom Controls (Locket-style)

Positioned at the bottom.

### Layout

```
[ Gallery ]   [ BIG CAPTURE BUTTON ]   [ Switch Camera ]
```

### Capture Button (Main Focus)

* Large circular
* White outer ring
* Primary color inner circle
* Soft shadow
* Slight press animation

Size:

* 70–84 px diameter

### Left Button

* Gallery icon
* Small circular glass button

### Right Button

* Switch camera icon
* Same style as gallery

---

## 🌈 6) Visual Design Rules

### Theme

* Use app primary color for:

  * Capture button inner circle
  * Focus accents
* White icons on dark overlay
* Premium iOS-like polish

### Corners

* Use consistent radius: 16–24

### Shadows

* Soft elevation for floating elements

### Spacing

* Top bar margin: 12–16
* Frame to hint text: 12
* Hint to capture button: 16–20
* Bottom padding: 24–32

---

## 🎬 7) Micro Animations (Important)

Add subtle motion for premium feel:

* Capture button:

  * Scale down on press
* Photo taken:

  * Quick white flash overlay
* Bottom sheet:

  * Slide up after capture

---

## 📦 8) After Capture (Next State)

When photo is taken:

* Freeze image in the square frame
* Show bottom sheet:

Contents:

* Square thumbnail
* TextField: "Add description"
* TextField: "Amount"
* Primary button: "Save expense"

---

## 🧩 9) Implementation Notes (Flutter)

Use:

* `Stack` for layering
* `Positioned` for top & bottom UI
* `SafeArea`
* `AnimatedScale` for button press
* `BackdropFilter` for glass effect

Avoid:

* Hard-coded colors → use theme constants
* Complex layouts → keep minimal

---

## 🏁 Result Expectation

UI should feel:

* Clean
* Focused
* Emotional like Locket
* Premium like iOS camera
* Simple enough for daily use

The square frame must be the visual center and the hero of the screen.
