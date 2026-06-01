/* 
**********************************************************************
INSERIMENTO CAMPO MAG_FORNSUPP (COD. FORNITORE SUPPORTO FILM SPALMATO)
**********************************************************************
*/    

ALTER TABLE [dbo].[U_MAG_GG] ADD 
	MAG_FORNSUPP varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MAG_GG_MAG_FORNSUPP] DEFAULT ('')
go
