--
-- public.product_category
create table public.product_category (
    id                      bigserial primary key not null,
    category_id             int8,
    name                    varchar(255) not null,
    details                 varchar(255) not null,
    description             text not null,
    picture                 text,
    created                 timestamp default current_timestamp not null,
    updated                 timestamp default current_timestamp not null,
    deleted                 timestamp null
);
--
-- Testing public.product_category table
insert into public.product_category (id, category_id, name, details, description, picture, created, updated, deleted) values 
    (1, null, '01. Комнатные растения', 'Комнатные растения', 'Описание категории "Комнатные растения"', null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (2,    1, '01.02. Цветы', 'Комнатные растения | Цветы', 'Описание категории "Цветы"', null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (3, null, '03. Садовый инвентарь', 'Садовый инвентарь', 'Описание категории "Садовый инвентарь"', null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (4,    3, '03.04. Ручной инструмент', 'Садовый инвентарь | Ручной инструмент', 'Описание категории "Ручной инструмент"', null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
alter sequence product_category_id_seq restart with 5;
