--
-- public.product
create table public.product (
    id                      bigserial primary key not null,
    product_category_id     int8 not null,
    name                    varchar(255) not null,
    details                 varchar(255) not null,
    primary_price           numeric(20, 2) default '0.0' not null,  -- Закупочная цена
    primary_currency        varchar(16) not null,                   -- Валюьа закупочной цены
    primary_order_quantity  int8 not null,                          -- Кратность закупа (минимальное количество)
    order_quantity          int8 not null,                          -- Кратность заказа пользователям (минимальное количество)
    description             text not null,
    picture                 text,
    created                 timestamp default current_timestamp not null,
    updated                 timestamp default current_timestamp not null,
    deleted                 timestamp null
);
--
-- public.product_view
CREATE OR REPLACE VIEW public.product_view AS
    SELECT
        p.id,
        p.product_category_id,
        pc.name as category,
        p.name,
        p.details,
        p.primary_price,
        p.primary_currency,
        p.primary_order_quantity,
        p.order_quantity,
        p.description,
        p.picture,                 
        p.created,
        p.updated,
        p.deleted
    FROM product p
        JOIN product_category pc ON p.product_category_id = pc.id;
--
-- Testing public.product table
insert into public.product (id, product_category_id, name, details, primary_price, primary_currency, primary_order_quantity, order_quantity, description, picture, created, updated, deleted) values 
    (1, 2, '01. Freesia andersoniae', 'Freesia andersoniae детали...', 1.1, 'EUR', 3, 1,
        'Фре́зия, или фрее́зия (лат. Freesia) — род африканских многолетних травянистых клубнелуковичных растений семейства Ирисовые (Касатиковые).',
        'https://upload.wikimedia.org/wikipedia/commons/4/42/Freesia.jpg',
        '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
insert into public.product (id, product_category_id, name, details, primary_price, primary_currency, primary_order_quantity, order_quantity, description, picture, created, updated, deleted) values 
    (2, 2, '02. Osmanthus attenuatus', 'Osmanthus attenuatus детали...', 1.2, 'EUR', 3, 1, 
        'Осма́нтус (лат. Osmānthus) — род вечнозелёных лиственных цветковых растений семейства Маслиновые (Oleaceae), включающий около 36 видов, происходящих из тропических районов Азии от Кавказа до Японии.',
        'https://upload.wikimedia.org/wikipedia/commons/1/13/Osmanthus_heterophyllus1.jpg',
        '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
insert into public.product (id, product_category_id, name, details, primary_price, primary_currency, primary_order_quantity, order_quantity, description, picture, created, updated, deleted) values 
    (3, 4, '03. Совок', 'Совок садовый детали...', 1.3, 'EUR', 3, 1, 
        'Совок садовый с деревянной ручкой широкий.',
        'https://upload.wikimedia.org/wikipedia/commons/9/93/Masons_trowel.jpg',
        '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
alter sequence product_id_seq restart with 4;
