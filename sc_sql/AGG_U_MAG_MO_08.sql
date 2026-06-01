/* 
***********************************************
INSERIMENTO CAMPO PER TRACCIABILITA' PRODUZIONE
***********************************************
*/

ALTER TABLE [dbo].[U_MAG_MO] ADD 
		MOV_TRCKNG text COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ''
go
