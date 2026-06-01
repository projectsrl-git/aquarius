
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_RR] ADD 
	 STA_CODSYS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_RR_STA_CODSYS] DEFAULT ('') FOR [STA_CODSYS]
go

UPDATE U_PRG_RR SET STA_CODSYS = SPACE(10)
