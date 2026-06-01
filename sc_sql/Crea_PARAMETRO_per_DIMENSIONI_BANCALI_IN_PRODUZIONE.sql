
-- PARAMETRO PER DIMENSIONI BANCALI IN PRODUZIONE TAGLIO

delete from para where codice like 'DMB%'

insert into para (codice,descri,libera) values ('DMB01','Pallet in legno standard 120 X 80','120 X 80')
insert into para (codice,descri,libera) values ('DMB02','Pallet in legno standard 120 X 100','120 X 100')
insert into para (codice,descri,libera) values ('DMB03','Pallet in legno pressato 114 X 114 ','114 X 114 ')

select * from para where codice like 'DMB%'


