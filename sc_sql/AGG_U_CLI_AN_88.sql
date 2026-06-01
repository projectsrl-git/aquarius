/*    
**************************************************************************************************
INSERIMENTO CAMPI PER Opzioni di stampa documenti avanzate IN TABELLA ANAGRAFICA CLIENTI:
	- Stampa prezzo lordo
	- Stampa sconti
	- Stampa codice IVA
**************************************************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	CLI_OPZSTQT BIT NULL,
	CLI_OPZSTPL BIT NULL,
	CLI_OPZSTSC BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_OPZSTQT] DEFAULT (0) FOR [CLI_OPZSTQT],
	CONSTRAINT [DF_U_CLI_AN_CLI_OPZSTPL] DEFAULT (0) FOR [CLI_OPZSTPL],
	CONSTRAINT [DF_U_CLI_AN_CLI_OPZSTSC] DEFAULT (0) FOR [CLI_OPZSTSC]
go

UPDATE U_CLI_AN SET CLI_OPZSTQT = 0
UPDATE U_CLI_AN SET CLI_OPZSTPL = 0
UPDATE U_CLI_AN SET CLI_OPZSTSC = 0

