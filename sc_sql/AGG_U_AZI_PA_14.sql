/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 	 	azi_sdbsig varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 	 	azi_sdbnog varchar(03) COLLATE Latin1_General_CI_AS NULL,	
			azi_cdbsig varchar(03) COLLATE Latin1_General_CI_AS NULL,
			azi_cdbnog varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_sdbsig] DEFAULT ('    ') FOR [azi_sdbsig],
	CONSTRAINT [DF_U_AZI_PA_azi_sdbnog] DEFAULT ('    ') FOR [azi_sdbnog],
	CONSTRAINT [DF_U_AZI_PA_azi_cdbsig] DEFAULT ('    ') FOR [azi_cdbsig],
	CONSTRAINT [DF_U_AZI_PA_azi_cdbnog] DEFAULT ('    ') FOR [azi_cdbnog]
go



UPDATE U_AZI_PA SET azi_sdbsig 	= ''
UPDATE U_AZI_PA SET azi_sdbnog 	= ''
UPDATE U_AZI_PA SET azi_cdbsig 	= ''
UPDATE U_AZI_PA SET azi_cdbnog 	= ''