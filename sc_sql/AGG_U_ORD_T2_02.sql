/* 
*************************************************************************************************************************
AGGIUNTA CAMPO "ORD_IDNSO" IN ORDINI CLIENTI: ENDPOINT CLIENTE LEGAME FATTURA ELETTRONICA CON NODO SMISTAMENTO ORDINI
*************************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ORD_T2] ADD 
	ORD_IDNSO varchar(6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_T2_ORD_IDNSO] DEFAULT ('')
go
