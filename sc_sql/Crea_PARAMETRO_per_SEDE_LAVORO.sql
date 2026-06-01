
-- PARAMETRO PER SEDE LAVORO nei ticket

delete from para where codice like 'SDL%'

insert into para (codice,descri,libera) values ('SDL001','Sede Cliente','01')
insert into para (codice,descri,libera) values ('SDL002','Sede Project Cava Manara','02')
insert into para (codice,descri,libera) values ('SDL003','Sede Project Formia','03')

select * from para where codice like 'SDL%'