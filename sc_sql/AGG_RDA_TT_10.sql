
/* 
**************************************************************
INSERIMENTO NUOVI CAMPI IN TESTATA RDA:
	- RDA_TT.DTINOLTRO: Data Inoltro
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT] ADD 
	 DTINOLTRO varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RDA_TT_DTINOLTRO] DEFAULT ('')
go

