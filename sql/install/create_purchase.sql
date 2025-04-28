--
-- public.purchase_status enum
create type public."purchase_status_enum" as enum (
    'prepare',
    'active',
    'purchase',
    'distribute',
    'archived',
    'canceled',
    'notsampled'
);
--
-- public.purchase
create table public.purchase (
    id                  bigserial primary key not null,
    name                varchar(255) not null,
    status              purchase_status_enum not null,                  -- current state of the purchase
    details             varchar(255) not null,                          -- short details about
    preview             text not null,                                  -- used to list some key items of the purchase
    description         text not null,                                  -- detiled description
    date_of_start       timestamp not null,
    date_of_end         timestamp not null,
    picture             text,                                           -- url to image
    created             timestamp default current_timestamp not null,
    updated             timestamp default current_timestamp not null,
    deleted             timestamp null
);
--
-- Testing public.purchase table
insert into public.purchase (name, status, details, preview, description, date_of_start, date_of_end, picture, created, updated, deleted) values 
    ('01. Закупка Сентябрь 2024', 'distribute', 'Закупка Сентябрь 2024. Цветы...', 'Preview...', 'Детальное описание закупки...', '2024-09-05 21:49:42.251', '2024-09-29 21:49:42.251', null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
insert into public.purchase (name, status, details, preview, description, date_of_start, date_of_end, picture, created, updated, deleted) values 
    ('02. Закупка Октябрь 2024', 'purchase', 'Закупка Октябрь 2024. Цветы...', 'Preview...', 'Детальное описание закупки...', '2024-10-01 21:49:42.251', '2024-10-30 21:49:42.251', null, '2024-10-01 21:49:42.251', '2024-10-01 21:49:42.251', null);
insert into public.purchase (name, status, details, preview, description, date_of_start, date_of_end, picture, created, updated, deleted) values 
    ('03. Закупка Ноябрь 2024', 'active', 'Закупка Ноябрь 2024. Цветы...', 'Preview...', 'Детальное описание закупки...', '2024-11-03 21:49:42.251', '2024-11-30 21:49:42.251', null, '2024-11-03 21:49:42.251', '2024-11-03 21:49:42.251', null);
insert into public.purchase (name, status, details, preview, description, date_of_start, date_of_end, picture, created, updated, deleted) values 
    ('04. Закупка Декабрь 2024', 'prepare', 'Закупка Декабрь 2024. Цветы...', 'Preview...', 'Детальное описание закупки...', '2024-12-02 21:49:42.251', '2024-12-29 21:49:42.251', null, '2024-12-02 21:49:42.251', '2024-12-02 21:49:42.251', null);
insert into public.purchase (name, status, details, preview, description, date_of_start, date_of_end, picture, created, updated, deleted) values 
    ('05. Закупка Январь 2025', 'prepare', 'Закупка Январь 2025. Цветы...', 'Preview...', 'Детальное описание закупки...', '2025-01-07 21:49:42.251', '2025-02-28 21:49:42.251', null, '2025-01-07 21:49:42.251', '2025-01-07 21:49:42.251', null);
