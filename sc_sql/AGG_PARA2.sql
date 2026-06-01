
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 TIPOMOV numeric(3) NULL,
	 DTIPOMOV varchar(90) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_TIPOMOV] DEFAULT (0) FOR [TIPOMOV],
	CONSTRAINT [DF_PARA_DTIPOMOV] DEFAULT ('') FOR [DTIPOMOV]
go

UPDATE PARA SET TIPOMOV = 0
UPDATE PARA SET DTIPOMOV = SPACE(90)

