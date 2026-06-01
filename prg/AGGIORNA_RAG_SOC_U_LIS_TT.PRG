
_risp = MESSAGEBOX("Aggiornare la ragione sociale dei clienti sui Listini cliente/articolo?",4+32+256,"Attenzione")
IF _RISP = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",48,"Attenzione")
	RETURN .F.
ENDIF

cSql=""
cNomeCursorSql="UPD_LIS_TT"
TEXT TO cSql NOSHOW
	update u_lis_tt set lis_ragsoc = (select top 1 cli_ragsoc from u_cli_an where cli_codcli = lis_codcli)
	where lis_codcli <> '' and lis_codcli in (
		select distinct lis_codcli from (
			select lis_codcli,lis_ragsoc,cli_ragsoc
			from u_lis_tt
			left outer join u_cli_an on cli_codcli = lis_codcli
			where lis_codcli <> ''
			) as main
		where lis_ragsoc <> cli_ragsoc)
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

MESSAGEBOX("Operazione effettuata",64,"Informazione")