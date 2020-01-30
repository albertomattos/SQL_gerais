--select * from famovcad
--select * from famovprd where codigo = "007178"

select c.data_mov, count (*)
from famovcad c, famovprd p
where p.comanda=c.comanda and p.codigo = "016858" and c.data_mov between "01/07/2004" and "31/07/2004"
and c.hora_mov between "07:00" and "18:59"
group by c.data_mov, p.codigo
order by data_mov

