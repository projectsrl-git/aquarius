/*    
***********************************************************************
INSERIMENTO DATI LETTERA INTENTO IN ANAGRAFICA CLIENTI
***********************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	 CLI_PE_PRI numeric (7,3),
	 CLI_PE_PRO numeric (7,3),
	 CLI_PE_PA1 numeric (7,3),
	 CLI_PE_PA2 numeric (7,3),
	 CLI_PE_PA3 numeric (7,3)
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ANA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ANA_CL_CLI_PE_PRI] DEFAULT (0) FOR [CLI_PE_PRI],
	CONSTRAINT [DF_U_ANA_CL_CLI_PE_PRO] DEFAULT (0) FOR [CLI_PE_PRO],
	CONSTRAINT [DF_U_ANA_CL_CLI_PE_PA1] DEFAULT (0) FOR [CLI_PE_PA1],
	CONSTRAINT [DF_U_ANA_CL_CLI_PE_PA2] DEFAULT (0) FOR [CLI_PE_PA2],
	CONSTRAINT [DF_U_ANA_CL_CLI_PE_PA3] DEFAULT (0) FOR [CLI_PE_PA3]
go

UPDATE U_ANA_CL SET CLI_PE_PRI = 0
UPDATE U_ANA_CL SET CLI_PE_PRO = 0
UPDATE U_ANA_CL SET CLI_PE_PA1 = 0
UPDATE U_ANA_CL SET CLI_PE_PA2 = 0
UPDATE U_ANA_CL SET CLI_PE_PA3 = 0