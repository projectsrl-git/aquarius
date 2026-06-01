/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_UMMAGA varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESMAT varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 ART_SPESSO numeric(3) NULL,
	 ART_ALTEZZ numeric(5) NULL,
	 ART_LUNGHE numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_UMMAGA] DEFAULT ('') FOR [ART_UMMAGA],
	CONSTRAINT [DF_U_ART_PR_ART_DESMAT] DEFAULT ('') FOR [ART_DESMAT],
	CONSTRAINT [DF_U_ART_PR_ART_SPESSO] DEFAULT (0) FOR [ART_SPESSO],
	CONSTRAINT [DF_U_ART_PR_ART_ALTEZZ] DEFAULT (0) FOR [ART_ALTEZZ],
	CONSTRAINT [DF_U_ART_PR_ART_LUNGHE] DEFAULT (0) FOR [ART_LUNGHE]
go

UPDATE U_ART_PR SET ART_DESMAT = SPACE(30)
UPDATE U_ART_PR SET ART_UMMAGA = SPACE(3)
UPDATE U_ART_PR SET ART_SPESSO = 0
UPDATE U_ART_PR SET ART_ALTEZZ = 0
UPDATE U_ART_PR SET ART_LUNGHE = 0

