select a.numcad matricula, a.nomfun nome, b.nomloc setor, c.titcar cargo, d.dessit situacao,
       e.valsal salario
from R034FUN a inner join r016orn b on a.numloc = b.numloc
               inner join R024CAR c on a.codcar = c.codcar
               inner join R010SIT d on a.sitafa = d.codsit
               inner join R038HSA e on a.numcad = e.numcad
where 1=1 --and a.numcad = '1396' --and a.codetb = '1' and b.numloc = '328'
    and a.sitafa != '7'
      and e.datalt=(select max(e2.datalt) from R038HSA e2 where a.numcad = e2.numcad and e2.datalt between to_date('01/01/2000', 'dd/mm/yyyy') and to_date('30/05/2016', 'dd/mm/yyyy'))
order by 2
