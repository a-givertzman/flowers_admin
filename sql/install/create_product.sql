--
-- public.product
create table public.product (
    id                      bigserial primary key not null,
    product_category_id     int8 not null,
    name                    varchar(255) not null,
    details                 varchar(255) not null,
    primary_price           numeric(20, 2) default '0.0' not null,  -- Закупочная цена
    primary_currency        varchar(16) not null,                   -- Валюьа в которой товар закупается
    primary_order_quantity  int8 not null,                          -- Кратность закупа (минимальное количество)
    order_quantity          int8 not null,                          -- Кратность заказа пользователям (минимальное количество)
    description             text not null,
    picture                 text,
    created                 timestamp default current_timestamp not null,
    updated                 timestamp default current_timestamp not null,
    deleted                 timestamp null
);
--
-- Testing public.product table
insert into public.product (id, product_category_id, name, details, primary_price, primary_currency, primary_order_quantity, order_quantity, description, picture, created, updated, deleted) values 
    (1, 2, '01. Freesia andersoniae', 'Freesia andersoniae детали...', 1.1, 'EUR', 3, 1,
        'Фре́зия, или фрее́зия (лат. Freesia) — род африканских многолетних травянистых клубнелуковичных растений семейства Ирисовые (Касатиковые).',
        null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
insert into public.product (id, product_category_id, name, details, primary_price, primary_currency, primary_order_quantity, order_quantity, description, picture, created, updated, deleted) values 
    (2, 2, '02. Osmanthus attenuatus', 'Osmanthus attenuatus детали...', 1.2, 'EUR', 3, 1, 
        'Осма́нтус (лат. Osmānthus) — род вечнозелёных лиственных цветковых растений семейства Маслиновые (Oleaceae), включающий около 36 видов, происходящих из тропических районов Азии от Кавказа до Японии.',
        null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
insert into public.product (id, product_category_id, name, details, primary_price, primary_currency, primary_order_quantity, order_quantity, description, picture, created, updated, deleted) values 
    (3, 4, '03. Совок', 'Совок садовый детали...', 1.3, 'EUR', 3, 1, 
        'Совок садовый с деревянной ручкой широкий.',
        null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
