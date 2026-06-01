
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[SALDI_FOR] ADD 
	 scad_da30 numeric(17,3) NULL ,
	 scad_da60 numeric(17,3) NULL ,
	 scad_da90 numeric(17,3) NULL ,
	 scad_da120 numeric(17,3) NULL ,
	 scad_oltre numeric(17,3) NULL ,
	 asca_da30 numeric(17,3) NULL ,
	 asca_da60 numeric(17,3) NULL ,
	 asca_da90 numeric(17,3) NULL ,
	 asca_da120 numeric(17,3) NULL ,
	 asca_oltre numeric(17,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[SALDI_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_SALDI_FOR_scad_da30] DEFAULT ('0') FOR [scad_da30],
	CONSTRAINT [DF_SALDI_FOR_scad_da60] DEFAULT ('0') FOR [scad_da60],
	CONSTRAINT [DF_SALDI_FOR_scad_da90] DEFAULT ('0') FOR [scad_da90],
	CONSTRAINT [DF_SALDI_FOR_scad_da120] DEFAULT ('0') FOR [scad_da120],
	CONSTRAINT [DF_SALDI_FOR_scad_oltre] DEFAULT ('0') FOR [scad_oltre],
	CONSTRAINT [DF_SALDI_FOR_asca_da30] DEFAULT ('0') FOR [asca_da30],
	CONSTRAINT [DF_SALDI_FOR_asca_da60] DEFAULT ('0') FOR [asca_da60],
	CONSTRAINT [DF_SALDI_FOR_asca_da90] DEFAULT ('0') FOR [asca_da90],
	CONSTRAINT [DF_SALDI_FOR_asca_da120] DEFAULT ('0') FOR [asca_da120],
	CONSTRAINT [DF_SALDI_FOR_asca_oltre] DEFAULT ('0') FOR [asca_oltre]

go

UPDATE SALDI_FOR SET scad_da30 = 0
UPDATE SALDI_FOR SET scad_da60 = 0
UPDATE SALDI_FOR SET scad_da90 = 0
UPDATE SALDI_FOR SET scad_da120 = 0
UPDATE SALDI_FOR SET scad_oltre = 0
UPDATE SALDI_FOR SET asca_da30 = 0
UPDATE SALDI_FOR SET asca_da60 = 0
UPDATE SALDI_FOR SET asca_da90 = 0
UPDATE SALDI_FOR SET asca_da120 = 0
UPDATE SALDI_FOR SET asca_oltre = 0