Bạn là Senior Flutter Engineer. Hãy viết unit test đầy đủ cho các logic và use case trong project Flutter theo các yêu cầu sau:

MỤC TIÊU:

* Test toàn bộ business logic, use case và repository
* Không test UI
* Không gọi API thật
* Sử dụng mock cho dependency

YÊU CẦU CHUNG:

* Dùng flutter_test
* Dùng mocktail để mock dependency
* Áp dụng pattern Arrange – Act – Assert
* Cover các case:

  * Success
  * Fail
  * Null / empty data
  * Exception

CẤU TRÚC TEST:

* Mỗi file test tương ứng với 1 class
* Tên file: <class_name>_test.dart

CẦN TEST CÁC THÀNH PHẦN:

1. USE CASE

* Test khi repository trả về data thành công
* Test khi repository throw exception
* Test khi input không hợp lệ

2. REPOSITORY

* Mock datasource/API
* Verify:

  * Có gọi đúng method
  * Mapping model đúng
  * Handle error đúng

3. STORE (MobX nếu có)

* Test giá trị khởi tạo
* Test action làm thay đổi state
* Test loading state
* Test error state

FORMAT MONG MUỐN:

* Tạo đầy đủ:

  * Mock class
  * setUp()
  * group()
  * test()

Ví dụ format:

group('LoginUseCase', () {
test('trả về user khi login thành công', () async {
// Arrange

```
// Act

// Assert
```

});
});

INPUT TÔI SẼ CUNG CẤP:

* Use case class
* Repository interface
* Model
* Store (nếu cần test)

OUTPUT MONG MUỐN:

* File test hoàn chỉnh
* Có thể chạy ngay
* Clean code
* Dễ mở rộng
