/* 
**********************************************************************
INSERIMENTO CAMPO MOV_FORNSUPP (COD. FORNITORE SUPPORTO FILM SPALMATO)
**********************************************************************
*/    

ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_FORNSUPP varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MAG_MO_MOV_FORNSUPP] DEFAULT ('')
go
