select data_baixa, valor_pago, valor_guia, valor_dir, valor_tot, remessa
from faremcad where data_baixa is not null --and cod_con = "004"
and data_baixa between '01/01/2011' and '31/12/2011'
and remessa in (select remessa from fafatcad where cod_pac = '1322151')
order by data_baixa

select data_baixa, valor_pago, valor_guia, valor_dir, valor_tot, remessa
from faremcad where remessa = "033848"
order by data_baixa

select data_baixa, valor_pago, valor_guia, valor_dir, valor_tot, remessa
from faremcad where valor_guia between "1300.00" and "1400.00" and cod_con = "001"
order by valor_guia


select * from quitacao_produto where cod_pac = '1322151'
select * from fafatcad where cod_pac = '1322151'
