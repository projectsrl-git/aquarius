
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_SLC_CQ] ADD 
	 SLC_ASPE_C varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 SLC_ANIN_C varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 SLC_FFIN_C varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 SLC_RESI_C varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_SLC_CQ] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SLC_CQ_SLC_ASPE_C] DEFAULT ('') FOR [SLC_ASPE_C],
	CONSTRAINT [DF_U_SLC_CQ_SLC_ANIN_C] DEFAULT ('') FOR [SLC_ANIN_C],
	CONSTRAINT [DF_U_SLC_CQ_SLC_FFIN_C] DEFAULT ('') FOR [SLC_FFIN_C],
	CONSTRAINT [DF_U_SLC_CQ_SLC_RESI_C] DEFAULT ('') FOR [SLC_RESI_C]	
go

UPDATE U_SLC_CQ SET SLC_ASPE_C = SPACE(50)
UPDATE U_SLC_CQ SET SLC_ANIN_C = SPACE(50)
UPDATE U_SLC_CQ SET SLC_FFIN_C = SPACE(50)
UPDATE U_SLC_CQ SET SLC_RESI_C = SPACE(50)
