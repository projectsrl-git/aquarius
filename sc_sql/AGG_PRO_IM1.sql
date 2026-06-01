
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRO_IM] ADD 
	 IMP_INILAV varchar(08) COLLATE Latin1_General_CI_AS NULL,
	 IMP_FINLAV varchar(08) COLLATE Latin1_General_CI_AS NULL,
	 IMP_INIIMP varchar(08) COLLATE Latin1_General_CI_AS NULL,
	 IMP_FINIMP varchar(08) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_IM] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_IM_IMP_INILAV] DEFAULT ('') FOR [IMP_INILAV],
	CONSTRAINT [DF_U_PRO_IM_IMP_FINLAV] DEFAULT ('') FOR [IMP_FINLAV],
	CONSTRAINT [DF_U_PRO_IM_IMP_INIIMP] DEFAULT ('') FOR [IMP_INIIMP],
	CONSTRAINT [DF_U_PRO_IM_IMP_FINIMP] DEFAULT ('') FOR [IMP_FINIMP]
go

UPDATE U_PRO_IM SET IMP_INILAV = SPACE(08)
UPDATE U_PRO_IM SET IMP_FINLAV = SPACE(08)
UPDATE U_PRO_IM SET IMP_INIIMP = SPACE(08)
UPDATE U_PRO_IM SET IMP_FINIMP = SPACE(08)
