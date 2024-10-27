drop type public."customer_role_enum";
create type public."customer_role_enum" as enum (
	'admin',
	'operator',
	'customer'
);
-- 
-- Create public.customer table
drop table public.customer;
create table public.customer (
	id 			bigserial primary key not null,
	role 		customer_role_enum not null,
	email 		varchar(320) not null,
	phone 		varchar(15) not null,
	name		varchar(255) not null,
	location	varchar(255) not null,,
	login		varchar(255) not null,,
	pass		varchar(255) not null,
	account		numeric(20, 2) default '0.0' not null,
	last_act 	timestamp not null,
	blocked		timestamp null
	created 	timestamp default current_timestamp NOT NULL,
	updated 	timestamp default current_timestamp NOT NULL,
	deleted 	timestamp null,
	UNIQUE(login)
);
--
-- Testing public.customer table
insert into public.customer (role, email, phone, name, location, login, pass, account, last_act, blocked, created, updated, deleted) values 
	('admin', 'lobanov.anton@gmail.com', '+79615258088', 'Lobanov Anton', 'SPB', '+79615258088', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
insert into public.customer (role, email, phone, name, location, login, pass, account, last_act, blocked, created, updated, deleted) values 
	('operator', 'lobanov.anton@gmail.com', '+79615258088', 'Lobanov Anton', 'SPB', '+79615258088', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
insert into public.customer (role, email, phone, name, location, login, pass, account, last_act, blocked, created, updated, deleted) values 
	('customer', 'lobanov.anton@gmail.com', '+79615258088', 'Lobanov Anton', 'SPB', '+79615258088', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
insert into public.customer (role, email, phone, name, location, login, pass, account, last_act, blocked, created, updated, deleted) values 
	('customer', 'lobanov.anton@gmail.com', '+79615258088', 'Lobanov Anton', 'SPB', '+79615258088', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
insert into public.customer (role, email, phone, name, location, login, pass, account, last_act, blocked, created, updated, deleted) values 
	('customer', 'lobanov.anton@gmail.com', '+79615258088', 'Lobanov Anton', 'SPB', '+79615258088', 'pass', 0.0, '2023-11-05 21:49:42.251', null, '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
