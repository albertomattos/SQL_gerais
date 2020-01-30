SELECT esmovcad.DOCUMENTO, esmovcad.SET_CON, FASETCAD.DESCRICAO, esmovcad.hra_movimentacao, esmovcad.DATA_MOV, esmovcad.COD_PAC, 
       fausucad.apelido FROM esmovcad esmovcad,FASETCAD FASETCAD, fausucad fausucad
WHERE FASETCAD.COD_SET = esmovcad.SET_CON and esmovcad.fk_matricula = fausucad.matricula
       AND (( esmovcad.DATA_MOV BETWEEN TO_DATE('2017/12/01','YYYY/MM/DD') AND TO_DATE('2017/12/15','YYYY/MM/DD') )
       AND ( esmovcad.SET_EST = '0155') AND ( esmovcad.cred_deb = 'D' ))
ORDER BY esmovcad.DATA_MOV, esmovcad.hra_movimentacao

select * from famovcad where comanda = '9988534'
SELECT famovcad.comanda, famovcad.set_ori, FASETCAD.DESCRICAO, famovcad.data_mov, famovcad.hora_mov, famovcad.data_hora_dig,
 famovcad.COD_PAC FROM famovcad famovcad,FASETCAD FASETCAD
WHERE FASETCAD.COD_SET = famovcad.set_ori
       AND (( famovcad.DATA_MOV BETWEEN TO_DATE('2017/12/01','YYYY/MM/DD') AND TO_DATE('2017/12/15','YYYY/MM/DD') )
       AND ( famovcad.SET_EST = '0155') AND ( famovcad.req_dev = 'D' ))
ORDER BY famovcad.DATA_MOV, famovcad.hora_mov
