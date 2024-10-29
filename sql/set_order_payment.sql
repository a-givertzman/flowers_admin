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
returns table (account numeric, error text)
language plpgsql
as $$
declare
    author text;
    item_id int8;
    order_id_ int8;
    customer_id_ int8;
    count_ int8;
    paid_ numeric;       -- уже оплачено
    cost numeric;        -- стоимость
    to_pay numeric;      -- к оплате
    to_refound numeric;      -- к оплате
    sale_price_ numeric;     -- цена за единицу
    shipping_ numeric;       -- стоимость доставки за единицу
    details_ varchar(2048);
    product_name text;
    tr_acc numeric;
    tr_err text;
    t text;
    customer_name text;
    customer_account numeric;
    result_error text = null;
begin
    select name into author from customer where id = author_id_;
    call log_info(format('set_order_payment | Performing payment: %s (%s)', description_, author));
    foreach item_id in array purchase_item_ids_ loop 
        call log_info(format('set_order_payment |   purchase_item_id: %s', item_id));
        -- loop over all customer orders
        for order_id_, customer_id_, count_, paid_ in
            select id, customer_id, count, paid from customer_order co 
                where co.purchase_item_id = item_id
                and co.customer_id = any ( coalesce(nullif(customer_ids_, array[]::int8[]), array[co.customer_id]) )
        loop
            select sale_price, shipping, coalesce(name, (select name from product p where p.id = pitem.product_id)) into sale_price_, shipping_, product_name from purchase_item pitem
                where pitem.id = item_id;
            select c.account, c.name into customer_account, customer_name from public.customer c
                where c.id = customer_id_;
            call log_info(format('set_order_payment |     customer_id_: [%s] "%s" ( %s )', customer_id_, customer_name, customer_account));
            cost := (sale_price_ + shipping_) * count_;
            call log_info(format('set_order_payment |     Order: [%s] "%s"', order_id_, product_name));
            call log_info(format('set_order_payment |        count_: %s', count_));
            call log_info(format('set_order_payment |        cost  : %s', cost));
            call log_info(format('set_order_payment |        paid_ : %s', paid_));
            case
                when paid_ < cost then
                    to_pay := cast(cost as numeric) - cast(paid_ as numeric);
                    details_ := format('Payment to Order [%s] "%s"', order_id_, product_name);
                    if customer_account < to_pay then
                        to_pay := customer_account;
                    end if;
                    if to_pay != 0 then
                        call log_info(format('set_order_payment |        to_pay: %s', to_pay));
                        call log_info(format('set_order_payment |        details: %s', details_));
                        select * into tr_acc, tr_err from add_transaction(
                            author_id_,         -- int8, 
                            customer_id_,       -- int8, 
                            - to_pay,             -- value_ numeric, 
                            details_,           -- varchar(2048), 
                            order_id_,          -- int8, 
                            description_,       -- varchar(2048), 
                            allow_indebted_     -- bool
                        );
                        call log_info(format('set_order_payment |        tr_acc: %s', tr_acc));
                        call log_info(format('set_order_payment |        tr_err: %s', tr_err));
                        if (tr_err <> '') IS NOT true then
                            execute 'update public.customer_order SET paid = ' || paid_ + to_pay
                                || ' where id = ' || order_id_;
                            call log_info(format('set_order_payment |        paid: %s', to_pay));
                        else
                            call log_info(format('set_order_payment |        payment fail'));
                        end if;
                    else
                        call log_info(format('set_order_payment |        SKIPED, possible Insufficient funds'));
                    end if;
                when paid_ = cost then
                    call log_info(format('set_order_payment |        Customer %s, Order %s: Already paid', customer_id_, order_id_));
                else -- paid_ > cost => Refounding...
                    to_refound := paid_ - cost;
                    details_ := format('Refound from Order [%s] "%s"', order_id_, product_name);
                    call log_info(format('set_order_payment |        to_refound: %s', to_refound));
                    call log_info(format('set_order_payment |        details: %s', details_));
                    select * into tr_acc, tr_err from add_transaction(
	                    author_id_,         -- int8, 
                        customer_id_,       -- int8, 
                        to_refound,         -- value_ numeric, 
                        details_,           -- varchar(2048), 
                        order_id_,          -- int8, 
                        description_,       -- varchar(2048), 
                        true     -- bool
                    );
                    call log_info(format('set_order_payment |        tr_acc: %s', tr_acc));
                    call log_info(format('set_order_payment |        tr_err: %s', tr_err));
                    if (tr_err <> '') IS NOT true then
                        execute 'update public.customer_order SET paid = ' || paid_ - to_refound
                            || ' where id = ' || order_id_;
                        call log_info(format('set_order_payment |        refounded: %s', to_refound));
                    else
                        call log_info(format('set_order_payment |        refounded fail'));
                    end if;
            end case;
        end loop;
    end loop;
    -- call log_info('set_order_payment | result_account: ' || result_account);
    -- call log_info('set_order_payment |   result_error  : ' || coalesce(result_error, '-'));
    return query values (0.0, result_error);
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
