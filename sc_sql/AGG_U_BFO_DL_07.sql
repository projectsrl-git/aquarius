
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DL] ADD 
		ORD_MAGA   varchar(06) COLLATE Latin1_General_CI_AS NULL,
		ORD_FILA_X varchar(05) COLLATE Latin1_General_CI_AS NULL,
		ORD_PIAN_X varchar(05) COLLATE Latin1_General_CI_AS NULL,
		ORD_UBIC_X varchar(05) COLLATE Latin1_General_CI_AS NULL,
		ORD_FILA_N numeric (5,0) NULL,
		ORD_PIAN_N numeric (5,0) NULL,
		ORD_UBIC_N numeric (5,0) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DL] WITH NOCHECK ADD 
   	    CONSTRAINT [DF_U_BFO_DL_ORD_MAGA] DEFAULT ('') FOR [ORD_MAGA],
   	    CONSTRAINT [DF_U_BFO_DL_ORD_FILA_X] DEFAULT ('') FOR [ORD_FILA_X],
  	    CONSTRAINT [DF_U_BFO_DL_ORD_PIAN_X] DEFAULT ('') FOR [ORD_PIAN_X],
  	    CONSTRAINT [DF_U_BFO_DL_ORD_UBIC_X] DEFAULT ('') FOR [ORD_UBIC_X],
		CONSTRAINT [DF_U_BFO_DL_ORD_FILA_N] DEFAULT (0) FOR [ORD_FILA_N],
		CONSTRAINT [DF_U_BFO_DL_ORD_PIAN_N] DEFAULT (0) FOR [ORD_PIAN_N],
		CONSTRAINT [DF_U_BFO_DL_ORD_UBIC_N] DEFAULT (0) FOR [ORD_UBIC_N]

go

UPDATE U_BFO_DL SET ORD_MAGA 	= '' 
UPDATE U_BFO_DL SET ORD_FILA_X 	= '' 
UPDATE U_BFO_DL SET ORD_PIAN_X 	= '' 
UPDATE U_BFO_DL SET ORD_UBIC_X 	= '' 
UPDATE U_BFO_DL SET ORD_FILA_N 	= 0
UPDATE U_BFO_DL SET ORD_PIAN_N 	= 0 
UPDATE U_BFO_DL SET ORD_UBIC_N 	= 0 


