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
CREATE OR REPLACE VIEW public.customer_order_view AS 
    SELECT 
        cord.id,
        cord.customer_id as customer_id,
        cord.purchase_item_id as purchase_item_id,
        cord.count as count,
        cord.count * (puc.sale_price + puc.shipping) as cost,
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
--
-- Testing public.customer_order table
insert into public.customer_order (id, customer_id, purchase_item_id, count, paid, distributed, to_refound, refounded, description, created, updated, deleted) values 
    (1, 1, 1, 11, 200.0, 0, 0.0, 0.0, 'Purchase Id 1, Description...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    (2, 1, 2, 12, 2000.0, 0, 0.0, 0.0, 'Purchase Id 2, Description...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    (3, 2, 1, 13, 0.0, 0, 0.0, 0.0, 'Purchase Id 1, Description...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null),
    (4, 2, 2, 14, 0.0, 0, 0.0, 0.0, 'Purchase Id 1, Description...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', null);
alter sequence customer_order_id_seq restart with 5;

