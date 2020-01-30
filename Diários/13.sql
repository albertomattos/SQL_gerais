--Consumo H:
drop table consumofat;
create global temporary table consumofat (req varchar2(15), dev varchar2(15));
insert into consumofat values(
(select sum(sum(c.valor_tot)) from famovcad a, famovprd b, famovdestino c where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and a.data_mov = &data_mov
and c.destino ='H' and a.req_dev = 'R' group by a.data_mov),
(select sum(sum(c.valor_tot)) from famovcad a, famovprd b, famovdestino c where
a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and b.sequencial = c.sequencial and a.data_mov = &data_mov
and c.destino ='H' and a.req_dev = 'D' group by a.data_mov
));
select (req-dev) from consumofat;