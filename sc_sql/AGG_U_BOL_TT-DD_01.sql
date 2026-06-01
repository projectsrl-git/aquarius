/* 
*****************************************************************************
AGGIORNAMENTO DIMENSIONE CAMPI "Nr. Colli" in testata e dettagli DDT
*****************************************************************************
*/

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	 ORD_COLLI varchar(8) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	 ORD_COLLI varchar(8) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN 
	 ORD_NCOLLI numeric (8,0)
go
ALTER TABLE [dbo].[L_BOL_DD] ALTER COLUMN 
	 ORD_NCOLLI numeric (8,0)
go
