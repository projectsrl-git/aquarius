
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Settaggi tecnici", nel "form\menu_azi000.scx":
***		- Controllo numero sessioni attive per tutta l'azienda
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_NRSESSIONI_PREVISTE NUMERIC(4,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_NRSESSIONI_PREVISTE] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_NRSESSIONI_PREVISTE = 200