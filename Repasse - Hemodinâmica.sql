select distinct numero_repasse from fafatprd t where fatura in
(select fatura from fafatcad where data_emiss between '01/01/2012' and '31/01/2012')
and cod_set = '0124'
select distinct numero_repasse from famovprd where comanda in
(select comanda from famovcad where  data_mov between '01/01/2012' and '31/01/2012')
and tipo_comanda = 'HEDM'-- cod_pro in ('001689','000910')
