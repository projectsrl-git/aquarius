/* 
**************************************************************
CAMPI PER LA GESTIONE DELLE DISTINTE RID
**************************************************************
*/



ALTER TABLE [DBO].[U_ANA_CL] ADD 
	CLI_IBANRID varchar(27) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_IBANRID] DEFAULT (''),
	CLI_TPSRID varchar(4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_TPSRID] DEFAULT ('')
GO

