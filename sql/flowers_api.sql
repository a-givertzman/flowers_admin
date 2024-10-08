
drop view public.customer_order_view;
CREATE OR REPLACE VIEW public.customer_order_view
AS SELECT cord.id,
    cord.customer_id as customer_id,
    cord.purchase_content_id as purchase_content_id,
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
     JOIN purchase_content puc ON cord.purchase_content_id = puc.id
     JOIN purchase pu ON puc.purchase_id = pu.id
     JOIN product p ON puc.product_id = p.id;

    
drop view public.purchase_content_view ;
CREATE OR REPLACE VIEW public.purchase_content_view AS
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
   FROM purchase_content puc
     JOIN purchase pu ON puc.purchase_id = pu.id
     JOIN product p ON puc.product_id = p.id;

-- Notice
-- Notice
DROP TABLE public.notice;
CREATE TABLE public.notice (
	id bigserial not null,
	customer_id int8 not null,			-- Author of the notice
	purchase_id int8,					-- If notice refers to whole Purchase, not to exact position
	purchase_content_id int8,			-- If notice refers to single position of the Purchase, purchase_id - not required
	title varchar(255) not null,		-- Title of the notice
	body text not null,					-- Text of the notice
	created timestamp DEFAULT CURRENT_TIMESTAMP not null,
	updated timestamp DEFAULT CURRENT_TIMESTAMP not null,
	deleted timestamp NULL,
	primary key (id)
);
INSERT INTO public.notice (customer_id, purchase_id, purchase_content_id, title, body) VALUES(15, 1, null, 'Notice 1 to Purchase 1', 'Some text of the Notice 1 to Purchase 1...');
INSERT INTO public.notice (customer_id, purchase_id, purchase_content_id, title, body) VALUES(15, 3, null, 'Notice 1 to Purchase 3', 'Some text of the Notice 1 to Purchase 3...');
INSERT INTO public.notice (customer_id, purchase_id, purchase_content_id, title, body) VALUES(15, null, 2, 'Notice 1 to PurchaseItem 2', 'Some text of the Notice 1 to PurchaseItem 2...');
INSERT INTO public.notice (customer_id, purchase_id, purchase_content_id, title, body) VALUES(15, null, 2, 'Notice 2 to PurchaseItem 2', 'Some text of the Notice 2 to PurchaseItem 2...');









