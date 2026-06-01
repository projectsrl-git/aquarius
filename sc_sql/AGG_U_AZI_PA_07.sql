/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_stipe varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_stipe]  DEFAULT ('   ') FOR [azi_stipe]
go


UPDATE U_AZI_PA SET azi_stipe = space(03)



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_inccli varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_inccli]  DEFAULT ('   ') FOR [azi_inccli]
go


UPDATE U_AZI_PA SET azi_inccli = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_effpas varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_effpas]  DEFAULT ('   ') FOR [azi_effpas]
go


UPDATE U_AZI_PA SET azi_effpas = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_effatt varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_effatt]  DEFAULT ('   ') FOR [azi_effatt]
go


UPDATE U_AZI_PA SET azi_effatt = space(03)



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_contr varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_contr]  DEFAULT ('   ') FOR [azi_contr]
go


UPDATE U_AZI_PA SET azi_contr = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_leasin varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_leasin]  DEFAULT ('   ') FOR [azi_leasin]
go


UPDATE U_AZI_PA SET azi_leasin = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_finan varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_finan]  DEFAULT ('   ') FOR [azi_finan]
go


UPDATE U_AZI_PA SET azi_finan = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_comcli varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_comcli]  DEFAULT ('   ') FOR [azi_comcli]
go


UPDATE U_AZI_PA SET azi_comcli = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_comfor varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_comfor]  DEFAULT ('   ') FOR [azi_comfor]
go


UPDATE U_AZI_PA SET azi_comfor = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_dare varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_dare]  DEFAULT ('   ') FOR [azi_dare]
go


UPDATE U_AZI_PA SET azi_dare = space(03)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 azi_avere varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_avere]  DEFAULT ('   ') FOR [azi_avere]
go


UPDATE U_AZI_PA SET azi_avere = space(03)
