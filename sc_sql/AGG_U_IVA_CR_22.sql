/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/    

ALTER TABLE [dbo].[U_IVA_CR] ADD 
  iva_dtversa  varchar(10) COLLATE Latin1_General_CI_AS NULL,
  iva_acconto numeric (17,3) NULL,
  iva_peracco numeric (17,3) NULL,
  iva_daversa numeric (17,3) NULL
    
 go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVA_CR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVA_CR_iva_dtversa ] DEFAULT ('')  FOR [iva_dtversa],
    CONSTRAINT [DF_U_IVA_CR_iva_acconto] DEFAULT  ('0') FOR [iva_acconto],
	CONSTRAINT [DF_U_IVA_CR_iva_peracco] DEFAULT  ('0') FOR [iva_peracco],
	CONSTRAINT [DF_U_IVA_CR_iva_daversa] DEFAULT  ('0') FOR [iva_daversa]
go

UPDATE U_IVA_CR SET iva_dtversa  = ''
UPDATE U_IVA_CR SET iva_acconto  = 0 
UPDATE U_IVA_CR SET iva_peracco  = 0 
UPDATE U_IVA_CR SET iva_daversa  = 0 