
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/


/* 
**************************************************************
AGGIUNGO MOV_SYSCCO SU MOV_CONT
**************************************************************
*/


ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_SYSCCO varchar(10) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_SYSCCO] DEFAULT ('') FOR [MOV_SYSCCO]
go

UPDATE MOV_CONT SET MOV_SYSCCO = ''



/* 
**************************************************************
AGGIUNGO MOV_SYSCCO SU MOV_CCO
**************************************************************
*/


ALTER TABLE [dbo].[MOV_CCO] ADD 
	 	 MOV_SYSCCO varchar(10) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CCO] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CCO_MOV_SYSCCO] DEFAULT ('') FOR [MOV_SYSCCO]
go

UPDATE MOV_CCO SET MOV_SYSCCO = ''




