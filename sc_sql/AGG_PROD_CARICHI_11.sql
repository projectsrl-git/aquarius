/* 
**************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER RIPORTO DEL CAMPO PROD_AVANZA.SEQ_NOTE IN CARICHI DI PRODUZIONE LEVIGATURA PANNELLI TRUCIOLARI
**************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	SEQ_NOTE text COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_PROD_CARICHI_SEQ_NOTE] DEFAULT ('')
go
