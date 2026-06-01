
/*
*** Variabili gestite nella scheda "Altro", sottoscheda "Web", sottoscheda "Microsoft Graph" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Token URI
***		- Email URI
***		- Tenant ID
***		- Client ID
***		- Client secret
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_MGTKNURI varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MGTKNURI] DEFAULT (''),
	AZI_MGEMLURI varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MGEMLURI] DEFAULT (''),
	AZI_MGTNTID varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MGTNTID] DEFAULT (''),
	AZI_MGCLNID varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MGCLNID] DEFAULT (''),
	AZI_MGCLNSEC varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MGCLNSEC] DEFAULT ('')
GO

