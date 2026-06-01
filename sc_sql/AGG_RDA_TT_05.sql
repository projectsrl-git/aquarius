
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT] ADD 
	 CCOSTOT varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 DES_CCOSTOT varchar(60) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RDA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_TT_CCOSTOT] DEFAULT ('') FOR [CCOSTOT],
	CONSTRAINT [DF_RDA_TT_DES_CCOSTOT] DEFAULT ('') FOR [DES_CCOSTOT]

go

UPDATE RDA_TT SET CCOSTOT = ''
UPDATE RDA_TT SET DES_CCOSTOT = ''


