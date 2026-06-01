
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
		REG_CODOPE varchar (10) COLLATE Latin1_General_CI_AS NULL,
		REG_NOMOPE varchar (50) COLLATE Latin1_General_CI_AS NULL,
		REG_DATREG varchar (10) COLLATE Latin1_General_CI_AS NULL,
		REG_ORAREG varchar (08) COLLATE Latin1_General_CI_AS NULL,
		MOD_CODOPE varchar (10) COLLATE Latin1_General_CI_AS NULL,
		MOD_NOMOPE varchar (50) COLLATE Latin1_General_CI_AS NULL,
		MOD_DATREG varchar (10) COLLATE Latin1_General_CI_AS NULL,
		MOD_ORAREG varchar (08) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORF_TT_REG_CODOPE] DEFAULT ('') FOR [REG_CODOPE],
        CONSTRAINT [DF_U_ORF_TT_REG_NOMOPE] DEFAULT ('') FOR [REG_NOMOPE],
        CONSTRAINT [DF_U_ORF_TT_REG_DATREG] DEFAULT ('') FOR [REG_DATREG],
        CONSTRAINT [DF_U_ORF_TT_REG_ORAREG] DEFAULT ('') FOR [REG_ORAREG],
        CONSTRAINT [DF_U_ORF_TT_MOD_CODOPE] DEFAULT ('') FOR [MOD_CODOPE],
        CONSTRAINT [DF_U_ORF_TT_MOD_NOMOPE] DEFAULT ('') FOR [MOD_NOMOPE],
        CONSTRAINT [DF_U_ORF_TT_MOD_DATREG] DEFAULT ('') FOR [MOD_DATREG],
        CONSTRAINT [DF_U_ORF_TT_MOD_ORAREG] DEFAULT ('') FOR [MOD_ORAREG]
go

UPDATE U_ORF_TT SET REG_CODOPE = 'XXX'
UPDATE U_ORF_TT SET REG_NOMOPE = ''
UPDATE U_ORF_TT SET REG_DATREG = ''
UPDATE U_ORF_TT SET REG_ORAREG = ''
UPDATE U_ORF_TT SET MOD_CODOPE = ''
UPDATE U_ORF_TT SET MOD_NOMOPE = ''
UPDATE U_ORF_TT SET MOD_DATREG = ''
UPDATE U_ORF_TT SET MOD_ORAREG = ''
