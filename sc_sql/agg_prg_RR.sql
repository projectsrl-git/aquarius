
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_RR] ADD 
	 STA_FLGEND [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_RR_STA_FLGEND] DEFAULT (0) FOR [STA_FLGEND]
go

UPDATE U_PRG_RR SET STA_FLGEND = 0

