select mov_dtdocu,mov_dtregi,mov_oramov,mov_top,mov_segno,mov_qtamov,mov_codmag,* from u_mag_mo where mov_nrlint = 25000121 order by mov_dtregi,mov_oramov

update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000588
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000589
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000590
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000591
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000592
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000593
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000594
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000595
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000596
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000597
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000598
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000599
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000600
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000601
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000602
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000603
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000604
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000605
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000606
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000624
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000625
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000656
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000657
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000658
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000659
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000660
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000654
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 15000655

update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 25000121
delete from u_mag_mo where mov_nrlint = 25000121 and mov_dtregi = '2005/02/14'
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 25000122
delete from u_mag_mo where mov_nrlint = 25000122 and mov_dtregi = '2005/02/14' and mov_top <> 'SPS'
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 25000123
delete from u_mag_mo where mov_nrlint = 25000123 and mov_dtregi = '2005/02/14'
update u_mag_mo set mov_dtregi = mov_dtdocu where mov_top = 'BFO' and mov_nrlint = 25000124
delete from u_mag_mo where mov_nrlint = 25000124 and mov_dtregi = '2005/02/14'

DELETE FROM U_MAG_GG WHERE MAG_GIACEN < 0
DELETE FROM U_MAG_GG WHERE MAG_CODMAG = 'SEDE'


