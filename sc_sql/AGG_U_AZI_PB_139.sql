
/*
*** Variabili per i campo gestiti nella scheda "Altro", sottoscheda "Web" dei parametri di sistema nel "form\menu_azi000.scx":
***	Autenticazione con portale IDROLAB per gestione vendita al banco
***		- Dominio
***		- Username
***		- Password
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ILDOMI varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ILDOMI] DEFAULT (''),
	AZI_ILUSER varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ILUSER] DEFAULT (''),
	AZI_ILPASS varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ILPASS] DEFAULT ('')
GO
