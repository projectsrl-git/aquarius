
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CMP_CL] ADD 
	 CMP_DESART varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 CMP_DTUMAT varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 CMP_NRLINT numeric(10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CMP_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CMP_CL_CMP_DESART] DEFAULT ('') FOR [CMP_DESART],
	CONSTRAINT [DF_U_CMP_CL_CMP_DTUMAT] DEFAULT ('') FOR [CMP_DTUMAT],
	CONSTRAINT [DF_U_CMP_CL_CMP_NRLINT] DEFAULT (0) FOR [CMP_NRLINT]
go

UPDATE U_CMP_CL SET CMP_DESART = SPACE(50)
UPDATE U_CMP_CL SET CMP_DTUMAT = SPACE(10)
UPDATE U_CMP_CL SET CMP_NRLINT = 0
