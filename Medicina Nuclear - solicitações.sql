select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.descricao) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA
  and c.COD_PAC = a.COD_PAC
  and d.COMANDA = c.COMANDA
  and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD
  and f.TIPO_PRD = e.TIPO_PRD
  and f.tipo_prd in ('MEN')
  and to_char(a.data_ent,'MMYYYY') between '012012' and '102012'
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
