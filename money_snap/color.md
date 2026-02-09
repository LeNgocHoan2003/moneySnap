# 🎨 Color Usage Rule – MoneySnap

## Mục tiêu

Đảm bảo toàn bộ app sử dụng màu sắc thống nhất, dễ maintain, dễ đổi theme và tuân thủ Clean Architecture.

**QUY TẮC BẮT BUỘC:**
Không được gọi `Color(...)`, `Colors.red`, `Colors.blue`, `Colors.grey` trực tiếp trong UI.

Tất cả màu phải đi qua **Color Constants**.

---

# 🚫 Không được làm

```dart
Container(
  color: Colors.red,
)

Text(
  'Total',
  style: TextStyle(color: Color(0xFF00AAFF)),
)
```

---

# ✅ Phải làm

```dart
Container(
  color: AppColors.primary,
)

Text(
  'Total',
  style: TextStyle(color: AppColors.textPrimary),
)
```

---

# 📁 Vị trí file màu

```
lib/core/constants/app_colors.dart
```

---

# 📦 Tạo file app_colors.dart

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF2D5BFF);
  static const secondary = Color(0xFF00A86B);

  // Background
  static const background = Color(0xFFF8F9FB);
  static const surface = Color(0xFFFFFFFF);

  // Text
  static const textPrimary = Color(0xFF1C1C1C);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textLight = Color(0xFFFFFFFF);

  // Expense
  static const expense = Color(0xFFE53935);
  static const income = Color(0xFF2E7D32);

  // Border / Divider
  static const border = Color(0xFFE0E0E0);

  // Overlay
  static const overlayDark = Color(0x66000000);
}
```

---

# 📏 Quy tắc sử dụng

## 1) UI Layer

Chỉ dùng:

```
AppColors.*
```

Không dùng:

```
Colors.*
Color(...)
```

---

## 2) Nếu cần opacity

```dart
AppColors.primary.withOpacity(0.1)
```

---

## 3) Nếu cần trạng thái đặc biệt

Thêm vào AppColors, KHÔNG tạo màu mới tại chỗ.

Ví dụ:

```dart
static const error = Color(0xFFD32F2F);
static const warning = Color(0xFFF9A825);
```

---

# 🧠 Naming Convention

| Mục đích  | Tên           |
| --------- | ------------- |
| Màu chính | primary       |
| Màu phụ   | secondary     |
| Nền       | background    |
| Card      | surface       |
| Chữ chính | textPrimary   |
| Chữ phụ   | textSecondary |
| Tiền chi  | expense       |
| Tiền thu  | income        |
| Viền      | border        |

---

# 🎯 Áp dụng trong MoneySnap

## Giá tiền chi

```dart
Text(
  MoneyUtils.formatExpense(total),
  style: TextStyle(
    color: AppColors.expense,
    fontWeight: FontWeight.w600,
  ),
)
```

## Background lịch

```dart
Container(
  color: AppColors.surface,
)
```

## Overlay ảnh

```dart
Container(
  color: AppColors.overlayDark,
)
```

---

# 🚀 Lợi ích

* Đổi theme toàn app trong 1 file
* Không bị lệch màu
* Chuẩn production
* Recruiter đánh giá cao

---

# 🔒 Rule cho team / AI / Cursor

**Bắt buộc tuân thủ:**

1. Không dùng `Colors.*`
2. Không dùng `Color(0x...)` trực tiếp trong widget
3. Mọi màu phải khai báo trong `AppColors`
4. Nếu thiếu màu → thêm vào `AppColors`, không hardcode

---

# Optional (Level up)

Sau này có thể mở rộng:

```
AppColors.light.*
AppColors.dark.*
```

để hỗ trợ Dark Mode mà không cần sửa UI.
