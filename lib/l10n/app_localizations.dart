import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Tracker'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get navShopping;

  /// No description provided for @navRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get navRecipes;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @notRegistered.
  ///
  /// In en, this message translates to:
  /// **'Not registered yet?'**
  String get notRegistered;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Passwords must be minimum 6 symbols length'**
  String get passwordTooShort;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Passwords must be maximum 100 symbols length'**
  String get passwordTooLong;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myFridge.
  ///
  /// In en, this message translates to:
  /// **'My Fridge'**
  String get myFridge;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get filterExpiring;

  /// No description provided for @filterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterExpired;

  /// No description provided for @fridgeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Fridge is empty'**
  String get fridgeEmpty;

  /// No description provided for @addProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Add products using the button\nat the bottom of the screen'**
  String get addProductsHint;

  /// No description provided for @downloadError.
  ///
  /// In en, this message translates to:
  /// **'Download error'**
  String get downloadError;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name *'**
  String get productName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity *'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date *'**
  String get expiryDate;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @storageLocation.
  ///
  /// In en, this message translates to:
  /// **'Storage location'**
  String get storageLocation;

  /// No description provided for @enterStorageLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter storage location'**
  String get enterStorageLocation;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @categoryDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get categoryDairy;

  /// No description provided for @categoryMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get categoryMeat;

  /// No description provided for @categoryFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get categoryFish;

  /// No description provided for @categoryVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get categoryVegetables;

  /// No description provided for @categoryFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get categoryFruits;

  /// No description provided for @categoryBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get categoryBakery;

  /// No description provided for @categoryDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get categoryDrinks;

  /// No description provided for @categoryFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get categoryFrozen;

  /// No description provided for @categorySnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get categorySnacks;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @locationFridge.
  ///
  /// In en, this message translates to:
  /// **'🧊 Fridge'**
  String get locationFridge;

  /// No description provided for @locationFreezer.
  ///
  /// In en, this message translates to:
  /// **'❄️ Freezer'**
  String get locationFreezer;

  /// No description provided for @locationShelf.
  ///
  /// In en, this message translates to:
  /// **'🗄️ Shelf'**
  String get locationShelf;

  /// No description provided for @locationKitchenCabinet.
  ///
  /// In en, this message translates to:
  /// **'🚪 Kitchen cabinet'**
  String get locationKitchenCabinet;

  /// No description provided for @locationPantry.
  ///
  /// In en, this message translates to:
  /// **'📦 Pantry'**
  String get locationPantry;

  /// No description provided for @locationOther.
  ///
  /// In en, this message translates to:
  /// **'✏️ Other...'**
  String get locationOther;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @markAsUsed.
  ///
  /// In en, this message translates to:
  /// **'Mark as used'**
  String get markAsUsed;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete the product?'**
  String get deleteProduct;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String inDays(int days);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @addedDate.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String addedDate(String date);

  /// No description provided for @recommendedRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recommended recipes'**
  String get recommendedRecipes;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noRecommendationsYet.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet'**
  String get noRecommendationsYet;

  /// No description provided for @addProductsForRecipes.
  ///
  /// In en, this message translates to:
  /// **'Add products to inventory to see recipe recommendations.'**
  String get addProductsForRecipes;

  /// No description provided for @couldNotLoadRecipes.
  ///
  /// In en, this message translates to:
  /// **'Could not load recipes'**
  String get couldNotLoadRecipes;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @matchPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% match'**
  String matchPercent(int percent);

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @addMissing.
  ///
  /// In en, this message translates to:
  /// **'Add missing ({count})'**
  String addMissing(int count);

  /// No description provided for @inFridge.
  ///
  /// In en, this message translates to:
  /// **'✓ In fridge'**
  String get inFridge;

  /// No description provided for @addToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get addToShoppingList;

  /// No description provided for @addedToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'{name} added to shopping list'**
  String addedToShoppingList(String name);

  /// No description provided for @itemsAddedToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'{count} items added to shopping list'**
  String itemsAddedToShoppingList(int count);

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @couldNotLoadRecipe.
  ///
  /// In en, this message translates to:
  /// **'Could not load recipe'**
  String get couldNotLoadRecipe;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String minLabel(int min);

  /// No description provided for @servingsLabel.
  ///
  /// In en, this message translates to:
  /// **'{n} servings'**
  String servingsLabel(int n);

  /// No description provided for @kcalLabel.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal'**
  String kcalLabel(int kcal);

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// No description provided for @clearDone.
  ///
  /// In en, this message translates to:
  /// **'Clear done'**
  String get clearDone;

  /// No description provided for @toBuy.
  ///
  /// In en, this message translates to:
  /// **'To buy ({count})'**
  String toBuy(int count);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done ({count})'**
  String done(int count);

  /// No description provided for @listEmpty.
  ///
  /// In en, this message translates to:
  /// **'List is empty'**
  String get listEmpty;

  /// No description provided for @addItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Add items using the button below'**
  String get addItemsHint;

  /// No description provided for @errorLoadingList.
  ///
  /// In en, this message translates to:
  /// **'Error loading list'**
  String get errorLoadingList;

  /// No description provided for @addToList.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addToList;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item name *'**
  String get itemName;

  /// No description provided for @clearDoneItems.
  ///
  /// In en, this message translates to:
  /// **'Clear done items?'**
  String get clearDoneItems;

  /// No description provided for @clearDoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'All checked items will be removed from the list.'**
  String get clearDoneConfirm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @enterItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter item name'**
  String get enterItemName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @getAlertsBeforeExpiry.
  ///
  /// In en, this message translates to:
  /// **'Get alerts before food expires'**
  String get getAlertsBeforeExpiry;

  /// No description provided for @notifyBeforeExpiry.
  ///
  /// In en, this message translates to:
  /// **'Notify me before expiry'**
  String get notifyBeforeExpiry;

  /// No description provided for @selectOptions.
  ///
  /// In en, this message translates to:
  /// **'Select one or more options'**
  String get selectOptions;

  /// No description provided for @oneDay.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get oneDay;

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{n} days'**
  String nDays(int n);

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected: {days}'**
  String selected(String days);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @productFound.
  ///
  /// In en, this message translates to:
  /// **'Product found'**
  String get productFound;

  /// No description provided for @addToInventory.
  ///
  /// In en, this message translates to:
  /// **'Add to inventory'**
  String get addToInventory;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @productNotInDatabase.
  ///
  /// In en, this message translates to:
  /// **'This product is not in our database'**
  String get productNotInDatabase;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @willBeRemovedFromInventory.
  ///
  /// In en, this message translates to:
  /// **'«{name}» will be removed from the inventory.'**
  String willBeRemovedFromInventory(String name);

  /// No description provided for @storageRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Storage recommendations'**
  String get storageRecommendations;

  /// No description provided for @chooseStorageCondition.
  ///
  /// In en, this message translates to:
  /// **'Choose storage condition:'**
  String get chooseStorageCondition;

  /// No description provided for @applyRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyRecommendation;

  /// No description provided for @skipSetManually.
  ///
  /// In en, this message translates to:
  /// **'Skip, I\'ll set manually'**
  String get skipSetManually;

  /// No description provided for @recommendedDays.
  ///
  /// In en, this message translates to:
  /// **'Recommended: {days}'**
  String recommendedDays(String days);

  /// No description provided for @getTipAfterName.
  ///
  /// In en, this message translates to:
  /// **'Tap 💡 after entering name to get expiry recommendation'**
  String get getTipAfterName;

  /// No description provided for @getStorageRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Get storage recommendation'**
  String get getStorageRecommendation;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysUnit;

  /// No description provided for @locationFridgeShort.
  ///
  /// In en, this message translates to:
  /// **'Fridge'**
  String get locationFridgeShort;

  /// No description provided for @locationFreezerShort.
  ///
  /// In en, this message translates to:
  /// **'Freezer'**
  String get locationFreezerShort;

  /// No description provided for @locationPantryShort.
  ///
  /// In en, this message translates to:
  /// **'Pantry'**
  String get locationPantryShort;

  /// No description provided for @locationRoomShort.
  ///
  /// In en, this message translates to:
  /// **'Room temp'**
  String get locationRoomShort;

  /// No description provided for @stateWhole.
  ///
  /// In en, this message translates to:
  /// **'whole'**
  String get stateWhole;

  /// No description provided for @stateCut.
  ///
  /// In en, this message translates to:
  /// **'cut'**
  String get stateCut;

  /// No description provided for @stateRaw.
  ///
  /// In en, this message translates to:
  /// **'raw'**
  String get stateRaw;

  /// No description provided for @stateCooked.
  ///
  /// In en, this message translates to:
  /// **'cooked'**
  String get stateCooked;

  /// No description provided for @stateOpened.
  ///
  /// In en, this message translates to:
  /// **'opened'**
  String get stateOpened;

  /// No description provided for @stateUnopened.
  ///
  /// In en, this message translates to:
  /// **'unopened'**
  String get stateUnopened;

  /// No description provided for @stateFresh.
  ///
  /// In en, this message translates to:
  /// **'fresh'**
  String get stateFresh;
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
