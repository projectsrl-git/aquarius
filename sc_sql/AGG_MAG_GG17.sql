
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_BYPASS [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_BYPASS] DEFAULT (0) FOR [MAG_BYPASS]
go

UPDATE U_MAG_GG SET MAG_BYPASS = 0


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_CP] ADD 
	 MAG_BYPASS [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CP_MAG_BYPASS] DEFAULT (0) FOR [MAG_BYPASS]
go

UPDATE U_MAG_CP SET MAG_BYPASS = 0