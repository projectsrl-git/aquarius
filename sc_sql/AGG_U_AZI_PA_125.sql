/*
*** Campi della scheda Contabilità/Tesoreria
*   Codice SIA e DIRECTORY DI OUTPUT dei file CBI creati
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_CODSIA varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 AZI_DIRCBI varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_CODSIA] DEFAULT (0) FOR [AZI_CODSIA],
	CONSTRAINT [DF_U_AZI_PA_AZI_DIRCBI] DEFAULT (0) FOR [AZI_DIRCBI]
go

UPDATE U_AZI_PA SET AZI_CODSIA = ''
UPDATE U_AZI_PA SET AZI_DIRCBI = ''

