
-- PARAMETRO PER DIMENSIONI BANCALI IN PRODUZIONE TAGLIO

delete from para where codice like 'DMB%'

insert into para (codice,descri,libera,DESIVA) values ('DMB01','Pallet in legno standard 80 X 60','80 X 60','10')
insert into para (codice,descri,libera,DESIVA) values ('DMB02','Pallet in legno standard 120 X 80','120 X 80','20')
insert into para (codice,descri,libera,DESIVA) values ('DMB03','Pallet in legno standard 120 X 100','120 X 100','25')

select * from para where codice like 'DMB%'
