
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_ACCONT numeric(17,2) NULL,
	 ORD_DATACC varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_NUMSCO varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGACC bit NULL,
	 ORD_DATRIM varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_FLGRIM bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_ACCONT] DEFAULT (0) FOR [ORD_ACCONT],
	CONSTRAINT [DF_U_ORD_TT_ORD_DATACC] DEFAULT ('') FOR [ORD_DATACC],
	CONSTRAINT [DF_U_ORD_TT_ORD_NUMSCO] DEFAULT ('') FOR [ORD_NUMSCO],
	CONSTRAINT [DF_U_ORD_TT_ORD_FLGACC] DEFAULT (0) FOR [ORD_FLGACC],
	CONSTRAINT [DF_U_ORD_TT_ORD_DATRIM] DEFAULT ('') FOR [ORD_DATRIM],
	CONSTRAINT [DF_U_ORD_TT_ORD_FLGRIM] DEFAULT (0) FOR [ORD_FLGRIM]
go