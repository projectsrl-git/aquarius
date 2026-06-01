
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DL] ADD 
	 	 PR1_NUMPRG varchar (10) COLLATE Latin1_General_CI_AS NULL,
	 	 PJ_PRGPRD1 varchar (32) COLLATE Latin1_General_CI_AS NULL,
	 	 PJ_PRGPRD2 varchar (32) COLLATE Latin1_General_CI_AS NULL,
	 	 PJ_PRGPRD3 varchar (32) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DL_PR1_NUMPRG] DEFAULT ('')      FOR [PR1_NUMPRG],
	CONSTRAINT [DF_U_ORF_DL_PJ_PRGPRD1] DEFAULT ('')      FOR [PJ_PRGPRD1],
	CONSTRAINT [DF_U_ORF_DL_PJ_PRGPRD2] DEFAULT ('')      FOR [PJ_PRGPRD2],
	CONSTRAINT [DF_U_ORF_DL_PJ_PRGPRD3] DEFAULT ('')      FOR [PJ_PRGPRD3]
go



UPDATE U_ORF_DL SET PR1_NUMPRG 	= ''
UPDATE U_ORF_DL SET PJ_PRGPRD1 	= '' 
UPDATE U_ORF_DL SET PJ_PRGPRD2 	= '' 
UPDATE U_ORF_DL SET PJ_PRGPRD3 	= '' 
