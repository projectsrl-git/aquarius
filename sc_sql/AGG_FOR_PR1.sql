
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_PR] ADD 
	 FPR_CODMAG varchar(6) COLLATE Latin1_General_CI_AS NULL,
	 FPR_PRZVEN [numeric](17, 6) NULL ,
	 FPR_PRZRES [numeric](17, 6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_PR_FPR_CODMAG] DEFAULT ('') FOR [FPR_CODMAG],
	CONSTRAINT [DF_U_FOR_PR_FPR_PRZVEN] DEFAULT (0) FOR [FPR_PRZVEN],
	CONSTRAINT [DF_U_FOR_PR_FPR_PRZRES] DEFAULT (0) FOR [FPR_PRZRES]
go
