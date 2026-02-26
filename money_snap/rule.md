# MoneySnap – Cursor Guide (.md)
 **Clean Architecture + MVVM + SOLID + Repository Pattern**.

---

# 🧠 Project Context

**MoneySnap** là ứng dụng Flutter dùng để:

* Chụp ảnh hóa đơn
* Nhập số tiền + mô tả
* Lưu chi tiêu offline
* Quản lý lịch sử chi tiêu

Tech stack:

* Flutter
* MobX (MVVM state management)
* Hive (Local database)
* Image Picker
* Clean Architecture
* SOLID principles

---

# 🏗️ Architecture Rules (IMPORTANT)

Cursor phải tuân thủ:

## Layers

```
Presentation (UI + Store)
Domain (Entity + UseCase + Repository interface)
Data (Model + Datasource + Repository impl)
```

## Dependency Flow (1 chiều)

```
Presentation → Domain → Data
```

Presentation KHÔNG được gọi trực tiếp:

* Hive
* ImagePicker
* Datasource

---

# 📁 Folder Structure

```
lib/
 ├── core/
 │    ├── services/
 │    ├── utils/
 │    └── constants/
 │
 ├── features/
 │    └── expense/
 │         ├── data/
 │         │    ├── datasources/
 │         │    ├── models/
 │         │    └── repositories/
 │         │
 │         ├── domain/
 │         │    ├── entities/
 │         │    ├── repositories/
 │         │    └── usecases/
 │         │
 │         └── presentation/
 │              ├── stores/
 │              ├── screens/
 │              └── widgets/
```

---

# 📦 Coding Rules for Cursor

## Entity rules

* Không import Flutter
* Chỉ chứa dữ liệu thuần

Example:

```dart
class Expense {
  final String id;
  final String imagePath;
  final double amount;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.imagePath,
    required this.amount,
    required this.description,
    required this.date,
  });
}
```

---

## Repository rules

* Domain tạo interface
* Data tạo implementation

```dart
abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<List<Expense>> getExpenses();
  Future<void> deleteExpense(String id);
}
```

---

## UseCase rules

* Mỗi UseCase chỉ làm 1 việc (SRP)

```dart
class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) {
    return repository.addExpense(expense);
  }
}
```

---

## Model rules

* Model extends Entity
* Có toJson/fromJson

---

## Datasource rules

* Chỉ làm việc với Hive
* Không chứa business logic

---

## Store rules (MVVM)

* Store gọi UseCase
* Không gọi Repository trực tiếp
* Không gọi Hive

```dart
abstract class _ExpenseStore with Store {
  final AddExpenseUseCase addExpenseUseCase;

  _ExpenseStore(this.addExpenseUseCase);

  @observable
  List<Expense> expenses = [];

  @action
  Future<void> addExpense(Expense expense) async {
    await addExpenseUseCase(expense);
  }
}
```

---

# 🎯 SOLID Principles Applied

### S – Single Responsibility

* UseCase = 1 action
* Repository = data layer
* Store = state only

### O – Open/Closed

* Có thể thêm CloudRepository sau này

### L – Liskov

* Impl thay thế interface được

### I – Interface Segregation

* Tách datasource theo mục đích

### D – Dependency Inversion

* Store → UseCase → Repository

---

# 📸 Feature Scope

Cursor nên generate code xoay quanh:

* Add expense
* Capture image
* Save offline
* Get expense list
* Delete expense

---

# 📦 Packages

```
mobx
flutter_mobx
hive
hive_flutter
image_picker
path_provider
```

---

# 🚫 Anti-patterns (KHÔNG được làm)

❌ UI gọi Hive trực tiếp
❌ Store chứa business logic lớn
❌ Repository gọi UI
❌ Entity import Flutter

---

# 🧩 Naming Convention

| Type       | Format            | Example               |
| ---------- | ----------------- | --------------------- |
| Entity     | noun              | Expense               |
| Model      | noun + Model      | ExpenseModel          |
| Repository | noun + Repository | ExpenseRepository     |
| Impl       | + Impl            | ExpenseRepositoryImpl |
| UseCase    | verb              | AddExpenseUseCase     |
| Store      | noun + Store      | ExpenseStore          |

---

# 🎯 Goal

Project phải:

* Dễ maintain
* Dễ mở rộng Firebase sau này
* Chuẩn kiến trúc production
* Đủ mạnh để đưa vào CV Junior/Mid
