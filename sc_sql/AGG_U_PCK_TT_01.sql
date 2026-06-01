
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PCK_TT] ADD 
		 ORD_OKPREP [bit] NULL 

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_PCK_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_TT_ORD_OKPREP] DEFAULT (0) FOR [ORD_OKPREP]
go


UPDATE U_PCK_TT SET ORD_OKPREP 	= 0 
