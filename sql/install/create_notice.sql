--
-- Notice
create table public.notice (
    id                  bigserial primary key not null,
    customer_id         int8 not null,                  -- Author of the notice
    purchase_id         int8,                           -- If notice refers to whole Purchase, not to exact position
    purchase_item_id    int8,                           -- If notice refers to single position of the Purchase, purchase_id - not required
    title               varchar(255) not null,          -- Title of the notice
    body                text not null,                  -- Text of the notice
    created             timestamp default current_timestamp not null,
    updated             timestamp default current_timestamp not null,
    deleted             timestamp null
);
--
-- Testing public.notice table
insert into public.notice (customer_id, purchase_id, purchase_item_id, title, body) values (15, 1, null, 'Notice 1 to Purchase 1', 'Some text of the Notice 1 to Purchase 1...');
insert into public.notice (customer_id, purchase_id, purchase_item_id, title, body) values (15, 3, null, 'Notice 1 to Purchase 3', 'Some text of the Notice 1 to Purchase 3...');
insert into public.notice (customer_id, purchase_id, purchase_item_id, title, body) values (15, null, 2, 'Notice 1 to PurchaseItem 2', 'Some text of the Notice 1 to PurchaseItem 2...');
insert into public.notice (customer_id, purchase_id, purchase_item_id, title, body) values (15, null, 2, 'Notice 2 to PurchaseItem 2', 'Some text of the Notice 2 to PurchaseItem 2...');









