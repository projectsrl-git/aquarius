if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WC_ORDERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[WC_ORDERS]
GO

CREATE TABLE [dbo].[WC_ORDERS] (
	id_unique uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	LOG_DATA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_LOG_DATA DEFAULT (''),
	LOG_ORA varchar(8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_LOG_ORA DEFAULT (''),
	LOG_CODOPE varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_LOG_CODOPE DEFAULT (''),
	LOG_NOMOPE varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_LOG_NOMOPE DEFAULT (''),
	id integer NOT NULL CONSTRAINT df_wc_orders_id DEFAULT (0),
	parent_id integer NOT NULL CONSTRAINT df_wc_orders_parent_id DEFAULT (0),
	number varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_number DEFAULT (''),
	order_key varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_order_key DEFAULT (''),
	created_via varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_created_via DEFAULT (''),
	version integer NOT NULL CONSTRAINT df_wc_orders_version DEFAULT (0),
	status varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_status DEFAULT (''),
	currency varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_currency DEFAULT (''),
	date_created varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_created DEFAULT (''),
	date_created_gmt varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_created_gmt DEFAULT (''),
	date_modified varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_modified DEFAULT (''),
	date_modified_gmt varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_modified_gmt DEFAULT (''),
	discount_total varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_discount_total DEFAULT (''),
	discount_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_discount_tax DEFAULT (''),
	shipping_total varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_total DEFAULT (''),
	shipping_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_tax DEFAULT (''),
	cart_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_cart_tax DEFAULT (''),
	total varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_total DEFAULT (''),
	total_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_total_tax DEFAULT (''),
	prices_include_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_prices_include_tax DEFAULT (''),
	customer_id integer NOT NULL CONSTRAINT df_wc_orders_customer_id DEFAULT (0),
	customer_ip_address varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_customer_ip_address DEFAULT (''),
	customer_user_agent varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_customer_user_agent DEFAULT (''),
	customer_note varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_customer_note DEFAULT (''),
	--billing	object	Billing address. See Order - Billing properties
	billing_first_name varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_first_name DEFAULT (''),
	billing_last_name varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_last_name DEFAULT (''),
	billing_company varchar(200) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_company DEFAULT (''),
	billing_address_1 varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_address_1 DEFAULT (''),
	billing_address_2 varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_address_2 DEFAULT (''),
	billing_city varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_city DEFAULT (''),
	billing_state varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_state DEFAULT (''),
	billing_postcode varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_postcode DEFAULT (''),
	billing_country varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_country DEFAULT (''),
	billing_email varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_email DEFAULT (''),
	billing_phone varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_billing_phone DEFAULT (''),
	--shipping	object	Shipping address. See Order - Shipping properties
	shipping_first_name varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_first_name DEFAULT (''),
	shipping_last_name varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_last_name DEFAULT (''),
	shipping_company varchar(200) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_company DEFAULT (''),
	shipping_address_1 varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_address_1 DEFAULT (''),
	shipping_address_2 varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_address_2 DEFAULT (''),
	shipping_city varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_city DEFAULT (''),
	shipping_state varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_state DEFAULT (''),
	shipping_postcode varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_postcode DEFAULT (''),
	shipping_country varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_shipping_country DEFAULT (''),
	payment_method varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_payment_method DEFAULT (''),
	payment_method_title varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_payment_method_title DEFAULT (''),
	transaction_id varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_transaction_id DEFAULT (''),
	date_paid varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_paid DEFAULT (''),
	date_paid_gmt varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_paid_gmt DEFAULT (''),
	date_completed varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_completed DEFAULT (''),
	date_completed_gmt varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_date_completed_gmt DEFAULT (''),
	cart_hash varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_orders_payment_cart_hash DEFAULT (''),
	--meta_data	array	Meta data. See Order - Meta data properties
	--line_items	array	Line items data. See Order - Line items properties
	--tax_lines	array	Tax lines data. See Order - Tax lines properties read-only
	--shipping_lines	array	Shipping lines data. See Order - Shipping lines properties
	--fee_lines	array	Fee lines data. See Order - Fee lines properties
	--coupon_lines	array	Coupons line data. See Order - Coupon lines properties
	--refunds	array	List of refunds. See Order - Refunds properties read-only
	set_paid BIT NOT NULL CONSTRAINT df_wc_orders_set_paid DEFAULT (0)
) ON [PRIMARY] --TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[WC_ORDERS] WITH NOCHECK ADD 
	CONSTRAINT [PK_WC_ORDERS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
