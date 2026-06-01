/********************************************************************
 PARAMETRO RIFERIMENTI ORDINI -- DDT 
*********************************************************************
********************************************************************/

delete from para where SUBSTRING(codice,1,3) = 'RIO'
delete from para where SUBSTRING(codice,1,3) = 'RIB'
insert into para (codice,descri) values ('RIOVS1','A SALDO VS ORDINE N. ')
insert into para (codice,descri) values ('RIOVS2','IN CONTO VS ORDINE N. ')
insert into para (codice,descri) values ('RIONS1','A SALDO NS ORDINE N. ')
insert into para (codice,descri) values ('RIONS2','IN CONTO NS ORDINE N. ')
insert into para (codice,descri) values ('RIOORD','Rif. ordine Nr. ')
insert into para (codice,descri) values ('RIODEL','Del ')
insert into para (codice,descri) values ('RIOVS3','VS. RIF. ')
insert into para (codice,descri) values ('RIB001','D.d.T. N. ')
insert into para (codice,descri) values ('RIB002','Del ')
insert into para (codice,descri) values ('RIB003','Cliente ')
insert into para (codice,descri) values ('RIB004','Destinazione ')
insert into para (codice,descri) values ('RIB005','CLASSI DOGANALI ')

select * from para where codice like 'RIO%'
select * from para where codice like 'RIB%'


/********************************************************************
 TABELLA DESLINGUE  : RIFERIMENTO ORDINI
*********************************************************************
********************************************************************/

delete deslingue where tipodes = 'RIFERI-ORD' 

insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM11L6JO','RIFERI-ORD','008','VS1','A PAYMENT ORDER No. VS ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM11MR04','RIFERI-ORD','008','VS2','ACCOUNT IN ORDER VS N. ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM19UT2B','RIFERI-ORD','008','VS3','YOUR REF. ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM11J67J','RIFERI-ORD','008','ORD','ORDER REFERENCE NR. ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM11GBJH','RIFERI-ORD','008','NS1','A PAYMENT ORDER No. NS ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM11HGLX','RIFERI-ORD','008','NS2','NS ACCOUNT IN ORDER N. ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM1631U8','RIFERI-ORD','008','DEL',' OF ','')

select * from deslingue where tipodes = 'RIFERI-ORD' 

/********************************************************************
 TABELLA DESLINGUE  : RIFERIMENTO DOCUMENTI DI TRASPORTO
*********************************************************************
********************************************************************/

delete deslingue where tipodes = 'RIFERI-DDT' 
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM13353Q','RIFERI-DDT','008','001','TRANSPORT DOC. No. ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM1DBYB8','RIFERI-DDT','008','002',' OF ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM1DEGCQ','RIFERI-DDT','008','003','Customer ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM1DGCWH','RIFERI-DDT','008','004','Destination ','')
insert into deslingue (iddesling,tipodes,lingua,codice,descri,desest) values ('_3ZM1DUT02','RIFERI-DDT','008','005','CLASS CUSTOMS: ','')


select * from deslingue where tipodes = 'RIFERI-DDT' 