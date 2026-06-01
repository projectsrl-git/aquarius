/*    
*********************************************************************************************
INSERIMENTO CAMPO DESCRIZIONE PERSONALIZZATA PER GESTIONE PERSONALIZZAZIONE REPORT DOCUMENTI
*********************************************************************************************
*/

ALTER TABLE [dbo].[U_FAT_DD] ADD 
	 ORD_DSPERS TEXT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_DD_ORD_DSPERS] DEFAULT ('') FOR [ORD_DSPERS]
go

UPDATE U_FAT_DD SET ORD_DSPERS = ''
