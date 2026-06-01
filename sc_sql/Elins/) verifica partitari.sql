SELECT PAR_DTREG AS DTREG,* FROM PART_FOR WHERE PAR_ANNO = '2023' ORDER BY PAR_DTREG,PAR_NPART,PAR_NPROG

--DELETE FROM PART_FOR WHERE ID_UNIQUE = 'DB004B9F-F231-4E7A-9389-86B7AB991040'
--DELETE FROM PART_FOR WHERE ID_UNIQUE = '14A5D3B2-E839-49E3-8F28-B7934070AEE7'


SELECT LEG_CODTOP,LEG_SEQUEN AS SEQUEN,LEG_CODSYS AS CODSYS,* FROM U_CCO_LE ORDER BY LEG_CODSYS,LEG_SEQUEN

select * FROM U_CCO_LE where leg_codsoc = '01' order by leg_codsoc,leg_codtop,leg_codcon,leg_sequen


select par_codcli,par_npart from part_cli where par_anno = '2022' group by par_codcli,par_npart order by par_codcli,par_npart

select par_codcli,par_npart,'   ' AS apeclo,'   ' AS fattura,'   ' AS pagamento  from part_cli where par_anno = '2023' group by par_codcli,par_npart order by par_codcli,par_npart

SELECT PAR_DTREG AS DTREG,* FROM PART_CLI WHERE PAR_ANNO = '2023' AND PAR_NPART = '387454' ORDER BY PAR_DTREG,PAR_NPART,PAR_NPROG


SELECT PART_CLI.*, COALESCE(SUBSTRING(PARA_TOP.LIBERA,2,1),'') AS FATTU FROM PART_CLI LEFT OUTER JOIN PARA AS PARA_TOP ON PARA_TOP.CODICE = 'TOP'+PART_CLI.PAR_TIPFAT WHERE par_codsoc = '01' and par_npart = '387454' order by par_codsoc,par_codcli

SELECT PAR_TIPFAT,PAR_NREG,PAR_DTREG AS DTREG,* FROM PART_FOR ORDER BY PAR_DTREG DESC, PAR_NPART,PAR_NPROG
SELECT PAR_TIPFAT,PAR_NREG,PAR_DTREG AS DTREG,* FROM PART_CLI ORDER BY PAR_DTREG DESC, PAR_NPART,PAR_NPROG


select par_codcli,par_npart,par_nreg,par_dtreg,'   ' AS apeclo,'       ' AS fattura,'       ' AS pagamento  from part_cli where par_codsoc = '01' and par_dtreg between '2023/01/01' and '2023/12/31' group by par_codcli,par_npart order by par_codcli,par_npart





