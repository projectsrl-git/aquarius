
IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'segnalaErrore' AND type = 'TR')
   DROP TRIGGER segnalaErrore
GO

CREATE TRIGGER segnalaErrore
ON dbo.L_BOL_TT
FOR INSERT
AS

declare @_tipolog varchar(50)
declare @_datalog varchar(10)
declare @_oralog  varchar(8)
declare @_numDDT  varchar(6)
declare @_dataDDT varchar(10)
declare @_ragsoc  varchar(80)

declare @_corpoMsg varchar(1000)
declare @_nomeserver varchar(80)
declare @_oggetto varchar(80)


select  @_tipolog = LOG_TIPLOG from inserted
select  @_datalog = substring(LOG_DATLOG,9,2)+'/'+substring(LOG_DATLOG,6,2)+'/'+substring(LOG_DATLOG,1,4) from inserted
select  @_oralog  = LOG_ORALOG from inserted
select  @_numDDT  = ORD_NUMORD from inserted
select  @_dataDDT = substring(ORD_DATORD,9,2)+'/'+substring(ORD_DATORD,6,2)+'/'+substring(ORD_DATORD,1,4) from inserted
select  @_ragsoc  = ORD_RAGSOC from inserted

SELECT @_nomeserver = CONVERT(char(20), SERVERPROPERTY('servername'))

SET @_corpoMsg = '#######################################################' + CHAR(13) + 
			 CHAR(9) + CHAR(9) + CHAR(9) + 'ATTENZIONE !!!' + CHAR(13) + 
	         '#######################################################' + CHAR(13) + CHAR(13) +
	         'Si è verificato un ERRORE sul gestionale DDT : ' + CHAR(13) + CHAR(13) + 	         		 	 
		     'RIFERIMENTI :' + CHAR(13) + 
		 	 CHAR(9) + 'Data LOG   : '+ @_datalog + CHAR(13) +
		 	 CHAR(9) + 'Ora LOG    : '+ @_oralog + CHAR(13) +
		 	 CHAR(9) + 'Numero DDT : '+ @_numDDT + CHAR(13) +
		 	 CHAR(9) + 'Data DDT   : '+ @_dataDDT + CHAR(13) + 
		 	 CHAR(9) + 'Cliente    : '+ @_ragsoc + CHAR(13) + CHAR(13) +
		 	 '-------------------------------------------------------' + CHAR(13) +
		 	 'Verificare tabelle L_BOL_TT, L_BOL_DD, L_BOL_LE'+ CHAR(13) +
		 	 '-------------------------------------------------------' + CHAR(13) + CHAR(13) +
	         '#######################################################' + CHAR(13) + CHAR(13) +
	         CHAR(9) + 'Anomalia rilevata sul server : ' + @_nomeserver+ CHAR(13) + CHAR(13) +
	         '#######################################################'


IF (@_nomeserver = 'SERVERXEON')
	begin
		set @_oggetto = 'TEST TEST --- ANOMALIA IN SOPRAD --- TEST TEST'
	end
else	
	begin
		set @_oggetto = '@@@@@@ ANOMALIA IN SOPRAD @@@@@@'
	end


 		 
/* IF (@_tipolog = 'ORIGINALE')  -- per fare i test */

IF (@_tipolog = 'ERRORE-ORIGINALE')
	begin
		exec msdb.dbo.sp_send_dbmail
		  @profile_name = 'SQL_Project',
		  @recipients = 'simone.massa@project-online.it',
		  @copy_recipients = 'fabiano.moda@project-online.it;erasmo.masiello@project-online.it;sergio.piaggi@project-online.it',		  
		  @body = @_corpoMsg,
		  @subject = @_oggetto,
		  @importance = 'High';
	end


