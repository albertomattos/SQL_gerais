{ TABLE "wpd".lbmovprd row size = 596 number of columns = 45 index size = 150 }
create table "wpd".lbmovprd 
  (
    tipo_comanda char(4) not null ,
    comanda char(7) not null ,
    codigo char(6) not null ,
    hipotese_diag char(30),
    tipo_laudo char(3) not null ,
    quant decimal(6,1) not null ,
    lote_mapa_trab char(10),
    dt_prev_entrega date,
    dt_coleta date,
    hr_coleta datetime hour to minute,
    usu_coleta char(20),
    dt_triagem date,
    hr_triagem datetime hour to minute,
    usu_triagem char(20),
    dt_dig_laudo date,
    hr_dig_laudo datetime hour to minute,
    usu_dig_laudo decimal(10,0),
    dt_imp_laudo date,
    hr_imp_laudo datetime hour to minute,
    usu_imp_laudo decimal(10,0),
    dt_entrega date,
    hr_entrega datetime hour to minute,
    usu_entrega decimal(10,0),
    entregue_a char(20),
    laudo byte,
    urgente char(1),
    cod_mat_coleta char(4),
    comanda_bancada char(7),
    cod_kit char(6),
    tipo_com_bancada char(4),
    cod_set_bancada char(4),
    dt_pri_imp date,
    hr_pri_imp datetime hour to minute,
    dt_lib_res date,
    hr_lib_res datetime hour to minute,
    resp_lib_res decimal(10,0),
    via_envio char(2),
    end_via_envio varchar(255,30),
    numero_geracao char(6),
    cod_amostra varchar(20),
    cod_guia integer,
    cod_sen integer,
    hr_prev_entrega datetime hour to minute,
    num_pedido char(10),
    cod_cid char(6),
    primary key (tipo_comanda,comanda,codigo)  constraint "wpd".xpklbmovprd disabled 
              
  );
revoke all on "wpd".lbmovprd from "public";



create index "wpd".fk_guicad_lbmovprd on "wpd".lbmovprd (cod_guia) 
    using btree ;
create index "wpd".fk_lb_mov_pedprc on "wpd".lbmovprd (num_pedido) 
    using btree ;
create index "wpd".fk_lb_mov_ur_cid on "wpd".lbmovprd (cod_cid) 
    using btree ;
create index "wpd".fk_sencad_lbmovprd on "wpd".lbmovprd (cod_sen) 
    using btree ;
create index "wpd".ie_lbmovprd on "wpd".lbmovprd (comanda_bancada,
    tipo_com_bancada) using btree ;
create index "wpd".ix_lab_amostra on "wpd".lbmovprd (cod_amostra) 
    using btree ;
create index "wpd".lbmovlot on "wpd".lbmovprd (lote_mapa_trab) 
    using btree ;
create index "wpd".lbmprcod on "wpd".lbmovprd (codigo) using btree 
    ;
create index "wpd".lbmprcom on "wpd".lbmovprd (tipo_comanda,comanda) 
    using btree ;
alter table "wpd".lbmovprd add constraint (foreign key (cod_guia) 
    references "wpd".faguicad  constraint "wpd".fk_guicad_lbmovprd);
    

alter table "wpd".lbmovprd add constraint (foreign key (cod_sen) 
    references "wpd".fasencad  constraint "wpd".fk_sencad_lbmovprd);
    

alter table "wpd".lbmovprd add constraint (foreign key (num_pedido) 
    references "wpd".pedidos_proced  constraint "wpd".fk_lb_mov_pedprc);
    

alter table "wpd".lbmovprd add constraint (foreign key (cod_cid) 
    references "wpd".urcidcad  constraint "wpd".fk_lb_mov_ur_cid);
    


