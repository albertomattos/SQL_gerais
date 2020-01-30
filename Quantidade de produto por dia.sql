select c.data_mov, count (*) quantidade
from famovcad c, famovprd p
where p.comanda=c.comanda and p.codigo = "000111" and c.data_mov between "01/07/2005" and "31/07/2005"
and c.hora_mov between "07:00" and "18:59"
group by c.data_mov, p.codigo
order by data_mov

