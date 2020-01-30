select distinct num_docent, valor_p from int_pagar
select cod_lote, status_interface, num_docent, valor_p, cgc from int_pagar order by cod_lote
select * from int_pagar WHERE COD_LOTE = "00130465" order by num_docent
select * from log_pagar --lotes
select count(*) from controle_envio
select distinct cod_lote from int_pagar where status_interface is null
