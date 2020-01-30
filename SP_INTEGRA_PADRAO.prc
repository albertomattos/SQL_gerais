CREATE OR REPLACE PROCEDURE SP_INTEGRA_PADRAO(pTabela         VARCHAR2,

                                              pOperacao       VARCHAR2,

                                              pValoresparam1  VARCHAR2,

                                              pValoresparam2  VARCHAR2,

                                              pValoresparam3  VARCHAR2,

                                              pValoresparam4  VARCHAR2,

                                              pValoresparam5  VARCHAR2,

                                              pValoresparam6  VARCHAR2,

                                              pValoresparam7  VARCHAR2,

                                              pValoresparam8  VARCHAR2,

                                              pValoresparam9  VARCHAR2,

                                              pValoresparam10 VARCHAR2,

                                              pValoresparam11 VARCHAR2,

                                              pValoresparam12 VARCHAR2,

                                              pValoresparam13 VARCHAR2,

                                              pValoresparam14 VARCHAR2,

                                              pValoresparam15 VARCHAR2,

                                              pValoresparam16 VARCHAR2,

                                              pValoresparam17 VARCHAR2,

                                              pValoresparam18 VARCHAR2,

                                              pValoresparam19 VARCHAR2,

                                              pValoresparam20 VARCHAR2)

-------------------------------------------------------------------------------

  -- Finalidade.: a finalidade desta procedure eh realizar o log nas entidades de controle

  --              relacionadas as integracoes que estao sendo executadas pelo integrador padrao.

  -- Parametros.:    ptabela        - Nome da entidade que esta executando o evento e chamando a procedure para log

  --                 poperacao      - Evento que esta relacionado a trigger da entidade

  --                 pvaloresparam1 - Atributos genericos para passagem de valores para log ou validacao de 1 a 20

  --                 pvaloresparam2 -

  --                 ...

  -- Historico :

  -- 13/04/2009 - CR 71025 - Anderson Andrade    - Integracao WPDHOSP x WControl

  -- 28/04/2009 - CR 71026 - Anderson Andrade    - Inclusao do controle agente de Notas Fiscais

  -- 12/05/2009 - CR 73037 - Anderson Andrade    - Alinhamento de novas verificacaoes em movimento.

  -- 04/05/2009 - CR 73037 - Luzanilton Filho    - Ajustes de erros de sintax e nomes de campos errados

  -- 07/05/2010 - CR 81009 - Adroaldo Montenegro - Ajustes na tabela ti_ctr_bxtitulo

  -- 22/04/2010 - CR 81633 - Cristiano Tavares   - Incluída a chamada para a função fc_getvalparglobal

  -- 10/05/2010 - CR 82048 - Wanderley Wenceslau - Ajustar log para terceiros

  -- 27/05/2010 - CR 83118 - Wanderley Wenceslau - Ajustar problema de log por conta de trigger mutante

  -- 22/06/2010 - CR 83502 - Gilberto Silva      - Ajustar problema de máscara de parametro para vencimento de cheque pré.

  -- 01/07/2010 - CR 83882 - Moacir Bertolezo    -  Acrescentar os dados da fafatpag na tabela ti_ctr_bxtitulo.

  -- 16/08/2010 - CR 84640 - Wanderley Wenceslau - Ajustar o log de agentes para notas fiscais emitidas com a opção CONJUNTO, neste caso o paciente não é informado na fanotcad

  -- 16/08/2010 - CR 84615 - Wanderley Wenceslau - Ajustar o log de cancelamento de contas a pagar

  -- 10/09/2010 - CR 85878 - Octávio Beltrão     - Correção da formatação para salvar no campo date na tabela ti_ctr_bxprevrec

  -- 16/09/2010 - CR 86134 - Arthur Moura        - Tratar Select Into que retorna mais de uma linha.

  -- 22/09/2010 - CR 86391 - Ricardo Palhares    - Ajuste no if na rotina de log de agentes e bxprevrec quando Ã© chamado da fanotcad.

  -- 01/09/2010 - CR ????? - Wanderley Wenceslau - Ajustar o log de exclusão de produtos

  -- 27/10/2010 - CR ????? - Cristiano Tavares   - Ajustada para servir apenas de fachada para outras Stored Procedures

  -- 02/12/2010 - CR 88064 - Wanderley Wenceslau - Ajuste do controle para nota CONJUNTO e desmenbramento da procedure principal

  -- 10/12/2010 - CR 88392 - Wanderley Wenceslau - Ajuste do controle para nota CONJUNTO e desmenbramento da procedure principal

  -- 18/01/2011 - CR 88644 - Eudes Gomes         - Ajuste no select de verificacao da existencia do agente

  -- 14/04/2011 - CR 89788 - Antonio Formiga     - Integração wSUS x Piramide

  -- 15/08/2011 - CR 88884 - Antonio Formiga     - HOPE - Integração de pedidos consignados

  -- 20/10/2011 - CR 94717 - Antonio Formiga     - Corrigido o parametro de operação da SP_PADRAO_PRODUTO, que estava passando pOperacao em vez de cOperacao.

  -- 01/11/2011 - CR 93931 - Adroaldo Montenegro - Procenge - retirada das tabelas "faconcad" e "faprtcad" para a chamada da SP_PADRAO_CLIENTE

