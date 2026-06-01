/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D1] ADD 
 	 PR1_GRUPRD varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRD_D1] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRD_D1_PR1_GRUPRD] DEFAULT ('') FOR [PR1_GRUPRD]
go

UPDATE U_PRD_D1 SET PR1_GRUPRD = ''

