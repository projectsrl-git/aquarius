SELECT * FROM CONTI WHERE CON_TIPOCO = 'F' AND len(con_conto) = 12  and con_anno = '2016'
DELETE FROM CONTI WHERE CON_TIPOCO = 'F' AND len(con_conto) = 12  and con_anno = '2016'


SELECT * FROM CONTI WHERE CON_TIPOCO = 'C' AND len(con_conto) = 12  and con_anno = '2016'
DELETE FROM CONTI WHERE CON_TIPOCO = 'C' AND len(con_conto) = 12  and con_anno = '2016'

--211000000010 
--2110000000010

SELECT * FROM MOV_CONT WHERE len(mov_conto) = 12  and mov_anno = '2016'