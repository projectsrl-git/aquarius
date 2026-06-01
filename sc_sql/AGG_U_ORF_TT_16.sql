
/* 
*****************************************************************************
INSERIMENTO CAMPO "Ordine pianificato (non ricalcola lead time in accettaz.)"
*****************************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_PIANIF bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_PIANIF] DEFAULT (0) FOR [ORD_PIANIF]
go

UPDATE U_ORF_TT SET ORD_PIANIF = 0

