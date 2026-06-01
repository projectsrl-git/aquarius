if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WC_ORDER_LINE_ITEMS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[WC_ORDER_LINE_ITEMS]
GO

CREATE TABLE [dbo].[WC_ORDER_LINE_ITEMS] (
	id_unique uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	LOG_DATA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_LOG_DATA DEFAULT (''),
	LOG_ORA varchar(8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_LOG_ORA DEFAULT (''),
	LOG_CODOPE varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_LOG_CODOPE DEFAULT (''),
	LOG_NOMOPE varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_LOG_NOMOPE DEFAULT (''),
	id integer NOT NULL CONSTRAINT df_wc_order_line_items_id DEFAULT (0),
	id_order integer NOT NULL CONSTRAINT df_wc_order_line_items_id_order DEFAULT (0),
	order_key varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_order_key DEFAULT (''),
	customer_id integer NOT NULL CONSTRAINT df_wc_order_line_items_customer_id DEFAULT (0),
	name varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_name DEFAULT (''),
	product_id integer NOT NULL CONSTRAINT df_wc_order_line_items_product_id DEFAULT (0),
	variation_id integer NOT NULL CONSTRAINT df_wc_order_line_items_variation_id DEFAULT (0),
	quantity integer NOT NULL CONSTRAINT df_wc_order_line_items_quantity DEFAULT (0),
	tax_class integer NOT NULL CONSTRAINT df_wc_order_line_items_tax_class DEFAULT (0),
	subtotal varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_subtotal DEFAULT (''),
	subtotal_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_subtotal_tax DEFAULT (''),
	total varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_total DEFAULT (''),
	total_tax varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_total_tax DEFAULT (''),
	--taxes	array	Line taxes. See Order - Taxes properties read-only
	--meta_data	array	Meta data. See Order - Meta data properties
	sku varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_sku DEFAULT (''),
	price varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT df_wc_order_line_items_price DEFAULT ('')
) ON [PRIMARY] --TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[WC_ORDER_LINE_ITEMS] WITH NOCHECK ADD 
	CONSTRAINT [PK_WC_ORDER_LINE_ITEMS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
