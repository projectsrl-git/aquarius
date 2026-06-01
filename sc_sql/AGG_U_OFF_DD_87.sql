
/* 
*******************************************************************************************************
AGGIORNAMENTO DIMENSIONE CAMPO PROVVIGIONE, PER ALLINEARLO ALLA DIMENSIONE DI TUTTI GLI ALTRI DOCUMENTI
*******************************************************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ALTER COLUMN ORD_PRORIG NUMERIC(7,3) NOT NULL
