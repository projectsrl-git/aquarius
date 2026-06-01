
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 SCAFISS_1R	[numeric] (3,0) NULL 
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_SCAFISS_1R]	DEFAULT (0)  FOR [SCAFISS_1R]
go

UPDATE PARA SET SCAFISS_1R = 0