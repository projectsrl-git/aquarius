
/* 
*************************************************************************************
COME INSERIMENTO CAMPI 'SCONTI MINIMI' IN TABELLA SCONTI PER CLIENTE/CAT.MERCEOLOGICA
*************************************************************************************
*/

ALTER TABLE [dbo].[U_SCO_CM] ADD 
	SCO_SCMIN1 numeric (6,2) NULL,
	SCO_SCMIN2 numeric (6,2) NULL
go

ALTER TABLE [dbo].[U_SCO_CM] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SCO_CM_SCO_SCMIN1] DEFAULT (0) FOR [SCO_SCMIN1],
	CONSTRAINT [DF_U_SCO_CM_SCO_SCMIN2] DEFAULT (0) FOR [SCO_SCMIN2]
go

UPDATE U_SCO_CM SET SCO_SCMIN1 = 0
UPDATE U_SCO_CM SET SCO_SCMIN2 = 0
