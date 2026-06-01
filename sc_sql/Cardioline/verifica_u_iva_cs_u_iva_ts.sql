select * from part_cli where PAR_DTREG between '2013/10/25' and '2013/10/25'

update part_cli set par_desmov = 'Fatt.Sospens.IVA incassata' where id_unique = 'FE4B8AEB-6E79-401A-A505-8AC1C8F7D170'

select par_desmov,* from part_cli where PAR_DTREG between '2013/10/25' and '2013/10/25' and par_desmov = 'Fatt.Sospens.IVA incassata' ORDER BY PAR_DTREG, PAR_CODCLI

select par_tipfat,par_desmov,PAR_NPROT,par_fatt,par_dtreg,* from part_cli where PAR_CODCLI = '0701100100024'  and PAR_TIPFAT = 'FVS' ORDER BY PAR_DTREG, PAR_CODCLI

select par_tipfat,par_desmov,PAR_NPROT,par_fatt,par_dtreg,* from part_cli where PAR_CODCLI = '0701100100024'  and PAR_TIPFAT = 'FVS' and par_nprog = '100'


select par_desmov,* from part_cli where PAR_CODCLI = '0701100100024'  and PAR_NPART = '130253' and PAR_NPROG = '100' ORDER BY PAR_DTREG, PAR_CODCLI

    SELECT *
    FROM 
        PART_CLI
    WHERE 
        PAR_DESMOV = 'Fatt.Sospens.IVA incassata'
		AND PAR_DTREG >= '2013/10/01'
		AND PAR_DTREG <= '2013/10/31'
	ORDER BY PAR_DTREG, PAR_CODCLI
	



select par_desmov,* from part_cli where PAR_DTREG between '2013/10/25' and '2013/10/25' ORDER BY PAR_DTREG, PAR_CODCLI

SELECT * FROM PARA WHERE CODICE LIKE 'IVA22'




          
   select * from U_IVA_CS where iva_codsoc = '01' and iva_anno = '2013' and iva_mese = '10' and iva_chiave = 6 and iva_codiva = '22' and iva_fatnot = 'F' and iva_bollatoiva = '' order by iva_codsoc,iva_anno,iva_mese,iva_chiave,iva_codiva,iva_fatnot
               

SELECT * FROM U_FAT_TT where rtrim(len(ord_numord)) < 6