/* 
*****************************************************
INSERIMENTO NUOVO CAMPO PER LEGAME ORDINI WOOCOMMERCE
*****************************************************

*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 WC_ORDER_KEY varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_TT_WC_ORDER_KEY] DEFAULT (''),
 	 WC_DATE_MODIFIED varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT DF_U_ORD_TT_WC_DATE_MODIFIED DEFAULT ('')
go
