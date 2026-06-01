/* 
**************************************************************
CAMPI PER LA GESTIONE DELLE DISTINTE RID
**************************************************************
*/

ALTER TABLE [DBO].[U_ANA_CL] ADD 
	CLI_RIDCPA bit NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_RIDCPA] DEFAULT (0)
GO
