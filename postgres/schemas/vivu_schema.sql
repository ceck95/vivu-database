/*
* @Author: chienpm
* @Date:   2016-07-12 09:43:00
* @Last modified by:   nhutdev
* @Last modified time: 21-09-16 11:45:34
*/


SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;


CREATE SCHEMA IF NOT EXISTS vv;


-- Create hc.customer table

-- DROP TABLE hc.customer;

CREATE TABLE vv.customer
(
    id serial NOT NULL,
    email text,
    phone text NOT NULL,
    full_name text NOT NULL,
    dob timestamp with time zone,
    gender text NOT NULL,
    password_hash text,
    password_reset_token text,
    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
    created_by bigint,
    updated_by bigint,
    status int DEFAULT 1,

    CONSTRAINT customer_pkey PRIMARY KEY (id),
    CONSTRAINT customer_phone_unique UNIQUE(phone)
);

CREATE TABLE vv.customer_address
(
    id serial NOT NULL,
    customer_id int,
    type text,
    is_default boolean DEFAULT false,
    full_name text,
    phone text,
    street text,
    city text,
    postal_code text,
    state text,
    country_code text,
    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
    created_by bigint,
    updated_by bigint,
    status int DEFAULT 1,

    CONSTRAINT customer_address_pkey PRIMARY KEY (id)
);

-- Create category table

-- DROP TABLE category;

CREATE TABLE vv.category
(
    id serial NOT NULL,
    name text NOT NULL,
    priority int NOT NULL,
    notes text,
    url_key text NOT NULL,
    meta_desc jsonb,
    status int DEFAULT 1,
    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    created_by bigint,
    updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_by bigint,
    CONSTRAINT category_pkey PRIMARY KEY (id)
);

-- Create category_group table

-- DROP TABLE category_group;

CREATE TABLE vv.category_group
(
  id serial NOT NULL,
  name text NOT NULL,
  priority int NOT NULL,
  category_id int NOT NULL REFERENCES vv.category (id),
  notes text,
  url_key text NOT NULL,
  meta_desc jsonb,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT category_group_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.product
(
  id serial NOT NULL,
  category_id int NOT NULL REFERENCES vv.category (id),
  name text NOT NULL,
  sku text NOT NULL,
  meta_desc jsonb,
  notes text,
  details text,
  url_key text NOT NULL,
  image_path text NOT NULL,
  base_price real NOT NULL,
  is_sold_old boolean DEFAULT false,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT product_pkey PRIMARY KEY (id),
  CONSTRAINT product_sku_unique UNIQUE(sku)
);

CREATE TABLE vv.product_color
(
  id serial NOT NULL,
  product_id  int NOT NULL REFERENCES vv.product (id),
  color_name text NOT NULL,
  refer_product_image_path text NOT NULL,
  price real NOT NULL DEFAULT 0,
  priority int NOT NULL,
  is_sold_out boolean DEFAULT false,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT product_color_pkey PRIMARY KEY (id)

);

CREATE TABLE vv.product_color_preview_image
(
  id serial NOT NULL,
  product_color_id int NOT NULL REFERENCES vv.product_color(id),
  image_path text NOT NULL,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT product_color_preview_image_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.quote
(
  id serial NOT NULL,
  order_id int NOT NULL,
  subtotal real,
  grand_total real ,
  checkout_medthod text,
  customer_id int REFERENCES vv.customer(id),
  customer_address_id int REFERENCES vv.customer_address(id),
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT quote_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.quote_item
(
  id serial NOT NULL,
  quote_id int NOT NULL REFERENCES vv.quote(id),
  product_id int NOT NULL REFERENCES vv.product(id),
  selected_product_color_id int NOT NULL REFERENCES vv.product_color(id),
  quantity int NOT NULL,
  base_price real NOT NULL,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT quote_item_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.quote_payment
(
  id serial NOT NULL,
  quote_id int NOT NULL REFERENCES vv.quote(id),
  method text NOT NULL,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT quote_payment_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.sales_order
(
  id serial NOT NULL,
  order_status int NOT NULL,
  customer_id int NOT NULL REFERENCES vv.customer(id),
  customer_full_name text NOT NULL,
  customer_phone text NOT NULL,
  quote_id int NOT NULL REFERENCES vv.quote(id),
  shipping_address_id int NOT NULL REFERENCES vv.customer_address(id),
  shipping_amount real NOT NULL,
  subtotal real NOT NULL,
  grand_total real NOT NULL,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT sales_order_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.order_item
(
  id serial NOT NULL,
  order_id int NOT NULL REFERENCES vv.sales_order(id),
  quote_item_id int NOT NULL REFERENCES vv.quote_item(id),
  product_id int NOT NULL REFERENCES vv.product(id),
  selected_product_color_id int NOT NULL REFERENCES vv.product_color(id),
  quantity bigint NOT NULL,
  base_price real NOT NULL,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT order_item_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.order_payment
(
  id serial NOT NULL,
  order_id int NOT NULL REFERENCES vv.sales_order(id),
  method text NOT NULL,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT order_payment_pkey PRIMARY KEY (id)
);

CREATE TABLE vv.order_status_history
(
  id serial NOT NULL,
  order_id int NOT NULL REFERENCES vv.sales_order(id),
  order_status int NOT NULL,
  notes text,
  status int DEFAULT 1,
  created_at timestamp with time zone NOT NULL DEFAULT NOW(),
  created_by bigint,
  updated_at timestamp with time zone NOT NULL DEFAULT NOW(),
  updated_by bigint,
  CONSTRAINT order_status_history_pkey PRIMARY KEY (id)
);

ALTER TABLE vv.quote ADD CONSTRAINT quote_sales_order_frk FOREIGN KEY (order_id) REFERENCES vv.sales_order (id) MATCH FULL;
