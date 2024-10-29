/* Procedure DEL_TRANSACTION
    - `author_id_`             		- Person who created the transaction
	- `customer_id_` int	  		- Cuctomer which account will be proccesed
    - `description_` varchar(2048) 	- Additional info about transfer
	- `allow_indebted` bool   		- allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
	- Returns `value` numeric(20, 2) - new amount of Customer's account
*/ 
drop function if exists del_transaction;
create or replace function del_transaction(
	id_ int8, author_id_ int8, customer_id_ int8, description_ varchar(2048), allow_indebted bool)
returns table (account numeric(20, 2), error text)
language plpgsql
as $$ 
declare
    name_ text;
    value_ numeric(20, 2);
    account_ numeric(20, 2);
    account_before numeric(20, 2);
	result_account numeric(20, 2);
	result_error text = null;
begin
	call log_info(format('del_transaction | deleting transaction: ' || id_));	
	select tr.value, tr.customer_account into value_, account_before from public.transaction tr
	 	where tr.id = id_;
	select c.account, c.name into account_, name_ from public.customer c
	 	where c.id = customer_id_;
	call log_info(format('del_transaction | 	name_         : ' || name_));	
	call log_info(format('del_transaction | 	account_before: ' || account_before));	
	call log_info(format('del_transaction | 	account_      : ' || account_));	
    if (not allow_indebted and account_before > 0.0) or (allow_indebted) THEN
		-- revert customer account 
		execute 'update public.customer SET account = ' || account_before 
			|| ' where id = ' || customer_id_;
		execute 'update public.transaction set (description, deleted) = ('
			|| format('%L, ', description_)
			|| 'CURRENT_TIMESTAMP'
			|| ') '
			|| 'where id = ' || id_ || ';';
	else
		select 'Err: Insufficient funds' into result_error;
    end if;
	select c.account into result_account from public.customer c
	 	where c.id = customer_id_;
	call log_info('del_transaction | result_account: ' || result_account);
	call log_info('del_transaction | result_error  : ' || coalesce(result_error, ''));
	return query values (result_account, result_error);
end
$$;
--
-- -- Testing
-- select * from del_transaction(4, 15, 2, 'Testing transaction delete', false);
-- update public.transaction set (description, deleted) = ('Testing transaction delete', CURRENT_TIMESTAMP) where id = 4;
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



