/* 
*****************************************************************************
INSERIMENTO CAMPO "Nr. Colli" in tabella di log dettagli DDT
*****************************************************************************
*/
ALTER TABLE [dbo].[L_BOL_DD] ADD 
	 ORD_NCOLLI numeric (4,0)
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[L_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_DD_ORD_NCOLLI] DEFAULT (0) FOR [ORD_NCOLLI]
go

UPDATE L_BOL_DD SET ORD_NCOLLI = 0

