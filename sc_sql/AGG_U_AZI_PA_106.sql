/* 
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione dadi pressati
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	 azi_numautrda varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 AZI_DDTFATALL [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_numautrda] DEFAULT ('') FOR [azi_numautrda],
	CONSTRAINT [DF_u_azi_pa_AZI_DDTFATALL] DEFAULT (0) FOR [AZI_DDTFATALL]
go


UPDATE u_azi_pa SET AZI_DDTFATALL = 0 
UPDATE U_AZI_PA SET azi_numautrda = '3'