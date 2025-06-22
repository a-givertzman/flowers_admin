-- DROP TABLE public."transaction";

-- public."transaction" definition
CREATE TABLE public."transaction" (
	id bigserial PRIMARY KEY not null,
	author_id int8 NOT NULL,                      -- Person who created the transaction
	customer_id int8 NOT NULL,                    -- Cuctomer which account proccesed
	customer_account numeric(20, 2) NOT NULL,     -- Customer's account before transaction
	value numeric(20, 2) NOT NULL,                -- The amount transferred to/from Customers' account
	details varchar(2048) NOT NULL,               -- Transfer/Payment details
	order_id int8 NULL,                           -- If not NULL, trunsactions refers to the Customer's order
	description varchar(2048) NOT NULL,           -- Additional info about transfer
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL
);

-- For testing
INSERT INTO public.transaction (id, author_id, customer_id, customer_account, value, details, order_id, description, created, updated, deleted) VALUES
	(1, 15, 3, 0.00, 100.00, 'Пополнение баланса пользователя на +100.00', NULL, 'Description to the transaction', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', NULL),
	(2, 15, 2, 0.00, 200.00, 'Пополнение баланса пользователя на +200.00', NULL, 'Description to the transaction', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', NULL);
alter sequence transaction_id_seq restart with 3;
