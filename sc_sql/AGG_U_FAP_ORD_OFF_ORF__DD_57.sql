/*    
*********************************************************************************************
INSERIMENTO CAMPO DESCRIZIONE PERSONALIZZATA PER GESTIONE PERSONALIZZAZIONE REPORT DOCUMENTI
*********************************************************************************************
*/


ALTER TABLE [dbo].[U_FAP_DD] ADD 
	 ORD_DSPERS TEXT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_DD_ORD_DSPERS] DEFAULT ('') FOR [ORD_DSPERS]
go

UPDATE U_FAP_DD SET ORD_DSPERS = ''



ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 ORD_DSPERS TEXT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_DSPERS] DEFAULT ('') FOR [ORD_DSPERS]
go

UPDATE U_ORD_DD SET ORD_DSPERS = ''


ALTER TABLE [dbo].[U_OFF_DD] ADD 
	 ORD_DSPERS TEXT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_DD_ORD_DSPERS] DEFAULT ('') FOR [ORD_DSPERS]
go

UPDATE U_OFF_DD SET ORD_DSPERS = ''


ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORD_DSPERS TEXT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_DSPERS] DEFAULT ('') FOR [ORD_DSPERS]
go

UPDATE U_ORF_DD SET ORD_DSPERS = ''
