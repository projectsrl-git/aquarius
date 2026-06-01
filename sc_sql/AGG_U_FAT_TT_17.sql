
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		ORD_TARGA varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_TELAIO varchar (40) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_ORD_TARGA] DEFAULT ('') FOR [ORD_TARGA],
        CONSTRAINT [DF_U_FAT_TT_ORD_TELAIO] DEFAULT ('') FOR [ORD_TELAIO]
go



UPDATE U_FAT_TT SET ORD_TARGA 	= ''
UPDATE U_FAT_TT SET ORD_TELAIO 	= ''

