
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_FATCE varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_NOTCE varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_FATRC varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_NOTRC varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_FATCE] DEFAULT (' ') FOR [MOV_FATCE],
	CONSTRAINT [DF_MOV_CONT_MOV_NOTCE] DEFAULT (' ') FOR [MOV_NOTCE],
	CONSTRAINT [DF_MOV_CONT_MOV_FATRC] DEFAULT (' ') FOR [MOV_FATRC],
	CONSTRAINT [DF_MOV_CONT_MOV_NOTRC] DEFAULT (' ') FOR [MOV_NOTRC]
go

UPDATE MOV_CONT SET MOV_FATCE = ' '
UPDATE MOV_CONT SET MOV_NOTCE = ' '
UPDATE MOV_CONT SET MOV_FATRC = ' '
UPDATE MOV_CONT SET MOV_NOTRC = ' '