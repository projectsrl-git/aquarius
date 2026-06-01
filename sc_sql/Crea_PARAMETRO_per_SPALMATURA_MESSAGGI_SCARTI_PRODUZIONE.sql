
delete from para where codice like 'CSPSCA%'

insert into para (codice,descri) values ('CSPSCA001','Avviamento')
insert into para (codice,descri) values ('CSPSCA002','Film rotto')

select * from para where codice like 'CSPSCA%' order by codice

