select cod_set, codigo, descricao, tipo_prd, b.est_atu, custo_atu, doc_ultmov, ult_compra, dat_ultmov
from faprdcad a, esestcad b, esmovcad c, esmovite d
where a.codigo = b.cod_prd
and c.documento = d.documento
and c.tipo_documento = d.tipo_documento
and d.cod_prd = a.codigo
and d.cod_prd = b.cod_prd
and bloqueado = 'N' and a.dat_ultmov < '01/03/2012'
/*and tipo_cons = "0"*/
--and tipo_prd = "FIO"
and tipo_prd = 'MED'--in (select tipo_prd from fatipcad where pre_class = 'MAT')
--and b.est_atu <> 0
group by cod_set, codigo, descricao, tipo_prd, b.est_atu, custo_atu, doc_ultmov, ult_compra, dat_ultmov
order by cod_set,a.descricao
