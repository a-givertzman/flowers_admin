--
-- public.purchase_item
create table public.purchase_item (
    id                  bigserial primary key not null,
    purchase_id         int8 not null,                          -- Item refers to Purchase
    status              purchase_status_enum null,              -- Current state of the purchase item, inherits from purchase, can be customized
    product_id          int8 not null,                          -- Item refers to Product
    sale_price          numeric(20, 2) default '0.0' not null,  -- Цена за единицу
    sale_currency       varchar(16) not null,                   -- Валюьа цены
    shipping            numeric(20, 2) default '0.0' not null,  -- Цена доставки за единицу
    remains             int8 not null,
    name                varchar(255),
    details             varchar(255),
    description         text,
    picture             text,
    created             timestamp default current_timestamp not null,
    updated             timestamp default current_timestamp not null,
    deleted             timestamp null
);
--
-- public.purchase_item_view
CREATE OR REPLACE VIEW public.purchase_item_view AS
    SELECT 
        pui.id,
        pui.purchase_id,
        pu.name as purchase,
        coalesce(pui.name, p.name) as product,
        pui.status,         -- coalesce(pui.status, pu.status) as status,
        pui.product_id,
        pui.sale_price,
        pui.sale_currency,
        pui.shipping,
        pui.remains,
        pui.details,        -- coalesce(pui.details, p.details) as details,
        pui.description,        -- coalesce(pui.description, p.description) as description,
        pui.picture,        -- coalesce(pui.picture, p.picture) as picture,
        pui.created,
        pui.updated,
        pui.deleted
        -- pu.name AS purchase,
    FROM purchase_item pui
        JOIN purchase pu ON pui.purchase_id = pu.id
        JOIN product p ON pui.product_id = p.id;
--
-- Testing
insert into public.purchase_item (id, purchase_id, product_id, sale_price, sale_currency, shipping, remains, name, details, description, picture, created, updated, deleted) values
    -- (1, 2, 1, 101.0, 'RUB', 11.1, 111, name, details, description, picture, created, updated, deleted);
    (1, 2, 1, 101.0, 'RUB', 11.1, 111, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (2, 2, 2, 102.0, 'RUB', 11.2, 112, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (3, 2, 3, 103.0, 'RUB', 11.3, 113, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (4, 3, 1, 201.0, 'RUB', 11.1, 111, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (5, 3, 2, 202.0, 'RUB', 11.2, 112, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (6, 3, 3, 203.0, 'RUB', 11.3, 113, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null);
alter sequence purchase_item_id_seq restart with 7;
