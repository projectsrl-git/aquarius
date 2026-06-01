/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D1] ADD 
 	 PR1_HRINPR varchar(10) COLLATE Latin1_General_CI_AS NULL,
 	 PR1_HRFIPR varchar(10) COLLATE Latin1_General_CI_AS NULL,
 	 PR1_HRINEF varchar(10) COLLATE Latin1_General_CI_AS NULL,
 	 PR1_HRFIEF varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRD_D1] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRD_D1_PR1_HRINPR] DEFAULT ('') FOR [PR1_HRINPR],
	CONSTRAINT [DF_U_PRD_D1_PR1_HRFIPR] DEFAULT ('') FOR [PR1_HRFIPR],
	CONSTRAINT [DF_U_PRD_D1_PR1_HRINEF] DEFAULT ('') FOR [PR1_HRINEF],
	CONSTRAINT [DF_U_PRD_D1_PR1_HRFIEF] DEFAULT ('') FOR [PR1_HRFIEF]
go

UPDATE U_PRD_D1 SET PR1_HRINPR = ''
UPDATE U_PRD_D1 SET PR1_HRFIPR = ''
UPDATE U_PRD_D1 SET PR1_HRINEF = ''
UPDATE U_PRD_D1 SET PR1_HRFIEF = ''

