/* Procedure SET_ORDER_PAYMENT
    - `author_id_`                  - Person who performed the payment
    - `customer_ids_` int8[],       - Cuctomers which Order's will be proccesed
    - `purchase_item_ids_` int8[]   - Order item's which will be proccesed
    - `description_` text           - Additional info about payment
    - `allow_indebted` bool         - allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
    - Returns ???
*/
drop function if exists set_order_payment;
create or replace function set_order_payment(
    author_id_ int8,                    -- customer_id, Person who performed the payment
    customer_ids_ int8[],               -- Cuctomers which Order's will be proccesed
    purchase_item_ids_ int8[],          -- Order item's which will be proccesed
    description_ text,                  -- Additional info about payment
    allow_indebted_ bool                -- allow the transfer to be done with insufficient funds, transfer will be completed if account is positive but insufficient
)
returns table (account numeric(20, 2), error text)
language plpgsql
as $$
declare
    author text;
    item_id int8;
    order_id_ int8;
    customer_id_ int8;
    customer_name_ text;
    count_ int8;
    paid_ numeric(20, 2);       -- уже оплачено
    cost numeric(20, 2);        -- стоимость
    to_pay numeric(20, 2);      -- к оплате
    to_refound numeric(20, 2);      -- к оплате
    sale_price_ numeric(20, 2);     -- цена за единицу
    shipping_ numeric(20, 2);       -- стоимость доставки за единицу
    details_ varchar(2048);
    product_name text = 'ProductName';
    tr_acc numeric(20, 2);
    tr_err text;
    t text;
    result_account numeric(20, 2);
    result_error text = null;
begin
    select name into author from customer where id = author_id_;
    call log_info(format('set_order_payment | Performing payment: %L (%s)', description_, author));
    foreach item_id in array purchase_item_ids_ loop 
        call log_info(format('set_order_payment |   purchase_item_id: %L', item_id));
        -- loop over all customer orders
        for order_id_, customer_id_, count_, paid_ in
            select id, customer_id, count, paid from customer_order co 
                where co.purchase_item_id = item_id
                and co.customer_id = any ( coalesce(NULLIF(customer_ids_, array[]::int8[]), array[co.customer_id]) )
        loop
            select sale_price, shipping into sale_price_, shipping_ from purchase_item pitem
                where pitem.id = item_id;
            call log_info(format('set_order_payment |        paid_ type : %L', pg_typeof(paid_)));
            call log_info(format('set_order_payment |     customer_id_: %s ...', customer_id_, customer_name_));
            cost := (cast(sale_price_ as numeric(20, 2)) + cast(shipping_ as numeric(20, 2))) * cast(count_ as numeric(20, 2));
            call log_info(format('set_order_payment |        cost type : %L', pg_typeof(cost)));
            call log_info(format('set_order_payment |     Order: [%s] %s', order_id_, product_name));
            call log_info(format('set_order_payment |        count_: %L', count_));
            call log_info(format('set_order_payment |        cost  : %s', cost));
            call log_info(format('set_order_payment |        paid_ : %L', paid_));
            case
                when paid_ < cost then
                    to_pay := cast(cost as numeric(20, 2)) - cast(paid_ as numeric(20, 2));
                    call log_info(format('set_order_payment |        to_pay type : %L', pg_typeof(to_pay)));
                    select format('Payment to Order [%s] "%s"', order_id_, product_name) into details_;
                    call log_info(format('set_order_payment |        to pay: %s', to_pay));
                    call log_info(format('set_order_payment |        details: %s', details_));
                    select add_transaction(
	                    author_id_,         -- int8, 
                        customer_id_,       -- int8, 
                        cast(to_pay as numeric(20, 2)),             -- value_ numeric(20, 2), 
                        details_,           -- varchar(2048), 
                        order_id_,          -- int8, 
                        description_,       -- varchar(2048), 
                        allow_indebted_     -- bool
                    ) into tr_acc, tr_err;
                    call log_info(format('set_order_payment |        tr_acc: %s', tr_acc));
                    call log_info(format('set_order_payment |        tr_err: %s', tr_err));
                    execute 'update public.customer_order SET paid = ' || to_pay_
                        || ' where id = ' || order_id_;
                when paid_ = cost then
                    call log_info(format('set_order_payment |        Customer %L, Order %L: Already paid', customer_id_, order_id_));
                else -- paid_ > cost
                    select paid_ - cost into to_refound;
                    call log_info(format('set_order_payment |        to refound: %L', to_refound));
                    call log_info(format('set_order_payment |        Customer %L, Order %L: To be refound: %s', customer_id_, order_id_, paid_ - cost));
            end case;
        end loop;
    end loop;
    -- call log_info('set_order_payment | result_account: ' || result_account);
    call log_info('set_order_payment |   result_error  : ' || coalesce(result_error, '-'));
    return query values (result_account, result_error);
end
$$;
--
-- Testing
-- select * from set_order_payment(
--     1,	-- author
--     array[]::int[],	-- customer's
--     array[1, 2],	-- purchase_item's
--     'TEST Payment',	-- description
--     false		-- allow_indebted
-- );
