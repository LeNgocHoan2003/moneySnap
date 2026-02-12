///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsVi extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsVi({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.vi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <vi>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsVi _root = this; // ignore: unused_field

	@override 
	TranslationsVi $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsVi(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'MoneySnap';
	@override String get commonSave => 'Lưu';
	@override String get commonCancel => 'Hủy';
	@override String get commonClose => 'Đóng';
	@override String get commonAdd => 'Thêm';
	@override String get commonDelete => 'Xóa';
	@override String get commonRetry => 'Thử lại';
	@override String get commonOpenSettings => 'Mở Cài đặt';
	@override String get cameraAccessNeeded => 'Cần quyền truy cập camera';
	@override String get cameraPermissionMessage => 'Cần quyền camera để chụp hóa đơn. Vui lòng bật trong Cài đặt.';
	@override String get cameraAlignReceiptHint => 'Căn hóa đơn trong khung';
	@override String get cameraNoCameraFound => 'Không tìm thấy camera';
	@override String get cameraPermissionRequired => 'Cần quyền camera hoặc không khả dụng.';
	@override String cameraCaptureFailed({required Object error}) => 'Chụp thất bại: ${error}';
	@override String cameraError({required Object code}) => 'Lỗi camera: ${code}';
	@override String get cameraReplacePicture => 'Chụp lại';
	@override String get expenseAddExpense => 'Thêm khoản chi';
	@override String get expenseAddDescription => 'Thêm mô tả';
	@override String get expenseAmount => 'Số tiền';
	@override String get expenseAmountSpent => 'Số tiền đã chi';
	@override String get expenseSaveExpense => 'Lưu khoản chi';
	@override String get expenseEnterDescription => 'Nhập mô tả';
	@override String get expenseDescription => 'Mô tả';
	@override String get expenseNumbersOnly => 'Chỉ số';
	@override String get expenseTakeOnePictureFirst => 'Chụp ảnh trước';
	@override String get expenseTapToTakePicture => 'Chạm để chụp 1 ảnh';
	@override String get expenseReplacePicture => 'Thay ảnh';
	@override String get expenseNoExpensesOnDay => 'Không có khoản chi trong ngày';
	@override String get expenseTotal => 'Tổng';
	@override String get expenseRemoveExpenseConfirm => 'Xóa khoản chi này?';
	@override String expenseTransactionCount({required Object count}) => '${count} giao dịch';
	@override String expenseTransactionCountPlural({required Object count}) => '${count} giao dịch';
	@override String expensePercentOfBudget({required Object percent}) => '${percent}% ngân sách';
	@override String expenseExpenseCount({required Object count}) => '${count} khoản chi';
	@override String expenseExpenseCountPlural({required Object count}) => '${count} khoản chi';
	@override String expenseDayDescription({required Object day, required Object description}) => 'Ngày ${day} · ${description}';
	@override String get homeExpenses => 'Khoản chi';
	@override String get homeCalendar => 'Lịch';
	@override String get homeHome => 'Trang chủ';
	@override String get homeStatistics => 'Thống kê';
	@override String get homeSettings => 'Cài đặt';
	@override String homeTabComingSoon({required Object tab}) => '${tab} – Sắp ra mắt';
	@override String get commonWeekdayMon => 'T2';
	@override String get commonWeekdayTue => 'T3';
	@override String get commonWeekdayWed => 'T4';
	@override String get commonWeekdayThu => 'T5';
	@override String get commonWeekdayFri => 'T6';
	@override String get commonWeekdaySat => 'T7';
	@override String get commonWeekdaySun => 'CN';
	@override String get commonWeekdayMonShort => 'T2';
	@override String get commonWeekdayTueShort => 'T3';
	@override String get commonWeekdayWedShort => 'T4';
	@override String get commonWeekdayThuShort => 'T5';
	@override String get commonWeekdayFriShort => 'T6';
	@override String get commonWeekdaySatShort => 'T7';
	@override String get commonWeekdaySunShort => 'CN';
	@override String get errorsNoCamera => 'Không tìm thấy camera';
	@override String get errorsCameraPermission => 'Cần quyền camera hoặc không khả dụng.';
	@override String get errorsEnterDescription => 'Nhập mô tả';
	@override String get settingsAppearance => 'Giao diện';
	@override String get settingsDarkMode => 'Chế độ tối';
	@override String get settingsDarkModeSubtitle => 'Thay đổi giao diện ứng dụng';
	@override String get settingsLanguage => 'Ngôn ngữ';
	@override String get settingsLanguageSubtitle => 'Ngôn ngữ ứng dụng';
	@override String get settingsLanguageEnglish => 'English';
	@override String get settingsLanguageVietnamese => 'Tiếng Việt';
	@override String get commonMonthJanuary => 'Tháng 1';
	@override String get commonMonthFebruary => 'Tháng 2';
	@override String get commonMonthMarch => 'Tháng 3';
	@override String get commonMonthApril => 'Tháng 4';
	@override String get commonMonthMay => 'Tháng 5';
	@override String get commonMonthJune => 'Tháng 6';
	@override String get commonMonthJuly => 'Tháng 7';
	@override String get commonMonthAugust => 'Tháng 8';
	@override String get commonMonthSeptember => 'Tháng 9';
	@override String get commonMonthOctober => 'Tháng 10';
	@override String get commonMonthNovember => 'Tháng 11';
	@override String get commonMonthDecember => 'Tháng 12';
	@override String get expenseAmountHint => '0 đ';
	@override String get expenseTransactionDate => 'Ngày giao dịch';
	@override String get expenseTapToChangeDate => 'Chạm để thay đổi';
	@override String get expenseTransactionTime => 'Giờ';
}

