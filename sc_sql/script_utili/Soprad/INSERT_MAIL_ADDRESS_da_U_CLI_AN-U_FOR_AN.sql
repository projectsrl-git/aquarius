
-- OFFERTE CLIENTI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'C' AS CLI_FOR, CLI_CODCLI AS CODICE_CLI_FOR, 'OFF' AS TIPO_DOC,
		cli_mailto AS INDIRIZZO_A, cli_mailcc AS INDIRIZZO_CC, cli_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_cli_an 
	where substring(cli_mailto,1,1) <> '' or substring(cli_mailcc,1,1) <> '' or substring(cli_mailcn,1,1) <> ''

-- ORDINI CLIENTI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'C' AS CLI_FOR, CLI_CODCLI AS CODICE_CLI_FOR, 'ORD' AS TIPO_DOC,
		cli_mailto AS INDIRIZZO_A, cli_mailcc AS INDIRIZZO_CC, cli_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_cli_an 
	where substring(cli_mailto,1,1) <> '' or substring(cli_mailcc,1,1) <> '' or substring(cli_mailcn,1,1) <> ''

-- BOLLE CLIENTI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'C' AS CLI_FOR, CLI_CODCLI AS CODICE_CLI_FOR, 'BOL' AS TIPO_DOC,
		cli_mailto AS INDIRIZZO_A, cli_mailcc AS INDIRIZZO_CC, cli_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_cli_an 
	where substring(cli_mailto,1,1) <> '' or substring(cli_mailcc,1,1) <> '' or substring(cli_mailcn,1,1) <> ''

-- FATTURE PROFORMA CLIENTI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'C' AS CLI_FOR, CLI_CODCLI AS CODICE_CLI_FOR, 'FAP' AS TIPO_DOC,
		cli_mailto AS INDIRIZZO_A, cli_mailcc AS INDIRIZZO_CC, cli_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_cli_an 
	where substring(cli_mailto,1,1) <> '' or substring(cli_mailcc,1,1) <> '' or substring(cli_mailcn,1,1) <> ''

-- FATTURE CLIENTI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'C' AS CLI_FOR, CLI_CODCLI AS CODICE_CLI_FOR, 'FAT' AS TIPO_DOC,
		cli_mailto AS INDIRIZZO_A, cli_mailcc AS INDIRIZZO_CC, cli_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_cli_an 
	where substring(cli_mailto,1,1) <> '' or substring(cli_mailcc,1,1) <> '' or substring(cli_mailcn,1,1) <> ''



-- ORDINI FORNITORI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'F' AS CLI_FOR, FOR_CODCLI AS CODICE_CLI_FOR, 'ORF' AS TIPO_DOC,
		FOR_mailto AS INDIRIZZO_A, FOR_mailcc AS INDIRIZZO_CC, FOR_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_FOR_an 
	where substring(FOR_mailto,1,1) <> '' or substring(FOR_mailcc,1,1) <> '' or substring(FOR_mailcn,1,1) <> ''

-- DOCUMENTI DI CARICO DA FORNITORI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'F' AS CLI_FOR, FOR_CODCLI AS CODICE_CLI_FOR, 'BFO' AS TIPO_DOC,
		FOR_mailto AS INDIRIZZO_A, FOR_mailcc AS INDIRIZZO_CC, FOR_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_FOR_an 
	where substring(FOR_mailto,1,1) <> '' or substring(FOR_mailcc,1,1) <> '' or substring(FOR_mailcn,1,1) <> ''

-- RESI A FORNITORI
INSERT INTO MAIL_ADDRESS (CLI_FOR, CODICE_CLI_FOR, TIPO_DOC, INDIRIZZO_A, INDIRIZZO_CC, INDIRIZZO_CCN, OGGETTO, CORPO)
	SELECT 'F' AS CLI_FOR, FOR_CODCLI AS CODICE_CLI_FOR, 'REF' AS TIPO_DOC,
		FOR_mailto AS INDIRIZZO_A, FOR_mailcc AS INDIRIZZO_CC, FOR_mailcn AS INDIRIZZO_CCN,
		'' AS OGGETTO, '' AS CORPO
	from u_FOR_an 
	where substring(FOR_mailto,1,1) <> '' or substring(FOR_mailcc,1,1) <> '' or substring(FOR_mailcn,1,1) <> ''