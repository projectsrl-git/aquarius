/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D3] ADD 
 	 PR3_PROGRE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRD_D3] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRD_D3_PR3_PROGRE] DEFAULT ('') FOR [PR3_PROGRE]
go

UPDATE U_PRD_D3 SET PR3_PROGRE = ''
