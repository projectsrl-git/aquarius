
/* 
***********************************************************************************
INSERIMENTO NUOVO CAMPO PER LEGAME CON GIACENZE E MOVIMENTI DEL MATERIALE PRELEVATO
***********************************************************************************
*/
ALTER TABLE [dbo].[PROD_IMPEGNI] ADD 
	MAG_NEWLEG varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
go
