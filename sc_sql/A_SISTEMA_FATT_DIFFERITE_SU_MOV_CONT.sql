select iva_numdoc,iva_bollatoiva,iva_top,iva_dtfatt,iva_numfat,iva_codcli,iva_imponi,iva_impost,iva_totale,* from u_iva_cl where iva_anno = '2005' and iva_mese = '03' order by iva_numdoc

select iva_numdoc,iva_bollatoiva,iva_top,iva_dtfatt,iva_numfat,iva_codcli,iva_imponi,iva_impost,iva_totale,* from u_iva_cl where iva_anno = '2005' and iva_mese = '03' AND IVA_NUMDOC = '000259' order by iva_numdoc
select MOV_BOLLATOIVA,MOV_DTDOC,MOV_NDOC,MOV_NREGIS,MOV_NPROT,MOV_NPART,MOV_CONTO,MOV_TOP,MOV_IMP,MOV_IMPOST,* from mov_cont where mov_anno = '2005' and mov_top = 'VEN' AND MOV_NPROT = '000259' ORDER BY MOV_SEQUEN
UPDATE mov_cont SET MOV_BOLLATOIVA = 'D' where mov_anno = '2005' and mov_top = 'VEN' AND MOV_NPROT = '000259' 




