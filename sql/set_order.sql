/* Procedure SET_ORDER
	- `customer_id_` int8	  - Cuctomer which order will be proccesed
	- `purchase_content_id_` numeric(20, 2) - the ID of the item in the `purchase_content`
	- `count` bool   - number of items to be incremented / decremented to the current state of the item in the `purchase_content` 
	- Returns count int8 - new count of the items in the `purchase_content`
*/ 
-- call set_order(15, 3, 2);
drop function set_order;
create or replace function set_order(customer_id_ int8, purchase_content_id_ int8, count_ int8) RETURNS int8 
language plpgsql
as $$
declare
	paid numeric(20, 2) = 0.0;
	distributed int = 0;
	to_refound numeric(20, 2) = 0.0;
	refounded numeric(20, 2) = 0.0;
	description text = '''''';
	delta int;
	remains int;
begin
	call raise_notice(format('start with new_count: ' || count_));	
	delta = (select count_ - co.count from public.customer_order co
	 	where co.customer_id = customer_id_
	 	and co.purchase_content_id = purchase_content_id_);
	if delta is null then
		call raise_notice('order not found, creating new one...');
		delta = count_;
	end if;
	remains = (select pc.remains from public.purchase_content pc
	 	where pc.id = purchase_content_id_);
	if delta != 0  and delta <= remains then
		call raise_notice('delta ' || delta);
		execute 'update public.purchase_content SET remains = remains - ' || delta
			|| ' where id = ' || purchase_content_id_;
		execute 'insert into public.customer_order as co (customer_id, purchase_content_id, count, paid, distributed, to_refound, refounded, description)' 
	        || ' values ('
			|| customer_id_ || ', '
			|| purchase_content_id_ || ', '
			|| count_ || ', '
			|| paid || ', '
			|| distributed || ', '
			|| to_refound || ', '
			|| refounded || ', '
			|| description
			|| ')'
	        || ' on conflict (customer_id, purchase_content_id) do update' 
	        	|| ' SET count = ' || count_ || ', '
				|| ' 	 deleted = NULL'
	         	|| ' where co.customer_id = ' || customer_id_
	         	|| ' and co.purchase_content_id = ' || purchase_content_id_;
		if count_ = 0 then
			call raise_notice('Deleting order...');
			execute 'update public.customer_order as co' 
		        	|| ' SET deleted = ''' || CURRENT_TIMESTAMP || ''''
		         	|| ' where co.customer_id = ' || customer_id_
		         	|| ' and co.purchase_content_id = ' || purchase_content_id_;
			call raise_notice('Deleting order - Ok');
		end if;
	end if;
	count_ = (select co.count from public.customer_order co
	 	where co.customer_id = customer_id_
	 	and co.purchase_content_id = purchase_content_id_);
	call raise_notice('new order count: ' || count_);
	remains = (select pc.remains from public.purchase_content pc
	 	where pc.id = purchase_content_id_);
	call raise_notice('new purchase content remains: ' || remains);
	return count_;
end
$$;
