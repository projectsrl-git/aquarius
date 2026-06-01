
/*         
***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	 CON_CODPADRE VARCHAR(20) NOT NULL CONSTRAINT [DF_CONTI_CON_CODPADRE] DEFAULT ('')
go

