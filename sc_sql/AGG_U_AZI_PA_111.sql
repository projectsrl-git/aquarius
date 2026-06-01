/* 
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione dadi pressati
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	 AZI_CCORIGA [bit] NULL
go 
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_CCORIGA] DEFAULT (0) FOR [AZI_CCORIGA]
go


UPDATE u_azi_pa SET AZI_CCORIGA = 0













