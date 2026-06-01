USE [Kuberth]
GO

/****** Object:  StoredProcedure [dbo].[ALERT_SCORTE_MINIME]    Script Date: 06/06/2023 12:38:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ALERT_SCORTE_MINIME]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @NR_ARTICOLI_SOTTOSCORTA as numeric(20,0)

	SET @NR_ARTICOLI_SOTTOSCORTA = (SELECT COUNT(*) FROM (SELECT ART_CODPRI,CAST(ART_SCORMI AS numeric(20,2)) AS ART_SCORMI,CAST(COALESCE((SELECT ROUND(SUM(MAG_GIACEN),2) FROM kuberth.dbo.U_MAG_GG WHERE MAG_CODMAG = ART_MAGA AND MAG_ANAART = ART_CODPRI),0) AS numeric(20,2)) AS MAG_GIACEN FROM kuberth.dbo.U_ART_PR WHERE ART_SCORMI > 0) AS MAIN WHERE MAG_GIACEN < ART_SCORMI)

	IF (@NR_ARTICOLI_SOTTOSCORTA > 0)
		BEGIN

			DECLARE @sub VARCHAR(100);
			DECLARE @qry VARCHAR(1000);
			DECLARE @msg VARCHAR(500);
			DECLARE @query NVARCHAR(1000);
			DECLARE @query_attachment_filename NVARCHAR(520);
			SELECT @sub = 'Alert Scorte minime magazzino Kuberth';
			SELECT @msg = 'Gentile utente Aquarius,' + char(13) + char(13) + 
				'questo è un messaggio inviato automaticamente dal sistema di database di Aquarius per informarla della presenza di articoli sotto scorta minima.' + char(13) + char(13) + 
				'Può consultare la lista di tali articoli nel file allegato.' + char(13) + char(13) + char(13) +
				'Staff Project Srl'
			SELECT @query = 'SET NOCOUNT ON;
			SELECT
				rtrim(ART_CODPRI) AS COD_ARTICOLO,
				rtrim(ART_DESCR) AS DESCRIZIONE,
				rtrim(ART_MAGA) AS MAGAZZINO,
				REPLACE(cast(ART_SCORMI as varchar(20)),''.'','','') AS SCORTA_MINIMA,
				REPLACE(cast(MAG_GIACEN as varchar(20)),''.'','','') AS GIACENZA
			FROM (
				SELECT * FROM (
						SELECT 
							ART_CODPRI,
							ART_DESCR,
							ART_MAGA,
							CAST(ART_SCORMI AS numeric(20,2)) AS ART_SCORMI,
							CAST(COALESCE((SELECT ROUND(SUM(MAG_GIACEN),2) FROM kuberth.dbo.U_MAG_GG WHERE MAG_CODMAG = ART_MAGA AND MAG_ANAART = ART_CODPRI),0) AS numeric(20,2)) AS MAG_GIACEN
						FROM kuberth.dbo.U_ART_PR
						WHERE ART_SCORMI > 0
					) AS MAIN
				WHERE MAG_GIACEN < ART_SCORMI
			) AS TAB
			ORDER BY COD_ARTICOLO';
			SELECT @query_attachment_filename = 'ScorteMinime.csv';
			EXEC msdb.dbo.sp_send_dbmail
				 @profile_name = 'Reporting',
				 @recipients = 'amministrazione@kuberth.com',
				 @blind_copy_recipients = 'erasmo.masiello@projectsrl.net',
				 @body = @msg,
				 @subject = @sub,
				 @query = @query,
				 @query_attachment_filename = @query_attachment_filename,
				 @attach_query_result_as_file = 1,
				 @query_result_header = 5,
				 @query_result_width = 256,
				 @query_result_separator = '	',
				 @query_result_no_padding = 1;

		END

END


GO