/// The flat map containing all translations for locale <vi>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsVi {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'MoneySnap',
			'commonSave' => 'Lưu',
			'commonCancel' => 'Hủy',
			'commonClose' => 'Đóng',
			'commonAdd' => 'Thêm',
			'commonDelete' => 'Xóa',
			'commonRetry' => 'Thử lại',
			'commonOpenSettings' => 'Mở Cài đặt',
			'cameraAccessNeeded' => 'Cần quyền truy cập camera',
			'cameraPermissionMessage' => 'Cần quyền camera để chụp hóa đơn. Vui lòng bật trong Cài đặt.',
			'cameraAlignReceiptHint' => 'Căn hóa đơn trong khung',
			'cameraNoCameraFound' => 'Không tìm thấy camera',
			'cameraPermissionRequired' => 'Cần quyền camera hoặc không khả dụng.',
			'cameraCaptureFailed' => ({required Object error}) => 'Chụp thất bại: ${error}',
			'cameraError' => ({required Object code}) => 'Lỗi camera: ${code}',
			'cameraReplacePicture' => 'Chụp lại',
			'expenseAddExpense' => 'Thêm khoản chi',
			'expenseAddDescription' => 'Thêm mô tả',
			'expenseAmount' => 'Số tiền',
			'expenseAmountSpent' => 'Số tiền đã chi',
			'expenseSaveExpense' => 'Lưu khoản chi',
			'expenseEnterDescription' => 'Nhập mô tả',
			'expenseDescription' => 'Mô tả',
			'expenseNumbersOnly' => 'Chỉ số',
			'expenseTakeOnePictureFirst' => 'Chụp ảnh trước',
			'expenseTapToTakePicture' => 'Chạm để chụp 1 ảnh',
			'expenseReplacePicture' => 'Thay ảnh',
			'expenseNoExpensesOnDay' => 'Không có khoản chi trong ngày',
			'expenseTotal' => 'Tổng',
			'expenseRemoveExpenseConfirm' => 'Xóa khoản chi này?',
			'expenseTransactionCount' => ({required Object count}) => '${count} giao dịch',
			'expenseTransactionCountPlural' => ({required Object count}) => '${count} giao dịch',
			'expensePercentOfBudget' => ({required Object percent}) => '${percent}% ngân sách',
			'expenseExpenseCount' => ({required Object count}) => '${count} khoản chi',
			'expenseExpenseCountPlural' => ({required Object count}) => '${count} khoản chi',
			'expenseDayDescription' => ({required Object day, required Object description}) => 'Ngày ${day} · ${description}',
			'homeExpenses' => 'Khoản chi',
			'homeCalendar' => 'Lịch',
			'homeHome' => 'Trang chủ',
			'homeStatistics' => 'Thống kê',
			'homeSettings' => 'Cài đặt',
			'homeTabComingSoon' => ({required Object tab}) => '${tab} – Sắp ra mắt',
			'commonWeekdayMon' => 'T2',
			'commonWeekdayTue' => 'T3',
			'commonWeekdayWed' => 'T4',
			'commonWeekdayThu' => 'T5',
			'commonWeekdayFri' => 'T6',
			'commonWeekdaySat' => 'T7',
			'commonWeekdaySun' => 'CN',
			'commonWeekdayMonShort' => 'T2',
			'commonWeekdayTueShort' => 'T3',
			'commonWeekdayWedShort' => 'T4',
			'commonWeekdayThuShort' => 'T5',
			'commonWeekdayFriShort' => 'T6',
			'commonWeekdaySatShort' => 'T7',
			'commonWeekdaySunShort' => 'CN',
			'errorsNoCamera' => 'Không tìm thấy camera',
			'errorsCameraPermission' => 'Cần quyền camera hoặc không khả dụng.',
			'errorsEnterDescription' => 'Nhập mô tả',
			'settingsAppearance' => 'Giao diện',
			'settingsDarkMode' => 'Chế độ tối',
			'settingsDarkModeSubtitle' => 'Thay đổi giao diện ứng dụng',
			'settingsLanguage' => 'Ngôn ngữ',
			'settingsLanguageSubtitle' => 'Ngôn ngữ ứng dụng',
			'settingsLanguageEnglish' => 'English',
			'settingsLanguageVietnamese' => 'Tiếng Việt',
			'commonMonthJanuary' => 'Tháng 1',
			'commonMonthFebruary' => 'Tháng 2',
			'commonMonthMarch' => 'Tháng 3',
			'commonMonthApril' => 'Tháng 4',
			'commonMonthMay' => 'Tháng 5',
			'commonMonthJune' => 'Tháng 6',
			'commonMonthJuly' => 'Tháng 7',
			'commonMonthAugust' => 'Tháng 8',
			'commonMonthSeptember' => 'Tháng 9',
			'commonMonthOctober' => 'Tháng 10',
			'commonMonthNovember' => 'Tháng 11',
			'commonMonthDecember' => 'Tháng 12',
			'expenseAmountHint' => '0 đ',
			'expenseTransactionDate' => 'Ngày giao dịch',
			'expenseTapToChangeDate' => 'Chạm để thay đổi',
			'expenseTransactionTime' => 'Giờ',
			_ => null,
		};
	}
}
