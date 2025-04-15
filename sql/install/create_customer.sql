
-- drop table public.customer cascade;
-- drop type public."customer_role_enum";
-- 
-- Create public.customer_role_enum enum
create type public."customer_role_enum" as enum (
    'admin',
    'operator',
    'customer',
    'guest'
);
-- 
-- Create public.customer table
create table public.customer (
    id          bigserial primary key not null,
    role        customer_role_enum not null,
    email       varchar(320) not null,
    phone       varchar(15) not null,
    name        varchar(255) not null,
    location    varchar(255) not null,
    login       varchar(255) not null,
    pass        varchar(255) not null,
    account     numeric(20, 2) default '0.0' not null,
    last_act    timestamp not null,
    blocked     timestamp null,
    created     timestamp default current_timestamp NOT NULL,
    updated     timestamp default current_timestamp NOT NULL,
    deleted     timestamp null,
    UNIQUE(login)
);
--
-- Testing public.customer table
insert into public.customer (role, email, phone, name, location, login, pass, account, last_act, blocked, created, updated, deleted) values 
    ('admin',    'lobanov.anton@gmail.com',  '+79615258088', 'Lobanov Anton',   'SPB', '+79615258088', '3201,3202,3203', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    ('operator', 'lobanov.anton1@gmail.com', '+79615258089', 'Lobanov Anton 1', 'SPB', 'lobanov.anton1@gmail.com', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    ('customer', 'lobanov.anton2@gmail.com', '+79615258091', 'Lobanov Anton 2', 'SPB', 'lobanov.anton2@gmail.com', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    ('customer', 'lobanov.anton3@gmail.com', '+79615258092', 'Lobanov Anton 3', 'SPB', 'lobanov.anton3@gmail.com', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    ('customer', 'lobanov.anton4@gmail.com', '+79615258093', 'Lobanov Anton 4', 'SPB', 'lobanov.anton4@gmail.com', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
