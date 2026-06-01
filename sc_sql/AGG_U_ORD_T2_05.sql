/* 
**********************************************************************************************
AGGIUNTA CAMPO "EC_ORDER_ID" IN ORDINI CLIENTI: ID ORDINE CORRISPONDENTE SU E-COMMERCE
**********************************************************************************************
*/

ALTER TABLE [dbo].[U_ORD_T2] ADD
	EC_ORDER_ID INT NOT NULL CONSTRAINT [DF_U_ORD_T2_EC_ORDER_ID] DEFAULT (0),
	EC_ORDER_CODE varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_T2_EC_ORDER_CODE] DEFAULT ('')
GO
