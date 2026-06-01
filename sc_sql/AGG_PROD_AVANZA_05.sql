
/* 
********************************************************************************
MODIFICA CAMPO PROD_AVANZA.FORMATO PER CAPACITA' FORMATI PRODUZ. FILM PROTETTIVO
********************************************************************************
*/
ALTER TABLE [dbo].[PROD_AVANZA] ALTER COLUMN 
	FORMATO varchar (254) COLLATE Latin1_General_CI_AS NULL
go
