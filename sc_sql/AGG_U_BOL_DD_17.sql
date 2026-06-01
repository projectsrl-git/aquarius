
/* 
******************************************************
INSERIMENTO CAMPO PER GESTIONE SCARICHI RESI FORNITORE
******************************************************
*/
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	RES_MAGUNQ varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_RES_MAGUNQ] DEFAULT ('') FOR [RES_MAGUNQ]
go

UPDATE U_BOL_DD SET RES_MAGUNQ = ''
