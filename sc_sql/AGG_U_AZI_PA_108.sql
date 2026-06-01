/* 
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione dadi pressati
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	 AZI_INTRA_MITTE varchar(04) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_NOFLU varchar(12) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_COSDO varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_CFPIV varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_CAPRE varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_CASIP varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_PIVSO varchar(11) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_CONAT varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 AZI_INTRA_PRODE varchar(02) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_INTRA_MITTE] DEFAULT ('') FOR [AZI_INTRA_MITTE],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_NOFLU] DEFAULT ('') FOR [AZI_INTRA_NOFLU],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_COSDO] DEFAULT ('') FOR [AZI_INTRA_COSDO],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_CFPIV] DEFAULT ('') FOR [AZI_INTRA_CFPIV],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_CAPRE] DEFAULT ('') FOR [AZI_INTRA_CAPRE],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_CASIP] DEFAULT ('') FOR [AZI_INTRA_CASIP],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_PIVSO] DEFAULT ('') FOR [AZI_INTRA_PIVSO],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_CONAT] DEFAULT ('') FOR [AZI_INTRA_CONAT],
	CONSTRAINT [DF_u_azi_pa_AZI_INTRA_PRODE] DEFAULT ('') FOR [AZI_INTRA_PRODE]
go



UPDATE U_AZI_PA SET AZI_INTRA_MITTE = ''
UPDATE u_azi_pa SET AZI_INTRA_NOFLU = ''
UPDATE u_azi_pa SET AZI_INTRA_COSDO = ''
UPDATE u_azi_pa SET AZI_INTRA_CFPIV = ''
UPDATE u_azi_pa SET AZI_INTRA_CAPRE = ''
UPDATE u_azi_pa SET AZI_INTRA_CASIP = ''
UPDATE u_azi_pa SET AZI_INTRA_PIVSO = ''
UPDATE u_azi_pa SET AZI_INTRA_CONAT = ''
UPDATE u_azi_pa SET AZI_INTRA_PRODE = ''