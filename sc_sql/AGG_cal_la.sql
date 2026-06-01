
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CAL_LA] ADD 
	 CAL_ORAINI varchar(8) COLLATE Latin1_General_CI_AS NULL,
	 CAL_ORAFIN varchar(8) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CAL_LA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CAL_LA_CAL_ORAINI] DEFAULT ('') FOR [CAL_ORAINI],
	CONSTRAINT [DF_U_CAL_LA_CAL_ORAFIN] DEFAULT ('') FOR [CAL_ORAFIN]
go

update u_cal_la set cal_oraini = space(08)
update u_cal_la set cal_orafin = space(08)