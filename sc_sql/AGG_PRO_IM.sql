
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRO_IM] ADD 
	 IMP_ORAINI varchar(08) COLLATE Latin1_General_CI_AS NULL,
	 IMP_ORAFIN varchar(08) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_IM] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_IM_IMP_ORAINI] DEFAULT ('') FOR [IMP_ORAINI],
	CONSTRAINT [DF_U_PRO_IM_IMP_ORAFIN] DEFAULT ('') FOR [IMP_ORAFIN]
go

UPDATE U_PRO_IM SET IMP_ORAINI = SPACE(08)
UPDATE U_PRO_IM SET IMP_ORAFIN = SPACE(08)
