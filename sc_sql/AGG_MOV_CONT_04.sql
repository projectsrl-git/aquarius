
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
		 MOV_PUBBLI numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
        CONSTRAINT [DF_MOV_CONT_MOV_PUBBLI] DEFAULT ('0')    FOR [MOV_PUBBLI]
go


UPDATE MOV_CONT SET MOV_PUBBLI 	= 0 