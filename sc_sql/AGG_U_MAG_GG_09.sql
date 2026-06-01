/* 
********************************************
INSERIMENTO CAMPO MAG_ANNOMM (CALCOLO MDB)
********************************************
*/    

ALTER TABLE [dbo].[U_MAG_GG] ADD 
	MAG_ANNOMM varchar(7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MAG_GG_MAG_ANNOMM] DEFAULT ('')
go
