import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Daum Postcode Search Example'**
  String get appTitle;

  /// No description provided for @webviewSelection.
  ///
  /// In en, this message translates to:
  /// **'Select WebView Library'**
  String get webviewSelection;

  /// No description provided for @webviewFlutterButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Search with webview_flutter'**
  String get webviewFlutterButtonLabel;

  /// No description provided for @webviewFlutterDescription.
  ///
  /// In en, this message translates to:
  /// **'Official Flutter WebView plugin'**
  String get webviewFlutterDescription;

  /// No description provided for @inappWebviewButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Search with flutter_inappwebview'**
  String get inappWebviewButtonLabel;

  /// No description provided for @inappWebviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Third-party WebView with advanced features'**
  String get inappWebviewDescription;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Address Search Results'**
  String get searchResults;

  /// No description provided for @koreanAddress.
  ///
  /// In en, this message translates to:
  /// **'Korean Address'**
  String get koreanAddress;

  /// No description provided for @englishAddress.
  ///
  /// In en, this message translates to:
  /// **'English Address'**
  String get englishAddress;

  /// No description provided for @zipcode.
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// No description provided for @jibunAddress.
  ///
  /// In en, this message translates to:
  /// **'Jibun Address'**
  String get jibunAddress;

  /// No description provided for @jibunAddressEnglish.
  ///
  /// In en, this message translates to:
  /// **'Jibun Address (English)'**
  String get jibunAddressEnglish;

  /// No description provided for @searchButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Address'**
  String get searchButtonLabel;

  /// No description provided for @parsingError.
  ///
  /// In en, this message translates to:
  /// **'Data parsing error: {error}'**
  String parsingError(Object error);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @searchPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Address Search'**
  String get searchPageTitle;

  /// No description provided for @searchPageTitleWebViewFlutter.
  ///
  /// In en, this message translates to:
  /// **'Address Search (webview_flutter)'**
  String get searchPageTitleWebViewFlutter;

  /// No description provided for @searchPageTitleInAppWebView.
  ///
  /// In en, this message translates to:
  /// **'Address Search (flutter_inappwebview)'**
  String get searchPageTitleInAppWebView;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
