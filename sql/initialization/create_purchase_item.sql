--
-- public.notice
drop table public.notice;
create table public.notice (


  
	id                  bigserial primary key not null,
	customer_id         int8 not null,			-- Author of the notice
	purchase_id         int8,					-- If notice refers to whole Purchase, not to exact position
	purchase_item_id    int8,			-- If notice refers to single position of the Purchase, purchase_id - not required
	title               varchar(255) not null,		-- Title of the notice
	body                text not null,					-- Text of the notice
	created             timestamp default current_timestamp not null,
	updated             timestamp default current_timestamp not null,
	deleted             timestamp null
);
--
-- public.purchase_item_view
drop view public.purchase_item_view ;
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
