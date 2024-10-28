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
    name                varchar(255) not null,
    details             varchar(255) not null,
    description         text not null,     -- Text of the notice
    picture             text,
    created             timestamp default current_timestamp not null,
    updated             timestamp default current_timestamp not null,
    deleted             timestamp null
);
--
-- public.purchase_item_view
CREATE OR REPLACE VIEW public.purchase_item_view AS
SELECT puc.id,
    puc.purchase_id,
    puc.product_id,
    puc.sale_price,
    puc.sale_currency,
    puc.shipping,
    puc.remains,
    puc.name,
--    puc.details,
--    puc.description,
--    puc.picture,
    puc.created,
    puc.updated,
    puc.deleted,
    p.name AS product,
    p.details AS details,
    p.description AS description,
    p.picture AS picture,
    pu.name AS purchase,
    pu.status as status
   FROM purchase_item puc
     JOIN purchase pu ON puc.purchase_id = pu.id
     JOIN product p ON puc.product_id = p.id;
