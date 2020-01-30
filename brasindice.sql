select codigo, cod_bras, descricao, divisor, preco, ult_atu_bras, cod_erro
from braswpd_prod where cod_erro like 'Cód. BrasÍndice%' order by codigo
