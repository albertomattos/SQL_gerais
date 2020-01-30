CREATE OR REPLACE PROCEDURE altpedcompra_pec (
   ppec_numero          IN   CHAR,
   ppec_cdempresa       IN   CHAR,
   ppec_moeda           IN   CHAR,
   ppec_data            IN   DATE,
   ppec_fornecedor      IN   CHAR,
   ppec_mapa            IN   CHAR,
   ppec_emitido         IN   CHAR,
   ppec_condpag         IN   CHAR,
   ppec_obs             IN   CHAR,
   ppec_valortotal      IN   NUMBER,
   ppec_embalagem       IN   CHAR,
   ppec_transportadora  IN   CHAR
)
AS
BEGIN
   excpedcompra_pec (ppec_numero, ppec_cdempresa);
   inspedcompra_pec (
      ppec_numero,
      ppec_cdempresa,
      ppec_moeda,
      ppec_data,
      ppec_fornecedor,
      ppec_mapa,
      ppec_emitido,
      ppec_condpag,
      ppec_obs,
      ppec_valortotal,
      ppec_embalagem,
      ppec_transportadora
   );
END;
/

CREATE OR REPLACE PROCEDURE inspedcompra1_pec (
   ppec_numero          IN   CHAR,
   ppec_cdempresa       IN   CHAR,
   ppec_moeda           IN   CHAR,
   ppec_mapa            IN   CHAR,
   ppec_data            IN   DATE,
   ppec_fornecedor      IN   CHAR,
   ppec_emitido         IN   CHAR,
   ppec_condpag         IN   CHAR,
   ppec_obs             IN   CHAR,
   ppec_valortotal      IN   NUMBER,
   ppec_embalagem       IN   CHAR,
   ppec_transportadora  IN   CHAR
)
AS
BEGIN
   INSERT INTO pedcompra_pec (
                  pec_numero,
                  pec_cdempresa,
                  pec_moeda,
                  pec_mapa,
                  pec_data,
                  pec_fornecedor,
                  pec_emitido,
                  pec_status,
                  pec_etapa,
                  pec_obs,
                  pec_condpag,
                  pec_valortotal,
                  pec_aprov1,
                  pec_taprov1,
                  pec_dtaprov1,
                  pec_aprovusu1,
                  pec_embalagem,
                  pec_transportadora
               )
        VALUES (
           ppec_numero,
           ppec_cdempresa,
           ppec_moeda,
           ppec_mapa,
           ppec_data,
           ppec_fornecedor,
           ppec_emitido,
           'A',
           1,
           ppec_obs,
           ppec_condpag,
           ppec_valortotal,
           USER,
           'R',
           SYSDATE,
           USER,
           ppec_embalagem,
           ppec_transportadora
        );
END;
/

