--
-- public."customer_order" definition
create table public.customer_order (
    id                  bigserial primary key not null,
    customer_id         int8 not null,
    purchase_item_id    int8 not null,
    count               int8 not null,
    paid                numeric(20, 2) not null,
    distributed         int8 not null,
    to_refound          numeric(20, 2) not null,
    refounded           numeric(20, 2) not null,
    description         text,
    created             timestamp default current_timestamp NOT NULL,
    updated             timestamp default current_timestamp NOT NULL,
    deleted             timestamp null
);
--
-- public."customer_order_view" definition
CREATE OR REPLACE VIEW public.customer_order_view
AS SELECT cord.id,
    cord.customer_id as customer_id,
    cord.purchase_item_id as purchase_item_id,
    cord.count as count,
    cord.paid as paid,
    cord.distributed as distributed,
    cord.to_refound as to_refound,
    cord.refounded as refounded,
    cord.description as description,
    cord.created as created,
    cord.updated as updated,
    cord.deleted as deleted,
    cu.name AS customer,
    p.name AS product,
    pu.name AS purchase
    FROM customer_order cord
        JOIN customer cu ON cord.customer_id = cu.id
        JOIN purchase_item puc ON cord.purchase_item_id = puc.id
        JOIN purchase pu ON puc.purchase_id = pu.id
        JOIN product p ON puc.product_id = p.id;






