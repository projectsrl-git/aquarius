select par_sys,par_npart,par_nprog,par_tipfat,par_dtscad,* from part_cli where par_codcli = '1010200001468' ORDER BY PAR_NPART,PAR_NPROG,par_dtscad



SELECT SUBSTRING(PAR_DTSCAD,7,4)+'/'+SUBSTRING(PAR_DTSCAD,4,2)+'/'+SUBSTRING(PAR_DTSCAD,1,2) FROM PART_CLI WHERE par_codcli = '1010200001468' AND PAR_NPROG <> '100'

--UPDATE PART_CLI SET PAR_DTSCAD =  SUBSTRING(PAR_DTSCAD,7,4)+'/'+SUBSTRING(PAR_DTSCAD,4,2)+'/'+SUBSTRING(PAR_DTSCAD,1,2) WHERE par_codcli = '1010200001468' AND PAR_NPROG <> '100'

select par_anno,par_sys,par_tipfat,par_dtscad,* from part_cli where par_codcli = '1010200001468' AND PAR_NPART = 8121744  order by par_dtscad

--UPDATE PART_CLI SET PAR_NPART = 9121744  WHERE par_codcli = '1010200001468' AND PAR_NPART = 8121744

SELECT PAR_nprog,par_anno,par_sys,par_tipfat,par_dtscad,* FROM PART_CLI WHERE par_codcli = '1010200001468' and par_npart =      9120458    order by PAR_DTSCAD
SELECT par_anno,par_sys,par_tipfat,par_dtscad,* FROM PART_CLI WHERE par_codcli = '1010200001468' and par_npart = 9121744  and par_nprog <> 100 order by PAR_DTSCAD
SELECT par_anno,par_sys,par_tipfat,par_dtscad,* FROM PART_CLI WHERE par_codcli = '1010200001468' and par_npart = 9121744  and par_anno = '2012' and par_nprog <> 100 and par_tipodo = 'FAT' order by PAR_DTSCAD



SELECT par_anno,par_sys,par_tipfat,par_dtscad,* FROM PART_CLI WHERE par_codsoc = '01' and par_codcli = '1010200001468' and par_npart = 9121744 and par_anno = '2012' and par_nprog <> 100 and par_tipodo = 'FAT' order by PAR_DTSCAD
