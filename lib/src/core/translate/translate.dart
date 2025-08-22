class InEn {
  final String _value;
  InEn(value) : _value = value;
  @override
  String toString() {
    return tr[_value]?[Lang.en] ?? _value;
  }
}

class InRu {
  final String _value;
  InRu(value) : _value = value;
  @override
  String toString() {
    return tr[_value]?[Lang.ru] ?? _value;
  }
}

enum Lang {
  en,
  ru
}

const tr = {
  'name': {Lang.en: 'name', Lang.ru: 'имя'},
  'Edit customer': {Lang.en: 'Edit customer', Lang.ru: 'Редактировать пользователя'},
  'Create customer': {Lang.en: 'Create customer', Lang.ru: 'Создать пользователя'},
  'Edit transaction': {Lang.en: 'Edit transaction', Lang.ru: 'Редактировать транзакцию'},
  'Create transaction': {Lang.en: 'Create transaction', Lang.ru: 'Создать транзакцию'},
  'New transaction': {Lang.en: 'New transaction', Lang.ru: 'Новая транзакция'},
  'Edit product': {Lang.en: 'Edit product', Lang.ru: 'Редактировать товар'},
  'Create product': {Lang.en: 'Create product', Lang.ru: 'Создать товар'},
  'Edit product category': {Lang.en: 'Edit product category', Lang.ru: 'Редактировать категорию товаров'},
  'Create product category': {Lang.en: 'Create product category', Lang.ru: 'Создать категорию товаров'},
  'from': {Lang.en: 'from', Lang.ru: 'от'},
  'Author': {Lang.en: 'Author', Lang.ru: 'Автор'},
  'Role': {Lang.en: 'Role', Lang.ru: 'Роль'},
  'Customer': {Lang.en: 'Customer', Lang.ru: 'Пользователь'},
  'Value': {Lang.en: 'Value', Lang.ru: 'Сумма'},
  'Created': {Lang.en: 'Created', Lang.ru: 'Создано'},
  'Details': {Lang.en: 'Details', Lang.ru: 'Детали'},
  'Description': {Lang.en: 'Description', Lang.ru: 'Описание'},
  'TransactionDetails': {Lang.en: 'Details', Lang.ru: 'Назначение'},
  'CustomerAccountBefore': {Lang.en: 'Customer account before', Lang.ru: 'Счет клиента до'},
  'NotSampled': {Lang.en: 'Not sampled', Lang.ru: 'Не выбрано'},
  'AllowIndebted': {Lang.en: 'Allow indebted', Lang.ru: 'Разрешить в долг'},
  'Amount': {Lang.en: 'Amount', Lang.ru: 'Сумма'},
  'amount': {Lang.en: 'amount', Lang.ru: 'сумма'},
  
  'Price': {Lang.en: 'Price', Lang.ru: 'Цена'},
  'Currency': {Lang.en: 'Currency', Lang.ru: 'Валюта'},
  'Shipping': {Lang.en: 'Shipping', Lang.ru: 'Доставка'},
  'Remains': {Lang.en: 'Remains', Lang.ru: 'Остаток'},
  // '**': {Lang.en: '**', Lang.ru: '---'},
  // '**': {Lang.en: '**', Lang.ru: '---'},
  // '**': {Lang.en: '**', Lang.ru: '---'},
  // '**': {Lang.en: '**', Lang.ru: '---'},
  // '**': {Lang.en: '**', Lang.ru: '---'},

  'of': {Lang.en: 'of', Lang.ru: 'от'},
  'In all': {Lang.en: 'In all', Lang.ru: 'Всего'},
  'Show deleted': {Lang.en: 'Show deleted', Lang.ru: 'Показывать удаленные'},
  'Customers': {Lang.en: 'Customers', Lang.ru: 'Пользователи'},
  'Transactions': {Lang.en: 'Transactions', Lang.ru: 'Транзакции'},
  'Payment': {Lang.en: 'Payment', Lang.ru: 'Оплата'},
  'ProductCategory': {Lang.en: 'Product Category', Lang.ru: 'Категории'},
  'Product': {Lang.en: 'Product', Lang.ru: 'Товар'},
  'Products': {Lang.en: 'Products', Lang.ru: 'Товары'},
  'Purchase': {Lang.en: 'Purchase', Lang.ru: 'Закупка'},
  'Purchases': {Lang.en: 'Purchases', Lang.ru: 'Закупки'},
  'PurchaseItems': {Lang.en: 'Purchase Items', Lang.ru: 'Позиции закупок'},
  'Purchase Item': {Lang.en: 'Purchase Item', Lang.ru: 'Позиция в закупке'},
  'Orders': {Lang.en: 'Orders', Lang.ru: 'Заказы'},
  'Count': {Lang.en: 'Count', Lang.ru: 'Кол-во'},
  'Paid': {Lang.en: 'Paid', Lang.ru: 'Оплачено'},
  'Cost': {Lang.en: 'Cost', Lang.ru: 'Стоимость'},
  'Distributed': {Lang.en: 'Distributed', Lang.ru: 'Выдано'},
  'To refound': {Lang.en: 'To refound', Lang.ru: 'Возврат'},
  'Refounded': {Lang.en: 'Refounded', Lang.ru: 'Возвращено'},
  'No date': {Lang.en: 'No date', Lang.ru: 'Нет даты'},
  'Allow indebted': {Lang.en: 'Allow indebted', Lang.ru: 'Разрешить долг'},
  'Perform payments': {Lang.en: 'Perform payments', Lang.ru: 'Провести платежи'},
  'Payments will be performed for selected Customers by selected Purchase items': {
    Lang.en: 'Payments will be performed for selected Customers by selected Purchase items',
    Lang.ru: 'Платежи будут проведены для выбранных Клиентов по выбранным позициям закупок',
  },
};
///
/// Simple translate
extension StringTranslation on String{
  String get inEn {
    return tr[this]?[Lang.en] ?? this;
  }
  String get inRu {
    return tr[this]?[Lang.ru] ?? this;
  }
}
