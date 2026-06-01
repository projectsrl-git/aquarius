
/* 
**************************************************************
INSERIMENTO NUOVI CAMPI IN TESTATA RDA:
	- RDA_TT.DATACHIU: Data chiusura
	- RDA_TT.RIFDDT: Riferimento DDT
	- RDA_TT.RIFFAT: Riferimento Fattura
**************************************************************
*/

ALTER TABLE [dbo].[RDA_TT] ADD 
	 DATACHIU varchar(10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	 RIFDDT varchar(20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	 RIFFAT varchar(20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
go

