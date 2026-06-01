
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
		TIPRENDO varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_OFF_TT_TIPRENDO] DEFAULT ('') FOR [TIPRENDO]
go



UPDATE U_OFF_TT SET TIPRENDO 	= ''


