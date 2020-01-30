select a.datadm, a.nomfun nome, b.nomloc setor, c.titcar cargo
from R034FUN a inner join r016orn b on a.numloc = b.numloc
               inner join R024CAR c on a.codcar = c.codcar
               inner join R010SIT d on a.sitafa = d.codsit
where a.sitafa != '7' and a.datadm >= '01/09/2016'
--      and e.datalt=(select max(e2.datalt) from R038HSA e2 where a.numcad = e2.numcad and e2.datalt between to_date('01/01/2000', 'dd/mm/yyyy') and to_date('30/05/2016', 'dd/mm/yyyy'))
order by 2
