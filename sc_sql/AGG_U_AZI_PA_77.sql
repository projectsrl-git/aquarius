
/*
*** Variabile per l'opzione "Lead time di default per data consegna (giorni)" gestita nella scheda "Altro", sottoscheda "Codici di default" 
*** dei parametri di sistama nel "form\menu_azi000.scx"
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_GGCONS numeric(3,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_GGCONS] DEFAULT (0) FOR [AZI_GGCONS]
go

UPDATE u_azi_pa SET AZI_GGCONS = 0

