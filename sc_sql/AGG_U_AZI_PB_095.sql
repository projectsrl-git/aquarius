
/*
*** Variabile per l' opzione gestita nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Magazzini per produz.  macchine industriali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Magazzino esterno fornitore
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_MAGPMIEST varchar (6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_MAGPMIEST] DEFAULT ('')
GO

-- SE AZIENDA PRODUZIONE MACCHINE INDUSTRIALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_MAGPMIEST = CASE WHEN COALESCE((SELECT AZI_PRMMOL FROM U_AZI_PA),0) = 1 THEN 'NGB' ELSE '' END
