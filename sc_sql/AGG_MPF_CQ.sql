/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MPF_CQ] ADD 
	MPF_ROTR_V NUMERIC(5,0) NULL,
	MPF_ROLO_V NUMERIC(5,0) NULL,
	MPF_IMBU_V NUMERIC(2,0) NULL,
	MPF_TRAT_V NUMERIC(2,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MPF_CQ] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MPF_CQ_MPF_ROTR_V] DEFAULT (0) FOR [MPF_ROTR_V],
	CONSTRAINT [DF_U_MPF_CQ_MPF_ROLO_V] DEFAULT (0) FOR [MPF_ROLO_V],
	CONSTRAINT [DF_U_MPF_CQ_MPF_IMBU_V] DEFAULT (0) FOR [MPF_IMBU_V],
	CONSTRAINT [DF_U_MPF_CQ_MPF_TRAT_V] DEFAULT (0) FOR [MPF_TRAT_V]
go

UPDATE U_MPF_CQ SET MPF_ROTR_V = 0
UPDATE U_MPF_CQ SET MPF_ROLO_V = 0
UPDATE U_MPF_CQ SET MPF_IMBU_V = 0
UPDATE U_MPF_CQ SET MPF_TRAT_V = 0


