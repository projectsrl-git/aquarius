  
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ADD 
		ORS_NUMORC varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORS_DATORC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_OFF_DD_ORS_NUMORC] DEFAULT ('') FOR [ORS_NUMORC],
        CONSTRAINT [DF_U_OFF_DD_ORS_DATORC] DEFAULT ('') FOR [ORS_DATORC]
 go

UPDATE U_OFF_DD SET ORS_NUMORC = ''
UPDATE U_OFF_DD SET ORS_DATORC = ''
