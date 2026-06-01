
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_STC_AN] ADD 
		 ORD_QTAMCE numeric (17,3) NULL,
		 ORD_QTAMC1 numeric (17,3) NULL,
		 ORD_QTAMC numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_STC_AN] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_STC_AN_ORD_QTAMCE] DEFAULT ('0')    FOR [ORD_QTAMCE],
        CONSTRAINT [DF_U_STC_AN_ORD_QTAMC1] DEFAULT ('0')    FOR [ORD_QTAMC1],
        CONSTRAINT [DF_U_STC_AN_ORD_QTAMC] DEFAULT ('0')    FOR [ORD_QTAMC]
go

UPDATE U_STC_AN SET ORD_QTAMCE 	= 0 
UPDATE U_STC_AN SET ORD_QTAMC1 	= 0 
UPDATE U_STC_AN SET ORD_QTAMC 	= 0 