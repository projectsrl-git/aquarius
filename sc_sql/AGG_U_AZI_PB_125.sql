
/*
*** Variabili per i campo gestiti nella scheda "Altro", sottoscheda "Web" dei parametri di sistema nel "form\menu_azi000.scx":
***	WordPress REST API Authentication
***		- Nome sito
***		- Username
***		- Password
***		- Consumer key
***		- Consumer secret
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_WPSITO varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPSITO] DEFAULT (''),
	AZI_WPUSER varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPUSER] DEFAULT (''),
	AZI_WPPASS varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPPASS] DEFAULT (''),
	AZI_WPCKEY varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPCKEY] DEFAULT (''),
	AZI_WPCSECRET varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_WPCSECRET] DEFAULT ('')
GO

