
/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione legno truciolare" 
*** dei parametri di sistama nel "form\menu_azi000.scx":
***		- Attiva stato di MANUTENZIONE (impedisce l'utilizzo del programma di avanzamento PRESSA)
***		- Attiva stato di MANUTENZIONE (impedisce l'utilizzo del programma di avanzamento LEVIGA)
***		- Attiva stato di MANUTENZIONE (impedisce l'utilizzo del programma di avanzamento NOBILITA)
*/

ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_LCKPRE bit NULL,
	AZI_LCKLEV bit NULL,
	AZI_LCKNOB bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_LCKPRE] DEFAULT (0) FOR [AZI_LCKPRE],
	CONSTRAINT [DF_u_azi_pa_AZI_LCKLEV] DEFAULT (0) FOR [AZI_LCKLEV],
	CONSTRAINT [DF_u_azi_pa_AZI_LCKNOB] DEFAULT (0) FOR [AZI_LCKNOB]
go

UPDATE u_azi_pa SET AZI_LCKPRE = 0
UPDATE u_azi_pa SET AZI_LCKLEV = 0
UPDATE u_azi_pa SET AZI_LCKNOB = 0
