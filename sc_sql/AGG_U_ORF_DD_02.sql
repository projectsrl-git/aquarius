
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 	 PR1_NUMPRG varchar (10) COLLATE Latin1_General_CI_AS NULL,
	 	 PJ_PRGPRD1 varchar (32) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_PR1_NUMPRG] DEFAULT ('')      FOR [PR1_NUMPRG],
	CONSTRAINT [DF_U_ORF_DD_PJ_PRGPRD1] DEFAULT ('')      FOR [PJ_PRGPRD1]
go



UPDATE U_ORF_DD SET PR1_NUMPRG 	= ''
UPDATE U_ORF_DD SET PJ_PRGPRD1 	= '' 
