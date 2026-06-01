/*    
****************************************************************
INSERIMENTO CAMPO CODICE AGENTE IN TABELLA LOCALITA' DI CONSEGNA
****************************************************************
*/

ALTER TABLE [dbo].[U_LOC_AN] ADD 
	 LOC_CODAGE varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LOC_AN_LOC_CODAGE] DEFAULT ('')
go
