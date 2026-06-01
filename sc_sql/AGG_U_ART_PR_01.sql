/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ADD 
	 	 ART_AMMORT varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_AMMORT] DEFAULT (' ') FOR [ART_AMMORT]
go

UPDATE U_ART_PR SET ART_AMMORT = ' '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ADD 
	 	 ART_VALORE numeric(18,3)  NULL,
	 	 ART_DTUTIL varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 ART_DTCEBE varchar(10) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_VALORE] DEFAULT (0) FOR [ART_VALORE],
	CONSTRAINT [DF_U_ART_PR_ART_DTUTIL] DEFAULT (' ') FOR [ART_DTUTIL],
	CONSTRAINT [DF_U_ART_PR_ART_DTCEBE] DEFAULT (' ') FOR [ART_DTCEBE]
go


UPDATE U_ART_PR SET ART_VALORE = 0
UPDATE U_ART_PR SET ART_DTUTIL = '        '
UPDATE U_ART_PR SET ART_DTCEBE = '        '