CREATE OR REPLACE PROCEDURE inspedcompra_pec (
   ppec_numero          IN   CHAR,
   ppec_cdempresa       IN   CHAR,
   ppec_moeda           IN   CHAR,
   ppec_data            IN   DATE,
   ppec_fornecedor      IN   CHAR,
   ppec_mapa            IN   CHAR,
   ppec_emitido         IN   CHAR,
   ppec_condpag         IN   CHAR,
   ppec_obs             IN   CHAR,
   ppec_valortotal      IN   NUMBER,
   ppec_embalagem       IN   CHAR,
   ppec_transportadora  IN   CHAR
)
AS
   caprovusu           VARCHAR2(30);
   eusuario            VARCHAR2(100);
   cestrufunc          VARCHAR2(20);
   cmixregra           CHAR(1);
   cfunc               VARCHAR2(20);
   cfuncreq            VARCHAR2(20);
   csuper              VARCHAR2(20);
   cprevorc            VARCHAR2(01);
   eendemail           VARCHAR2(60);
   citrq_qespcf        VARCHAR2(200);   -- Categorias funcionais dos aprovadores
   citrq_qespefe       VARCHAR2(200);   -- Estruturas funcionais dos aprovadores
   eitrq_qespcf        VARCHAR2(2000);   -- E-Mails por categorias funcionais dos aprovadores
   eitrq_qespefe       VARCHAR2(2000);   -- E-Mails por estruturas funcionais dos aprovadores
   aitrq_qespcf        VARCHAR2(10);   -- Variável auxiliar para "montar" codigo da categoria funcional
   aitrq_qespefe       VARCHAR2(25);   -- Variável auxiliar para "montar" codigo da estrutura funcional
   nitrq_qcf           NUMBER;
   nitrq_qnfs          NUMBER;
   nitrq_qefe          NUMBER;
   nitrq_qflapr1       NUMBER;
   nitrq_qflapr2       NUMBER;
   nitrq_qflapr3       NUMBER;
   citrq_qespcfi       VARCHAR2(200);   -- Categorias funcionais dos aprovadores (regra específica)
   citrq_qespefei      VARCHAR2(200);   -- Estruturas funcionais dos aprovadores (regra específica)
   nitrq_qcfi          NUMBER;
   nitrq_qnfsi         NUMBER;
   nitrq_qefei         NUMBER;
   nitrq_qflapr1i      NUMBER;
   nitrq_qflapr2i      NUMBER;
   nitrq_qflapr3i      NUMBER;
   nloop               NUMBER;
   nposi               NUMBER;
   nvez                NUMBER;
   pirc_tipo           VARCHAR2(10);
   pirc_empresa        VARCHAR2(4);
   pirc_setor          VARCHAR2(10);
   pirc_requisitante   VARCHAR2(30);

   CURSOR estrfunc
   IS
      SELECT esf_codigo
        FROM estrfunc_esf
       WHERE esf_cdempresa = ppec_cdempresa
         AND esf_categfunc = LTRIM (aitrq_qespcf)
         AND esf_homologado IS NOT NULL;

   CURSOR aprovvalor
   IS
      SELECT NVL (reg_qnfs, 0),
             NVL (reg_qefe, 0),
             NVL (reg_qespefe, ''),
             NVL (reg_qcf, 0),
             NVL (reg_qespcf, ''),
             reg_qflapr1,
             reg_qflapr2,
             reg_qflapr3
        FROM tpreq_trq, tpped_ped, cadregra_reg
       WHERE trq_codigo = pirc_tipo
         AND ped_codigo = trq_pedido
         AND ped_regra = reg_codigo
         AND reg_valor >= ppec_valortotal;

   CURSOR aprovvalori
   IS
      SELECT NVL (reg_qnfs, 0),
             NVL (reg_qefe, 0),
             NVL (reg_qespefe, ''),
             NVL (reg_qcf, 0),
             NVL (reg_qespcf, ''),
             reg_qflapr1,
             reg_qflapr2,
             reg_qflapr3
        FROM cadregra_reg
       WHERE reg_codigo = caprovusu
         AND reg_valor >= ppec_valortotal;

   CURSOR subordinado
   IS
      SELECT asf_estrutfunc
        FROM alocsubfunc_asf
       WHERE asf_usuario = pirc_requisitante
         AND asf_empresa = pirc_empresa
         AND asf_homologado IS NOT NULL;

   CURSOR previsao
   IS
      SELECT DISTINCT irc_prevorc
        FROM reqcompra_rco, ireqcompra_irc
       WHERE rco_numero = irc_numero
         AND irc_mapa = ppec_mapa
         AND irc_prevorc = 'S';

   CURSOR dadosped
   IS
      SELECT DISTINCT rco_tipo,
                      rco_requisitante,
                      rco_empresa,
                      rco_posfunc
        FROM reqcompra_rco, ireqcompra_irc
       WHERE rco_numero = irc_numero
         AND irc_mapa = ppec_mapa;

   CURSOR verif_hom_estr
   IS
      SELECT esf_homologado
        FROM estrfunc_esf
       WHERE esf_codigo = cfunc
         AND esf_cdempresa = ppec_cdempresa
         AND esf_homologado IS NOT NULL;

   CURSOR pegemail
   IS
      SELECT uso_endemail
        FROM alocestrfunc_aef, usuario_uso
       WHERE aef_cdempresa = ppec_cdempresa
         AND aef_usuario = uso_codigo
         AND aef_codigo = LTRIM (aitrq_qespefe);

   CURSOR pegemail_u
   IS
      SELECT uso_endemail
        FROM usuario_uso
       WHERE uso_codigo = LTRIM (aitrq_qespefe);

   CURSOR pegmixreg
   IS
      SELECT SUBSTR (par_vlparam, 1, 1) AS sn
        FROM params_par
       WHERE par_cdparam = 'wSCO_MIXREG';
