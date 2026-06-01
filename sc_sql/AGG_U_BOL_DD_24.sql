/*    
*********************************************************************************************
INSERIMENTO CAMPO DESCRIZIONE PERSONALIZZATA PER GESTIONE PERSONALIZZAZIONE REPORT DOCUMENTI
*********************************************************************************************
*/


ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 ORD_DSPERS TEXT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_DSPERS] DEFAULT ('') FOR [ORD_DSPERS]
go

UPDATE U_BOL_DD SET ORD_DSPERS = ''

