/* Procedure SET_TRANSACTION
    - `author_id`             - Person who created the transaction
	- `details_` varchar(2048) - Transfer/Payment details
	- `value_` numeric(20, 2) - the amount to be transferred to/from Customers' account
	- `customer_id_` int	  - Cuctomer which account will be proccesed
    - `order_id_` int8 -       - If not NULL, trunsactions refers to the Customer's order
	- `allow_indebted` bool   - allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
	- Returns `value` numeric(20, 2) - new amount of Customer's account
*/ 
call set_transaction(15, 3, 2);
drop procedure set_transaction;
create or replace function set_transaction(author_id in8, details_ varchar(2048), value_ int, customer_id_ int8, order_id_ int8, allow_indebted bool) RETURNS int as 
$$ 
declare
	paid numeric(20, 2) = 0.0;
	distributed int = 0;
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
	value_ = (select c.account from public.customer co
	 	where co.customer_id = customer_id_;
	call raise_notice('new customer account: ' || account_);
	return account_;
end
language plpgsql;
$$;
