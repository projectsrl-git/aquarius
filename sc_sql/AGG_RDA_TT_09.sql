
/* 
**************************************************************
INSERIMENTO NUOVI CAMPI IN TESTATA RDA:
	- RDA_TT.COMMCAUS: Commessa / Causale
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT] ADD 
	 COMMCAUS varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RDA_TT_COMMCAUS] DEFAULT ('')
go

