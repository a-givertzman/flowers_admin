--
-- public.purchase_item
create table public.purchase_item (
    id                  bigserial primary key not null,
    purchase_id         int8 not null,     -- item refers to Purchase
    product_id          int8 not null,     -- item refers to Product
    sale_price          numeric(20, 2) default '0.0' not null,
    sale_currency       varchar(16) not null,
    shipping            numeric(20, 2) default '0.0' not null,
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
        puc.id,
        puc.purchase_id,
        puc.product_id,
        puc.sale_price,
        puc.sale_currency,
        puc.shipping,
        puc.remains,
        coalesce(puc.name, p.name) as name,
        coalesce(puc.details, p.details) as details,
        coalesce(puc.description, p.description) as description,
        coalesce(puc.picture, p.picture) as picture,
        puc.created,
        puc.updated,
        puc.deleted,
        pu.status as status
        -- pu.name AS purchase,
    FROM purchase_item puc
        JOIN purchase pu ON puc.purchase_id = pu.id
        JOIN product p ON puc.product_id = p.id;
--
-- Testing
insert into public.purchase_item (id, purchase_id, product_id, sale_price, sale_currency, shipping, remains, name, details, description, picture, created, updated, deleted) values
    -- (1, 2, 1, 101.0, 'RUB', 11.1, 111, name, details, description, picture, created, updated, deleted);
    (1, 2, 1, 101.0, 'RUB', 11.1, 111, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    (2, 2, 2, 101.0, 'RUB', 11.1, 111, null, null, null, null, '2024-09-05 21:49:42.251', '2024-09-05 21:49:42.251', null),
    ;