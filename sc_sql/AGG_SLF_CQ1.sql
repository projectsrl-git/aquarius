
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_SLF_CQ] ADD 
	[SLF_FSAD_V] [numeric](3, 0) NULL ,   	
	[SLF_FSAD_R] [varchar] (1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_SLF_CQ] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SLF_CQ_SLF_FSAD_V] DEFAULT (0) FOR [SLF_FSAD_V],
	CONSTRAINT [DF_U_SLF_CQ_SLF_FSAD_R] DEFAULT ('') FOR [SLF_FSAD_R]
go

UPDATE U_SLF_CQ SET SLF_FSAD_V = 0
UPDATE U_SLF_CQ SET SLF_FSAD_R = SPACE(01)


/* 
**************************************************************
COME MODIFICARE UN CAMPO ESISTENTE IN UNA TABELLA
**************************************************************

ATTENZIONE!!!!!
SE LA VARIAZIONE COMPORTA UNA RIDUZIONE DELLE DIMENSIONI DEL CAMPO,
SQL LO PERMETTE SOLO SE LA DIMENSIONE DEL DATO CONTENUTO E' 
UGUALE O INFERIORE ALLA NUOVA DIMENSIONE (SU TUTTI I RECORD
PRESENTI IN TABELLA)
**************************************************************
*/
ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN SLF_ADPH_V [numeric](6,2) NULL

ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN SLF_LA1PHV [numeric](6,2) NULL

ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN SLF_LA2PHV [numeric](6,2) NULL 

ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN SLF_LA3PHV [numeric](6,2) NULL 

ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN SLF_LA4PHV [numeric](6,2) NULL 

GO