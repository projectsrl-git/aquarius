/* 
**************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER RIPORTO DEL CAMPO PROD_AVANZA.FORMATO IN CARICHI DI PRODUZIONE CONFEZIONAMENTO (CAMPO MARCHIO)
**************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	FORMATO varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_PROD_CARICHI_FORMATO] DEFAULT ('')
go
