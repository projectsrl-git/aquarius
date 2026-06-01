/* 
********************************************************************************
AGGIUNTA CAMPO "WC_CUSTOMER_ID" IN ANAGRAFICA CLIENTI PER LEGAME CON WOOCOMMERCE
********************************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	WC_CUSTOMER_ID INTEGER CONSTRAINT [DF_U_ANA_CL_WC_CUSTOMER_ID] DEFAULT (0)
go
