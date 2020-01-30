select count(t.cod_agenda) from imagnexa t, imagncad u where t.cod_agenda = u.cod_agenda
and u.data between '01/01/2015' and '31/01/2015'
and u.cod_sala in ('0001','0002','0003','0004','0005','0006','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0019','0020','0021','0022','0023','0024','0025','0026','0027','0028','0029','0030','0031','0032','0033')
and (t.cod_pac is null or t.cod_pac = ' ')
