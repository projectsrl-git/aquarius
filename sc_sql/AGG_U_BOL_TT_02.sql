
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
		 T_OMAGGIO numeric (17,3) NULL,
		 I_OMAGGIO numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_BOL_TT_T_OMAGGIO] DEFAULT ('0')    FOR [T_OMAGGIO],
        CONSTRAINT [DF_U_BOL_TT_I_OMAGGIO] DEFAULT ('0')    FOR [I_OMAGGIO]
go


UPDATE U_BOL_TT SET T_OMAGGIO 	= 0 
UPDATE U_BOL_TT SET I_OMAGGIO 	= 0 