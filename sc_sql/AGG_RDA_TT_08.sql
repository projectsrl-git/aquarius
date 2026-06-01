
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TESTATA RDA:
	- RDA_TT.NOPRIMI2VISTI: Valida automaticamente i primi 2 Visti
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT] ADD 
	 NOPRIMI2VISTI bit NOT NULL CONSTRAINT [DF_RDA_TT_NOPRIMI2VISTI] DEFAULT (0)
go

