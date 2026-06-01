
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Impostazioni", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Visualizza anche gli anni contabili CHIUSI nella schermata di switch anno contabile
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_riccontdes2 BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_azi_riccontdes2] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET azi_riccontdes2 = 0 

