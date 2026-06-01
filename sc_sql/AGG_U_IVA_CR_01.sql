
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CR] ADD 
		 iva_01recu numeric (17,3) NULL,
		 iva_02recu numeric (17,3) NULL,
		 iva_03recu numeric (17,3) NULL,
		 iva_04recu numeric (17,3) NULL,
		 iva_05recu numeric (17,3) NULL,
		 iva_06recu numeric (17,3) NULL,
		 iva_07recu numeric (17,3) NULL,
		 iva_08recu numeric (17,3) NULL,
		 iva_09recu numeric (17,3) NULL,
		 iva_10recu numeric (17,3) NULL,
		 iva_11recu numeric (17,3) NULL,
		 iva_12recu numeric (17,3) NULL,
		 iva_ttrecu numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_IVA_CR] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_IVA_CR_iva_01recu] DEFAULT ('0')    FOR [iva_01recu],
        CONSTRAINT [DF_U_IVA_CR_iva_02recu] DEFAULT ('0')    FOR [iva_02recu],
        CONSTRAINT [DF_U_IVA_CR_iva_03recu] DEFAULT ('0')    FOR [iva_03recu],
        CONSTRAINT [DF_U_IVA_CR_iva_04recu] DEFAULT ('0')    FOR [iva_04recu],
        CONSTRAINT [DF_U_IVA_CR_iva_05recu] DEFAULT ('0')    FOR [iva_05recu],
        CONSTRAINT [DF_U_IVA_CR_iva_06recu] DEFAULT ('0')    FOR [iva_06recu],
        CONSTRAINT [DF_U_IVA_CR_iva_07recu] DEFAULT ('0')    FOR [iva_07recu],
        CONSTRAINT [DF_U_IVA_CR_iva_08recu] DEFAULT ('0')    FOR [iva_08recu],
        CONSTRAINT [DF_U_IVA_CR_iva_09recu] DEFAULT ('0')    FOR [iva_09recu],
        CONSTRAINT [DF_U_IVA_CR_iva_10recu] DEFAULT ('0')    FOR [iva_10recu],
        CONSTRAINT [DF_U_IVA_CR_iva_11recu] DEFAULT ('0')    FOR [iva_11recu],
        CONSTRAINT [DF_U_IVA_CR_iva_12recu] DEFAULT ('0')    FOR [iva_12recu],
        CONSTRAINT [DF_U_IVA_CR_iva_ttrecu] DEFAULT ('0')    FOR [iva_ttrecu]
go


UPDATE U_IVA_CR SET iva_01recu 	= 0 
UPDATE U_IVA_CR SET iva_02recu 	= 0 
UPDATE U_IVA_CR SET iva_03recu 	= 0 
UPDATE U_IVA_CR SET iva_04recu 	= 0 
UPDATE U_IVA_CR SET iva_05recu 	= 0 
UPDATE U_IVA_CR SET iva_06recu 	= 0 
UPDATE U_IVA_CR SET iva_07recu 	= 0 
UPDATE U_IVA_CR SET iva_08recu 	= 0 
UPDATE U_IVA_CR SET iva_09recu 	= 0 
UPDATE U_IVA_CR SET iva_10recu 	= 0 
UPDATE U_IVA_CR SET iva_11recu 	= 0 
UPDATE U_IVA_CR SET iva_12recu 	= 0 
UPDATE U_IVA_CR SET iva_ttrecu 	= 0 

