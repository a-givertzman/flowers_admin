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
  'Edit transaction': {Lang.en: 'Edit transaction', Lang.ru: 'Редактировать транзакцию'},
  'New transaction': {Lang.en: 'New transaction', Lang.ru: 'Новая транзакция'},
  'from': {Lang.en: 'from', Lang.ru: 'от'},
  'Author': {Lang.en: 'Author', Lang.ru: 'Автор'},
  'Customer': {Lang.en: 'Customer', Lang.ru: 'Пользователь'},
  'Value': {Lang.en: 'Value', Lang.ru: 'Сумма'},
  'Created': {Lang.en: 'Created', Lang.ru: 'Создано'},
  'Description': {Lang.en: 'Description', Lang.ru: 'Описание'},
  'TransactionDetails': {Lang.en: 'Details', Lang.ru: 'Назначение'},
  'CustomerAccountBefore': {Lang.en: 'Customer account before', Lang.ru: 'Счет клиента до'},
  'NotSampled': {Lang.en: 'Not sampled', Lang.ru: 'Не выбрано'},
};


extension StringTranslation on String{
  String inEn() {
    return tr[this]?[Lang.en] ?? this;
  }
  String inRu() {
    return tr[this]?[Lang.ru] ?? this;
  }
}
