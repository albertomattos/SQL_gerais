drop trigger td_lbmovcad;
create trigger "wpd".td_lbmovcad delete on "wpd".lbmovcad referencing 
    old as deleted
    for each row
        when (("wpd".verifica_trg_sw()= 1 ) )
            (
            execute procedure hs_exc_prcd_real(deleted.comanda 
     ,deleted.tipo_comanda, deleted.cod_pac, deleted.data_mov, 
     deleted.hora_mov,deleted.cod_pro)),
        (
        delete from "wpd".lbmovprd  where ((tipo_comanda = deleted.tipo_comanda 
    ) AND (comanda = deleted.comanda ) ) );




