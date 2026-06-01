
/* 
*********************************************************************
INSERIMENTO CAMPO "DATA CONFERMA ORDINE" IN TESTATA ORDINE FORNITORIE
*********************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_DTCONF varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORF_TT_ORD_DTCONF] DEFAULT ('')
go

