/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_ragleg varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 FOR_rgleg2 varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 FOR_indleg varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 FOR_locleg varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 FOR_proleg varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 FOR_nazleg varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 FOR_capleg varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 FOR_cfislg varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 FOR_pivalg varchar(11) COLLATE Latin1_General_CI_AS NULL,
	 FOR_ivcelg varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_ragleg] DEFAULT ('') FOR [FOR_ragleg],
	CONSTRAINT [DF_U_FOR_AN_FOR_rgleg2] DEFAULT ('') FOR [FOR_rgleg2],
	CONSTRAINT [DF_U_FOR_AN_FOR_indleg] DEFAULT ('') FOR [FOR_indleg],
	CONSTRAINT [DF_U_FOR_AN_FOR_locleg] DEFAULT ('') FOR [FOR_locleg],
	CONSTRAINT [DF_U_FOR_AN_FOR_proleg] DEFAULT ('') FOR [FOR_proleg],
	CONSTRAINT [DF_U_FOR_AN_FOR_nazleg] DEFAULT ('') FOR [FOR_nazleg],
	CONSTRAINT [DF_U_FOR_AN_FOR_capleg] DEFAULT ('') FOR [FOR_capleg],
	CONSTRAINT [DF_U_FOR_AN_FOR_cfislg] DEFAULT ('') FOR [FOR_cfislg],
	CONSTRAINT [DF_U_FOR_AN_FOR_pivalg] DEFAULT ('') FOR [FOR_pivalg],
	CONSTRAINT [DF_U_FOR_AN_FOR_ivcelg] DEFAULT ('') FOR [FOR_ivcelg]
go

UPDATE U_FOR_AN SET FOR_ragleg = ''
UPDATE U_FOR_AN SET FOR_rgleg2 = ''
UPDATE U_FOR_AN SET FOR_indleg = ''
UPDATE U_FOR_AN SET FOR_locleg = ''
UPDATE U_FOR_AN SET FOR_proleg = ''
UPDATE U_FOR_AN SET FOR_nazleg = ''
UPDATE U_FOR_AN SET FOR_capleg = ''
UPDATE U_FOR_AN SET FOR_cfislg = ''
UPDATE U_FOR_AN SET FOR_pivalg = ''
UPDATE U_FOR_AN SET FOR_ivcelg = ''
