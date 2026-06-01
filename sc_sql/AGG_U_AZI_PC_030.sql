
/*
*** Variabile gestita nella scheda "Fe / Xml del "form\menu_azi000.scx":
***		- Flag per gestire l'invio/ricezione delle fatture elettroniche a SDI tramite il portale BLUENEXT
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FATESDI bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FATESDI] DEFAULT (0)
GO

