
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CR] ADD 
		 iva_daextr numeric (17,3) NULL,
		 iva_01extr numeric (17,3) NULL,
		 iva_02extr numeric (17,3) NULL,
		 iva_03extr numeric (17,3) NULL,
		 iva_04extr numeric (17,3) NULL,
		 iva_05extr numeric (17,3) NULL,
		 iva_06extr numeric (17,3) NULL,
		 iva_07extr numeric (17,3) NULL,
		 iva_08extr numeric (17,3) NULL,
		 iva_09extr numeric (17,3) NULL,
		 iva_10extr numeric (17,3) NULL,
		 iva_11extr numeric (17,3) NULL,
		 iva_12extr numeric (17,3) NULL,
		 iva_ttextr numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_IVA_CR] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_IVA_CR_iva_daextr] DEFAULT ('0')    FOR [iva_daextr],
        CONSTRAINT [DF_U_IVA_CR_iva_01extr] DEFAULT ('0')    FOR [iva_01extr],
        CONSTRAINT [DF_U_IVA_CR_iva_02extr] DEFAULT ('0')    FOR [iva_02extr],
        CONSTRAINT [DF_U_IVA_CR_iva_03extr] DEFAULT ('0')    FOR [iva_03extr],
        CONSTRAINT [DF_U_IVA_CR_iva_04extr] DEFAULT ('0')    FOR [iva_04extr],
        CONSTRAINT [DF_U_IVA_CR_iva_05extr] DEFAULT ('0')    FOR [iva_05extr],
        CONSTRAINT [DF_U_IVA_CR_iva_06extr] DEFAULT ('0')    FOR [iva_06extr],
        CONSTRAINT [DF_U_IVA_CR_iva_07extr] DEFAULT ('0')    FOR [iva_07extr],
        CONSTRAINT [DF_U_IVA_CR_iva_08extr] DEFAULT ('0')    FOR [iva_08extr],
        CONSTRAINT [DF_U_IVA_CR_iva_09extr] DEFAULT ('0')    FOR [iva_09extr],
        CONSTRAINT [DF_U_IVA_CR_iva_10extr] DEFAULT ('0')    FOR [iva_10extr],
        CONSTRAINT [DF_U_IVA_CR_iva_11extr] DEFAULT ('0')    FOR [iva_11extr],
        CONSTRAINT [DF_U_IVA_CR_iva_12extr] DEFAULT ('0')    FOR [iva_12extr],
        CONSTRAINT [DF_U_IVA_CR_iva_ttextr] DEFAULT ('0')    FOR [iva_ttextr]
go

UPDATE U_IVA_CR SET iva_daextr 	= 0 
UPDATE U_IVA_CR SET iva_01extr 	= 0 
UPDATE U_IVA_CR SET iva_02extr 	= 0 
UPDATE U_IVA_CR SET iva_03extr 	= 0 
UPDATE U_IVA_CR SET iva_04extr 	= 0 
UPDATE U_IVA_CR SET iva_05extr 	= 0 
UPDATE U_IVA_CR SET iva_06extr 	= 0 
UPDATE U_IVA_CR SET iva_07extr 	= 0 
UPDATE U_IVA_CR SET iva_08extr 	= 0 
UPDATE U_IVA_CR SET iva_09extr 	= 0 
UPDATE U_IVA_CR SET iva_10extr 	= 0 
UPDATE U_IVA_CR SET iva_11extr 	= 0 
UPDATE U_IVA_CR SET iva_12extr 	= 0 
UPDATE U_IVA_CR SET iva_ttextr 	= 0 

