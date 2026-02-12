///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'MoneySnap'
	String get appTitle => 'MoneySnap';

	/// en: 'Save'
	String get commonSave => 'Save';

	/// en: 'Cancel'
	String get commonCancel => 'Cancel';

	/// en: 'Close'
	String get commonClose => 'Close';

	/// en: 'Add'
	String get commonAdd => 'Add';

	/// en: 'Delete'
	String get commonDelete => 'Delete';

	/// en: 'Retry'
	String get commonRetry => 'Retry';

	/// en: 'Open Settings'
	String get commonOpenSettings => 'Open Settings';

	/// en: 'Camera access needed'
	String get cameraAccessNeeded => 'Camera access needed';

	/// en: 'Camera permission is required to capture receipts. Please enable it in Settings.'
	String get cameraPermissionMessage => 'Camera permission is required to capture receipts. Please enable it in Settings.';

	/// en: 'Align receipt inside the square'
	String get cameraAlignReceiptHint => 'Align receipt inside the square';

	/// en: 'No camera found'
	String get cameraNoCameraFound => 'No camera found';

	/// en: 'Camera permission is required or unavailable.'
	String get cameraPermissionRequired => 'Camera permission is required or unavailable.';

	/// en: 'Capture failed: $error'
	String cameraCaptureFailed({required Object error}) => 'Capture failed: ${error}';

	/// en: 'Camera error: $code'
	String cameraError({required Object code}) => 'Camera error: ${code}';

	/// en: 'Retake'
	String get cameraReplacePicture => 'Retake';

	/// en: 'Add Expense'
	String get expenseAddExpense => 'Add Expense';

	/// en: 'Add description'
	String get expenseAddDescription => 'Add description';

	/// en: 'Amount'
	String get expenseAmount => 'Amount';

	/// en: 'Amount spent'
	String get expenseAmountSpent => 'Amount spent';

	/// en: 'Save expense'
	String get expenseSaveExpense => 'Save expense';

	/// en: 'Enter description'
	String get expenseEnterDescription => 'Enter description';

	/// en: 'Description'
	String get expenseDescription => 'Description';

	/// en: 'Numbers only'
	String get expenseNumbersOnly => 'Numbers only';

	/// en: 'Take one picture first'
	String get expenseTakeOnePictureFirst => 'Take one picture first';

	/// en: 'Tap to take 1 picture'
	String get expenseTapToTakePicture => 'Tap to take 1 picture';

	/// en: 'Replace picture'
	String get expenseReplacePicture => 'Replace picture';

	/// en: 'No expenses on this day'
	String get expenseNoExpensesOnDay => 'No expenses on this day';

	/// en: 'Total'
	String get expenseTotal => 'Total';

	/// en: 'Remove this expense?'
	String get expenseRemoveExpenseConfirm => 'Remove this expense?';

	/// en: '$count transaction'
	String expenseTransactionCount({required Object count}) => '${count} transaction';

	/// en: '$count transactions'
	String expenseTransactionCountPlural({required Object count}) => '${count} transactions';

	/// en: '$percent% of budget'
	String expensePercentOfBudget({required Object percent}) => '${percent}% of budget';

	/// en: '$count expense'
	String expenseExpenseCount({required Object count}) => '${count} expense';

	/// en: '$count expenses'
	String expenseExpenseCountPlural({required Object count}) => '${count} expenses';

	/// en: 'Day $day · $description'
	String expenseDayDescription({required Object day, required Object description}) => 'Day ${day} · ${description}';

	/// en: 'Expenses'
	String get homeExpenses => 'Expenses';

	/// en: 'Calendar'
	String get homeCalendar => 'Calendar';

	/// en: 'Home'
	String get homeHome => 'Home';

	/// en: 'Statistics'
	String get homeStatistics => 'Statistics';

	/// en: 'Settings'
	String get homeSettings => 'Settings';

	/// en: '$tab – Coming soon'
	String homeTabComingSoon({required Object tab}) => '${tab} – Coming soon';

	/// en: 'Mon'
	String get commonWeekdayMon => 'Mon';

	/// en: 'Tue'
	String get commonWeekdayTue => 'Tue';

	/// en: 'Wed'
	String get commonWeekdayWed => 'Wed';

	/// en: 'Thu'
	String get commonWeekdayThu => 'Thu';

	/// en: 'Fri'
	String get commonWeekdayFri => 'Fri';

	/// en: 'Sat'
	String get commonWeekdaySat => 'Sat';

	/// en: 'Sun'
	String get commonWeekdaySun => 'Sun';

	/// en: 'MON'
	String get commonWeekdayMonShort => 'MON';

	/// en: 'TUE'
	String get commonWeekdayTueShort => 'TUE';

	/// en: 'WED'
	String get commonWeekdayWedShort => 'WED';

	/// en: 'THU'
	String get commonWeekdayThuShort => 'THU';

	/// en: 'FRI'
	String get commonWeekdayFriShort => 'FRI';

	/// en: 'SAT'
	String get commonWeekdaySatShort => 'SAT';

	/// en: 'SUN'
	String get commonWeekdaySunShort => 'SUN';

	/// en: 'No camera found'
	String get errorsNoCamera => 'No camera found';

	/// en: 'Camera permission is required or unavailable.'
	String get errorsCameraPermission => 'Camera permission is required or unavailable.';

	/// en: 'Enter description'
	String get errorsEnterDescription => 'Enter description';

	/// en: 'Appearance'
	String get settingsAppearance => 'Appearance';

	/// en: 'Dark mode'
	String get settingsDarkMode => 'Dark mode';

	/// en: 'Change app appearance'
	String get settingsDarkModeSubtitle => 'Change app appearance';

	/// en: 'Language'
	String get settingsLanguage => 'Language';

	/// en: 'App language'
	String get settingsLanguageSubtitle => 'App language';

	/// en: 'English'
	String get settingsLanguageEnglish => 'English';

	/// en: 'Tiếng Việt'
	String get settingsLanguageVietnamese => 'Tiếng Việt';

	/// en: 'January'
	String get commonMonthJanuary => 'January';

	/// en: 'February'
	String get commonMonthFebruary => 'February';

	/// en: 'March'
	String get commonMonthMarch => 'March';

	/// en: 'April'
	String get commonMonthApril => 'April';

	/// en: 'May'
	String get commonMonthMay => 'May';

	/// en: 'June'
	String get commonMonthJune => 'June';

	/// en: 'July'
	String get commonMonthJuly => 'July';

	/// en: 'August'
	String get commonMonthAugust => 'August';

	/// en: 'September'
	String get commonMonthSeptember => 'September';

	/// en: 'October'
	String get commonMonthOctober => 'October';

	/// en: 'November'
	String get commonMonthNovember => 'November';

	/// en: 'December'
	String get commonMonthDecember => 'December';

	/// en: '0 đ'
	String get expenseAmountHint => '0 đ';

	/// en: 'Transaction date'
	String get expenseTransactionDate => 'Transaction date';

	/// en: 'Tap to change'
	String get expenseTapToChangeDate => 'Tap to change';

	/// en: 'Time'
	String get expenseTransactionTime => 'Time';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'MoneySnap',
			'commonSave' => 'Save',
			'commonCancel' => 'Cancel',
			'commonClose' => 'Close',
			'commonAdd' => 'Add',
			'commonDelete' => 'Delete',
			'commonRetry' => 'Retry',
			'commonOpenSettings' => 'Open Settings',
			'cameraAccessNeeded' => 'Camera access needed',
			'cameraPermissionMessage' => 'Camera permission is required to capture receipts. Please enable it in Settings.',
			'cameraAlignReceiptHint' => 'Align receipt inside the square',
			'cameraNoCameraFound' => 'No camera found',
			'cameraPermissionRequired' => 'Camera permission is required or unavailable.',
			'cameraCaptureFailed' => ({required Object error}) => 'Capture failed: ${error}',
			'cameraError' => ({required Object code}) => 'Camera error: ${code}',
			'cameraReplacePicture' => 'Retake',
			'expenseAddExpense' => 'Add Expense',
			'expenseAddDescription' => 'Add description',
			'expenseAmount' => 'Amount',
			'expenseAmountSpent' => 'Amount spent',
			'expenseSaveExpense' => 'Save expense',
			'expenseEnterDescription' => 'Enter description',
			'expenseDescription' => 'Description',
			'expenseNumbersOnly' => 'Numbers only',
			'expenseTakeOnePictureFirst' => 'Take one picture first',
			'expenseTapToTakePicture' => 'Tap to take 1 picture',
			'expenseReplacePicture' => 'Replace picture',
			'expenseNoExpensesOnDay' => 'No expenses on this day',
			'expenseTotal' => 'Total',
			'expenseRemoveExpenseConfirm' => 'Remove this expense?',
			'expenseTransactionCount' => ({required Object count}) => '${count} transaction',
			'expenseTransactionCountPlural' => ({required Object count}) => '${count} transactions',
			'expensePercentOfBudget' => ({required Object percent}) => '${percent}% of budget',
			'expenseExpenseCount' => ({required Object count}) => '${count} expense',
			'expenseExpenseCountPlural' => ({required Object count}) => '${count} expenses',
			'expenseDayDescription' => ({required Object day, required Object description}) => 'Day ${day} · ${description}',
			'homeExpenses' => 'Expenses',
			'homeCalendar' => 'Calendar',
			'homeHome' => 'Home',
			'homeStatistics' => 'Statistics',
			'homeSettings' => 'Settings',
			'homeTabComingSoon' => ({required Object tab}) => '${tab} – Coming soon',
			'commonWeekdayMon' => 'Mon',
			'commonWeekdayTue' => 'Tue',
			'commonWeekdayWed' => 'Wed',
			'commonWeekdayThu' => 'Thu',
			'commonWeekdayFri' => 'Fri',
			'commonWeekdaySat' => 'Sat',
			'commonWeekdaySun' => 'Sun',
			'commonWeekdayMonShort' => 'MON',
			'commonWeekdayTueShort' => 'TUE',
			'commonWeekdayWedShort' => 'WED',
			'commonWeekdayThuShort' => 'THU',
			'commonWeekdayFriShort' => 'FRI',
			'commonWeekdaySatShort' => 'SAT',
			'commonWeekdaySunShort' => 'SUN',
			'errorsNoCamera' => 'No camera found',
			'errorsCameraPermission' => 'Camera permission is required or unavailable.',
			'errorsEnterDescription' => 'Enter description',
			'settingsAppearance' => 'Appearance',
			'settingsDarkMode' => 'Dark mode',
			'settingsDarkModeSubtitle' => 'Change app appearance',
			'settingsLanguage' => 'Language',
			'settingsLanguageSubtitle' => 'App language',
			'settingsLanguageEnglish' => 'English',
			'settingsLanguageVietnamese' => 'Tiếng Việt',
			'commonMonthJanuary' => 'January',
			'commonMonthFebruary' => 'February',
			'commonMonthMarch' => 'March',
			'commonMonthApril' => 'April',
			'commonMonthMay' => 'May',
			'commonMonthJune' => 'June',
			'commonMonthJuly' => 'July',
			'commonMonthAugust' => 'August',
			'commonMonthSeptember' => 'September',
			'commonMonthOctober' => 'October',
			'commonMonthNovember' => 'November',
			'commonMonthDecember' => 'December',
			'expenseAmountHint' => '0 đ',
			'expenseTransactionDate' => 'Transaction date',
			'expenseTapToChangeDate' => 'Tap to change',
			'expenseTransactionTime' => 'Time',
			_ => null,
		};
	}
}
