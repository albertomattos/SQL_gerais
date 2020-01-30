select t.codigo, t.descricao, t.cod_bancada from faprdcad t where t.tipo_prd = 'LAB'
and t.bloqueado = 'N' and t.cod_bancada = 'BIOQ'
