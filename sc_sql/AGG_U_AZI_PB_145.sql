
/*
*** Variabile gestite nella scheda "Altro", sottoscheda "Web", sottoscheda "Salesforce REST API Authentication" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Login URL
***		- Logout URL
***		- Username
***		- Password
***		- Client ID
***		- Client secret
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_SFLOGIN varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SFLOGIN] DEFAULT (''),
	AZI_SFLOGOUT varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SFLOGOUT] DEFAULT (''),
	AZI_SFUSER varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SFUSER] DEFAULT (''),
	AZI_SFPASS varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SFPASS] DEFAULT (''),
	AZI_SFCKEY varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SFCKEY] DEFAULT (''),
	AZI_SFCSECRET varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SFCSECRET] DEFAULT ('')
GO

