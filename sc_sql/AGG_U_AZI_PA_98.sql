/* 
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la gestione della produzione dadi pressati
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	 azi_prgdadi [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_azi_prgdadi] DEFAULT (0) FOR [azi_prgdadi]
go


UPDATE u_azi_pa SET azi_prgdadi = 0 