// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Food Tracker';

  @override
  String get navHome => 'Home';

  @override
  String get navShopping => 'Shopping';

  @override
  String get navRecipes => 'Recipes';

  @override
  String get navSettings => 'Settings';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get notRegistered => 'Not registered yet?';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Passwords must be minimum 6 symbols length';

  @override
  String get passwordTooLong => 'Passwords must be maximum 100 symbols length';

  @override
  String get createAccount => 'Create Account';

  @override
  String get home => 'Home';

  @override
  String get myFridge => 'My Fridge';

  @override
  String get exit => 'Exit';

  @override
  String get add => 'Add';

  @override
  String get total => 'Total';

  @override
  String get expiringSoon => 'Expiring Soon';

  @override
  String get expired => 'Expired';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterExpiring => 'Expiring Soon';

  @override
  String get filterExpired => 'Expired';

  @override
  String get fridgeEmpty => 'Fridge is empty';

  @override
  String get addProductsHint =>
      'Add products using the button\nat the bottom of the screen';

  @override
  String get downloadError => 'Download error';

  @override
  String get repeat => 'Repeat';

  @override
  String get addProduct => 'Add product';

  @override
  String get editProduct => 'Edit product';

  @override
  String get productName => 'Product name *';

  @override
  String get quantity => 'Quantity *';

  @override
  String get unit => 'Unit';

  @override
  String get expiryDate => 'Expiry date *';

  @override
  String get category => 'Category';

  @override
  String get storageLocation => 'Storage location';

  @override
  String get enterStorageLocation => 'Enter storage location';

  @override
  String get notes => 'Notes';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get enterValidQuantity => 'Enter a valid quantity';

  @override
  String get save => 'Save';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get categoryDairy => 'Dairy';

  @override
  String get categoryMeat => 'Meat';

  @override
  String get categoryFish => 'Fish';

  @override
  String get categoryVegetables => 'Vegetables';

  @override
  String get categoryFruits => 'Fruits';

  @override
  String get categoryBakery => 'Bakery';

  @override
  String get categoryDrinks => 'Drinks';

  @override
  String get categoryFrozen => 'Frozen';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get categoryOther => 'Other';

  @override
  String get locationFridge => '🧊 Fridge';

  @override
  String get locationFreezer => '❄️ Freezer';

  @override
  String get locationShelf => '🗄️ Shelf';

  @override
  String get locationKitchenCabinet => '🚪 Kitchen cabinet';

  @override
  String get locationPantry => '📦 Pantry';

  @override
  String get locationOther => '✏️ Other...';

  @override
  String get edit => 'Edit';

  @override
  String get markAsUsed => 'Mark as used';

  @override
  String get delete => 'Delete';

  @override
  String get deleteProduct => 'Delete the product?';

  @override
  String get cancel => 'Cancel';

  @override
  String inDays(int days) {
    return 'In $days days';
  }

  @override
  String get today => 'Today';

  @override
  String addedDate(String date) {
    return 'Added $date';
  }

  @override
  String get recommendedRecipes => 'Recommended recipes';

  @override
  String get refresh => 'Refresh';

  @override
  String get noRecommendationsYet => 'No recommendations yet';

  @override
  String get addProductsForRecipes =>
      'Add products to inventory to see recipe recommendations.';

  @override
  String get couldNotLoadRecipes => 'Could not load recipes';

  @override
  String get retry => 'Retry';

  @override
  String matchPercent(int percent) {
    return '$percent% match';
  }

  @override
  String get ingredients => 'Ingredients';

  @override
  String addMissing(int count) {
    return 'Add missing ($count)';
  }

  @override
  String get inFridge => '✓ In fridge';

  @override
  String get addToShoppingList => 'Add to shopping list';

  @override
  String addedToShoppingList(String name) {
    return '$name added to shopping list';
  }

  @override
  String itemsAddedToShoppingList(int count) {
    return '$count items added to shopping list';
  }

  @override
  String get instructions => 'Instructions';

  @override
  String get couldNotLoadRecipe => 'Could not load recipe';

  @override
  String minLabel(int min) {
    return '$min min';
  }

  @override
  String servingsLabel(int n) {
    return '$n servings';
  }

  @override
  String kcalLabel(int kcal) {
    return '$kcal kcal';
  }

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get clearDone => 'Clear done';

  @override
  String toBuy(int count) {
    return 'To buy ($count)';
  }

  @override
  String done(int count) {
    return 'Done ($count)';
  }

  @override
  String get listEmpty => 'List is empty';

  @override
  String get addItemsHint => 'Add items using the button below';

  @override
  String get errorLoadingList => 'Error loading list';

  @override
  String get addToList => 'Add item';

  @override
  String get itemName => 'Item name *';

  @override
  String get clearDoneItems => 'Clear done items?';

  @override
  String get clearDoneConfirm =>
      'All checked items will be removed from the list.';

  @override
  String get clear => 'Clear';

  @override
  String get enterItemName => 'Enter item name';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get getAlertsBeforeExpiry => 'Get alerts before food expires';

  @override
  String get notifyBeforeExpiry => 'Notify me before expiry';

  @override
  String get selectOptions => 'Select one or more options';

  @override
  String get oneDay => '1 day';

  @override
  String nDays(int n) {
    return '$n days';
  }

  @override
  String selected(String days) {
    return 'Selected: $days';
  }

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App language';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get productFound => 'Product found';

  @override
  String get addToInventory => 'Add to inventory';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get productNotInDatabase => 'This product is not in our database';

  @override
  String get addManually => 'Add manually';

  @override
  String willBeRemovedFromInventory(String name) {
    return '«$name» will be removed from the inventory.';
  }

  @override
  String get storageRecommendations => 'Storage recommendations';

  @override
  String get chooseStorageCondition => 'Choose storage condition:';

  @override
  String get applyRecommendation => 'Apply';

  @override
  String get skipSetManually => 'Skip, I\'ll set manually';

  @override
  String recommendedDays(String days) {
    return 'Recommended: $days';
  }

  @override
  String get getTipAfterName =>
      'Tap 💡 after entering name to get expiry recommendation';

  @override
  String get getStorageRecommendation => 'Get storage recommendation';

  @override
  String get daysUnit => 'days';

  @override
  String get locationFridgeShort => 'Fridge';

  @override
  String get locationFreezerShort => 'Freezer';

  @override
  String get locationPantryShort => 'Pantry';

  @override
  String get locationRoomShort => 'Room temp';

  @override
  String get stateWhole => 'whole';

  @override
  String get stateCut => 'cut';

  @override
  String get stateRaw => 'raw';

  @override
  String get stateCooked => 'cooked';

  @override
  String get stateOpened => 'opened';

  @override
  String get stateUnopened => 'unopened';

  @override
  String get stateFresh => 'fresh';

  @override
  String get accountType => 'Account type';

  @override
  String get businessAccount => 'Business account';

  @override
  String get businessAccountSubtitle => 'Stop list mode for restaurants';

  @override
  String get stopList => 'Stop List';

  @override
  String get addDish => 'Add dish';

  @override
  String get dishName => 'Dish name';

  @override
  String get addIngredient => 'Add ingredient...';

  @override
  String get noDishesYet => 'No dishes yet';

  @override
  String get noDishesSubtitle =>
      'Add your menu dishes to track ingredient availability';
}
