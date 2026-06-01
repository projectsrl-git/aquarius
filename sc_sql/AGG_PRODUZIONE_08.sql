/* 
*****************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER PROGRAMMA DI PRODUZIONE:
	- PRODUZIONE.DIS_COMSOS: Componente sostituibile
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[DIS_COMSOS] [varchar] (1) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
go
