
select mov_dtreg,mov_nregis,mov_numpro,mov_contabilita_previsionale from indice where mov_anno = '2020' order by cast(mov_nregis as numeric(10,0)),mov_dtreg

select mov_dtreg,mov_nregis,mov_numpro,mov_contabilita_previsionale from indice where mov_anno = '2020' order by mov_dtreg,cast(mov_nregis as numeric(10,0))

select mov_top from indice where mov_anno = '2020' and mov_top = 'CHI' order by cast(mov_nregis as numeric(10,0)),mov_dtreg

select mov_dtreg,mov_nregis,mov_numpro,mov_contabilita_previsionale, * from indice where mov_numpro = '_5TL0W8JY5   '

select mov_dtreg,mov_nregis,mov_numpro,mov_contabilita_previsionale, * from indice where mov_nregis = '5896' and mov_anno = '2020'

update indice set mov_dtreg = '2020/10/01' where mov_numpro = '_5TL0W8JY5   '