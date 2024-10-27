drop type public."purchase_status_enum";
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
drop table public.purchase;
create table public.purchase (
    id                  bigserial primary key not null,
    name                varchar(255) not null,
    details             varchar(255) not null,
    status              purchase_status_enum not null,
    date_of_start       timestamp not null,
    date_of_end         timestamp not null,
    description         text not null,
    picture             text
);
