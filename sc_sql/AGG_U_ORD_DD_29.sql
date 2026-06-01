/* 
*****************************************************
INSERIMENTO NUOVI CAMPI PER LEGAME ORDINI WOOCOMMERCE
*****************************************************

*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 WC_ORDER_KEY varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_DD_WC_ORDER_KEY] DEFAULT (''),
	 WC_ORDER_LINE_ITEMS_ID INTEGER NOT NULL CONSTRAINT [DF_U_ORD_DD_WC_ORDER_LINE_ITEMS_ID] DEFAULT (0)
go
