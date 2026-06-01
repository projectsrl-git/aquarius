
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	 CON_PERCO1  numeric(10,3)  NULL,
	 CON_PERCO2  numeric(10,3)  NULL,
	 CON_PERCO3  numeric(10,3)  NULL,
	 CON_PERCO4  numeric(10,3)  NULL,
	 CON_PERCO5  numeric(10,3)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_CON_PERCO1] DEFAULT (0) FOR [CON_PERCO1],
	CONSTRAINT [DF_CONTI_CON_PERCO2] DEFAULT (0) FOR [CON_PERCO2],
	CONSTRAINT [DF_CONTI_CON_PERCO3] DEFAULT (0) FOR [CON_PERCO3],
	CONSTRAINT [DF_CONTI_CON_PERCO4] DEFAULT (0) FOR [CON_PERCO4],
	CONSTRAINT [DF_CONTI_CON_PERCO5] DEFAULT (0) FOR [CON_PERCO5]

go

UPDATE CONTI SET CON_PERCO1 	= 0
UPDATE CONTI SET CON_PERCO2 	= 0
UPDATE CONTI SET CON_PERCO3 	= 0
UPDATE CONTI SET CON_PERCO4 	= 0
UPDATE CONTI SET CON_PERCO5 	= 0
