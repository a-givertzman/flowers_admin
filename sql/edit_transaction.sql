/* Procedure EDIT_TRANSACTION
    - `author_id_`             - Person who created the transaction
	- `customer_id_` int	  - Cuctomer which account will be proccesed
	- `value_` numeric(20, 2) - the amount to be transferred to/from Customers' account
	- `details_` varchar(2048) - Transfer/Payment details
    - `order_id_` int8 -       - If not NULL, trunsactions refers to the Customer's order
    - `description_` varchar(2048) - Additional info about transfer
	- `allow_indebted` bool   - allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
	- Returns `value` numeric(20, 2) - new amount of Customer's account
*/ 
drop function if exists edit_transaction;
create or replace function edit_transaction(
	id_ int8, author_id_ int8, customer_id_ int8, value_ numeric(20, 2), details_ varchar(2048), order_id_ int8, description_ varchar(2048), allow_indebted bool)
returns table (account numeric(20, 2), error text)
language plpgsql
as $$ 
declare
    name_ text;
    account_ numeric(20, 2);
    account_before numeric(20, 2);
	result_account numeric(20, 2);
	result_error text = null;
begin
	call log_info(format('edit_transaction | start with:'));	
	call log_info(format('edit_transaction | 	value  : ' || value_));	
	select tr.customer_account into account_before from public.transaction tr
	 	where tr.id = id_;
	select c.account, c.name into account_, name_ from public.customer c
	 	where c.id = customer_id_;
	call log_info(format('edit_transaction | 	name_         : ' || name_));	
	call log_info(format('edit_transaction | 	account_before: ' || account_before));	
	call log_info(format('edit_transaction | 	account_      : ' || account_));	
    if (not allow_indebted and account_before + value_ > 0.0) or (allow_indebted and account_before > 0.0) THEN
		-- revert customer account 
		execute 'update public.customer SET account = ' || account_before 
			|| ' where id = ' || customer_id_;
		-- update customer account with new value
		select c.account, c.name into account_, name_ from public.customer c
		 	where c.id = customer_id_;
		execute 'update public.customer SET account = ' || account_ + value_
			|| ' where id = ' || customer_id_;
		if order_id_ is null then
			execute 'update public.transaction set (author_id, customer_id, customer_account, value, details, description) = ('
				|| author_id_ || ', '
				|| customer_id_ || ', '
				|| account_ || ', '
				|| value_ || ', '
				|| format('%L', details_) || ', '
				|| format('%L', description_)
				|| ') '
				|| 'where id = ' || id_ || ';';
		else
			execute 'update public.transaction (author_id, customer_id, customer_account, value, details, order_id, description) = ('
				|| author_id_ || ', '
				|| customer_id_ || ', '
				|| account_ || ', '
				|| value_ || ', '
				|| format('%L', details_) || ', '
				|| order_id_ || ', '
				|| format('%L', description_)
				|| ') '
				|| 'where id = ' || id_ || ';';
		end if;
	else
		select 'Error: Insufficient funds' into result_error;
    end if;
	select c.account into result_account from public.customer c
	 	where c.id = customer_id_;
	call log_info('edit_transaction | result_account: ' || result_account);
	call log_info('edit_transaction | result_error  : ' || coalesce(result_error, ''));
	return query values (result_account, result_error);
end
$$;
--
-- Testing
-- select * from edit_transaction(4, 15, 2, -33.33, 'Testing transaction - 33.33', null, 'Empty description', false);
-- select * from edit_transaction(4, 15, 2,  11.11, 'Testing transaction + 11.11', null, 'Empty description', false);
-- select * from edit_transaction(4, 15, 2, 100.33, 'Testing transaction +100.33', null, 'Empty description', false);
-- select * from edit_transaction(4, 15, 2, -430.33, 'Testing transaction -430.33', null, 'Empty description', false);
-- select * from edit_transaction(4, 15, 2, -330.34, 'Testing transaction -330.34', null, 'Empty description', false);
--
-- select
--     t.id,
--     t.author_id,
--     t.customer_id,
--     t.customer_account,
--     t.value,
--     t.customer_account + t.value as after,
--     c.account,
--     t.details,
--     t.order_id,
--     t.description,
--     t.created,
--     t.updated,
--     t.deleted
-- from public."transaction" t
-- join customer c on c.id = t.customer_id;