-----------------------------------------------------------------------------------------

 IS

  ncount            NUMBER(10);

  cOperacao         VARCHAR2(1);

  cUsaIntPadrao     VARCHAR2(1);

  cTipoChave        VARCHAR2(1);

  cUsaIntProcenge   VARCHAR2(1);

  sIndConsignado    ESPECIE_NOTA.ID_CONSIGNADO%TYPE;

BEGIN

  ncount           := 0;

  cOperacao        := '';

  cUsaIntPadrao    := '';

  cTipoChave       := '';

  cUsaIntProcenge  := '';



  --Confirma se o parametro que indica a utilizacao do integrador padrao esta ativado 0 ou 1.

  sp_usa_int_padrao(cUsaIntPadrao);

  sp_usa_int_proceng(cUsaIntProcenge);



  cOperacao := CASE pOperacao WHEN 'I' THEN 'I'

                              WHEN 'A' THEN 'M'

                              WHEN 'E' THEN 'D'

                              END;



  IF (cUsaIntPadrao = 1) THEN

    --Inicio dos logs de agentes na TI_CTR_AGENTE

    --Tratamento apenas para os agentes de cadastro, os destinatarios de notas nao sao contemplados neste ponto

    IF ((pTabela = 'faconcad') OR (pTabela = 'esforcad') OR (pTabela = 'fausucad') OR

        (pTabela = 'fagprcad') OR (pTabela = 'faprocad'))  THEN

      cTipoChave := CASE pTabela WHEN 'faconcad' THEN 'C'

                                 WHEN 'esforcad' THEN 'F'

                                 WHEN 'fausucad' THEN 'U'

                                 WHEN 'fagprcad' THEN 'G'

                                 WHEN 'faprocad' THEN 'S'

                                 END;

      --Verifica se ja existe um agente inserido na entidade de log

      BEGIN

        SELECT COUNT(SEQUENCIAL)

        INTO   ncount

        FROM   TI_CTR_AGENTE

        WHERE  CHAVE_ACESSO = pValoresparam1

        AND    TIPO_CHAVE   = cTipoChave

        AND    TIPO_OPER    = 'I';

      EXCEPTION

        WHEN NO_DATA_FOUND THEN

          ncount := 0;

      END;

      IF (ncount = 0) THEN

        cOperacao := 'I';

      END IF;

    END IF;

    --Logar agente Convenio.

    IF (pTabela = 'faconcad' AND fc_getvalparglobal('integra_agente_convenio', '207') = 'S')     OR

       (pTabela = 'esforcad' AND fc_getvalparglobal('integra_agente_fornecedor', '207') = 'S')   OR

       (pTabela = 'fausucad' AND fc_GetValParGlobal('XXX', '207') = 'S')                         OR

       (pTabela = 'fagprcad' AND fc_GetValParGlobal('integra_agente_grpprofi', '207') = 'S')     OR

       (pTabela = 'faprocad' AND fc_GetValParGlobal('integra_agente_profissional', '207') = 'S') THEN

      INSERT INTO ti_ctr_agente

        (tipo_chave, tipo_oper, chave_acesso, cgccpf_dest, insc_est_dest, nome_dest, end_dest, bai_dest,

         cid_dest, est_dest, fone_dest, cep_dest, compl_dest, complemento, data_inc, hora_inc)

      VALUES

        (cTipoChave, cOperacao, pValoresparam1, NULL, NULL, NULL, NULL, NULL,

         NULL, NULL, NULL, NULL, NULL, NULL, TRUNC(SYSDATE), TO_CHAR(SYSDATE, 'hh24:mi'));

    END IF;



    IF (pTabela = 'fanotcad' AND cOperacao = 'I') OR (pTabela = 'fanotavl' AND cOperacao = 'I') THEN

      SP_PADRAO_AGENTE(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4, pValoresparam5,

                       pValoresparam6, pValoresparam7, pValoresparam8, pValoresparam9, pValoresparam10, pValoresparam11,

                       pValoresparam12, pValoresparam13, pValoresparam14, pValoresparam15, pValoresparam16, pValoresparam17);

    END IF;

    --Contas a pagar e Repasse

    IF (pTabela = 'cpmovcad') OR (pTabela = 'farepcad')  THEN

      SP_PADRAO_CTAPAGAR(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4,

                         pValoresparam5, pValoresparam6, pValoresparam7, pValoresparam8, pValoresparam9, pValoresparam10);

    END IF;



    --Previsao de recebimento

    IF (pTabela = 'faremcad') OR (pTabela = 'fafatcad') THEN

      SP_PADRAO_PREVREC(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3,

                        pValoresparam4, pValoresparam5, pValoresparam6);

    END IF;



    -- Notas do contas a receber (Nota e Titulo)

    /*IF (pTabela = 'fanotcad') OR (pTabela = 'fanotavl') THEN

      SP_PADRAO_CTARECEB(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4, pValoresparam5,

                         pValoresparam6, pValoresparam7, pValoresparam8, pValoresparam9, pValoresparam10, pValoresparam11,

                         pValoresparam12, pValoresparam13, pValoresparam14, pValoresparam15, pValoresparam16, pValoresparam17,

                         pValoresparam18, pValoresparam19, pValoresparam20);

    END IF;*/



    --Baixa de previsão de recebiment

    IF (pTabela = 'fafatpag') THEN

      SP_PADRAO_BXPREVRE(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4, pValoresparam5,

                         pValoresparam6, pValoresparam7, pValoresparam8, pValoresparam9, pValoresparam10, pValoresparam11,

                         pValoresparam12, pValoresparam13, pValoresparam14, pValoresparam15, pValoresparam16, pValoresparam17,

                         pValoresparam18, pValoresparam19);

    END IF;



    -- Desconto de adiantamento

    IF (pTabela = 'tm_adiantmega') THEN

      SP_PADRAO_MVINCULA(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4, pValoresparam5,

                         pValoresparam6, pValoresparam7, pValoresparam8, pValoresparam9, pValoresparam10, pValoresparam11,

                         pValoresparam12, pValoresparam13, pValoresparam14, pValoresparam15, pValoresparam16, pValoresparam17,

                         pValoresparam18, pValoresparam19, pValoresparam20);

    END IF;



    --Integracao PIRAMIDE / PROCENGE so processa se integracao procenge estiver "ligada"

    IF (cUsaIntProcenge = 1) THEN

      -- Integracao de Produtos

      IF (pTabela = 'produto_unidade') OR (pTabela = 'faprdcad') THEN

        SP_PADRAO_PRODUTO(pTabela, pOperacao, pValoresparam1, pValoresparam2);

      END IF;



      -- Integracao de Profissionais

      IF (pTabela = 'faprocad') THEN

        SP_PADRAO_PROFISS(pTabela, pOperacao, pValoresparam1, pValoresparam2);

      END IF;



      -- Integracao de Fabricantes

      IF (pTabela = 'esfabricante') THEN

        SP_PADRAO_FABRICAN(pTabela, pOperacao, pValoresparam1);

      END IF;



      -- Integracao de Solicitacao de Cotacao e de movimento consignado

      If (Ptabela = 'escotcad') Or (Ptabela = 'esmovcad') Then

        -- Verifica se a espécie da nota é de consignado



        If Pvaloresparam8 Is Not Null Then

          Begin

          Select 'S'

            Into sIndConsignado

            from especie_nota

           Where COD_ESPECIE = Pvaloresparam8

            AND FK_ESNFCG IS NOT NULL;

          Exception

            When NO_DATA_FOUND Then

              sIndConsignado := 'N';

          End;

        Else

          sIndConsignado := 'N';

        End If;



        If Fc_Getvalparglobal('ind_pedido_compra_consignado_pir','510') = 'S' and Pvaloresparam1 = 'PED'

           and (Pvaloresparam7 = 'S' Or sIndConsignado = 'S') Then

          SP_PADRAO_PEDCOMPRA(pTabela, pOperacao, Pvaloresparam2, Pvaloresparam9, Pvaloresparam10, Pvaloresparam5, Pvaloresparam11,

                            Pvaloresparam12, Pvaloresparam4,Pvaloresparam13, Pvaloresparam14);

        Else

          SP_PADRAO_SOLCOTAC(Ptabela, pOperacao, Pvaloresparam1, Pvaloresparam2, Pvaloresparam3, Pvaloresparam4, Pvaloresparam5,

                            Pvaloresparam6, Pvaloresparam7);

        End If;

      END IF;



      -- Integracao de clientes, convenios e destinatários da Nota

      -- Retirada das tabelas faconcad e faprtcad - CR 93931 - Adroaldo 01/11/2011

      IF (pTabela IN ('fanotcad','fanotavl')) AND (cOperacao = 'I') THEN

        SP_PADRAO_CLIENTE(pTabela, pOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4, pValoresparam5,

                          pValoresparam6, pValoresparam7, pValoresparam8, pValoresparam9, pValoresparam10, pValoresparam11,

                          pValoresparam12, pValoresparam13, pValoresparam14, pValoresparam15, pValoresparam16, pValoresparam17,

                          pValoresparam18, pValoresparam19, pValoresparam20);

      END IF;



      --Inicio da integracao de cauções

      IF (pTabela = 'famcacad') THEN

        SP_PADRAO_CAUCAO(pTabela, cOperacao, pValoresparam1, pValoresparam2, pValoresparam3);

      END IF;



      --Integração do faturamento do SUS - Recebimento - Antonio Formiga - 03/03/2011 (Inicio)

      IF (pTabela = 'tb_expraih') OR (pTabela = 'tb_exprapac') OR (pTabela = 'tb_exprbpa') THEN

        SP_PADRAO_SUS_CREC(pTabela, pOperacao, pValoresparam1, pValoresparam2, pValoresparam3,

                               pValoresparam4, pValoresparam5, pValoresparam6, pValoresparam7, pValoresparam8);

      END IF;

      --Integração do faturamento do SUS - Recebimento - Antonio Formiga - 03/03/2011 (Fim)



    END IF;

    -- Final da integracao PIRAMIDE / PROCENGE so processa se integracao procenge estiver "ligada"



    -- Integracao de Matriculas

    IF (pTabela = 'matric_prontuario') THEN

      SP_PADRAO_MATRICUL(pTabela, pOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4);

    END IF;

    -- Início do log de inscricao na TI_CTR_INSCRICAO

    IF (pTabela = 'tb_inscricao')  THEN

       SP_PADRAO_LOTE_INSC(pOperacao, pValoresparam1, pValoresparam2, pValoresparam3, pValoresparam4, pValoresparam5, To_Date(pValoresparam6, 'DD/MM/YYYY hh24:mi:ss'), To_Date(pValoresparam7, 'DD/MM/YYYY hh24:mi:ss'));

    END IF;

    -- Fim processo do log de inscricoes na TI_CTR_INSCRICAO

	-- inicio do log de Solicitação de Exames - TI_CTR_PED_PROCED

    IF (pTabela = 'ITENS_PED_PROCED')  THEN

       SP_PADRAO_PED_PROC(pTabela, pOperacao, pValoresparam1, pValoresparam2,pValoresparam3, pValoresparam4);

    END IF;

    -- fim processo do log de Solicitação de Exames - TI_CTR_PED_PROCED

  END IF;

END SP_INTEGRA_PADRAO;
/
