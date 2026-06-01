
-- ARTICOLI DOPPI IN U_ART_PR
select * from u_art_pr where ART_CODPRI in
      (select ART_CODPRI from (
      select ART_CODPRI,count(*) as nr_righe from u_art_pr group by ART_CODPRI)
      as ART1 where ART1.nr_righe > 1)

-- ARTICOLI DOPPI IN U_ART_AN
select * from u_art_AN where ART_CODPRI in
      (select ART_CODPRI from (
      select ART_CODPRI,count(*) as nr_righe from u_art_AN group by ART_CODPRI)
      as ART1 where ART1.nr_righe > 1)
