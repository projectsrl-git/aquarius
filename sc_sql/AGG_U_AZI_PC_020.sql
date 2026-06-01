
/*
*** Variabili gestite nella scheda "Altro", sottoscheda "Web", sottoscheda "E-commerce" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Endpoint URL
***		- Authorization Key
***		- Magazzino
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_ECURL varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ECURL] DEFAULT (''),
	AZI_ECAUTK varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ECAUTK] DEFAULT (''),
	AZI_ECMAGA varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ECMAGA] DEFAULT ('')
GO
