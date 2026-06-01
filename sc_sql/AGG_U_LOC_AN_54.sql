/*    
****************************************************************
INSERIMENTO CAMPO EMAIL IN TABELLA LOCALITA' DI CONSEGNA
****************************************************************
*/

ALTER TABLE [dbo].[U_LOC_AN] ADD 
	 LOC_EMAIL varchar(150) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LOC_AN_LOC_EMAIL] DEFAULT ('')
go
