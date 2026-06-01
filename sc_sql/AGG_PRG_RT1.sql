
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_RT] ADD 
	 STA_PRGNEW [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_RT_STA_PRGNEW] DEFAULT (0) FOR [STA_PRGNEW]
go

UPDATE U_PRG_RT SET STA_PRGNEW = 0


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_RT] ADD 
	 STA_DATNEW varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_RT_STA_DATNEW] DEFAULT ('') FOR [STA_DATNEW]
go

UPDATE U_PRG_RT SET STA_DATNEW = SPACE(10)
