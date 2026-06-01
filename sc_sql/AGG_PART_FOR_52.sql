
/* 
*****************************************************************
INSERIMENTO CAMPO DATA SCADENZA ORIGINALE IN PARTITARIO FORNITORI
***************************************************************יי
*/

ALTER TABLE [dbo].[PART_FOR] ADD 
	PAR_DTSCOR varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_PART_FOR_PAR_DTSCOR] DEFAULT ('')
go
