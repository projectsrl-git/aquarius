
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 	 MOV_DATES varchar(6) COLLATE Latin1_General_CI_AS NULL,
	 	 MOV_OKTES varchar(6) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_DATES] DEFAULT (' ') FOR [MOV_DATES],
	CONSTRAINT [DF_INDICE_MOV_OKTES] DEFAULT (' ') FOR [MOV_OKTES]
go

UPDATE INDICE SET MOV_DATES= '          '
UPDATE INDICE SET MOV_OKTES= '          '