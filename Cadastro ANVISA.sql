select t.tipo_prd, t.codigo, t.descricao produto, t.num_registro anvisa, t.nu_ref_mat ref_tuss
from faprdcad t where t.bloqueado = 'N' and t.tipo_prd in ('MED','MQU','OPM')
order by 1,3
