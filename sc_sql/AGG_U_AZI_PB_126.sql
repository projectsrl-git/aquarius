
/*
*** Variabili per i campo gestiti nella scheda "Altro", sottoscheda "Web" dei parametri di sistema nel "form\menu_azi000.scx":
***	WordPress REST API Authentication
***		- Cod. Iva default Clienti CEE
***		- Cod. Iva default Clienti ExtraCEE
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_WPIVCEE varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPIVCEE] DEFAULT (''),
	AZI_WPIVEXT varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPIVEXT] DEFAULT ('')
GO

