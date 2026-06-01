
/****** Object:  View [dbo].[ORDINE_PRODUZIONE] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ORDINE_PRODUZIONE]'))
	DROP VIEW [dbo].[ORDINE_PRODUZIONE]
GO
CREATE VIEW [dbo].[ORDINE_PRODUZIONE]  
AS
	SELECT
		NOME_LAVORAZIONE,
		--P_TIG.TEDESCO,
		CAST(CASE
				WHEN CHARINDEX('<percentuale_truciolo>', P_TIG.TEDESCO) > 0 AND CHARINDEX('</percentuale_truciolo>', P_TIG.TEDESCO) > 0 AND
					 (CHARINDEX('</percentuale_truciolo>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_truciolo>', P_TIG.TEDESCO) + LEN('<percentuale_truciolo>')) > 0
				THEN SUBSTRING(P_TIG.TEDESCO, CHARINDEX('<percentuale_truciolo>', P_TIG.TEDESCO) + LEN('<percentuale_truciolo>'), (CHARINDEX('</percentuale_truciolo>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_truciolo>', P_TIG.TEDESCO) + LEN('<percentuale_truciolo>')))
				ELSE '0'
			 END
			AS real) AS PERCENTUALE_TRUCIOLO,
		CAST(CASE
				WHEN CHARINDEX('<percentuale_sfogliato>', P_TIG.TEDESCO) > 0 AND CHARINDEX('</percentuale_sfogliato>', P_TIG.TEDESCO) > 0 AND
					 (CHARINDEX('</percentuale_sfogliato>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_sfogliato>', P_TIG.TEDESCO) + LEN('<percentuale_sfogliato>')) > 0
				THEN SUBSTRING(P_TIG.TEDESCO, CHARINDEX('<percentuale_sfogliato>', P_TIG.TEDESCO) + LEN('<percentuale_sfogliato>'), (CHARINDEX('</percentuale_sfogliato>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_sfogliato>', P_TIG.TEDESCO) + LEN('<percentuale_sfogliato>')))
				ELSE '0'
			 END
			AS real) AS PERCENTUALE_SFOGLIATO,
		CAST(CASE
				WHEN CHARINDEX('<percentuale_raffinato>', P_TIG.TEDESCO) > 0 AND CHARINDEX('</percentuale_raffinato>', P_TIG.TEDESCO) > 0 AND
					 (CHARINDEX('</percentuale_raffinato>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_raffinato>', P_TIG.TEDESCO) + LEN('<percentuale_raffinato>')) > 0
				THEN SUBSTRING(P_TIG.TEDESCO, CHARINDEX('<percentuale_raffinato>', P_TIG.TEDESCO) + LEN('<percentuale_raffinato>'), (CHARINDEX('</percentuale_raffinato>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_raffinato>', P_TIG.TEDESCO) + LEN('<percentuale_raffinato>')))
				ELSE '0'
			 END
			AS real) AS PERCENTUALE_RAFFINATO,
		CAST(CASE
				WHEN CHARINDEX('<percentuale_riciclato>', P_TIG.TEDESCO) > 0 AND CHARINDEX('</percentuale_riciclato>', P_TIG.TEDESCO) > 0 AND
					 (CHARINDEX('</percentuale_riciclato>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_riciclato>', P_TIG.TEDESCO) + LEN('<percentuale_riciclato>')) > 0
				THEN SUBSTRING(P_TIG.TEDESCO, CHARINDEX('<percentuale_riciclato>', P_TIG.TEDESCO) + LEN('<percentuale_riciclato>'), (CHARINDEX('</percentuale_riciclato>', P_TIG.TEDESCO)) - (CHARINDEX('<percentuale_riciclato>', P_TIG.TEDESCO) + LEN('<percentuale_riciclato>')))
				ELSE '0'
			 END
			AS real) AS PERCENTUALE_RICICLATO
	FROM (
		SELECT
			IDPRG,
			SUBSTRING(RTRIM(NUMPRG)+'/'+SUBSTRING(DATPRG,9,2)+SUBSTRING(DATPRG,6,2)+SUBSTRING(DATPRG,3,2)+' '+COALESCE((SELECT TOP 1 COMP FROM PROD_AVANZA WHERE IDPRG = PRODUZIONE.IDPRG AND FASELA = 'PRESSA' ORDER BY SEQUEN),''),1,30) AS NOME_LAVORAZIONE,
			COALESCE((SELECT TOP 1 COMP FROM PROD_AVANZA WHERE IDPRG = PRODUZIONE.IDPRG AND FASELA = 'PRESSA' ORDER BY SEQUEN),'') AS PRODOTTO
		FROM PRODUZIONE
		WHERE PARENT = '' AND FLGCLOSED = 0 AND IDPRG IN (SELECT IDPRG FROM PROD_AVANZA WHERE FASELA = 'PRESSA' AND QTAPROD < QTA) 
		) AS MAIN
	LEFT OUTER JOIN PARA AS P_PRD ON P_PRD.CODICE = 'PRD'+MAIN.PRODOTTO
	LEFT OUTER JOIN PARA AS P_TIG ON P_TIG.CODICE = 'TIG'+P_PRD.LIBERA
GO

SELECT * FROM ORDINE_PRODUZIONE ORDER BY NOME_LAVORAZIONE
