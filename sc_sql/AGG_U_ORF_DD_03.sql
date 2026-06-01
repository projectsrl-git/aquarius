
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 	 SAV_NUMPRG varchar (10) COLLATE Latin1_General_CI_AS NULL,
	 	 SAV_PJ_PRD1 varchar (32) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_SAV_NUMPRG] DEFAULT ('')      FOR [SAV_NUMPRG],
	CONSTRAINT [DF_U_ORF_DD_SAV_PJ_PRD1] DEFAULT ('')      FOR [SAV_PJ_PRD1]
go



UPDATE U_ORF_DD SET SAV_NUMPRG 	= ''
UPDATE U_ORF_DD SET SAV_PJ_PRD1	= '' 
