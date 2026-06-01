
/* 
***************************************************************
INSERIMENTO CAMPO DATA SCADENZA ORIGINALE IN PARTITARIO CLIENTI
***************************************************************
*/

ALTER TABLE [dbo].[PART_CLI] ADD 
	PAR_DTSCOR varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_PART_CLI_PAR_DTSCOR] DEFAULT ('')
go