create trigger "wpd".tu_lbmovprd update on "wpd".lbmovprd referencing 
    old as deleted new as updated
    for each row
        when (((("wpd".sp_se_usa_medview()= 1 ) AND ((NVL (deleted.dt_dig_laudo 
    ,'01/01/1900' )!= NVL (updated.dt_dig_laudo ,'01/01/1900' )) OR (NVL 
    (deleted.hr_dig_laudo ,'00:00:00' )!= NVL (updated.hr_dig_laudo ,'00:00:00'
     )) ) ) AND ((deleted.dt_dig_laudo IS NULL ) AND (updated.dt_dig_laudo 
    IS NOT NULL ) ) ) )
            (
            -- A alteração feita nos campos data e hora de digitação de laudo
            -- representa que o laudo foi aferido e portanto representa um insert 
            -- no nas tabelas do medview
            --
            execute procedure "wpd".sp_ti_mdl_res_exa(deleted.comanda 
    ,deleted.tipo_comanda ,deleted.codigo ,updated.dt_dig_laudo ,updated.hr_dig_laudo 
    )),
        when (((("wpd".sp_se_usa_medview()= 1 ) AND ((NVL (deleted.dt_dig_laudo 
    ,'01/01/1900' )!= NVL (updated.dt_dig_laudo ,'01/01/1900' )) OR (NVL 
    (deleted.hr_dig_laudo ,'00:00:00' )!= NVL (updated.hr_dig_laudo ,'00:00:00'
     )) ) ) AND ((deleted.dt_dig_laudo IS NOT NULL ) AND (updated.dt_dig_laudo 
    IS NULL ) ) ) )
            (
            -- A alteração feita nos campos data e hora de digitação de laudo
            -- representa uma desassociação do laudo e portanto um delete no medview
            -- 
            execute procedure "wpd".sp_td_mdl_res_exa(deleted.comanda 
    ,deleted.tipo_comanda ,deleted.codigo ,deleted.dt_dig_laudo ,deleted.hr_dig_laudo 
    )),
        when (((("wpd".sp_se_usa_medview()= 1 ) AND ((NVL (deleted.dt_dig_laudo 
    ,'01/01/1900' )!= NVL (updated.dt_dig_laudo ,'01/01/1900' )) OR (NVL 
    (deleted.hr_dig_laudo ,'00:00:00' )!= NVL (updated.hr_dig_laudo ,'00:00:00'
     )) ) ) AND ((deleted.dt_dig_laudo IS NOT NULL ) AND (updated.dt_dig_laudo 
    IS NOT NULL ) ) ) )
            (
            -- A alteração feita nos campos data e hora de digitação de laudo
            -- representa que foi feita uma nova aferição para o laudo em questão e,
            -- portanto um update nas tabelas do medview com os novos valores
            -- 
            execute procedure "wpd".sp_tu_mdl_res_exa(deleted.comanda 
    ,deleted.tipo_comanda ,deleted.codigo ,deleted.dt_dig_laudo ,deleted.hr_dig_laudo 
    ,updated.dt_dig_laudo ,updated.hr_dig_laudo )),
        when ((("wpd".verifica_trg_sw()= 1 ) AND ("wpd".sp_se_usa_integra()= 
    1 ) ) )
            (
            execute procedure "wpd".sp_integracao('lbmovprd' ,
    'A' ,((deleted.tipo_comanda || ';' ) || deleted.comanda ) ,NULL ,NULL ,
    NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL 
    ,NULL ,NULL ,NULL ,NULL ));

create trigger "wpd".ti_lbmovprd insert on "wpd".lbmovprd referencing 
    new as inserted
    for each row
        when ((((("wpd".verifica_trg_sw()= 1 ) AND (inserted.cod_mat_coleta 
    IS NOT NULL ) ) AND (inserted.cod_mat_coleta != ' ' ) ) AND (0. = 
    (select count(*) from "wpd".lbmatcad x0 where (inserted.cod_mat_coleta 
    = x0.cod_mat_coleta ) ) ) ) )
            (
            execute procedure "wpd".erwin_raise_except(-746 ,
    'Nao inseri "Movimento de Exames " porque nao existe "Material de Coleta".'
     )),
        when ((("wpd".verifica_trg_sw()= 1 ) AND (0. = (select 
    count(*) from "wpd".faprdcad x1 where (inserted.codigo = x1.codigo 
    ) ) ) ) )
            (
            execute procedure "wpd".erwin_raise_except(-746 ,
    'Nao inseri "Movimento de Exames " porque nao existe "Produtos/Servicos".'
     )),
        when ((("wpd".verifica_trg_sw()= 1 ) AND (0. = (select 
    count(*) from "wpd".lbmovcad x2 where ((inserted.tipo_comanda = x2.tipo_comanda 
    ) AND (inserted.comanda = x2.comanda ) ) ) ) ) )
            (
            execute procedure "wpd".erwin_raise_except(-746 ,
    'Nao inseri "Movimento de Exames " porque nao existe "Movimento de Pacientes ".'
     )),
        when ((("wpd".verifica_trg_sw()= 1 ) AND ("wpd".sp_se_usa_integra()= 
    1 ) ) )
            (
            execute procedure "wpd".sp_integracao('lbmovprd' ,
    'I' ,((inserted.tipo_comanda || ';' ) || inserted.comanda ) ,NULL ,NULL 
    ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL 
    ,NULL ,NULL ,NULL ,NULL )),
        when (("wpd".verifica_trg_sw()= 1 ) )
            (
            execute procedure "informix".hs_prcd_realizado(inserted.comanda 
    ,inserted.tipo_comanda ,inserted.codigo ,'I' ));

create trigger "wpd".td_lbmovprd delete on "wpd".lbmovprd referencing 
    old as deleted
    for each row
        when (("wpd".verifica_trg_sw()= 1 ) )
            (
            delete from "wpd".lbmlapad  where (((tipo_comanda 
    = deleted.tipo_comanda ) AND (comanda = deleted.comanda ) ) AND (cod_prd 
    = deleted.codigo ) ) ),
        when (("wpd".sp_se_usa_medview()= 1 ) )
            (
            execute procedure "wpd".sp_td_mdl_res_exa(deleted.comanda 
    ,deleted.tipo_comanda ,deleted.codigo ,deleted.dt_dig_laudo ,deleted.hr_dig_laudo 
    )),
        when ((("wpd".verifica_trg_sw()= 1 ) AND ("wpd".sp_se_usa_integra()= 
    1 ) ) )
            (
            execute procedure "wpd".sp_integracao('lbmovprd' ,
    'E' ,((deleted.tipo_comanda || ';' ) || deleted.comanda ) ,deleted.codigo 
    ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL ,NULL 
    ,NULL ,NULL ,NULL ,NULL ,NULL )),
        when (("wpd".verifica_trg_sw()= 1 ) )
            (
            execute procedure "informix".hs_prcd_realizado(deleted.comanda 
    ,deleted.tipo_comanda ,deleted.codigo ,'E' ));



hs_exc_prcd_real
