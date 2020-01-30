select c.tipo_prd, a.conta_ctb_deb, a.conta_ctb_cre, b.cod_tpo, c.descricao
from de_para_iq_tprdctb a, de_para_iq_tpotprd b, fatipcad c
where c.tipo_prd = a.tipo_prd
and a.tipo_prd = b.tipo_prd
order by b.cod_tpo
