
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_LI] ADD 
	 	 LIS_CODART varchar (16) COLLATE Latin1_General_CI_AS NULL,
	 	 LIS_DESART varchar (50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_LIS_LI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_LI_LIS_CODART] DEFAULT ('    ') FOR [LIS_CODART],
	CONSTRAINT [DF_U_LIS_LI_LIS_DESART] DEFAULT ('    ') FOR [LIS_DESART]
go

UPDATE U_LIS_LI SET LIS_CODART 	= SPACE(16)  
UPDATE U_LIS_LI SET LIS_DESART 	= SPACE(16)  
 