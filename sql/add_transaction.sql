/* Procedure SET_TRANSACTION
    - `author_id_`             - Person who created the transaction
	- `customer_id_` int	  - Cuctomer which account will be proccesed
	- `value_` numeric(20, 2) - the amount to be transferred to/from Customers' account
	- `details_` varchar(2048) - Transfer/Payment details
    - `order_id_` int8 -       - If not NULL, trunsactions refers to the Customer's order
    - `description_` varchar(2048) - Additional info about transfer
	- `allow_indebted` bool   - allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
	- Returns `value` numeric(20, 2) - new amount of Customer's account
*/ 
-- select add_transaction(15, 2, -33.33, 'Testing transaction - 33.33', null, 'Empty description', false);
-- select add_transaction(15, 2, 100.33, 'Testing transaction +100.33', null, 'Empty description', false);
-- select add_transaction(15, 2, 100.33, 'Testing transaction +100.33',    1, 'Empty description', false);
drop function if exists add_transaction;
create or replace function add_transaction(
	author_id_ int8, customer_id_ int8, value_ numeric(20, 2), details_ varchar(2048), order_id_ int8, description_ varchar(2048), allow_indebted bool)
returns table (account numeric(20, 2), error text)
language plpgsql
as $$ 
declare
    name_ text;
    account_ numeric(20, 2);
	result_account numeric(20, 2);
	result_error text;
begin
	call raise_notice(format('add_transaction | start with:'));	
	call raise_notice(format('add_transaction | value  : ' || value_));	
	select c.account, c.name into account_, name_ from public.customer c
	 	where c.id = customer_id_;
	call raise_notice(format('add_transaction | name_   : ' || name_));	
	call raise_notice(format('add_transaction | account_: ' || account_));	
    if (not allow_indebted and account_ + value_ > 0.0) or (allow_indebted and account_ > 0.0) then
		execute 'update public.customer SET account = ' || account_ + value_
			|| ' where id = ' || customer_id_;
		if order_id_ is null then
			execute 'insert into public.transaction (author_id, customer_id, customer_account, value, details, description) values ('
				|| author_id_ || ', '
				|| customer_id_ || ', '
				|| account_ || ', '
				|| value_ || ', '
				|| format('%L', details_) || ', '
				|| format('%L', description_)
			|| ');';
		else
			execute 'insert into public.transaction (author_id, customer_id, customer_account, value, details, order_id, description) values ('
				|| author_id_ || ', '
				|| customer_id_ || ', '
				|| account_ || ', '
				|| value_ || ', '
				|| format('%L', details_) || ', '
				|| order_id_ || ', '
				|| format('%L', description_)
			|| ');';
		end if;
		select c.account into result_account from public.customer c
		 	where c.id = customer_id_;
		select null into result_error;
	else
		select c.account into result_account from public.customer c
		 	where c.id = customer_id_;
		select 'Error: Insufficient funds' into result_error;
    end if;
	call raise_notice('add_transaction | result_account: ' || result_account);
	call raise_notice('add_transaction | result_error  : ' || coalesce(result_error, ''));
	return query values (result_account, result_error);
end
$$;

select *, t.customer_account + t.value as after_ from public."transaction" t 

