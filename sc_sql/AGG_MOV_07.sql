/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
		 MOV_INCPAG NUMERIC (17,3)  NULL,
	 	 MOV_AAMM varchar(6) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_RAGSOC varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_INCPAG] DEFAULT (0) FOR [MOV_INCPAG],
	CONSTRAINT [DF_MOV_CONT_MOV_AAMM] DEFAULT ('') FOR [MOV_AAMM],
	CONSTRAINT [DF_MOV_CONT_MOV_RAGSOC] DEFAULT ('') FOR [MOV_RAGSOC]
go

UPDATE MOV_CONT SET MOV_INCPAG = 0
UPDATE MOV_CONT SET MOV_AAMM = SPACE(06)
UPDATE MOV_CONT SET MOV_RAGSOC = SPACE(50)
