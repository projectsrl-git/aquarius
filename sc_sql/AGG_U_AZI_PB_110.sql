
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Partitari" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Attiva la possibilità di inserire nuove righe di partite manuali
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NEWPARTM BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NEWPARTM] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE FILM PROTETTIVI CON TAPPETO PRODUTTIVO, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_NEWPARTM = CASE WHEN COALESCE((SELECT AZI_PRDFILM FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
