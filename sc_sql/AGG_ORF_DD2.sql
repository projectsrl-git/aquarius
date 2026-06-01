
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORS_CODACQ varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 ORS_DESACQ varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 ORS_CODCPA varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORS_CODACQ] DEFAULT ('') FOR [ORS_CODACQ],
	CONSTRAINT [DF_U_ORF_DD_ORS_DESACQ] DEFAULT ('') FOR [ORS_DESACQ],
	CONSTRAINT [DF_U_ORF_DD_ORS_CODCPA] DEFAULT ('') FOR [ORS_CODCPA]
go

UPDATE U_ORF_DD SET ORS_CODACQ = SPACE(03)
UPDATE U_ORF_DD SET ORS_DESACQ = SPACE(30)
UPDATE U_ORF_DD SET ORS_CODCPA = SPACE(03)
