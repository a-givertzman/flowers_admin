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
  'Edit transaction': {Lang.en: 'Edit customer', Lang.ru: 'Редактировать транзакцию'},
  'from': {Lang.en: 'from', Lang.ru: 'от'},
  'Author': {Lang.en: 'Author', Lang.ru: 'Автор'},
};


extension StringTranslation on String{
  String inEn() {
    return tr[this]?[Lang.en] ?? this;
  }
  String inRu() {
    return tr[this]?[Lang.ru] ?? this;
  }
}
