
/*
################################################################
-- AGGIORNAMENTO TABELLA U_CLI_AN PER CLIENTI IN SOSPENSIONE IVA
################################################################
*/

UPDATE U_CLI_AN SET CLI_SOSIMP = (
	CASE
		WHEN U_CLI_AN.CLI_CODCLI IN (SELECT CODCF FROM CARD_CFVEN WHERE FATIVASOSP = 'S' AND TIPO = 'C') THEN 'FVS'
		ELSE ''
	END)

SELECT CLI_CODCLI,CLI_RAGSOC,CLI_SOSIMP FROM U_CLI_AN WHERE CLI_SOSIMP <> ''
