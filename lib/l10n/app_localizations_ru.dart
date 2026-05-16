// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Food Tracker';

  @override
  String get navHome => 'Главная';

  @override
  String get navShopping => 'Покупки';

  @override
  String get navRecipes => 'Рецепты';

  @override
  String get navSettings => 'Настройки';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get name => 'Имя';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get notRegistered => 'Ещё нет аккаунта?';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get invalidEmailOrPassword => 'Неверный email или пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get passwordTooLong => 'Пароль должен быть не более 100 символов';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get home => 'Главная';

  @override
  String get myFridge => 'Мой холодильник';

  @override
  String get exit => 'Выйти';

  @override
  String get add => 'Добавить';

  @override
  String get total => 'Всего';

  @override
  String get expiringSoon => 'Скоро истечёт';

  @override
  String get expired => 'Истёк';

  @override
  String get filterAll => 'Все';

  @override
  String get filterActive => 'Активные';

  @override
  String get filterExpiring => 'Скоро истечёт';

  @override
  String get filterExpired => 'Истёкшие';

  @override
  String get fridgeEmpty => 'Холодильник пуст';

  @override
  String get addProductsHint =>
      'Добавьте продукты с помощью\nкнопки внизу экрана';

  @override
  String get downloadError => 'Ошибка загрузки';

  @override
  String get repeat => 'Повторить';

  @override
  String get addProduct => 'Добавить продукт';

  @override
  String get editProduct => 'Редактировать продукт';

  @override
  String get productName => 'Название продукта *';

  @override
  String get quantity => 'Количество *';

  @override
  String get unit => 'Единица';

  @override
  String get expiryDate => 'Срок годности *';

  @override
  String get category => 'Категория';

  @override
  String get storageLocation => 'Место хранения';

  @override
  String get enterStorageLocation => 'Введите место хранения';

  @override
  String get notes => 'Заметки';

  @override
  String get notSpecified => 'Не указано';

  @override
  String get enterProductName => 'Введите название продукта';

  @override
  String get enterValidQuantity => 'Введите корректное количество';

  @override
  String get save => 'Сохранить';

  @override
  String get errorPrefix => 'Ошибка: ';

  @override
  String get categoryDairy => 'Молочные';

  @override
  String get categoryMeat => 'Мясо';

  @override
  String get categoryFish => 'Рыба';

  @override
  String get categoryVegetables => 'Овощи';

  @override
  String get categoryFruits => 'Фрукты';

  @override
  String get categoryBakery => 'Выпечка';

  @override
  String get categoryDrinks => 'Напитки';

  @override
  String get categoryFrozen => 'Заморозка';

  @override
  String get categorySnacks => 'Снеки';

  @override
  String get categoryOther => 'Другое';

  @override
  String get locationFridge => '🧊 Холодильник';

  @override
  String get locationFreezer => '❄️ Морозильник';

  @override
  String get locationShelf => '🗄️ Полка';

  @override
  String get locationKitchenCabinet => '🚪 Кухонный шкаф';

  @override
  String get locationPantry => '📦 Кладовая';

  @override
  String get locationOther => '✏️ Другое...';

  @override
  String get edit => 'Редактировать';

  @override
  String get markAsUsed => 'Отметить как использованное';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteProduct => 'Удалить продукт?';

  @override
  String get cancel => 'Отмена';

  @override
  String inDays(int days) {
    return 'Через $days дн.';
  }

  @override
  String get today => 'Сегодня';

  @override
  String addedDate(String date) {
    return 'Добавлено $date';
  }

  @override
  String get recommendedRecipes => 'Рекомендуемые рецепты';

  @override
  String get refresh => 'Обновить';

  @override
  String get noRecommendationsYet => 'Пока нет рекомендаций';

  @override
  String get addProductsForRecipes =>
      'Добавьте продукты в холодильник, чтобы увидеть рецепты.';

  @override
  String get couldNotLoadRecipes => 'Не удалось загрузить рецепты';

  @override
  String get retry => 'Повторить';

  @override
  String matchPercent(int percent) {
    return '$percent% совпадение';
  }

  @override
  String get ingredients => 'Ингредиенты';

  @override
  String addMissing(int count) {
    return 'Добавить недостающие ($count)';
  }

  @override
  String get inFridge => '✓ В холодильнике';

  @override
  String get addToShoppingList => 'Добавить в список покупок';

  @override
  String addedToShoppingList(String name) {
    return '$name добавлен в список покупок';
  }

  @override
  String itemsAddedToShoppingList(int count) {
    return '$count товаров добавлено в список';
  }

  @override
  String get instructions => 'Инструкция';

  @override
  String get couldNotLoadRecipe => 'Не удалось загрузить рецепт';

  @override
  String minLabel(int min) {
    return '$min мин';
  }

  @override
  String servingsLabel(int n) {
    return '$n порций';
  }

  @override
  String kcalLabel(int kcal) {
    return '$kcal ккал';
  }

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get clearDone => 'Очистить купленные';

  @override
  String toBuy(int count) {
    return 'Купить ($count)';
  }

  @override
  String done(int count) {
    return 'Куплено ($count)';
  }

  @override
  String get listEmpty => 'Список пуст';

  @override
  String get addItemsHint => 'Добавьте товары с помощью кнопки ниже';

  @override
  String get errorLoadingList => 'Ошибка загрузки списка';

  @override
  String get addToList => 'Добавить';

  @override
  String get itemName => 'Название товара *';

  @override
  String get clearDoneItems => 'Очистить купленные?';

  @override
  String get clearDoneConfirm =>
      'Все отмеченные товары будут удалены из списка.';

  @override
  String get clear => 'Очистить';

  @override
  String get enterItemName => 'Введите название товара';

  @override
  String get settings => 'Настройки';

  @override
  String get notifications => 'Уведомления';

  @override
  String get enableNotifications => 'Включить уведомления';

  @override
  String get getAlertsBeforeExpiry =>
      'Получайте уведомления до истечения срока';

  @override
  String get notifyBeforeExpiry => 'Уведомлять до истечения срока';

  @override
  String get selectOptions => 'Выберите один или несколько вариантов';

  @override
  String get oneDay => '1 день';

  @override
  String nDays(int n) {
    return '$n дней';
  }

  @override
  String selected(String days) {
    return 'Выбрано: $days';
  }

  @override
  String get language => 'Язык';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get scanBarcode => 'Сканировать штрихкод';

  @override
  String get productFound => 'Продукт найден';

  @override
  String get addToInventory => 'Добавить в холодильник';

  @override
  String get productNotFound => 'Продукт не найден';

  @override
  String get productNotInDatabase => 'Этого продукта нет в нашей базе';

  @override
  String get addManually => 'Добавить вручную';

  @override
  String willBeRemovedFromInventory(String name) {
    return '«$name» будет удалён из холодильника.';
  }

  @override
  String get storageRecommendations => 'Рекомендации по хранению';

  @override
  String get chooseStorageCondition => 'Выберите условие хранения:';

  @override
  String get applyRecommendation => 'Применить';

  @override
  String get skipSetManually => 'Пропустить, введу вручную';

  @override
  String recommendedDays(String days) {
    return 'Рекомендуется: $days';
  }

  @override
  String get getTipAfterName =>
      'Нажми 💡 после ввода названия для рекомендации срока';

  @override
  String get getStorageRecommendation => 'Получить рекомендацию хранения';

  @override
  String get daysUnit => 'дней';

  @override
  String get locationFridgeShort => 'Холодильник';

  @override
  String get locationFreezerShort => 'Морозильник';

  @override
  String get locationPantryShort => 'Кладовая';

  @override
  String get locationRoomShort => 'Комнатная темп.';

  @override
  String get stateWhole => 'целый';

  @override
  String get stateCut => 'нарезанный';

  @override
  String get stateRaw => 'сырой';

  @override
  String get stateCooked => 'приготовленный';

  @override
  String get stateOpened => 'открытый';

  @override
  String get stateUnopened => 'закрытый';

  @override
  String get stateFresh => 'свежий';

  @override
  String get accountType => 'Тип аккаунта';

  @override
  String get businessAccount => 'Бизнес аккаунт';

  @override
  String get businessAccountSubtitle => 'Режим стоп-листа для ресторанов';

  @override
  String get stopList => 'Стоп-лист';

  @override
  String get addDish => 'Добавить блюдо';

  @override
  String get dishName => 'Название блюда';

  @override
  String get addIngredient => 'Добавить ингредиент...';

  @override
  String get noDishesYet => 'Блюд пока нет';

  @override
  String get noDishesSubtitle =>
      'Добавьте блюда из меню для отслеживания наличия ингредиентов';
}
