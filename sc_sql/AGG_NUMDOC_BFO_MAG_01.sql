
/***********************************************/
/* ALTERAZIONE DELLA SOLA DIMENSIONE DEL CAMPO */
/***********************************************/

ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_NUMORD varchar(20) NULL
GO

ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 TNUMERO varchar(20) NULL
GO

ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
	 ORS_NUMORD varchar(20) NULL
GO

ALTER TABLE [dbo].[U_MAG_MO] ALTER COLUMN
	 MOV_NUMDOC varchar(20) NULL
GO
