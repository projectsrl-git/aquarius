/* 
********************************************
INSERIMENTO CAMPO MOV_DTCOLL (DATA COLLAUDO)
********************************************
*/    

ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_ANNOMM varchar(7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MOV_GG_MOV_ANNOMM] DEFAULT ('')
go


