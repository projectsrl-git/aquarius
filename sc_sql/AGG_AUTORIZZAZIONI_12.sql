
ALTER TABLE [dbo].[AUTORIZZAZIONI] ADD 
	UTE_ADMIN [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[AUTORIZZAZIONI] WITH NOCHECK ADD 
	CONSTRAINT [DF_AUTORIZZAZIONI_UTE_ADMIN] DEFAULT (0) FOR [UTE_ADMIN]
go


UPDATE AUTORIZZAZIONI SET UTE_ADMIN = 0
-- SE UTENTE SER SETTA 1 (TRUE)
UPDATE AUTORIZZAZIONI  
SET     UTE_ADMIN =  CASE  
                        WHEN USERID = 'ANTONIAZZI' THEN 1 
                        WHEN USERID = 'ERCOLI' THEN 1 
                        WHEN USERID = 'FERRARESE' THEN 1
						WHEN USERID = 'SER' THEN 1
						WHEN USERID = 'ASS' THEN 1
						WHEN USERID = 'DES' THEN 1
						WHEN USERID = 'EMA' THEN 1
                        ELSE 0
                    END 
WHERE   USERID IN ('ANTONIAZZI', 'ERCOLI', 'FERRARESE', 'SER', 'ASS','DES','EMA')


--select UTE_ADMIN,* from AUTORIZZAZIONI