BEGIN
   INSERT INTO pedcompra_pec (
                  pec_numero,
                  pec_cdempresa,
                  pec_moeda,
                  pec_mapa,
                  pec_data,
                  pec_fornecedor,
                  pec_emitido,
                  pec_status,
                  pec_etapa,
                  pec_obs,
                  pec_condpag,
                  pec_valortotal,
                  pec_embalagem,
                  pec_transportadora
               )
        VALUES (
           ppec_numero,
           ppec_cdempresa,
           ppec_moeda,
           ppec_mapa,
           ppec_data,
           ppec_fornecedor,
           ppec_emitido,
           'E',
           1,
           ppec_obs,
           ppec_condpag,
           ppec_valortotal,
           ppec_embalagem,
           ppec_transportadora
        );
   -- Pega dados do pedido

   OPEN dadosped;
   FETCH dadosped INTO pirc_tipo,
                       pirc_requisitante,
                       pirc_empresa,
                       cfunc;
   CLOSE dadosped;


   IF cfunc IS NULL
   THEN
      OPEN subordinado;
      FETCH subordinado INTO cfunc;
      CLOSE subordinado;
   END IF;

   cfuncreq := cfunc;   -- Posicao funcional do requisitante

   IF cfunc IS NOT NULL
   THEN
      -- Verifica a posicao funcional do req. esta homologada.
      OPEN verif_hom_estr;
      FETCH verif_hom_estr INTO caprovusu;
      CLOSE verif_hom_estr;
   END IF;

   IF caprovusu IS NOT NULL
   THEN
      caprovusu := '';
      -- Verifica previsao orcamentaria
      OPEN previsao;
      FETCH previsao INTO cprevorc;

      IF previsao%FOUND
      THEN
         SELECT esf_regrac
           INTO caprovusu
           FROM estrfunc_esf
          WHERE esf_codigo = cfunc
            AND esf_cdempresa = pirc_empresa
            AND esf_homologado IS NOT NULL;
      ELSE
         SELECT esf_regrac1
           INTO caprovusu
           FROM estrfunc_esf
          WHERE esf_codigo = cfunc
            AND esf_cdempresa = pirc_empresa
            AND esf_homologado IS NOT NULL;
      END IF;

      CLOSE previsao;
   ELSE
     IF cfunc IS NOT NULL
     THEN
        raise_application_error (
           -20000,
           'A ESTRUTURA FUNCIONAL DO REQUISITANTE NAO ESTA HOMOLOGADA!'
        );
     END IF;
   END IF;

   OPEN aprovvalor;
   FETCH aprovvalor INTO nitrq_qnfs,
                         nitrq_qefe,
                         citrq_qespefe,
                         nitrq_qcf,
                         citrq_qespcf,
                         nitrq_qflapr1,
                         nitrq_qflapr2,
                         nitrq_qflapr3;

   IF aprovvalor%NOTFOUND
   THEN
      raise_application_error (
         -20000,
         'TIPO DE PEDIDO NAO ESPECIFICADO NO TIPO DE REQUISICAO'
      );
   END IF;
   CLOSE aprovvalor;
   OPEN pegmixreg;
   FETCH pegmixreg INTO cmixregra;

   IF NOT pegmixreg%FOUND
   THEN
      cmixregra := 'N';
   END IF;

   CLOSE pegmixreg;
   OPEN aprovvalori;
   FETCH aprovvalori INTO nitrq_qnfsi,
                          nitrq_qefei,
                          citrq_qespefei,
                          nitrq_qcfi,
                          citrq_qespcfi,
                          nitrq_qflapr1i,
                          nitrq_qflapr2i,
                          nitrq_qflapr3i;

   IF aprovvalori%FOUND
   THEN
      IF nitrq_qnfsi = 0
      THEN
         IF cmixregra = 'S'
         THEN
            nitrq_qnfs := nitrq_qnfs + nitrq_qnfsi;
            nitrq_qefe := nitrq_qefe + nitrq_qefei;
            nitrq_qcf := nitrq_qcf + nitrq_qcfi;
            IF nitrq_qnfs > 0
            THEN
               IF citrq_qespcf IS NOT NULL
               THEN
                  citrq_qespcf := citrq_qespcf || ',' || citrq_qespcfi;
               ELSE
                  citrq_qespcf := citrq_qespcfi;
               END IF;
            ELSE
               citrq_qespcf := '';
            END IF;

            IF nitrq_qefe > 0
            THEN
               IF citrq_qespefe IS NOT NULL
               THEN
                  citrq_qespefe := citrq_qespefe || ',' || citrq_qespefei;
               ELSE
                  citrq_qespefe := citrq_qespefei;
               END IF;
            ELSE
               citrq_qespefe := '';
            END IF;
            IF nitrq_qflapr2 IS NULL
            THEN
               IF nitrq_qflapr1 <> nitrq_qflapr1i
               THEN
                  nitrq_qflapr2 := nitrq_qflapr1i;

                  IF nitrq_qflapr1 <> nitrq_qflapr2i
                  THEN
                     nitrq_qflapr3 := nitrq_qflapr2i;
                  ELSE
                     nitrq_qflapr3 := nitrq_qflapr3i;
                  END IF;
               ELSE
                  nitrq_qflapr2 := nitrq_qflapr2i;
                  nitrq_qflapr3 := nitrq_qflapr3i;
               END IF;
            ELSE
               IF nitrq_qflapr3 IS NULL
               THEN
                  IF     nitrq_qflapr1 <> nitrq_qflapr1i
                     AND nitrq_qflapr2 <> nitrq_qflapr1i
                  THEN
                     nitrq_qflapr3 := nitrq_qflapr1i;
                  ELSE
                     IF     nitrq_qflapr1 <> nitrq_qflapr2i
                        AND nitrq_qflapr2 <> nitrq_qflapr2i
                     THEN
                        nitrq_qflapr3 := nitrq_qflapr2i;
                     ELSE
                        nitrq_qflapr3 := nitrq_qflapr3i;
                     END IF;
                  END IF;
               END IF;
            END IF;
         ELSE
            nitrq_qnfs := nitrq_qnfsi;
            nitrq_qefe := nitrq_qefei;
            citrq_qespefe := citrq_qespefei;
            nitrq_qcf := nitrq_qcfi;
            citrq_qespcf := citrq_qespcfi;
            nitrq_qflapr1 := nitrq_qflapr1i;
            nitrq_qflapr2 := nitrq_qflapr2i;
            nitrq_qflapr3 := nitrq_qflapr3i;
         END IF;
      END IF;
   END IF;

   CLOSE aprovvalori;
   nvez := 1;

   IF nitrq_qflapr1 = 2
   THEN
      nloop := 1;

      WHILE nloop <= nitrq_qefe
        AND (nvez <= 6)
      LOOP
         /* Loop para tratamento de e-mails, para regra com estrutura funcional específica;
            A variável < eITRQ_QESPEFE > contém os e-mail dos prováveis aprovadores. */
         IF citrq_qespefe IS NOT NULL
         THEN
            nposi := 1;
            aitrq_qespefe := ' ';

            WHILE nposi <= LENGTH (citrq_qespefe)
            LOOP
               IF     (SUBSTR (citrq_qespefe, nposi, 1) <> ',')
                  AND nposi <= LENGTH (citrq_qespefe)
               THEN
                  aitrq_qespefe :=
                     aitrq_qespefe || SUBSTR (citrq_qespefe, nposi, 1);
               ELSE
                  OPEN pegemail;
                  FETCH pegemail INTO eendemail;

                  IF pegemail%FOUND
                  THEN
                     IF eitrq_qespefe IS NOT NULL
                     THEN
                        eitrq_qespefe :=
                           eitrq_qespefe || CHR (13) || CHR (10) || eendemail;
                     ELSE
                        eitrq_qespefe := eendemail;
                     END IF;
                  END IF;

                  CLOSE pegemail;
                  aitrq_qespefe := ' ';
               END IF;

               nposi := nposi + 1;
            END LOOP;

            OPEN pegemail;
            FETCH pegemail INTO eendemail;

            IF pegemail%FOUND
            THEN
               eitrq_qespefe :=
                  eitrq_qespefe || CHR (13) || CHR (10) || eendemail;
            END IF;

            CLOSE pegemail;
         END IF;

         aitrq_qespefe := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;

         IF eusuario = ''
         THEN
            aitrq_qespefe := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;

         IF citrq_qespefe <> ' '
         THEN
            insemails_em (
               eusuario,
               eitrq_qespefe,
               NULL,
               'Aprovacao do Pedido ' ||
               ppec_numero ||
               ' da Empresa ' ||
               ppec_cdempresa,
               mens_aprovacao (
                  'APRPED',
                  ppec_cdempresa,
                  ppec_numero,
                  NULL,
                  ppec_data
               ),
               NULL,
               ppec_cdempresa,
               ppec_numero
            );
         END IF;

         /* Fim do tratamento do e-mail para Estrutura funcional */
         IF nvez = 1
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov1 = citrq_qespefe,
                   pec_taprov1 = 'R',
                   pec_aprovvez = citrq_qespefe,
                   pec_taprovv = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 2
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov2 = citrq_qespefe,
                   pec_taprov2 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 3
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov3 = citrq_qespefe,
                   pec_taprov3 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 4
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov4 = citrq_qespefe,
                   pec_taprov4 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 5
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov5 = citrq_qespefe,
                   pec_taprov5 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 6
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov6 = citrq_qespefe,
                   pec_taprov6 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         nvez := nvez + 1;
      END LOOP;
   END IF;

   IF nitrq_qflapr1 = 3
   THEN
      nloop := 1;

      WHILE (nloop <= nitrq_qcf)
        AND (nvez <= 6)
      LOOP
         /* Loop para tratamento de e-mails, para regra com estrutura para Categorias Funcionais;
            A variável < eITRQ_QESPCF > contém os e-mail dos prováveis aprovadores. */
         IF citrq_qespcf IS NOT NULL
         THEN
            nposi := 1;
            aitrq_qespcf := ' ';

            WHILE nposi <= LENGTH (citrq_qespcf)
            LOOP
               IF     (SUBSTR (citrq_qespcf, nposi, 1) <> ',')
                  AND nposi <= LENGTH (citrq_qespcf)
               THEN
                  aitrq_qespcf :=
                     aitrq_qespcf || SUBSTR (citrq_qespcf, nposi, 1);
               ELSE
                  OPEN estrfunc;
                  FETCH estrfunc INTO aitrq_qespefe;   -- "pega" todos os cargos da categoria funcional

                  WHILE estrfunc%FOUND
                  LOOP
                     OPEN pegemail;
                     FETCH pegemail INTO eendemail;

                     IF pegemail%FOUND
                     THEN
                        IF eitrq_qespcf IS NOT NULL
                        THEN
                           eitrq_qespcf :=
                              eitrq_qespcf ||
                              CHR (13) ||
                              CHR (10) ||
                              eendemail;
                        ELSE
                           eitrq_qespcf := eendemail;
                        END IF;
                     END IF;

                     CLOSE pegemail;
                     FETCH estrfunc INTO aitrq_qespefe;
                  END LOOP;

                  CLOSE estrfunc;
                  aitrq_qespcf := ' ';
               END IF;

               nposi := nposi + 1;
            END LOOP;

            OPEN estrfunc;
            FETCH estrfunc INTO aitrq_qespefe;   -- "pega" todos os cargos da categoria funcional

            WHILE estrfunc%FOUND
            LOOP
               OPEN pegemail;
               FETCH pegemail INTO eendemail;

               IF pegemail%FOUND
               THEN
                  eitrq_qespcf :=
                     eitrq_qespcf || CHR (13) || CHR (10) || eendemail;
               END IF;

               CLOSE pegemail;
               FETCH estrfunc INTO aitrq_qespefe;
            END LOOP;

            CLOSE estrfunc;
         END IF;

         aitrq_qespefe := USER;   -- De
         OPEN pegemail_u;
         FETCH pegemail_u INTO eusuario;
         CLOSE pegemail_u;

         IF eusuario = ''
         THEN
            aitrq_qespefe := USER;   -- De
            OPEN pegemail;
            FETCH pegemail INTO eusuario;
            CLOSE pegemail;
         END IF;

         IF citrq_qespcf <> ' '
         THEN
            insemails_em (
               eusuario,
               eitrq_qespcf,
               NULL,
               'Aprovacao do Pedido ' ||
               ppec_numero ||
               ' da Empresa ' ||
               ppec_cdempresa,
               mens_aprovacao (
                  'APRPED',
                  ppec_cdempresa,
                  ppec_numero,
                  NULL,
                  ppec_data
               ),
               NULL,
               ppec_cdempresa,
               ppec_numero
            );
         END IF;

         /* Fim do tratamento do e-mail para Categorias Funcionais. */
         IF nvez = 1
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov1 = citrq_qespcf,
                   pec_taprov1 = 'F',
                   pec_aprovvez = citrq_qespcf,
                   pec_taprovv = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 2
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov2 = citrq_qespcf,
                   pec_taprov2 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 3
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov3 = citrq_qespcf,
                   pec_taprov3 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 4
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov4 = citrq_qespcf,
                   pec_taprov4 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 5
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov5 = citrq_qespcf,
                   pec_taprov5 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 6
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov6 = citrq_qespcf,
                   pec_taprov6 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         nvez := nvez + 1;
      END LOOP;
   END IF;

   IF nitrq_qflapr2 = 2
   THEN
      nloop := 1;

      WHILE nloop <= nitrq_qefe
        AND (nvez <= 6)
      LOOP
         IF nvez = 2
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov2 = citrq_qespefe,
                   pec_taprov2 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 3
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov3 = citrq_qespefe,
                   pec_taprov3 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 4
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov4 = citrq_qespefe,
                   pec_taprov4 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 5
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov5 = citrq_qespefe,
                   pec_taprov5 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 6
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov6 = citrq_qespefe,
                   pec_taprov6 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         nvez := nvez + 1;
      END LOOP;
   END IF;

   IF nitrq_qflapr2 = 3
   THEN
      nloop := 1;

      WHILE (nloop <= nitrq_qcf)
        AND (nvez <= 6)
      LOOP
         IF nvez = 2
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov2 = citrq_qespcf,
                   pec_taprov2 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 3
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov3 = citrq_qespcf,
                   pec_taprov3 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 4
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov4 = citrq_qespcf,
                   pec_taprov4 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 5         THEN
            UPDATE pedcompra_pec
               SET pec_aprov5 = citrq_qespcf,
                   pec_taprov5 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 6
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov6 = citrq_qespcf,
                   pec_taprov6 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         nvez := nvez + 1;
      END LOOP;
   END IF;

   IF nitrq_qflapr3 = 2
   THEN
      nloop := 1;

      WHILE nloop <= nitrq_qefe
        AND (nvez <= 6)
      LOOP
         IF nvez = 3
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov3 = citrq_qespefe,
                   pec_taprov3 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 4
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov4 = citrq_qespefe,
                   pec_taprov4 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 5
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov5 = citrq_qespefe,
                   pec_taprov5 = 'R'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 6
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov6 = citrq_qespefe,
                   pec_taprov6 = 'R'
             WHERE pec_numero = ppec_numero;
           nloop := nloop + 1;
         END IF;

         nvez := nvez + 1;
      END LOOP;
   END IF;

   IF nitrq_qflapr3 = 3
   THEN
      nloop := 1;

      WHILE (nloop <= nitrq_qcf)
        AND (nvez <= 6)
      LOOP
         IF nvez = 3
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov3 = citrq_qespcf,
                   pec_taprov3 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 4
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov4 = citrq_qespcf,
                   pec_taprov4 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 5
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov5 = citrq_qespcf,
                   pec_taprov5 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         IF nvez = 6
         THEN
            UPDATE pedcompra_pec
               SET pec_aprov6 = citrq_qespcf,
                   pec_taprov6 = 'F'
             WHERE pec_numero = ppec_numero;
            nloop := nloop + 1;
         END IF;

         nvez := nvez + 1;
      END LOOP;
   END IF;
END;
/