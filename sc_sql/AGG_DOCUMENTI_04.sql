/* 
*******************************************************************************************
AGGIUNTA CAMPI PER DETERMINAZIONE SOGGETTO IN SOTTORIGA ARTICOLO NEI DETTAGLI DEI DOCUMENTI
*******************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 FAB_SYSORD varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_ORD_DD_FAB_SYSORD] DEFAULT ('') FOR [FAB_SYSORD]
go

UPDATE U_ORD_DD SET FAB_SYSORD = ''

--*******************************************************************************************

ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 FAB_SYSORF varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_ORF_DD_FAB_SYSORF] DEFAULT ('') FOR [FAB_SYSORF]
go

UPDATE U_ORF_DD SET FAB_SYSORF = ''

