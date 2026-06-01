
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/


ALTER TABLE [DBO].[VENDITE_TT] ADD 
       ORD_INCASS NUMERIC(17,3) NOT NULL DEFAULT (0)
GO
