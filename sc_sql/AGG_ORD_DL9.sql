/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DL] ADD 
	 ORD_CDDIBA varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ORD_CILRET numeric(3) NULL,
	 ORD_ALTCOM numeric(5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DL_ORD_CDDIBA] DEFAULT ('') FOR [ORD_CDDIBA],
	CONSTRAINT [DF_U_ORD_DL_ORD_CILRET] DEFAULT (0) FOR [ORD_CILRET],
	CONSTRAINT [DF_U_ORD_DL_ORD_ALTCOM] DEFAULT (0) FOR [ORD_ALTCOM]
go

UPDATE U_ORD_DL SET ORD_CDDIBA = SPACE(16)
UPDATE U_ORD_DL SET ORD_CILRET = 0
UPDATE U_ORD_DL SET ORD_ALTCOM = 0
