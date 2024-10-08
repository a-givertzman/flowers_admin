DROP TYPE public."customer_role_enum";
CREATE TYPE public."customer_role_enum" AS ENUM (
	'admin',
	'operator',
	'customer');

DROP TABLE public.customer_order;
CREATE TABLE public.customer_order (
	id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	customer_id int8 NOT NULL,
	purchase_item_id int8 NOT NULL,
	count int8 DEFAULT 0 NOT NULL,
	paid numeric(20, 2) NOT NULL,
	distributed int8 DEFAULT 0 NOT NULL,
	to_refound numeric(20, 2) NOT NULL,
	refounded numeric(20, 2) NOT NULL,
	description text NOT NULL,
	created timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted timestamp NULL,
	CONSTRAINT customer_order_pkey PRIMARY KEY (id),
	unique (customer_id, purchase_item_id)
);
-- Testing
INSERT INTO public.customer_order (id, customer_id, purchase_item_id, count, paid, distributed, to_refound, refounded, description, created, updated, deleted) VALUES(1, 2, 1, 13, 0.77, 0, 0.00, 0.00, '...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', NULL);
INSERT INTO public.customer_order (id, customer_id, purchase_item_id, count, paid, distributed, to_refound, refounded, description, created, updated, deleted) VALUES(2, 2, 2, 17, 0.00, 0, 0.00, 0.00, '...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', NULL);
INSERT INTO public.customer_order (id, customer_id, purchase_item_id, count, paid, distributed, to_refound, refounded, description, created, updated, deleted) VALUES(3, 2, 3, 5, 1.33, 0, 0.00, 0.00, '...', '2023-11-05 21:49:42.251', '2023-11-05 21:49:42.251', NULL);
INSERT INTO public.customer_order (id, customer_id, purchase_item_id, count, paid, distributed, to_refound, refounded, description, created, updated, deleted) VALUES(4, 15, 3, 2, 0.00, 0, 0.00, 0.00, '', '2024-09-10 14:17:58.635', '2024-09-10 14:17:58.635', NULL);
