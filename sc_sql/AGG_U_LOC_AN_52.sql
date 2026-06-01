/*    
*******************************************************************************
INSERIMENTO CAMPI CODICE E DESCRIZIONE NAZIONE IN TABELLA LOCALITA' DI CONSEGNA
*******************************************************************************
*/

ALTER TABLE [dbo].[U_LOC_AN] ADD 
	 LOC_CODNAZ varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LOC_AN_LOC_CODNAZ] DEFAULT (''),
	 LOC_DESNAZ varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_LOC_AN_LOC_DESNAZ] DEFAULT ('')
go
