/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FTP_AN] ADD 
	 FTP_EXECUTE bit NULL 

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FTP_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FTP_AN_FTP_EXECUTE] DEFAULT (0) FOR [FTP_EXECUTE]

go