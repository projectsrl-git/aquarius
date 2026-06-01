
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_CODPDV varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_ORAMOV varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SEGNO varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 MOV_TIPMOV varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 MOV_FORNIT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_CODPDV] DEFAULT ('') FOR [MOV_CODPDV],
	CONSTRAINT [DF_U_MAG_MO_MOV_ORAMOV] DEFAULT ('') FOR [MOV_ORAMOV],
	CONSTRAINT [DF_U_MAG_MO_MOV_SEGNO] DEFAULT ('') FOR [MOV_SEGNO],
	CONSTRAINT [DF_U_MAG_MO_MOV_TIPMOV] DEFAULT ('') FOR [MOV_TIPMOV],
	CONSTRAINT [DF_U_MAG_MO_MOV_FORNIT] DEFAULT ('') FOR [MOV_FORNIT]
go
