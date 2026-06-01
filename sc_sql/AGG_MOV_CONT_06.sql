
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_DTORI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_NDORI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_NPORI varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_DTORI] DEFAULT (' ') FOR [MOV_DTORI],
	CONSTRAINT [DF_MOV_CONT_MOV_NDORI] DEFAULT (' ') FOR [MOV_NDORI],
	CONSTRAINT [DF_MOV_CONT_MOV_NPORI] DEFAULT (' ') FOR [MOV_NPORI]
go

UPDATE MOV_CONT SET MOV_DTORI = ' '
UPDATE MOV_CONT SET MOV_NDORI = ' '
UPDATE MOV_CONT SET MOV_NPORI = ' '
