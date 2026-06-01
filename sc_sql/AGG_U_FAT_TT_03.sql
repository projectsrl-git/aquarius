
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		ORD_NUMORC varchar (6) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATORC varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_NUMOFC varchar (30) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATOFC varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_CDC varchar (5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_ORD_NUMORC] DEFAULT ('') FOR [ORD_NUMORC],
        CONSTRAINT [DF_U_FAT_TT_ORD_DATORC] DEFAULT ('') FOR [ORD_DATORC],
        CONSTRAINT [DF_U_FAT_TT_ORD_NUMOFC] DEFAULT ('') FOR [ORD_NUMOFC],
        CONSTRAINT [DF_U_FAT_TT_ORD_DATOFC] DEFAULT ('') FOR [ORD_DATOFC],
        CONSTRAINT [DF_U_FAT_TT_ORD_CDC] DEFAULT ('') FOR [ORD_CDC]
go



UPDATE U_FAT_TT SET ORD_NUMORC 	= ''
UPDATE U_FAT_TT SET ORD_DATORC 	= ''
UPDATE U_FAT_TT SET ORD_NUMOFC 	= ''
UPDATE U_FAT_TT SET ORD_DATOFC 	= ''
UPDATE U_FAT_TT SET ORD_CDC 	= ''

