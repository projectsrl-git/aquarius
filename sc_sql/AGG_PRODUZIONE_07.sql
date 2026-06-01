/* 
*****************************************************************************************************************************
ALLARGAMENTO CAMPI COEFFICIENTI DI IMPIEGO DA DISTINTA BASE IN TABELLA DELLA STRUTTURA PROGRAMMI DI PRODUZIONE
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ALTER COLUMN DIS_QTA numeric(20,7) NULL
ALTER TABLE [dbo].[PRODUZIONE] ALTER COLUMN DIS_QTAT numeric(20,7) NULL
