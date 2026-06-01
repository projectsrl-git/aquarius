
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CCO] ADD 
		 MOV_PUBBLI numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[MOV_CCO] WITH NOCHECK ADD 
        CONSTRAINT [DF_MOV_CCO_MOV_PUBBLI] DEFAULT ('0')    FOR [MOV_PUBBLI]
go


UPDATE MOV_CCO SET MOV_PUBBLI 	= 0 