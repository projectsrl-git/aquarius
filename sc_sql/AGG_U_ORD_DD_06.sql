
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
		 VAR_NUMBOB numeric (6,0) NULL,
		 VAR_ALTEZZ numeric (5,0) NULL,
		 VAR_LUNGHE numeric (6,0) NULL,
		 VAR_QTAKG1 numeric (11,2) NULL,
		 VAR_QTAMQ1 numeric (11,2) NULL,
		 VAR_QTAML1 numeric (11,2) NULL,
		 VAR_QTAKG  numeric (11,2) NULL,
		 VAR_QTAMQ  numeric (11,2) NULL,
		 VAR_QTAML  numeric (11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORD_DD_VAR_NUMBOB] DEFAULT ('0')    FOR [VAR_NUMBOB],
        CONSTRAINT [DF_U_ORD_DD_VAR_ALTEZZ] DEFAULT ('0')    FOR [VAR_ALTEZZ],
        CONSTRAINT [DF_U_ORD_DD_VAR_LUNGHE] DEFAULT ('0')    FOR [VAR_LUNGHE],
        CONSTRAINT [DF_U_ORD_DD_VAR_QTAKG1] DEFAULT ('0')    FOR [VAR_QTAKG1],
        CONSTRAINT [DF_U_ORD_DD_VAR_QTAMQ1] DEFAULT ('0')    FOR [VAR_QTAMQ1],
        CONSTRAINT [DF_U_ORD_DD_VAR_QTAML1] DEFAULT ('0')    FOR [VAR_QTAML1],
        CONSTRAINT [DF_U_ORD_DD_VAR_QTAKG]  DEFAULT ('0')    FOR [VAR_QTAKG],
        CONSTRAINT [DF_U_ORD_DD_VAR_QTAMQ]  DEFAULT ('0')    FOR [VAR_QTAMQ],
        CONSTRAINT [DF_U_ORD_DD_VAR_QTAML]  DEFAULT ('0')    FOR [VAR_QTAML]

go

UPDATE U_ORD_DD SET VAR_NUMBOB 	= 0 
UPDATE U_ORD_DD SET VAR_ALTEZZ 	= 0 
UPDATE U_ORD_DD SET VAR_LUNGHE 	= 0 
UPDATE U_ORD_DD SET VAR_QTAKG1 	= 0 
UPDATE U_ORD_DD SET VAR_QTAMQ1 	= 0 
UPDATE U_ORD_DD SET VAR_QTAML1 	= 0 
UPDATE U_ORD_DD SET VAR_QTAKG 	= 0 
UPDATE U_ORD_DD SET VAR_QTAMQ 	= 0 
UPDATE U_ORD_DD SET VAR_QTAML 	= 0 