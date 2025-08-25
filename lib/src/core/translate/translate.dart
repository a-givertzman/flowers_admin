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
  'Pay': {Lang.en: 'Pay', Lang.ru: 'Оплатить'},
  'Perform payments': {Lang.en: 'Perform payments', Lang.ru: 'Провести платежи'},
  'Payments will be performed for selected Customers by selected Purchase items': {
    Lang.en: 'Payments will be performed for selected Customers by selected Purchase items',
    Lang.ru: 'Платежи будут проведены для выбранных Клиентов по выбранным позициям закупок',
  },
  'Total count of the items in the order': {
    Lang.en: 'Total count of the items in the order',
    Lang.ru: 'Количество товаров в заказе',
  },
  'Total cost of the ordered items': {
    Lang.en: 'The total cost of the ordered items',
    Lang.ru: 'Общая стоимость заказанных товаров',
  },
  'Amount already payed by the order from the Customer\'s account': {
    Lang.en: 'Amount already payed by the order from the Customer\'s account',
    Lang.ru: 'Сумма, уже оплаченная по заказу со счета Клиента',
  },
  'Count of the items in the order already picked up by the Customer': {
    Lang.en: 'Count of the items in the order already picked up by the Customer',
    Lang.ru: 'Количество товаров в заказе, уже полученных Клиентом',
  },
  'Amount to be returned to the Customer in the case of the overpay': {
    Lang.en: 'Amount to be returned to the Customer in the Case of the overpay',
    Lang.ru: 'Сумма, подлежащая возврату Клиенту в случае переплаты',
  },
  'Amount already returned to the customer on the  overpay': {
    Lang.en: 'Amount already returned to the customer on the  overpay',
    Lang.ru: 'Сумма, уже возвращенная Клиенту по переплате',
  },
  'Check the box to perform a payment on the order': {
    Lang.en: 'Check the box to perform a payment on the order',
    Lang.ru: 'Установите галочку что бы провести платежь по заказа',
  },
  'en_long': {
    Lang.en: 'en_long',
    Lang.ru: 'ru',
  },
  'en_compact': {Lang.en: 'en_compact', Lang.ru: 'ru'},
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
