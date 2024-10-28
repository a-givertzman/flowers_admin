
drop table if exists public.customer cascade;
drop type if exists public."customer_role_enum";

drop table if exists public.transaction cascade;

drop table if exists public.notice cascade;

drop table if exists public.purchase cascade;
drop type if exists public."purchase_status_enum";

drop view if exists public.purchase_item_view ;
drop table if exists public.purchase_item cascade;

drop view if exists public.customer_order_view;
drop table if exists public.customer_order cascade;

drop table if exists public.product cascade;
drop table if exists public.product_category cascade;
