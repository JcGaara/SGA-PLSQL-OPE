CREATE OR REPLACE PACKAGE BODY operacion.pkg_visita_sga_ce IS
  /****************************************************************
  '* Nombre Package : OPERACION.PKG_VISITA_SGA_CE
  '* Propósito : Agrupar funcionalidades para los procesos de
  Postventa CE
  '* Input : --
  '* Output : --
  '* Creado por : Equipo de proyecto TOA
  '* Fec. Creacion : 24/07/2018
  '* Fec. Actualizacion : 02/08/2018
  Ver        Date        Author              Solicitado por       Descripcion
  ---------  ----------  ------------------- ----------------   ------------------------------------
  1.0        04/09/2018  Obed Ortiz                               PROY-32581 - Actualizar Observacion_2 TOA
  2.0        25/10/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA12
  3.0        22/11/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA13
  4.0        28/11/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA15
  5.0        07/12/2018  Equipo TOA          Juan Cuya            PROY-32581_SGA16
  6.0        15/01/2019  Abel Ojeda          Luis Flores          PROY-32581_SGA20
  '***************************************************************/

  /****************************************************************
  '* Nombre SP : SGASS_orden_visita
  '* Propósito : Determinar si la transacción requiere visita técnica.
  '* Input : <pi_tipo_trx>   - Tipo de transacción
  <pi_codcli>     - Código de cliente
  <pi_numslc_old> - Número de proyecto referencia
  <pi_numslc_new> - Número de proyecto generado
  <pi_codsuc>     - Código de sucursal
  '* Output :<po_flg_visita> - Indicador de visita técnica
  <po_codmotot>   - Código de motivo
  <po_errorc>     - Código de error
  <po_errorm>     - Mensaje de error
  <po_anotacion>  - Anotación
  <po_subtipo>    - Sutipo de orden
  <po_tipo>       - Tipo de orden
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  PROCEDURE sgass_orden_visita(pi_tipo_trx   VARCHAR2,
                               pi_codcli     VARCHAR2,
                               pi_numslc_old VARCHAR2,
                               pi_numslc_new VARCHAR2,
                               pi_codsuc     VARCHAR2,
                               po_flg_visita OUT NUMBER,
                               po_codmotot   OUT NUMBER,
                               po_errorc     OUT NUMBER,
                               po_errorm     OUT VARCHAR2,
                               po_anotacion  OUT VARCHAR2,
                               po_subtipo    OUT VARCHAR2,
                               po_tipo       OUT VARCHAR2) IS
  
    error_motot_visita EXCEPTION;
    error_general      EXCEPTION;
  
    lv_abrev_motot operacion.opedd.abreviacion%TYPE;
    ln_codsolot    operacion.solot.codsolot%TYPE;
    ln_codigon_aux opedd.codigon_aux%TYPE;
    ln_codigoc     opedd.codigoc%TYPE;
    error_no_sot      EXCEPTION;
    error_no_tiporden EXCEPTION;
    error_cod_aux     EXCEPTION;
    ln_serv valores_srv;
  
    ln_total_old   NUMBER;
    ln_total_new   NUMBER;
    ln_cnt_tlf_old NUMBER;
    ln_cnt_tlf_new NUMBER;
    ln_cnt_int_old NUMBER;
    ln_cnt_int_new NUMBER;
    ln_cnt_ctv_old NUMBER;
    ln_cnt_ctv_new NUMBER;
    ln_val_tip_equ NUMBER;
    ln_val_vel_int NUMBER;
    --lv_anotacion   VARCHAR2(4000);
    ln_tiptra   operacion.tiptrabajo.tiptra%TYPE;
    ln_cont     NUMBER;
    lv_tipo_trx VARCHAR2(50);
    lv_tipo_tec VARCHAR2(50);
  
  BEGIN
  
    lv_tipo_trx := pi_tipo_trx; --Borrar y corregir
    lv_tipo_tec := 'HFC';
  
    DELETE FROM operacion.sga_visita_tecnica_ce v
     WHERE v.numslc_old = pi_numslc_old
       AND v.codcli = pi_codcli;
    COMMIT;
  
    po_flg_visita := 1;
    po_codmotot   := NULL;
    po_errorc     := 0;
    po_errorm     := 'OK';
  
    ln_serv.ln_val_ctv_old := 0;
    ln_serv.ln_val_int_old := 0;
    ln_serv.ln_val_tlf_old := 0;
    ln_cont                := 0;
    ln_serv.ln_val_ctv_new := 0;
    ln_serv.ln_val_int_new := 0;
    ln_serv.ln_val_tlf_new := 0;
    ln_cnt_tlf_old         := 0;
    ln_cnt_tlf_new         := 0;
    ln_cnt_int_old         := 0;
    ln_cnt_int_new         := 0;
    ln_cnt_ctv_old         := 0;
    ln_cnt_ctv_new         := 0;
    ln_val_tip_equ         := 0;
    ln_val_vel_int         := 0;
  
    -- Se carga la SOT de alta x proyecto
    BEGIN
      SELECT s.codsolot --, s.tiptra
        INTO ln_codsolot --, ln_tiptra
        FROM operacion.solot s
       WHERE s.numslc = pi_numslc_old
         AND s.estsol IN (12, 29);
    EXCEPTION
      WHEN no_data_found THEN
        RAISE error_no_sot;
      WHEN too_many_rows THEN
        SELECT MAX(s.codsolot)
          INTO ln_codsolot
          FROM operacion.solot s
         WHERE s.numslc = pi_numslc_old
           AND s.estsol IN (12, 29);
    END;
  
    -- Sprint 5 Se valida si la transacción requiere evaluar la visita técnica
    BEGIN
      SELECT op.codigon_aux, op.codigoc
        INTO ln_codigon_aux, ln_codigoc
        FROM operacion.opedd op
       INNER JOIN operacion.tipopedd tp
          ON (op.tipopedd = tp.tipopedd)
       WHERE tp.descripcion = cv_desc_trx_postv
         AND tp.abrev = cv_abrv_trx_postv
         AND op.codigon = to_number(pi_tipo_trx);
    EXCEPTION
      WHEN no_data_found THEN
        RAISE error_cod_aux;
    END;
    --ini v2.0
    -- Sprint 5 Se valida ejecutar solo los que requieran evaluar la visita técnica
    IF ln_codigon_aux = 0 THEN
      --Necesita evaluar Visita Tecnica: Cambio de Plan
    
      ln_tiptra := operacion.pkg_visita_sga_ce.sgafun_get_tiptra_pv_sef(pi_numslc_new);
    
    ELSE
      --NO Necesita evaluar Visita Tecnica
      IF ln_codigoc != cv_var_env_proy_nuevo THEN
        ---Envia proyecto nuevo
        ln_tiptra := operacion.pkg_visita_sga_ce.sgafun_get_tiptra_pv_sef(pi_numslc_new);
      ELSE
        --No envia proyecto nuevo
        ln_tiptra := pi_tipo_trx;
      
      END IF;
    END IF;
    BEGIN
      SELECT t.id_tipo_orden_ce
        INTO po_tipo
        FROM operacion.tiptrabajo t
       WHERE t.tiptra = ln_tiptra;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE error_no_tiporden;
    END;
    --fin v2.0
    IF ln_codigoc != cv_var_env_proy_nuevo THEN
      INSERT INTO operacion.sga_visita_tecnica_ce
        (numslc_new,
         numslc_old,
         codcli,
         idpaq,
         iddet,
         codsrv,
         tipsrv,
         codequcom,
         codtipequ,
         tipequ,
         dscequ,
         tipmaterial,
         qtysold,
         bandwidth,
         tipproducto,
         tipservicio,
         tiptrx,
         tipslc)
        SELECT vta.numslc,
               pi_numslc_old,
               vta.codcli,
               vta.idpaq,
               vta.iddet,
               vta.codsrv,
               vta.tipsrv,
               vta.codequcom,
               vta.codtipequ,
               vta.tipequ,
               (CASE nvl(vta.dscequ, 'X')
                 WHEN 'X' THEN
                  (CASE vta.tipsrv
                    WHEN '0004' THEN
                     CASE vta.flgprincipal
                       WHEN 1 THEN
                        'LINEA'
                     END
                  END)
                 ELSE
                  vta.dscequ
               END) dscequ,
               vta.material,
               vta.qtysold,
               vta.bandwidth,
               CASE vta.tipsrv
                 WHEN '0050' THEN
                  'EQUIPO'
                 WHEN '0015' THEN
                  'EQUIPO'
                 ELSE
                  'SERVICIO'
               END tipproducto,
               CASE vta.tipsrv
                 WHEN '0050' THEN
                  CASE (SELECT tipsrv
                      FROM billcolper.producto
                     WHERE idproducto = vta.idproducto_pri)
                    WHEN cv_telefonia THEN
                     'INT'
                    WHEN cv_internet THEN
                     'INT'
                    WHEN cv_cable THEN
                     'CTV'
                    ELSE
                     'OTRO'
                  END
                 WHEN '0015' THEN
                  CASE (SELECT tipsrv
                      FROM billcolper.producto
                     WHERE idproducto = vta.idproducto_pri)
                    WHEN cv_telefonia THEN
                     'INT'
                    WHEN cv_internet THEN
                     'INT'
                    WHEN cv_cable THEN
                     'CTV'
                    ELSE
                     'OTRO'
                  END
                 ELSE
                  (CASE vta.tipsrv
                    WHEN cv_telefonia THEN
                     'TLF'
                    WHEN cv_internet THEN
                     'INT'
                    WHEN cv_cable THEN
                     'CTV'
                    ELSE
                     'OTRO'
                  END)
               END tipservicio,
               lv_tipo_trx,
               'NEW'
          FROM (SELECT ve.numslc numslc,
                       vf.codcli codcli,
                       ve.idpaq idpaq,
                       ve.iddet iddet,
                       de.flgprincipal flgprincipal,
                       (SELECT DISTINCT p.idproducto
                          FROM sales.detalle_paquete d, billcolper.producto p
                         WHERE d.idproducto = p.idproducto
                           AND d.paquete = ve.paquete
                           AND d.idpaq = ve.idpaq
                           AND d.flgprincipal = 1
                           AND d.flgestado = 1) idproducto_pri,
                       ve.codsrv codsrv,
                       ve.numpto_prin numpto_prin,
                       ts.tipsrv tipsrv,
                       ve.codequcom codequcom,
                       eo.codtipequ codtipequ,
                       eo.tipequ tipequ,
                       te.tipo dscequ,
                       va.tip_eq material,
                       ve.cantidad qtysold,
                       ts.banwid bandwidth
                  FROM sales.vtadetptoenl ve
                 INNER JOIN sales.detalle_paquete de
                    ON ve.iddet = de.iddet
                 INNER JOIN billcolper.producto pr
                    ON de.idproducto = pr.idproducto
                 INNER JOIN sales.vtatabslcfac vf
                    ON ve.numslc = vf.numslc
                 INNER JOIN sales.tystabsrv ts
                    ON ve.codsrv = ts.codsrv
                  LEFT JOIN operacion.equcomxope eo
                    ON ve.codequcom = eo.codequcom
                  LEFT JOIN operacion.tipequ te
                    ON eo.tipequ = te.tipequ
                   AND eo.codtipequ = te.codtipequ
                  LEFT JOIN sales.vtaequcom va
                    ON ve.codequcom = va.codequcom
                 WHERE ve.numslc = pi_numslc_new
                   AND ve.codsuc = pi_codsuc) vta;
    END IF;
    --Se carga la tabla con los datos de la venta en proceso
  
    --Se carga la tabla con los datos de la venta anterior
    INSERT INTO operacion.sga_visita_tecnica_ce
      (numslc_new,
       numslc_old,
       codcli,
       idpaq,
       iddet,
       codsrv,
       tipsrv,
       codequcom,
       codtipequ,
       tipequ,
       dscequ,
       tipmaterial,
       qtysold,
       bandwidth,
       tipproducto,
       tipservicio,
       tiptrx,
       tipslc)
      SELECT pi_numslc_new,
             vta.numslc,
             vta.codcli,
             vta.idpaq,
             vta.iddet,
             vta.codsrv,
             vta.tipsrv,
             vta.codequcom,
             vta.codtipequ,
             vta.tipequ,
             (CASE nvl(vta.dscequ, 'X')
               WHEN 'X' THEN
                (CASE vta.tipsrv
                  WHEN '0004' THEN
                   CASE vta.flgprincipal
                     WHEN 1 THEN
                      'LINEA'
                   END
                END)
               ELSE
                vta.dscequ
             END) dscequ,
             vta.material,
             vta.qtysold,
             vta.bandwidth,
             CASE vta.tipsrv
               WHEN '0050' THEN
                'EQUIPO'
               WHEN '0015' THEN
                'EQUIPO'
               ELSE
                'SERVICIO'
             END tipproducto,
             CASE vta.tipsrv
               WHEN '0050' THEN
                CASE (SELECT tipsrv
                    FROM billcolper.producto
                   WHERE idproducto = vta.idproducto_pri)
                  WHEN cv_telefonia THEN
                   'INT'
                  WHEN cv_internet THEN
                   'INT'
                  WHEN cv_cable THEN
                   'CTV'
                  ELSE
                   'OTRO'
                END
               WHEN '0015' THEN
                CASE (SELECT tipsrv
                    FROM billcolper.producto
                   WHERE idproducto = vta.idproducto_pri)
                  WHEN cv_telefonia THEN
                   'INT'
                  WHEN cv_internet THEN
                   'INT'
                  WHEN cv_cable THEN
                   'CTV'
                  ELSE
                   'OTRO'
                END
               ELSE
                (CASE vta.tipsrv
                  WHEN cv_telefonia THEN
                   'TLF'
                  WHEN cv_internet THEN
                   'INT'
                  WHEN cv_cable THEN
                   'CTV'
                  ELSE
                   'OTRO'
                END)
             END tipservicio,
             lv_tipo_trx,
             'OLD'
        FROM (SELECT st.numslc,
                     st.codcli,
                     dp.idpaq,
                     ip.iddet,
                     dp.flgprincipal,
                     (SELECT DISTINCT b.idproducto
                        FROM sales.detalle_paquete a, billcolper.producto b
                       WHERE a.idproducto = b.idproducto
                         AND a.paquete = dp.paquete
                         AND a.idpaq = dp.idpaq
                         AND a.flgprincipal = 1
                         AND a.flgestado = 1) idproducto_pri,
                     ip.codsrv,
                     tyb.tipsrv,
                     ip.codequcom,
                     eqo.codtipequ,
                     eqo.tipequ,
                     tip.tipo dscequ,
                     veq.tip_eq material,
                     ip.cantidad qtysold, --verificar
                     isv.bw bandwidth
                FROM operacion.insprd ip
               INNER JOIN operacion.solotpto spo
                  ON ip.pid = spo.pid
               INNER JOIN operacion.solot st
                  ON spo.codsolot = st.codsolot
               INNER JOIN sales.tystabsrv tyb
                  ON ip.codsrv = tyb.codsrv
               INNER JOIN operacion.inssrv isv
                  ON ip.codinssrv = isv.codinssrv
                LEFT JOIN sales.detalle_paquete dp
                  ON ip.iddet = dp.iddet
                LEFT JOIN operacion.equcomxope eqo
                  ON ip.codequcom = eqo.codequcom
                LEFT JOIN operacion.tipequ tip
                  ON eqo.codtipequ = tip.codtipequ
                LEFT JOIN sales.vtaequcom veq
                  ON ip.codequcom = veq.codequcom
               WHERE st.codsolot = ln_codsolot
                 AND isv.estinssrv IN (1, 2)
                 AND st.codcli = pi_codcli) vta;
  
    COMMIT; --BORRAR
    IF ln_codigon_aux = 0 THEN
      ln_serv := operacion.pkg_visita_sga_ce.sgafun_inicia_valores(pi_numslc_old,
                                                                   pi_numslc_new);
    
      ln_cnt_tlf_old := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_old(pi_numslc_old,
                                                                           'TLF');
      ln_cnt_tlf_new := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_new(pi_numslc_new,
                                                                           'TLF');
      ln_cnt_int_old := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_old(pi_numslc_old,
                                                                           'INT');
      ln_cnt_int_new := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_new(pi_numslc_new,
                                                                           'INT');
      ln_cnt_ctv_old := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_old(pi_numslc_old,
                                                                           'CTV');
      ln_cnt_ctv_new := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_new(pi_numslc_new,
                                                                           'CTV');
      ln_val_tip_equ := operacion.pkg_visita_sga_ce.sgafun_val_tipdeco(pi_numslc_old,
                                                                       pi_numslc_new,
                                                                       'CTV');
    
      operacion.pkg_visita_sga_ce.sgass_get_val_internet_eq(pi_numslc_old,
                                                            pi_numslc_new,
                                                            'INT',
                                                            ln_val_vel_int,
                                                            po_errorc,
                                                            po_errorm);
      IF po_errorc != 0 THEN
        RAISE error_general;
      END IF;
    
      ln_total_old := ln_serv.ln_val_ctv_old + ln_serv.ln_val_int_old +
                      ln_serv.ln_val_tlf_old;
      ln_total_new := ln_serv.ln_val_ctv_new + ln_serv.ln_val_int_new +
                      ln_serv.ln_val_tlf_new;
    
      -- Validacion Cantidad de Servicios principales mayor a la cantidad de servicios principales de la SOT anterior
      -- CTV < CTV + INT                              --> Si Aplica
      -- CTV < CTV + TLF                              --> Si Aplica
      -- CTV < CTV + TLF + INT                        --> Si Aplica
      -- INT < INT + TLF                              --> Si Aplica
      -- INT < INT + TLF + CTV                        --> Si Aplica
      -- INT < INT + CTV                              --> Si Aplica
      -- INT + TLF < INT + CTV + TLF                  --> Si Aplica
      -- INT + CTV < INT + CTV + TLF                  --> Si Aplica
      -- CTV + TLF < INT + CTV + TLF                  --> Si Aplica
      IF ln_total_old < ln_total_new THEN
      
        po_flg_visita := 1;
        GOTO salto;
      
        -- CTV + INT + TLF > CTV + TLF                  --> No Aplica (Solo se Desahabilita el INT en IC)
        --:: Aplica en el caso de aumento de Deco u cambio
        -- CTV + INT + TLF > CTV + INT                  --> Si Aplica (Siempre y cuando el equipo de TLF sea recuperable)
        --:: Aplica en el caso de aumento de Deco u cambio
        -- CTV + INT + TLF > INT + TLF                  --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT + TLF > CTV                        --> Si Aplica (Valida si el equipo de INT es recuperable)
        --:: Aplica en el caso de aumento de Deco u cambio
        -- CTV + INT + TLF > INT                        --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT + TLF > TLF                        --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
        -- CTV + TLF > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + TLF > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + TLF > CTV                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
        -- INT + TLF > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
        -- INT + TLF > INT                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
        -- INT + TLF > TLF                              --> No Aplica
      
      ELSIF ln_total_old > ln_total_new THEN
      
        IF ln_total_old >= 3 THEN
        
          -- CTV + INT + TLF > CTV + TLF
          IF ln_serv.ln_val_ctv_new > 0 AND ln_serv.ln_val_tlf_new > 0 THEN
            -- Validar si se cambio de Deco (Aumento o Reducio)
            IF ln_cnt_ctv_old <> ln_cnt_ctv_new OR ln_val_tip_equ > 0 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0; -- No Aplica
            END IF;
          
            GOTO salto;
          
          END IF;
        
          -- CTV + INT + TLF > CTV + INT
          IF ln_serv.ln_val_ctv_new > 0 AND ln_serv.ln_val_int_new > 0 THEN
            po_flg_visita := 0;
            -- Validar si el Equipo de TLF es Recuperable
          
            -- Validar si se cambio de Deco (Aumento o Reducio)
            IF ln_cnt_ctv_old <> ln_cnt_ctv_new OR ln_val_tip_equ > 0 THEN
              po_flg_visita := 1;
            ELSE
              -- No Aplica
              po_flg_visita := 0;
            END IF;
          
            GOTO salto;
          END IF;
        
          -- CTV + INT + TLF > INT + TLF
          IF ln_serv.ln_val_int_new > 0 AND ln_serv.ln_val_tlf_new > 0 THEN
            -- Validar si el Equipo de TV es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_cable) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_ctv_new > 0 THEN
            -- Validar si el Equipo de INT es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_internet) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_int_new > 0 THEN
            -- Validar si el Equipo de TV es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_cable) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_tlf_new != 0 THEN
            -- Validar si el Equipo de TV o INT es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_cable) = 1 OR
               operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_internet) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          
          END IF;
        
        END IF;
      
        -- CTV + INT > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + INT > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
        IF ln_serv.ln_val_ctv_old > 0 AND ln_serv.ln_val_int_old > 0 THEN
          IF ln_serv.ln_val_tlf_new > 0 OR ln_serv.ln_val_int_new > 0 THEN
            -- Validar si el Equipo de TV es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_cable) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_ctv_new > 0 THEN
            -- Validar si el Equipo de INT es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_internet) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
        END IF;
      
        -- CTV + TLF > TLF                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + TLF > INT                              --> Si Aplica (Valida si el equipo de TV es recuperable)
        -- CTV + TLF > CTV                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
        IF ln_serv.ln_val_ctv_old > 0 AND ln_serv.ln_val_tlf_old > 0 THEN
        
          IF ln_serv.ln_val_tlf_new != 0 OR ln_serv.ln_val_int_new != 0 THEN
            -- Validar si el Equipo de TV es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_cable) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_ctv_new != 0 THEN
            -- Validar si el Equipo de TLF es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_telefonia) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
        END IF;
      
        -- INT + TLF > CTV                              --> Si Aplica (Valida si el equipo de INT es recuperable)
        -- INT + TLF > INT                              --> Si Aplica (Valida si el equipo de TLF es recuperable)
        -- INT + TLF > TLF                              --> No Aplica
        IF ln_serv.ln_val_int_old != 0 AND ln_serv.ln_val_tlf_old != 0 THEN
        
          IF ln_serv.ln_val_ctv_new != 0 THEN
            -- Validar si el Equipo de INT es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_internet) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_int_new != 0 THEN
            -- Validar si el Equipo de TLF es Recuperable
            IF operacion.pkg_visita_sga_ce.sgafun_val_recuperable(ln_codsolot,
                                                                  cv_telefonia) = 1 THEN
              po_flg_visita := 1;
            ELSE
              po_flg_visita := 0;
            END IF;
            GOTO salto;
          END IF;
        
          IF ln_serv.ln_val_tlf_new != 0 THEN
            po_flg_visita := 0;
            GOTO salto;
          END IF;
        
        END IF;
      
        -- CTV + INT + TLF = CTV_NEW + INT_NEW + TLF_NEW  -- Validar Equipos y Velocidad de EMTA
        -- CTV + INT = CTV_NEW + INT_NEW
        -- CTV + TLF = CTV_NEW + TLF_NEW
        -- INT + TLF = INT_NEW + TLF_NEW
        -- INT = INT_NEW
        -- CTV = CTV_NEW
        -- TLF = TLF_NEW
        -- Servicios Iguales
        --3PLAY
      ELSIF ln_total_old = ln_total_new AND ln_total_old = 3 THEN
        -- Validar Velocidad de INT
        IF ln_val_vel_int > 0 THEN
          po_flg_visita := 1;
        ELSIF ln_cnt_ctv_old <> ln_cnt_ctv_new OR ln_val_tip_equ > 0 THEN
          -- Validar Cantidad de Deco y Tipo de Deco
          po_flg_visita := 1;
        ELSE
          po_flg_visita := 0;
        END IF;
        --po_flg_visita := 1;
        GOTO salto;
        --2PLAY
      ELSIF ln_total_old = ln_total_new AND ln_total_old = 2 THEN
      
        IF (ln_serv.ln_val_ctv_new > 0 AND ln_serv.ln_val_int_new > 0) AND
           (ln_serv.ln_val_ctv_old > 0 AND ln_serv.ln_val_int_old > 0) THEN
          -- Validar Velocidad de INT
          IF ln_val_vel_int > 0 THEN
            po_flg_visita := 1;
          ELSIF ln_cnt_ctv_old <> ln_cnt_ctv_new OR ln_val_tip_equ > 0 THEN
            -- Validar Cantidad de Deco y Tipo de Deco
            po_flg_visita := 1;
          ELSE
            po_flg_visita := 0;
          END IF;
          --po_flg_visita := 1;
          GOTO salto;
        END IF;
      
        IF (ln_serv.ln_val_ctv_new > 0 AND ln_serv.ln_val_tlf_new > 0) AND
           (ln_serv.ln_val_ctv_old > 0 AND ln_serv.ln_val_tlf_old > 0) THEN
          -- Validar Cantidad de Deco y Tipo de Deco
          IF ln_cnt_ctv_old <> ln_cnt_ctv_new OR ln_val_tip_equ > 0 THEN
            po_flg_visita := 1;
          ELSE
            po_flg_visita := 0;
          END IF;
          GOTO salto;
        END IF;
      
        IF (ln_serv.ln_val_int_new > 0 AND ln_serv.ln_val_tlf_new > 0) AND
           (ln_serv.ln_val_int_old > 0 AND ln_serv.ln_val_tlf_old > 0) THEN
          -- Validar Velocidad de INT
          IF ln_val_vel_int > 0 THEN
            po_flg_visita := 1;
          ELSE
            po_flg_visita := 0;
          END IF;
          GOTO salto;
        END IF;
      
        --1PLAY
      ELSIF ln_total_old = ln_total_new AND ln_total_old = 1 THEN
        IF ln_serv.ln_val_int_new > 0 AND
           ln_serv.ln_val_int_new = ln_serv.ln_val_int_old THEN
          -- Validar Velocidad de INT
          IF ln_val_vel_int > 0 THEN
            po_flg_visita := 1;
          ELSE
            po_flg_visita := 0;
          END IF;
          GOTO salto;
        END IF;
      
        IF ln_serv.ln_val_tlf_new > 0 AND
           ln_serv.ln_val_tlf_new = ln_serv.ln_val_tlf_old THEN
          -- No Aplica Visita
          po_flg_visita := 0;
          GOTO salto;
        END IF;
      
        IF ln_serv.ln_val_ctv_new > 0 AND
           ln_serv.ln_val_ctv_new = ln_serv.ln_val_ctv_old THEN
          -- Validar Cantidad de Deco y Tipo de Deco
          IF ln_cnt_ctv_old <> ln_cnt_ctv_new OR ln_val_tip_equ > 0 THEN
            po_flg_visita := 1;
          ELSE
            po_flg_visita := 0;
          END IF;
          GOTO salto;
        END IF;
      END IF;
    
      <<salto>>
    
      IF po_flg_visita != 0 THEN
        lv_abrev_motot := 'HFC_CON_VISTA_CE';
      ELSIF nvl(po_flg_visita, 0) = 0 THEN
        lv_abrev_motot := 'HFC_SIN_VISTA_CE';
      END IF;
    
      BEGIN
        po_codmotot := operacion.pkg_visita_sga_ce.sgafun_get_codmotot_visit(lv_tipo_tec,
                                                                             lv_abrev_motot);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE error_motot_visita;
      END;
    
      IF po_flg_visita != 0 THEN
        -- Funcion para anotacion y subtipo Aplica Visita
        po_subtipo := operacion.pkg_visita_sga_ce.sgafun_get_subtipo(pi_numslc_old,
                                                                     pi_numslc_new,
                                                                     ln_tiptra);
      
        po_anotacion := operacion.pkg_visita_sga_ce.sgafun_get_inst_desin(pi_numslc_old,
                                                                          pi_numslc_new);
        --LV_ANOTACION := po_anotacion || ' - SUBTIPO_ORDEN:' || po_subtipo;
      
      END IF;
    ELSE
      --ln_codigon_aux = 0 //Requiere visita obligada: Cambio de Plan
      lv_abrev_motot := 'HFC_CON_VISTA_CE';
    
      po_subtipo   := 'No aplica';
      po_anotacion := '';
    
    END IF;
  
    COMMIT;
  
  EXCEPTION
    WHEN error_no_sot THEN
      ROLLBACK;
      po_flg_visita := 1;
      po_errorc     := -1;
      po_codmotot   := operacion.pkg_visita_sga_ce.sgafun_get_codmotot_visit(lv_tipo_tec,
                                                                             lv_abrev_motot);
    
      po_errorm := 'Error : No existe SOT de Alta asociado al proyecto origen : ' ||
                   pi_numslc_old;
    
    WHEN error_no_tiporden THEN
      ROLLBACK;
      po_flg_visita := 1;
      po_errorc     := -1;
      po_codmotot   := sgafun_get_codmotot_visit(lv_tipo_tec,
                                                 lv_abrev_motot);
    
      po_errorm := 'Error : No existe tipo de orden asociado al tipo de trabajo : ' ||
                   pi_numslc_old;
    
    WHEN error_motot_visita THEN
      ROLLBACK;
      po_flg_visita := 1;
      po_errorc     := -1;
      po_errorm     := 'Error : No existe un motivo configurado para ' ||
                       lv_tipo_tec || '(Parametro = ' || lv_abrev_motot || ')';
    
    WHEN error_general THEN
      ROLLBACK;
      po_flg_visita := 1;
      po_errorc     := -1;
      po_codmotot   := operacion.pkg_visita_sga_ce.sgafun_get_codmotot_visit(lv_tipo_tec,
                                                                             lv_abrev_motot);
    
    WHEN OTHERS THEN
      ROLLBACK;
      po_flg_visita := 1;
      po_codmotot   := operacion.pkg_visita_sga_ce.sgafun_get_codmotot_visit(lv_tipo_tec,
                                                                             lv_abrev_motot);
      po_errorc     := -99;
      po_errorm     := 'Error : ' || SQLCODE || ' ' || SQLERRM ||
                       ' Linea (' || dbms_utility.format_error_backtrace || ')';
  END sgass_orden_visita;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_cfg_codequcom
  '* Propósito : Comparar tipo de equipos por sus códigos.
  '* Input : <pi_codequcom_new>   - Código de equipo nuevo
  <pi_codequcom_old>   - Código de equipo antiguo
  '* Output: <po_return>          - Indicador de igualdad
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_cfg_codequcom(pi_codequcom_new VARCHAR2,
                                    pi_codequcom_old VARCHAR2) RETURN NUMBER IS
    po_return NUMBER;
  BEGIN
    SELECT cec.flag_aplica
      INTO po_return
      FROM operacion.config_equcom_cp cec
     WHERE cec.codequcom_new = pi_codequcom_new
       AND cec.codequcom_old = pi_codequcom_old;
  
    RETURN po_return;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 1;
    WHEN OTHERS THEN
      RETURN 1;
  END sgafun_val_cfg_codequcom;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_tipsrv_old
  '* Propósito : Obtener la cantidad de servicios actuales.
  '* Input : <pi_numslc_old>    - Número de proyecto referencia
  <pi_tipservicio>   - Tipo de servicio (TLF, INT, CTV)
  '* Output: <po_return>        - Cantidad de servicios
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_tipsrv_old(pi_numslc_old  sales.vtadetptoenl.numslc%TYPE,
                                 pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER IS
    po_return NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT vt.tipservicio)
      INTO po_return
      FROM operacion.sga_visita_tecnica_ce vt
     WHERE vt.numslc_old = pi_numslc_old
       AND vt.tipservicio = pi_tipservicio
       AND vt.tipproducto = 'SERVICIO'
       AND vt.tipslc = 'OLD';
  
    RETURN po_return;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END sgafun_val_tipsrv_old;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_tipsrv_new
  '* Propósito : Obtener la cantidad de servicios a vender.
  '* Input : <pi_numslc_new>    - Número de proyecto generado
  <pi_tipservicio>   - Tipo de servicio (TLF, INT, CTV)
  '* Output: <po_return>        - Cantidad de servicios
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_tipsrv_new(pi_numslc_new  sales.vtadetptoenl.numslc%TYPE,
                                 pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER IS
    po_return NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT vt.tipservicio)
      INTO po_return
      FROM operacion.sga_visita_tecnica_ce vt
     WHERE vt.numslc_new = pi_numslc_new
       AND vt.tipservicio = pi_tipservicio
       AND vt.tipproducto = 'SERVICIO'
       AND vt.tipslc = 'NEW';
  
    RETURN po_return;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END sgafun_val_tipsrv_new;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_codmotot_visit
  '* Propósito : Obtener el código de motivo de visita.
  '* Input : <pi_tipo>    - Tipo de tecnología
  <pi_visita>  - Abreviación del motivo
  '* Output: <po_codmotot> - Código de motivo
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_codmotot_visit(pi_tipo VARCHAR2, pi_visita VARCHAR2)
    RETURN NUMBER IS
    po_codmotot NUMBER;
  BEGIN
    SELECT o.codigon
      INTO po_codmotot
      FROM operacion.opedd o, tipopedd t
     WHERE o.tipopedd = t.tipopedd
       AND t.abrev = 'TIPO_MOT_HFC_CE_VIS'
       AND o.codigoc = pi_tipo
       AND o.abreviacion = pi_visita;
  
    RETURN po_codmotot;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END sgafun_get_codmotot_visit;

  /****************************************************************
  '* Nombre SP : SGASI_log_post_ce
  '* Propósito : Log del proceso de visita técnica.
  '* Input : <pi_postv_numslc>   - Número de proyecto
  <pi_postv_codcli>   - Código de cliente
  <pi_postv_proceso>  - Código de transacción
  <pi_postv_msgerror> - Mensaje de error
  '* Output: --
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  PROCEDURE sgasi_log_post_ce(pi_postv_numslc   operacion.sgat_postventasce_log.postv_numslc%TYPE,
                              pi_postv_codcli   operacion.sgat_postventasce_log.postv_codcli%TYPE,
                              pi_postv_proceso  operacion.sgat_postventasce_log.postv_proceso%TYPE,
                              pi_postv_msgerror operacion.sgat_postventasce_log.postv_msgerror%TYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO operacion.sgat_postventasce_log
      (postv_numslc, postv_codcli, postv_proceso, postv_msgerror)
    VALUES
      (pi_postv_numslc,
       pi_postv_codcli,
       pi_postv_proceso,
       pi_postv_msgerror);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END sgasi_log_post_ce;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_cantequ_old
  '* Propósito : Obtener la cantidad de equipos actuales.
  '* Input : <pi_numslc_old>  - Número de proyecto referencia
  <pi_tipservicio> - Tipo de servicio (TLF, INT, CTV)
  '* Output: <po_count>       - Cantidad de equipos
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_cantequ_old(pi_numslc_old  operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                  pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER IS
    po_count  NUMBER;
    ls_dscequ VARCHAR2(50);
  
  BEGIN
    IF pi_tipservicio = 'TLF' THEN
      ls_dscequ := 'LINEA';
    ELSIF pi_tipservicio = 'INT' THEN
      ls_dscequ := 'EMTA';
    ELSIF pi_tipservicio = 'CTV' THEN
      ls_dscequ := 'DECODIFICADOR';
    END IF;
  
    SELECT SUM(svt.qtysold)
      INTO po_count
      FROM operacion.sga_visita_tecnica_ce svt
     WHERE svt.numslc_old = pi_numslc_old
       AND svt.tipservicio = pi_tipservicio
          --AND svt.tipproducto = 'SERVICIO'
       AND svt.dscequ LIKE '%' || ls_dscequ || '%'
       AND svt.tipslc = 'OLD';
  
    po_count := nvl(po_count, 0);
    RETURN po_count;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END sgafun_val_cantequ_old;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_cantequ_new
  '* Propósito : Obtener la cantidad de equipos a vender.
  '* Input : <pi_numslc_new>  - Número de proyecto generado
  <pi_tipservicio> - Tipo de servicio (TLF, INT, CTV)
  '* Output: <po_count>       - Cantidad de equipos
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_cantequ_new(pi_numslc_new  operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                                  pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER IS
    po_count  NUMBER;
    ls_dscequ VARCHAR2(50);
  
  BEGIN
    IF pi_tipservicio = 'TLF' THEN
      ls_dscequ := 'LINEA';
    ELSIF pi_tipservicio = 'INT' THEN
      ls_dscequ := 'EMTA';
    ELSIF pi_tipservicio = 'CTV' THEN
      ls_dscequ := 'DECODIFICADOR';
    END IF;
  
    SELECT SUM(svt.qtysold)
      INTO po_count
      FROM operacion.sga_visita_tecnica_ce svt
     WHERE svt.numslc_new = pi_numslc_new
       AND svt.tipservicio = pi_tipservicio
          --AND svt.tipproducto = 'SERVICIO'
       AND svt.dscequ LIKE '%' || ls_dscequ || '%'
       AND svt.tipslc = 'NEW';
  
    po_count := nvl(po_count, 0);
    RETURN po_count;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END sgafun_val_cantequ_new;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_recuperable
  '* Propósito : Validar los equipos recuperables.
  '* Input : <pi_codsolot>           - Número de SOT
  <pi_tipsrv>             - Tipo de servicio SGA
  '* Output: <po_val_recuperable>    - Cantidad de equipos recuperable
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_recuperable(pi_codsolot operacion.solot.codsolot%TYPE,
                                  pi_tipsrv   tystipsrv.tipsrv%TYPE)
    RETURN NUMBER IS
    po_val_recuperable NUMBER;
  
    CURSOR c_equ_sga IS
      SELECT DISTINCT eq.tip_eq, eq.flg_recuperable
        FROM (SELECT DISTINCT ip.pid, ip.codequcom, ip.cantidad
                FROM operacion.solot    s,
                     operacion.solotpto sp,
                     operacion.insprd   ip,
                     operacion.inssrv   iv
               WHERE s.codsolot = sp.codsolot
                 AND sp.codinssrv = iv.codinssrv
                 AND ip.codinssrv = iv.codinssrv
                 AND s.codsolot = pi_codsolot
                 AND iv.tipsrv = pi_tipsrv
                 AND ip.estinsprd IN (1, 2)) x,
             sales.vtaequcom eq
       WHERE nvl(x.codequcom, 'X') != 'X'
         AND eq.codequcom = x.codequcom;
  BEGIN
    po_val_recuperable := 0;
  
    FOR r IN c_equ_sga LOOP
      IF r.flg_recuperable = 'SI' THEN
        po_val_recuperable := po_val_recuperable + 1;
      END IF;
    END LOOP;
  
    IF po_val_recuperable > 0 THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END sgafun_val_recuperable;

  /****************************************************************
  '* Nombre FN : SGAFUN_val_tipdeco
  '* Propósito : Comparar los tipos de deco actuales y en venta.
  '* Input : <pi_numslc_old>  - Número de proyecto referencia
  <pi_numslc_new>  - Número de proyecto generado
  <pi_tipservicio> - Tipo de servicio (TLF, INT, CTV)
  '* Output: <po_tipequ>      - Valor de igualdad de equipo
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_val_tipdeco(pi_numslc_old  operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                              pi_numslc_new  operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                              pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE)
    RETURN NUMBER IS
    po_tipequ NUMBER;
  
    /*SELECT eq.tip_eq, SUM(x.cantidad) cantidad
    FROM (SELECT DISTINCT ip.pid, IP.codequcom, ip.cantidad
    FROM solot s, solotpto sp, insprd ip, inssrv iv
    WHERE s.codsolot = sp.codsolot
    AND sp.codinssrv = iv.codinssrv
    AND ip.codinssrv = iv.codinssrv
    AND s.codsolot = pi_numslc_old
    AND iv.tipsrv IN ('0062')
    AND ip.estinsprd IN (1, 2)) X,
    vtaequcom eq,
    EQUCOMXOPE V,
    TIPEQU TE
    WHERE NVL(X.codequcom, 'X') != 'X'
    AND eq.codequcom = x.codequcom
    AND eq.CODEQUCOM = V.CODEQUCOM
    AND V.CODTIPEQU = TE.CODTIPEQU
    AND TE.TIPO = 'DECODIFICADOR'
    GROUP BY eq.tip_eq;*/
  
    CURSOR c_equ_sga IS
      SELECT svt.tipmaterial tip_eq, SUM(svt.qtysold) cantidad
        FROM operacion.sga_visita_tecnica_ce svt
       WHERE svt.numslc_old = pi_numslc_old
         AND svt.tipservicio = pi_tipservicio
         AND svt.tipproducto = 'EQUIPO'
         AND svt.tipslc = 'OLD'
         AND svt.dscequ = 'DECODIFICADOR'
       GROUP BY svt.tipmaterial;
  
    CURSOR c_equ_new IS
      SELECT svt.tipmaterial tip_eq, SUM(svt.qtysold) cantidad
        FROM operacion.sga_visita_tecnica_ce svt
       WHERE svt.numslc_new = pi_numslc_new
         AND svt.tipservicio = pi_tipservicio
         AND svt.tipproducto = 'EQUIPO'
         AND svt.tipslc = 'NEW'
         AND svt.dscequ = 'DECODIFICADOR'
       GROUP BY svt.tipmaterial;
  
    ln_cont_equ_old NUMBER;
    ln_cont_equ_new NUMBER;
    lv_val_tipequ   NUMBER;
  BEGIN
    ln_cont_equ_old := 0;
    ln_cont_equ_new := 0;
    lv_val_tipequ   := 0;
  
    FOR x IN c_equ_sga LOOP
      ln_cont_equ_old := ln_cont_equ_old + 1;
      ln_cont_equ_new := 0;
    
      FOR c IN c_equ_new LOOP
        ln_cont_equ_new := ln_cont_equ_new + 1;
      
        IF x.tip_eq = c.tip_eq THEN
          IF x.cantidad = c.cantidad THEN
            lv_val_tipequ := 0;
          ELSE
            lv_val_tipequ := 1;
          END IF;
        END IF;
      END LOOP;
    END LOOP;
  
    IF ln_cont_equ_new = ln_cont_equ_old AND lv_val_tipequ = 0 THEN
      po_tipequ := 0;
    ELSE
      po_tipequ := 1;
    END IF;
  
    RETURN po_tipequ;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 1;
  END sgafun_val_tipdeco;

  /****************************************************************
  '* Nombre SP : SGASS_get_val_internet_eq
  '* Propósito : Comparar los equipos y velocidad de internet.
  '* Input : <pi_numslc_old>  - Número de proyecto referencia
  <pi_numslc_new>  - Número de proyecto generado
  <pi_tipservicio> - Tipo de servicio (TLF, INT, CTV)
  '* Output: <po_flag>      - Indicador de diferencia
  <po_errorc>    - Código de error
  <po_errorm>    - Mensaje de error
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  PROCEDURE sgass_get_val_internet_eq(pi_numslc_old  operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                      pi_numslc_new  operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                                      pi_tipservicio operacion.sga_visita_tecnica_ce.tipservicio%TYPE,
                                      po_flag        OUT NUMBER,
                                      po_errorc      OUT NUMBER,
                                      po_errorm      OUT VARCHAR2) IS
    ln_tipo_mat      VARCHAR2(50);
    ln_velocidad     NUMBER;
    ln_velocidad_old NUMBER;
    ln_tipo_mat_ant  sales.vtaequcom.tip_eq%TYPE;
    lv_vel_conf      NUMBER;
    exc_internet EXCEPTION;
    --lv_codequcom     sales.vtaequcom.codequcom%TYPE;
    --lv_codequcom_new sales.vtaequcom.codequcom%TYPE;
    --lv_tipequ        operacion.tipequ.tipequ%TYPE;
  
    CURSOR c_int_equ_old IS
      SELECT v.codsrv, v.codequcom, v.tipmaterial, v.qtysold
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_old = pi_numslc_old
         AND v.tipservicio = pi_tipservicio
         AND v.tipproducto = 'EQUIPO'
         AND v.tipslc = 'OLD';
  
    CURSOR c_int_equ_new IS
      SELECT v.codsrv, v.codequcom, v.tipmaterial, v.qtysold
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_new = pi_numslc_new
         AND v.tipservicio = pi_tipservicio
         AND v.tipproducto = 'EQUIPO'
         AND v.dscequ = 'EMTA'
         AND v.tipslc = 'NEW';
  
    CURSOR c_int_srv_new IS
      SELECT v.codsrv, v.codequcom, nvl(v.bandwidth, 0) bw
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_new = pi_numslc_new
         AND v.tipservicio = pi_tipservicio
         AND v.tipproducto = 'SERVICIO'
         AND v.tipslc = 'NEW';
    --ini v2.0
    CURSOR c_int_srv_old IS
      SELECT v.codsrv, v.codequcom, nvl(v.bandwidth, 0) bw
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_new = pi_numslc_new
         AND v.tipservicio = pi_tipservicio
         AND v.tipproducto = 'SERVICIO'
         AND v.tipslc = 'OLD';
    --fin v2.0
  
  BEGIN
    po_errorc := 0;
    po_errorm := 'OK';
  
    lv_vel_conf := operacion.pq_sga_janus.f_get_constante_conf('CVELINT_VISITEC');
    lv_vel_conf := lv_vel_conf * 1024;
    FOR idx IN c_int_equ_new LOOP
      po_errorc   := 0;
      po_errorm   := 'OK';
      ln_tipo_mat := nvl(idx.tipmaterial, 'OTROS');
      FOR idy IN c_int_equ_old LOOP
        ln_tipo_mat_ant := nvl(idy.tipmaterial, 'OTROS');
        FOR idy IN c_int_srv_new LOOP
          ln_velocidad := idy.bw;
          FOR idz IN c_int_srv_old LOOP
            ln_velocidad_old := idz.bw;
          
            IF ln_tipo_mat_ant <> ln_tipo_mat THEN
              ---SPRINT 5 No considerar visita técnica para BAM v2.0
              IF ln_velocidad_old > ln_velocidad THEN
                --RETURN 0;
                po_flag := 0;
                RETURN;
              ELSE
                po_flag := 1;
                RETURN;
              END IF;
            END IF;
            ---SPRINT 5 No considerar visita técnica para BAM v2.0
            IF ln_velocidad_old > ln_velocidad THEN
              --RETURN 0;
              po_flag := 0;
              RETURN;
            ELSE
              --Escenario Equipo DOCSIS3
              IF ln_tipo_mat_ant <> 'DOCSIS3' AND
                 ln_velocidad >= lv_vel_conf THEN
                --RETURN 1;
                po_flag := 1;
                RETURN;
              ELSE
                --RETURN 0;
                po_flag := 0;
                RETURN;
              END IF;
            
              --Escenario Equipo EMTA
              IF ln_tipo_mat_ant <> 'EMTA' AND ln_velocidad >= lv_vel_conf THEN
                --RETURN 1;
                po_flag := 0;
                RETURN;
              ELSE
                --RETURN 0;
                po_flag := 0;
                RETURN;
              END IF;
            END IF;
          END LOOP;
        END LOOP;
      END LOOP;
    END LOOP;
  EXCEPTION
    WHEN exc_internet THEN
      po_flag   := -1;
      po_errorc := -1;
      po_errorm := 'El proyecto de referencia ' || pi_numslc_old ||
                   ' del cliente no tiene equipos de Internet';
    WHEN OTHERS THEN
      po_flag   := -1;
      po_errorc := -1;
      po_errorm := 'Ocurrio un error al validar la velocidad y tipo de equipos para servicio de INTERNET';
  END sgass_get_val_internet_eq;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_nombre_equ
  '* Propósito : Obtener descripción de equipo.
  '* Input : <pi_codequcom>  - Código de equipo
  '* Output: <po_descequ>    - Descripción de equipo
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_nombre_equ(pi_codequcom vtaequcom.codequcom%TYPE)
    RETURN vtaequcom.dscequ%TYPE IS
    po_descequ vtaequcom.dscequ%TYPE;
  BEGIN
    SELECT v.dscequ
      INTO po_descequ
      FROM sales.vtaequcom v
     WHERE v.codequcom = pi_codequcom;
  
    RETURN po_descequ;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END sgafun_get_nombre_equ;

  /****************************************************************
  '* Nombre FN : SGAFUN_format_vacio
  '* Propósito : Concatenar valores.
  '* Input : <pi_cad> - Cadena de valores
  '* Output: --
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_format_vacio(pi_cad VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF length(pi_cad) > 0 THEN
      RETURN pi_cad || ' + ';
    ELSE
      RETURN pi_cad;
    END IF;
  END sgafun_format_vacio;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_codequ_old
  '* Propósito : Obtener código de equipo de internet actual.
  '* Input : <pi_numslc>    - Número de proyecto actual
  '* Output: <po_codequcom> - Código de equipo de internet
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_codequ_old(pi_numslc operacion.sga_visita_tecnica_ce.numslc_old%TYPE)
    RETURN VARCHAR2 IS
    po_codequcom vtaequcom.codequcom%TYPE;
  
  BEGIN
    SELECT s.codequcom
      INTO po_codequcom
      FROM operacion.sga_visita_tecnica_ce s
     WHERE s.numslc_old = pi_numslc
       AND s.tipservicio = 'INT'
       AND s.tipproducto = 'EQUIPO'
       AND s.dscequ = 'EMTA'
       AND s.tipslc = 'OLD';
  
    RETURN po_codequcom;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN NULL;
  END sgafun_get_codequ_old;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_codequ_new
  '* Propósito : Obtener código de equipo de internet a vender.
  '* Input : <pi_numslc>    - Número de proyecto generado
  '* Output: <po_codequcom> - Código de equipo de internet
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_codequ_new(pi_numslc operacion.sga_visita_tecnica_ce.numslc_new%TYPE)
    RETURN VARCHAR2 IS
    po_codequcom operacion.equcomxope.codequcom%TYPE;
  BEGIN
    SELECT s.codequcom
      INTO po_codequcom
      FROM operacion.sga_visita_tecnica_ce s
     WHERE s.numslc_new = pi_numslc
       AND s.tipservicio = 'INT'
       AND s.tipproducto = 'EQUIPO'
       AND s.dscequ = 'EMTA'
       AND s.tipslc = 'NEW';
  
    RETURN po_codequcom;
  
  EXCEPTION
    WHEN no_data_found THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN NULL;
  END sgafun_get_codequ_new;

  /****************************************************************
  '* Nombre FN : SGAFUN_inicia_valores
  '* Propósito : Cargar datos iniciales de servicios.
  '* Input : <pi_numslc_old>    - Número de proyecto referencia
  <pi_numslc_new>    - Número de proyecto generado
  '* Output: <valores_srv>      - Cursor con valores de servicios actuales y nuevos
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_inicia_valores(pi_numslc_old IN operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                 pi_numslc_new IN operacion.sga_visita_tecnica_ce.numslc_new%TYPE)
    RETURN valores_srv IS
    servicios_val valores_srv;
  BEGIN
    servicios_val.ln_val_ctv_old := operacion.pkg_visita_sga_ce.sgafun_val_tipsrv_old(pi_numslc_old,
                                                                                      'CTV');
    servicios_val.ln_val_int_old := operacion.pkg_visita_sga_ce.sgafun_val_tipsrv_old(pi_numslc_old,
                                                                                      'INT');
    servicios_val.ln_val_tlf_old := operacion.pkg_visita_sga_ce.sgafun_val_tipsrv_old(pi_numslc_old,
                                                                                      'TLF');
  
    servicios_val.ln_val_ctv_new := operacion.pkg_visita_sga_ce.sgafun_val_tipsrv_new(pi_numslc_new,
                                                                                      'CTV');
    servicios_val.ln_val_int_new := operacion.pkg_visita_sga_ce.sgafun_val_tipsrv_new(pi_numslc_new,
                                                                                      'INT');
    servicios_val.ln_val_tlf_new := operacion.pkg_visita_sga_ce.sgafun_val_tipsrv_new(pi_numslc_new,
                                                                                      'TLF');
  
    RETURN servicios_val;
  END sgafun_inicia_valores;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_inst_desin
  '* Propósito : Obtener anotación con datos de instalación.
  '* Input : <pi_numslc_old>  - Número de proyecto referencia
  <pi_numslc_new>  - Número de proyecto generado
  '* Output: <lv_cadena>      - Cadena de anotación
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_inst_desin(pi_numslc_old operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                                 pi_numslc_new operacion.sga_visita_tecnica_ce.numslc_new%TYPE)
    RETURN VARCHAR2 IS
    CURSOR c_equ_old IS
      SELECT v.tipmaterial tip_eq, SUM(v.qtysold) cantidad
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_old = pi_numslc_old
         AND v.tipservicio = 'CTV'
         AND v.tipproducto = 'EQUIPO'
         AND v.dscequ = 'DECODIFICADOR'
         AND v.tipslc = 'OLD'
       GROUP BY v.tipmaterial
       ORDER BY v.tipmaterial;
  
    CURSOR c_equ_new IS
      SELECT v.tipmaterial tip_eq, SUM(v.qtysold) cantidad
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_new = pi_numslc_new
         AND v.tipservicio = 'CTV'
         AND v.tipproducto = 'EQUIPO'
         AND v.dscequ = 'DECODIFICADOR'
         AND v.tipslc = 'NEW'
       GROUP BY v.tipmaterial
       ORDER BY v.tipmaterial;
  
    lv_codequcom_old vtaequcom.codequcom%TYPE;
    lv_codequcom_new vtaequcom.codequcom%TYPE;
    exc_internet      EXCEPTION;
    exc_codequcom_new EXCEPTION;
    lv_instalar    VARCHAR2(4000);
    lv_desinstalar VARCHAR2(4000);
    lv_cadena      VARCHAR2(4000);
    l_cadena       VARCHAR2(4000);
    l_cadena2      VARCHAR2(4000);
    flg_igual      NUMBER;
    ln_servicios   valores_srv;
  BEGIN
    -- Evaluo los equipos
    ln_servicios     := operacion.pkg_visita_sga_ce.sgafun_inicia_valores(pi_numslc_old,
                                                                          pi_numslc_new);
    lv_codequcom_old := operacion.pkg_visita_sga_ce.sgafun_get_codequ_old(pi_numslc_old); --serv internet
    lv_codequcom_new := operacion.pkg_visita_sga_ce.sgafun_get_codequ_new(pi_numslc_new); --serv internet
  
    -- Evaluo internet
    IF ln_servicios.ln_val_int_new > 0 AND ln_servicios.ln_val_int_old = 0 AND
       ln_servicios.ln_val_tlf_old = 0 THEN
      lv_instalar := operacion.pkg_visita_sga_ce.sgafun_get_nombre_equ(lv_codequcom_new);
    
    ELSIF ln_servicios.ln_val_int_new = 0 AND
          ln_servicios.ln_val_int_old > 0 AND
          ln_servicios.ln_val_tlf_new = 0 THEN
      lv_desinstalar := sgafun_get_nombre_equ(lv_codequcom_old);
    ELSIF ln_servicios.ln_val_int_new > 0 AND
          ln_servicios.ln_val_int_old > 0 THEN
    
      IF operacion.pkg_visita_sga_ce.sgafun_val_cfg_codequcom(nvl(lv_codequcom_new,
                                                                  'X'),
                                                              nvl(lv_codequcom_old,
                                                                  'X')) = 1 AND
         lv_codequcom_new != lv_codequcom_old THEN
        lv_instalar    := operacion.pkg_visita_sga_ce.sgafun_get_nombre_equ(lv_codequcom_new);
        lv_desinstalar := operacion.pkg_visita_sga_ce.sgafun_get_nombre_equ(lv_codequcom_old);
      END IF;
    END IF;
  
    -- Instalar decos new - old
    l_cadena  := '';
    l_cadena2 := '';
    flg_igual := 0;
  
    IF ln_servicios.ln_val_ctv_new > 0 THEN
      FOR c IN c_equ_new LOOP        
        FOR x IN c_equ_old LOOP
          IF c.tip_eq = x.tip_eq THEN
            IF (c.cantidad - x.cantidad) > 0 THEN
              --validar cantidades de decos para saber que se instala
              l_cadena2 := operacion.pkg_visita_sga_ce.sgafun_format_vacio(l_cadena2) ||
                           (c.cantidad - x.cantidad) || ' (' ||
			   OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_CHANGE_CADENA(C.TIP_EQ,CV_ABUSCAR,CV_AREEMPLAZAR) -- 6.0
			   || ')';
            END IF;
            flg_igual := 1;
          END IF;
        END LOOP;
      
        IF flg_igual != 1 THEN
          l_cadena := operacion.pkg_visita_sga_ce.sgafun_format_vacio(l_cadena) ||
                      c.cantidad || ' (' ||
		      OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_CHANGE_CADENA(C.TIP_EQ,CV_ABUSCAR,CV_AREEMPLAZAR) -- 6.0
		     || ')';
        END IF;
        flg_igual := 0;
      END LOOP;
    
      lv_instalar := operacion.pkg_visita_sga_ce.sgafun_format_vacio(lv_instalar) ||
                     l_cadena || l_cadena2;
    END IF;
  
    -- Desintalar decos old - new
    l_cadena  := '';
    l_cadena2 := '';
    flg_igual := 0;
  
    IF ln_servicios.ln_val_ctv_old > 0 THEN
      FOR c IN c_equ_old LOOP
        FOR x IN c_equ_new LOOP
          IF c.tip_eq = x.tip_eq THEN
            IF (c.cantidad - x.cantidad) > 0 THEN
              -- validar cantidades de decos para saber que se desinstala
              l_cadena2 := operacion.pkg_visita_sga_ce.sgafun_format_vacio(l_cadena2) ||
                           (c.cantidad - x.cantidad) || ' (' ||
			   OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_CHANGE_CADENA(c.tip_eq,CV_ABUSCAR,CV_AREEMPLAZAR) -- 6.0                           
			   || ')';
            END IF;
            flg_igual := 1;
          END IF;
        END LOOP;
      
        IF flg_igual != 1 THEN
          l_cadena := operacion.pkg_visita_sga_ce.sgafun_format_vacio(l_cadena) ||
                      c.cantidad || ' (' ||
		      OPERACION.PQ_VISITA_SGA_SIAC.SGAFUN_CHANGE_CADENA(c.tip_eq,CV_ABUSCAR,CV_AREEMPLAZAR) -- 6.0                      
		      || ')';
        END IF;
        flg_igual := 0;
      END LOOP;
      lv_desinstalar := operacion.pkg_visita_sga_ce.sgafun_format_vacio(lv_desinstalar) ||
                        l_cadena || l_cadena2;
    END IF;
  
    IF length(lv_desinstalar) > 0 THEN
      lv_desinstalar := 'RETIRAR: ' || lv_desinstalar || '; ' || chr(13);
    END IF;
    IF length(lv_instalar) > 0 THEN
      lv_instalar := 'INSTALAR: ' || lv_instalar;
    END IF;
    lv_cadena := lv_desinstalar || lv_instalar;
  
    RETURN lv_cadena;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END sgafun_get_inst_desin;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_subtipo
  '* Propósito : Obtener subtipo de orden CE.
  '* Input : <pi_numslc_old>  - Número de proyecto referencia
  <pi_numslc_new>  - Número de proyecto generado
  <pi_tiptra>      - Tipo de trabajo de SOT a crear
  '* Output: <lv_subtipo>     - Subtipo de orden o mensaje de error
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_subtipo(pi_numslc_old operacion.sga_visita_tecnica_ce.numslc_old%TYPE,
                              pi_numslc_new operacion.sga_visita_tecnica_ce.numslc_new%TYPE,
                              pi_tiptra     operacion.tiptrabajo.tiptra%TYPE)
    RETURN VARCHAR2 IS
  
    exc_internet      EXCEPTION;
    exc_codequcom_new EXCEPTION;
    lv_tmp               VARCHAR2(4000);
    ln_gcnt_ctv_old      NUMBER;
    ln_gcnt_ctv_new      NUMBER;
    ln_gcnt_tlf_old      NUMBER;
    ln_gcnt_tlf_new      NUMBER;
    ln_srv               valores_srv;
    lv_codequcom_old     vtaequcom.codequcom%TYPE;
    lv_codequcom_new     vtaequcom.codequcom%TYPE;
    lv_retira_deco       VARCHAR2(100) := 'RDECO'; --'RETIRAR DECOS';
    lv_instala_m2_deco   VARCHAR2(100) := 'IM2D'; --'INSTALAR MAYOR A 02 DECOS';
    lv_instala_h2_deco   VARCHAR2(100) := 'IH2D'; --'INSTALAR HASTA 02 DECOS';
    lv_retira_telefonia  VARCHAR2(100) := 'RTLF'; --'RETIRAR TELEFONIA' **;
    lv_retira_internet   VARCHAR2(100) := 'RINT'; --'RETIRAR INTERNET';
    lv_instala_internet  VARCHAR2(100) := 'IINT'; --'INSTALAR INTERNET';
    lv_cemta             VARCHAR2(100) := 'CEMTA'; --'CAMBIO EMTA';
    lv_instala_me2_telef VARCHAR2(100) := 'ITLFME2'; --'INSTALAR TELEFONIA HASTA 02 LINEAS';
    lv_instala_ma2_telef VARCHAR2(100) := 'ITLFMA2'; --'INSTALAR TELEFONIA MAYOR A 02 LINEAS';
    lv_union             VARCHAR2(10) := '_'; --' + ';
    lv_cadena_deco_ins   VARCHAR2(100);
    lv_cadena_deco_des   VARCHAR2(100);
    lv_cadena_tlf_ins    VARCHAR2(100);
    lv_cadena_tlf_des    VARCHAR2(100);
    lv_cadena_deco       VARCHAR2(100);
    lv_cadena_int        VARCHAR2(100);
    lv_cadena_tlf        VARCHAR2(100);
    lv_subtipo           VARCHAR2(1000);
    lv_flag_rdeco        VARCHAR(1);
    lv_count             INT;
    error_subtipo EXCEPTION;
  
    --CURSOR CABLE
    CURSOR c_equ_old IS
      SELECT v.tipmaterial tip_eq, v.codequcom, SUM(v.qtysold) cantidad
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_old = pi_numslc_old
         AND v.tipservicio = 'CTV'
         AND v.tipproducto = 'EQUIPO'
         AND v.dscequ = 'DECODIFICADOR'
         AND v.tipslc = 'OLD'
       GROUP BY v.tipmaterial, v.codequcom
       ORDER BY v.tipmaterial;
  
    CURSOR c_equ_new IS
      SELECT v.tipmaterial tip_eq, v.codequcom, SUM(v.qtysold) cantidad
        FROM operacion.sga_visita_tecnica_ce v
       WHERE v.numslc_new = pi_numslc_new
         AND v.tipservicio = 'CTV'
         AND v.tipproducto = 'EQUIPO'
         AND v.dscequ = 'DECODIFICADOR'
         AND v.tipslc = 'NEW'
       GROUP BY v.tipmaterial, v.codequcom
       ORDER BY v.tipmaterial;
  
  BEGIN
    -- INICIO VALORES SERVICIOS
    ln_srv := operacion.pkg_visita_sga_ce.sgafun_inicia_valores(pi_numslc_old,
                                                                pi_numslc_new);
  
    -- INI INT
    IF ln_srv.ln_val_int_new > 0 AND ln_srv.ln_val_int_old = 0 AND
       ln_srv.ln_val_tlf_old = 0 THEN
      lv_cadena_int := lv_instala_internet;
    ELSIF ln_srv.ln_val_int_new > 0 AND ln_srv.ln_val_int_old = 0 AND
          ln_srv.ln_val_tlf_new > 0 THEN
      lv_cadena_int := lv_instala_internet;
    ELSIF ln_srv.ln_val_int_new = 0 AND ln_srv.ln_val_int_old > 0 AND
          ln_srv.ln_val_tlf_new = 0 THEN
      lv_cadena_int := lv_retira_internet;
    ELSIF ln_srv.ln_val_int_new > 0 AND ln_srv.ln_val_int_old > 0 THEN
      -- TIENE SRV INTERNET, VALIDO SI CAMBIA EMTA
      --LV_CODEQUCOM_OLD := operacion.PKG_VISITA_SGA_CE.SGAFUN_GET_CODEQU_OLD(pi_codsolot);
    
      lv_codequcom_old := operacion.pkg_visita_sga_ce.sgafun_get_codequ_old(pi_numslc_old);
      lv_codequcom_new := operacion.pkg_visita_sga_ce.sgafun_get_codequ_new(pi_numslc_new);
    
      /*BEGIN
      SELECT DISTINCT S.CODEQUCOM
      INTO LV_CODEQUCOM_NEW
      FROM OPERACION.SGA_VISITA_TECNICA_CE S
      WHERE S.NUMSLC_NEW = pi_numslc_new
      AND S.TIPSERVICIO = 'INT'
      AND s.tipproducto = 'EQUIPO'
      AND s.tipslc = 'NEW'
      AND S.TIPEQU IS NOT NULL
      AND ROWNUM < 2;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      LV_CODEQUCOM_NEW := 'OTROS';
      END;
      
      BEGIN
      SELECT DISTINCT S.CODEQUCOM
      INTO LV_CODEQUCOM_OLD
      FROM OPERACION.SGA_VISITA_TECNICA_CE S
      WHERE S.NUMSLC_old = pi_numslc_old
      AND S.TIPSERVICIO = 'INT'
      AND s.tipproducto = 'EQUIPO'
      AND s.tipslc = 'OLD'
      AND S.TIPEQU IS NOT NULL
      AND ROWNUM < 2;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      LV_CODEQUCOM_OLD := 'OTROS';
      END;*/
    
      IF operacion.pkg_visita_sga_ce.sgafun_val_cfg_codequcom(nvl(lv_codequcom_new,
                                                                  'X'),
                                                              nvl(lv_codequcom_old,
                                                                  'X')) = 1 AND
         lv_codequcom_new != lv_codequcom_old THEN
        lv_cadena_int := lv_cemta;
      END IF;
    END IF;
    -- FIN INT
  
    -- INI TLF
    ln_gcnt_tlf_new := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_new(pi_numslc_new,
                                                                          'TLF'); --Qty líneas
  
    -- INI TELF
    -- SRV NEW NO TIENE SRV OLD TIENE -> RETIRO NO COMPARO CANTIDAD
    IF ln_srv.ln_val_tlf_old > 0 AND ln_srv.ln_val_tlf_new = 0 THEN
      lv_cadena_tlf_des := lv_retira_telefonia;
    ELSIF ln_srv.ln_val_tlf_old = 0 AND ln_srv.ln_val_tlf_new > 0 THEN
      IF (nvl(ln_gcnt_tlf_new, 0)) > 2 THEN
        lv_cadena_tlf_ins := lv_instala_ma2_telef;
      ELSE
        lv_cadena_tlf_ins := lv_instala_me2_telef;
      END IF;
    ELSIF ln_srv.ln_val_tlf_old > 0 AND ln_srv.ln_val_tlf_new > 0 THEN
      -- Armando CADENA TELF INSTALA
      ln_gcnt_tlf_new := ln_gcnt_tlf_new -
                         operacion.pkg_visita_sga_ce.sgafun_val_cantequ_old(pi_numslc_old,
                                                                            'TLF');
      IF (nvl(ln_gcnt_tlf_new, 0)) < 0 THEN
        lv_cadena_tlf_des := lv_retira_telefonia;
      ELSE
        IF (nvl(ln_gcnt_tlf_new, 0)) > 2 THEN
          lv_cadena_tlf_ins := lv_instala_ma2_telef;
        ELSIF (nvl(ln_gcnt_tlf_new, 0)) = 0 THEN
          lv_cadena_tlf_ins := 'X';
        ELSE
          lv_cadena_tlf_ins := lv_instala_me2_telef;
        END IF;
      END IF;
    END IF;
  
    lv_cadena_tlf_ins := nvl(lv_cadena_tlf_ins, 'X');
    lv_cadena_tlf_des := nvl(lv_cadena_tlf_des, 'X');
  
    IF lv_cadena_tlf_ins != 'X' THEN
      lv_cadena_tlf := lv_cadena_tlf_ins;
    END IF;
  
    IF lv_cadena_tlf_des != 'X' THEN
      IF lv_cadena_tlf_ins = 'X' THEN
        lv_cadena_tlf := lv_cadena_tlf_des;
      ELSE
        lv_cadena_tlf := lv_cadena_tlf || lv_union || lv_cadena_tlf_des;
      END IF;
    END IF;
    -- FIN TLF
  
    -- Cantidad de Equipos Serv Anterior CTV
    /*SELECT SUM(x.cantidad)
    INTO ln_gcnt_ctv_old
    FROM (SELECT DISTINCT ip.pid, ip.codequcom, ip.cantidad
    FROM solot s, solotpto sp, insprd ip, inssrv iv
    WHERE s.codsolot = sp.codsolot
    AND sp.codinssrv = iv.codinssrv
    AND ip.codinssrv = iv.codinssrv
    --AND s.codsolot = pi_codsolot
    AND iv.tipsrv IN ('0062')
    AND ip.estinsprd IN (1, 2)) X
    WHERE NVL(X.codequcom, 'X') != 'X';*/
  
    /* SELECT SUM(vt.QTYSOLD) CANTIDAD
    INTO ln_gcnt_ctv_old
    FROM operacion.sga_visita_tecnica_ce vt
    WHERE vt.numslc_old = pi_numslc_old
    AND vt.TIPPRODUCTO = 'EQUIPO'
    AND vt.TIPSERVICIO = 'CTV'
    AND vt.DSCEQU = 'DECODIFICADOR'
    AND vt.TIPSLC = 'OLD';*/
  
    -- Cantidad de Equipos Serv Nuevo
    ln_gcnt_ctv_new := operacion.pkg_visita_sga_ce.sgafun_val_cantequ_new(pi_numslc_new,
                                                                          'CTV');
    lv_flag_rdeco   := '0';
  
    -- INI DECO
    -- SRV NEW NO TIENE SRV OLD TIENE -> RETIRO NO COMPARO CANTIDAD
    IF ln_srv.ln_val_ctv_old > 0 AND ln_srv.ln_val_ctv_new = 0 THEN
      lv_cadena_deco := lv_retira_deco;
    ELSIF ln_srv.ln_val_ctv_old = 0 AND ln_srv.ln_val_ctv_new > 0 THEN
      IF (nvl(ln_gcnt_ctv_new, 0)) > 2 THEN
        lv_cadena_deco := lv_instala_m2_deco;
      ELSE
        lv_cadena_deco := lv_instala_h2_deco;
      END IF;
    ELSIF ln_srv.ln_val_ctv_old > 0 AND ln_srv.ln_val_ctv_new > 0 THEN
      -- Armando CADENA DECOS INSTALA
      FOR c IN c_equ_new LOOP
        lv_codequcom_new := c.codequcom;
        FOR x IN c_equ_old LOOP
          IF c.tip_eq = x.tip_eq THEN
            IF (c.cantidad - x.cantidad) < 0 THEN
              ln_gcnt_ctv_new := ln_gcnt_ctv_new - c.cantidad;
            END IF;
            /*ELSE
            LV_FLAG_RDECO := 1;*/
          END IF;
        END LOOP;
      END LOOP;
    
      IF ln_srv.ln_val_ctv_old > 0 THEN
        FOR c IN c_equ_old LOOP
          FOR x IN c_equ_new LOOP
            IF c.tip_eq = x.tip_eq THEN
              IF (c.cantidad - x.cantidad) > 0 THEN
                lv_flag_rdeco := 1;
              END IF;
            END IF;
          END LOOP;
        END LOOP;
      END IF;
    
      IF (nvl(ln_gcnt_ctv_new, 0)) > 2 THEN
        lv_cadena_deco_ins := lv_instala_m2_deco;
      ELSE
        lv_cadena_deco_ins := lv_instala_h2_deco;
      END IF;
    
      IF (nvl(lv_flag_rdeco, 0)) = 1 THEN
        lv_cadena_deco_des := lv_retira_deco;
      END IF;
    
      IF nvl(lv_cadena_deco_ins, 'X') != 'X' THEN
        IF nvl(lv_cadena_deco_des, 'X') != 'X' THEN
          lv_cadena_deco := lv_cadena_deco_ins || lv_union ||
                            lv_cadena_deco_des;
        ELSE
          lv_cadena_deco := lv_cadena_deco_ins;
        END IF;
      END IF;
    END IF;
    -- FIN DECO
    -- ARMANDO LA DESCRIPCION
    lv_cadena_deco := nvl(lv_cadena_deco, 'X');
    lv_cadena_int  := nvl(lv_cadena_int, 'X');
    lv_cadena_tlf  := nvl(lv_cadena_tlf, 'X');
  
    IF lv_cadena_deco != 'X' THEN
      lv_tmp := lv_cadena_deco;
    END IF;
    IF lv_cadena_int != 'X' THEN
      lv_tmp := lv_tmp || CASE nvl(lv_tmp, '1')
                  WHEN '1' THEN
                   lv_cadena_int
                  ELSE
                   lv_union || lv_cadena_int
                END;
    END IF;
    IF lv_cadena_tlf != 'X' THEN
      lv_tmp := lv_tmp || CASE nvl(lv_tmp, '1')
                  WHEN '1' THEN
                   lv_cadena_tlf
                  ELSE
                   lv_union || lv_cadena_tlf
                END;
    END IF;
  
    -- Crear un funcion que devuelva EL SUBTIPO ORDEN
    /*OPERACION.SGAT_POSTVENTASCE_LOG(pi_numslc,
    NULL,
    'SUBTIPO_ALTERNO_VISIT_CP',
    LV_TMP);*/
    -----
    BEGIN
      SELECT cod_subtipo_orden
        INTO lv_subtipo
        FROM operacion.subtipo_orden_adc
       WHERE cod_alterno = lv_tmp
         AND id_tipo_orden = (SELECT id_tipo_orden_ce
                                FROM operacion.tiptrabajo
                               WHERE tiptra = pi_tiptra);
    EXCEPTION
      WHEN no_data_found THEN
        lv_subtipo := 'CODIGO ALTERNO NO ENCONTRADO: ' || lv_tmp;
      WHEN OTHERS THEN
        lv_subtipo := '';
    END;
    RETURN lv_subtipo;
  END;

  /****************************************************************
  '* Nombre FN : SGAFUN_get_tiptra_pv_sef
  '* Propósito : Obtener tipo de trabajo de nueva SEF.
  '* Input : <pi_numslc>  - Número de proyecto generado
  '* Output: <ln_tiptra>  - Tipo de trabajo
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  FUNCTION sgafun_get_tiptra_pv_sef(pi_numslc sales.vtatabslcfac.numslc%TYPE)
    RETURN NUMBER IS
    ln_tiptra       operacion.tiptrabajo.tiptra%TYPE;
    ln_tipo         NUMBER;
    lv_tipsrv       sales.tystipsrv.tipsrv%TYPE;
    ln_flg_cehfc_cp sales.vtatabslcfac.flg_cehfc_cp%TYPE;
  BEGIN
    ln_tiptra := to_number(sales.pkg_etadirect_utl.conf('etadirect',
                                                        'tiptra_venta'));
  
    BEGIN
      SELECT tipsrv, flg_cehfc_cp
        INTO lv_tipsrv, ln_flg_cehfc_cp
        FROM sales.vtatabslcfac
       WHERE numslc = pi_numslc;
    EXCEPTION
      WHEN no_data_found THEN
        RETURN - 1;
    END;
  
    IF lv_tipsrv IS NULL OR lv_tipsrv = ' ' THEN
      RETURN - 2;
    END IF;
  
    ln_tipo := operacion.pq_adm_cuadrilla.f_tipo_x_tiposerv(lv_tipsrv);
  
    IF ln_tipo = 2 THEN
      --Si es tipo servicio Claro Empresa
      BEGIN
        SELECT d.codigon
          INTO ln_tiptra
          FROM operacion.parametro_cab_adc c
         INNER JOIN operacion.parametro_det_adc d
            ON d.id_parametro = c.id_parametro
         WHERE c.estado = 1
           AND d.estado = 1
           AND upper(c.abreviatura) = upper('TIPO_TRABAJO')
           AND upper(d.abreviatura) = 'SRV_MENORES'
           AND d.codigoc = to_char(ln_flg_cehfc_cp);
      EXCEPTION
        WHEN no_data_found THEN
          RETURN - 3;
      END;
    END IF;
  
    RETURN ln_tiptra;
  END sgafun_get_tiptra_pv_sef;

  /****************************************************************
  '* Nombre SP : SGASS_get_subtipord_ce
  '* Propósito : Listar subtipo de orden CE.
  '* Input : <pi_id_tiporden>    - ID de tipo de orden
  '*         <pi_cod_subtipord>  - Código de subtipo de orden
  '* Output: <po_cursor>         - Cursor del listado de subtipo de orden
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 24/07/2018
  '* Fec Actualización : 02/08/2018
  '****************************************************************/
  PROCEDURE sgass_get_subtipord_ce(pi_id_tiporden   IN operacion.tipo_orden_adc.id_tipo_orden%TYPE,
                                   pi_cod_subtipord IN operacion.subtipo_orden_adc.cod_subtipo_orden%TYPE,
                                   po_cursor        OUT gc_salida) IS
  BEGIN
    OPEN po_cursor FOR
      SELECT s.cod_subtipo_orden,
             s.descripcion,
             s.id_work_skill,
             s.grado_dificultad,
             s.tiempo_min,
             t.id_tipo_orden,
             s.id_subtipo_orden --3.0
        FROM operacion.subtipo_orden_adc s
       INNER JOIN operacion.tipo_orden_adc t
          ON s.id_tipo_orden = t.id_tipo_orden
       WHERE t.id_tipo_orden = pi_id_tiporden
         AND (s.cod_subtipo_orden = pi_cod_subtipord OR
             pi_cod_subtipord IS NULL)
         AND s.estado = 1;
    RETURN;
  END sgass_get_subtipord_ce;

  --INI 1.0
  /**************************************************
  '* Nombre SP : SGASS_product_internet
  '* Propósito : Listar ancho de banda de los productos de internet.
  '* Input: <pi_codsrv>          - Codigo srv
  '* Input: <pi_dscsrv>          - Descripcion de svr
  '* Output: <po_cursor>         - Cursor del listado de productos de internet
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creación : 24/08/2018
  '* Fec Actualización : -
  *********************************************/
  PROCEDURE sgass_product_internet(pi_codsrv IN sales.tystabsrv.codsrv%TYPE,
                                   pi_dscsrv IN sales.tystabsrv.dscsrv%TYPE,
                                   po_cursor OUT gc_salida) IS
  BEGIN
    OPEN po_cursor FOR
      SELECT t.codsrv, t.dscsrv, t.banwid, t.codigo_ext
        FROM sales.tystabsrv t
       WHERE ('-1' = pi_codsrv OR upper(t.codsrv) = upper(pi_codsrv))
         AND ('-1' = pi_dscsrv OR
             upper(t.dscsrv) LIKE upper('%' || pi_dscsrv || '%'))
         AND t.estado = 1
         AND t.tipsrv = '0006';
    RETURN;
  END sgass_product_internet;

  /**************************************************
  '* Nombre SP : SGASU_banwid_internet
  '* Propósito : Actualizar el ancho de banda de los productos de internet.
  '* Input: <pi_codsrv>          - Codigo srv
  '* Input: <pi_codigo_ext>      - Codigo ext
  '* Input: <pi_banwid>          - Nuevo valor para el ancho de banda
  '* Output: <po_resultado>      - Codigo del resultado
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creación : 24/08/2018
  '* Fec Actualización : -
  *********************************************/
  PROCEDURE sgasu_banwid_internet(pi_codsrv     IN sales.tystabsrv.codsrv%TYPE,
                                  pi_codigo_ext IN sales.tystabsrv.codigo_ext%TYPE,
                                  pi_banwid     IN sales.tystabsrv.banwid%TYPE,
                                  po_resultado  OUT INTEGER) IS
  BEGIN
    po_resultado := 0;
  
    UPDATE sales.tystabsrv
       SET banwid = pi_banwid, usumod = USER, fecmod = SYSDATE
     WHERE codsrv = pi_codsrv;
  
    UPDATE intraway.configuracion_itw
       SET intraway.configuracion_itw.capacidad = pi_banwid
     WHERE to_char(intraway.configuracion_itw.idconfigitw) = pi_codigo_ext;
  
    po_resultado := 1;
  
  END sgasu_banwid_internet;
  /**************************************************
  '* Nombre SP : SGASU_ORDEN_TOA
  '* Proposito : Actualizar Notas 2 para la orden en TOA.
  '* Input: <pi_codsolot>          - Codigo de solot
  '* Input: <pi_observacion>       - Observacion a actualizar
  '* Output: <po_mensaje_res>      - Mensaje de respuesta
  '* Output: <po_codigo_res>       - Codigo de respuesta
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 18/09/2018
  '* Fec Actualizacion : -
  *********************************************/
  PROCEDURE sgasu_orden_toa(pi_codsolot    operacion.solot.codsolot%TYPE,
                            pi_observacion VARCHAR2,
                            po_mensaje_res OUT VARCHAR2,
                            po_codigo_res  OUT NUMBER) IS
    lv_id_agenda          NUMBER;
    lv_servicio           VARCHAR2(100);
    lv_trama              CLOB;
    lv_xml                CLOB;
    lv_mensaje_repws      VARCHAR2(1000);
    lv_codigo_respws      VARCHAR2(1000);
    lv_numbercaracter     NUMBER;
    lv_idconsulta         CLOB;
    lv_idconsulta2        CLOB;
    lv_modo_propiedad     VARCHAR2(20);
    lv_tipo_comando       VARCHAR2(20);
    lv_delimitador        VARCHAR2(1);
    lv_separador3         VARCHAR2(1);
    lv_xa_activity_notes2 VARCHAR2(50);
  BEGIN
  
    lv_servicio := 'gestionarOrdenSGA_ADC';
  
    BEGIN
      SELECT MAX(idagenda)
        INTO lv_id_agenda
        FROM operacion.transaccion_ws_adc
       WHERE codsolot = pi_codsolot
         AND iderror = 0;
      IF lv_id_agenda IS NULL THEN
        po_mensaje_res := '';
        po_codigo_res  := -1002;
        RETURN;
      END IF;
    EXCEPTION
      WHEN no_data_found THEN
        po_mensaje_res := '';
        po_codigo_res  := -1002;
        RETURN;
    END;
    BEGIN
      SELECT xmlenvio
        INTO lv_trama
        FROM operacion.transaccion_ws_adc
       WHERE codsolot = pi_codsolot
         AND metodo = 'gestionarOrdenSGA'
         AND rownum <= 1
         AND iderror = 0;
    EXCEPTION
      WHEN no_data_found THEN
        po_mensaje_res := 'No se encontro trama de Orden Eta Direct';
        po_codigo_res  := -1003;
        RETURN;
    END;
    BEGIN
      SELECT pda.codigoc
        INTO lv_modo_propiedad
        FROM operacion.parametro_det_adc pda
       WHERE pda.id_parametro =
             (SELECT id_parametro
                FROM operacion.parametro_cab_adc
               WHERE abreviatura = 'PARAM_CRE_OT')
         AND pda.abreviatura = 'MOD_PRD';
    EXCEPTION
      WHEN no_data_found THEN
        po_codigo_res  := -1004;
        po_mensaje_res := 'No se encontro registro de Modo de Propiedad de Programada';
        RETURN;
    END;
    BEGIN
      SELECT pda.codigoc
        INTO lv_tipo_comando
        FROM operacion.parametro_det_adc pda
       WHERE pda.id_parametro =
             (SELECT id_parametro
                FROM operacion.parametro_cab_adc
               WHERE abreviatura = 'PARAM_CRE_OT')
         AND pda.abreviatura = 'TIP_CMD';
    EXCEPTION
      WHEN no_data_found THEN
        po_codigo_res  := -1005;
        po_mensaje_res := 'No se encontro registro de Tipo de Comando';
        RETURN;
    END;
    BEGIN
      SELECT pda.codigoc
        INTO lv_separador3
        FROM operacion.parametro_det_adc pda
       WHERE pda.id_parametro =
             (SELECT id_parametro
                FROM operacion.parametro_cab_adc
               WHERE abreviatura = 'PARAM_CRE_OT')
         AND pda.abreviatura = 'SEP_3';
    EXCEPTION
      WHEN no_data_found THEN
        po_codigo_res  := -1006;
        po_mensaje_res := 'No se encontro registro de Separador';
        RETURN;
    END;
    BEGIN
      SELECT pda.codigoc
        INTO lv_xa_activity_notes2
        FROM operacion.parametro_cab_adc pca
        JOIN operacion.parametro_det_adc pda
          ON pca.id_parametro = pda.id_parametro
         AND pca.abreviatura = 'PARAM_CRE_OT'
         AND pda.abreviatura = 'XANO_2';
    EXCEPTION
      WHEN no_data_found THEN
        po_codigo_res  := -1007;
        po_mensaje_res := 'No se encontro el Campo de XA_Activity_Notes_2';
        RETURN;
    END;
    BEGIN
      SELECT pda.codigoc
        INTO lv_delimitador
        FROM operacion.parametro_det_adc pda
       WHERE pda.id_parametro =
             (SELECT id_parametro
                FROM operacion.parametro_cab_adc
               WHERE abreviatura = 'PARAM_CRE_OT')
         AND pda.abreviatura = 'DEL_1';
    EXCEPTION
      WHEN no_data_found THEN
        po_codigo_res  := -1008;
        po_mensaje_res := 'No se encontro registro de Delimitador';
        RETURN;
    END;
  
    lv_trama := substr(lv_trama,
                       instr(lv_trama, 'cadenaRequest'),
                       length(lv_trama));
    lv_trama := substr(lv_trama, instr(lv_trama, '>') + 1, length(lv_trama));
    lv_trama := TRIM(substr(lv_trama, 1, instr(lv_trama, '<') - 1));
    lv_trama := REPLACE(lv_trama, '  ', '');
    lv_trama := REPLACE(lv_trama, chr(10), '');
    -------------------
    --modo_propiedad
    lv_numbercaracter := length(lv_trama) - instr(lv_trama, '|', 1, 5);
    lv_idconsulta     := nvl(substr(lv_trama, 1, instr(lv_trama, '|', 1, 4)),
                             '');
    lv_idconsulta2    := nvl(substr(lv_trama,
                                    instr(lv_trama, '|', 1, 5),
                                    lv_numbercaracter),
                             '');
    lv_trama          := lv_idconsulta || lv_modo_propiedad ||
                         lv_idconsulta2;
    -------------------
    --tipo_comando
    lv_numbercaracter := length(lv_trama) - instr(lv_trama, '|', 1, 13);
    lv_idconsulta     := nvl(substr(lv_trama,
                                    1,
                                    instr(lv_trama, '|', 1, 12)),
                             '');
    lv_idconsulta2    := nvl(substr(lv_trama,
                                    instr(lv_trama, '|', 1, 13),
                                    lv_numbercaracter),
                             '');
    lv_trama          := lv_idconsulta || lv_tipo_comando || lv_idconsulta2;
    --------------------
    lv_idconsulta := nvl(substr(lv_trama, 1, instr(lv_trama, '|', 1, 33)),
                         '');
    lv_trama      := lv_idconsulta || lv_xa_activity_notes2 ||
                     lv_separador3 || pi_observacion || lv_delimitador ||
                     lv_delimitador;
  
    webservice.pq_obtiene_envia_trama_adc.p_ws_consulta(pi_codsolot,
                                                        lv_id_agenda,
                                                        lv_servicio,
                                                        lv_trama,
                                                        lv_xml,
                                                        lv_mensaje_repws,
                                                        lv_codigo_respws);
  
    IF lv_codigo_respws IS NULL THEN
      po_mensaje_res := 'Servicio Eta Direct no responde';
      po_codigo_res  := -1001;
      RETURN;
    END IF;
  
    po_mensaje_res := lv_mensaje_repws;
    po_codigo_res  := lv_codigo_respws;
  
  END sgasu_orden_toa;

  FUNCTION sgafun_consult_cambplan(pi_codect VARCHAR2) RETURN INTEGER IS
    ln_find INTEGER;
  BEGIN
    ln_find := 0;
  
    SELECT COUNT(vta.codect)
      INTO ln_find
      FROM sales.vtatabect vta
     WHERE vta.estect = '1'
       AND vta.tipect NOT IN ('18', '19')
       AND vta.nomect = pi_codect
       AND vta.nomect = 'Cambio plan MC';
  
    RETURN ln_find;
  END sgafun_consult_cambplan;

  FUNCTION sgafun_agente_agendam(pi_codect IN VARCHAR2) RETURN VARCHAR2 IS
    lv_find VARCHAR2(20);
  BEGIN
    lv_find := pi_codect;
  
    SELECT vta.codect
      INTO lv_find
      FROM sales.vtatabect vta
     WHERE vta.codect = '00000000'; --Sin Definir
  
    RETURN lv_find;
  END sgafun_agente_agendam;

  FUNCTION sgafun_tipserv_agendam(pi_codect VARCHAR2) RETURN INTEGER IS
    ln_find INTEGER;
  BEGIN
    ln_find := 0;
  
    SELECT COUNT(tys.tipsrv)
      INTO ln_find
      FROM sales.tystipsrv tys
     WHERE tys.estado = 1
       AND tys.tipsrv = pi_codect
       AND pi_codect = '0073'; --Paquetes Pymes en HFC
  
    RETURN ln_find;
  END sgafun_tipserv_agendam;
  --FIN 1.0
  --INI 2.0

  /****************************************************************
  '* Nombre FN : SGAFUN_tiptrab_agendam
  '* Proposito : Valida si el tipo de trabajo pertenece HFC CE Transacciones Postventa
  '* Input : <pi_tiptra>  - Tipo de trabajo
  '* Return: <ln_find>  - Cuenta 1 si pertenece o 0 si no.
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 14/09/2018
  '* Fec Actualizacion :
  '****************************************************************/
  FUNCTION sgafun_tiptrab_agendam(pi_tiptra IN NUMBER) RETURN INTEGER IS
    ln_find INTEGER;
  BEGIN
    ln_find := 0;
  
    SELECT COUNT(1)
      INTO ln_find
      FROM operacion.opedd o
     INNER JOIN operacion.tipopedd t
        ON o.tipopedd = t.tipopedd
       AND t.descripcion = 'HFC CE Transacciones Postventa'
       AND t.abrev = 'CEHFCPOST'
     WHERE to_number(o.codigon) = pi_tiptra;
    RETURN ln_find;
  END;

  /****************************************************************
  '* Nombre SP : SGASS_zonaplano_x_sot
  '* Propósito : Obtiene Centro Poblado, Plano y Tecnologia en base a la SOT
  '* Input : <pi_codsolot>  - Numero de Solicitud
  '* Output: <po_centrop>  - Centro Poblado
  '* Output: <po_idplano>  - Id Plano
  '* Output: <po_tecnologia>  - Tipo de Tecnologia
  '* Output: <po_error_n>  - Numero de error
  '* Output: <po_error_v>  - Mensaje del error
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 14/09/2018
  '* Fec Actualización :
  '****************************************************************/
  PROCEDURE sgass_zonaplano_x_sot(pi_codsolot   operacion.solot.codsolot%TYPE,
                                  po_centrop    OUT marketing.vtasuccli.ubigeo2%TYPE,
                                  po_idplano    OUT marketing.vtasuccli.idplano%TYPE,
                                  po_tecnologia OUT VARCHAR2,
                                  po_error_n    OUT NUMBER,
                                  po_error_v    OUT VARCHAR2) IS
    e_error EXCEPTION;
  
    CURSOR c_ IS
      SELECT DISTINCT v.ubigeo2 centrop, v.idplano
        FROM operacion.inssrv    i,
             marketing.vtasuccli v,
             solotpto            p,
             operacion.solot     s
       WHERE i.codinssrv = p.codinssrv
         AND i.codcli = v.codcli
         AND i.codsuc = v.codsuc
         AND v.codcli = s.codcli
         AND p.codsolot = s.codsolot
         AND s.codsolot = pi_codsolot;
  BEGIN
    BEGIN
    
      po_tecnologia := sgafun_tipo_tecnologia(pi_codsolot,
                                              po_error_n,
                                              po_error_v);
    
      FOR r_ IN c_ LOOP
        IF r_.centrop IS NOT NULL OR r_.idplano IS NOT NULL THEN
          po_centrop := r_.centrop;
          po_idplano := r_.idplano;
          IF po_tecnologia = 'DTH' THEN
            IF po_centrop IS NULL OR po_centrop LIKE '' THEN
              po_error_v := '[operacion.pkg_visita_sga_ce.SGASS_zonaplano_x_sot] Codigo de centro Poblado a consultar es nulo, por favor verificar';
              RAISE e_error;
            END IF;
            po_idplano := NULL;
            EXIT;
          ELSE
            IF po_idplano IS NULL OR po_idplano LIKE '' THEN
              po_error_v := '[operacion.pkg_visita_sga_ce.SGASS_zonaplano_x_sot] Codigo de plano a consultar es nulo, por favor verificar';
              RAISE e_error;
            END IF;
            po_centrop := NULL;
            EXIT;
          END IF;
        END IF;
      END LOOP;
    EXCEPTION
      WHEN e_error THEN
        po_error_n := -1;
      
      WHEN OTHERS THEN
        po_error_n := -2;
        po_error_v := '[operacion.pkg_visita_sga_ce.SGASS_zonaplano_x_sot] Se genero el error: ' ||
                      SQLERRM || '.';
    END;
  END;

  /****************************************************************
  '* Nombre FN : SGAFUN_tipo_tecnologia
  '* Proposito : Devuelve el tipo de Tecnologia
  '* Input : <pi_codsolot>  - Numero de Solicitud
  '* Output : <po_error_n>  - Numero de error
  '* Output : <po_error_v>  - Mensaje del error
  '* Return: <lv_tecnol>  - Tipo de Tecnologia.
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 17/09/2018
  '* Fec Actualizacion :
  '****************************************************************/
  FUNCTION sgafun_tipo_tecnologia(pi_codsolot solot.codsolot%TYPE,
                                  po_error_n  OUT NUMBER,
                                  po_error_v  OUT VARCHAR2) RETURN VARCHAR2 IS
  
    lv_tecnol operacion.tipo_orden_adc.tipo_tecnologia%TYPE;
    lv_tipsrv solot.tipsrv%TYPE;
    ln_tipo   NUMBER;
  
  BEGIN
    po_error_n := 0;
    po_error_v := '';
  
    SELECT s.tipsrv
      INTO lv_tipsrv
      FROM solot s
     WHERE s.codsolot = pi_codsolot;
  
    ln_tipo := operacion.pq_adm_cuadrilla.f_tipo_x_tiposerv(lv_tipsrv);
  
    IF ln_tipo = 2 THEN
      BEGIN
        SELECT c.tipo_tecnologia
          INTO lv_tecnol
          FROM solot a, tiptrabajo b, operacion.tipo_orden_adc c
         WHERE a.tiptra = b.tiptra
           AND b.id_tipo_orden_ce = c.id_tipo_orden
           AND a.codsolot = pi_codsolot
           AND c.estado = 1;
      
      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol  := '';
          po_error_n := -1;
          po_error_v := '[operacion.pkg_visita_sga_ce.SGAFUN_tipo_tecnologia] La Configuracion de TIPO TECNOLOGIA CE No Existe ';
      END;
    ELSIF ln_tipo = 1 THEN
    
      BEGIN
        SELECT c.tipo_tecnologia
          INTO lv_tecnol
          FROM solot a, tiptrabajo b, operacion.tipo_orden_adc c
         WHERE a.tiptra = b.tiptra
           AND b.id_tipo_orden = c.id_tipo_orden
           AND a.codsolot = pi_codsolot
           AND c.estado = 1;
      
      EXCEPTION
        WHEN no_data_found THEN
          lv_tecnol  := '';
          po_error_n := -1;
          po_error_v := '[operacion.pkg_visita_sga_ce.SGAFUN_tipo_tecnologia] La Configuracion de TIPO TECNOLOGIA No Existe ';
      END;
    END IF;
    RETURN lv_tecnol;
  END;

  /****************************************************************
  '* Nombre SP : SGASS_valflujozona_adc
  '* Propósito : Obtiene codigo de zona
  '* Input : <pi_codsolot>  - Numero de Solicitud
  '* Input: <pi_idplano>  - Id Plano
  '* Input: <pi_tiptra>  - Tipo de Trabajo
  '* Input: <pi_tipsrv>  - Tipo de Servicio
  '* Output: <po_codzona>  - Codigo de zona
  '* Output: <po_indica>  - Indica si hay visita
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 17/09/2018
  '* Fec Actualización :
  '****************************************************************/
  PROCEDURE sgass_valflujozona_adc(pi_origen  IN VARCHAR2,
                                   pi_idplano IN marketing.vtatabgeoref.idplano%TYPE,
                                   pi_tiptra  IN operacion.matriz_tystipsrv_tiptra_adc.tiptra%TYPE,
                                   pi_tipsrv  IN operacion.matriz_tystipsrv_tiptra_adc.tipsrv%TYPE,
                                   po_codzona OUT operacion.zona_adc.codzona%TYPE,
                                   po_indica  OUT NUMBER) IS
    ln_flg_adc     NUMBER;
    ln_indicador   NUMBER;
    ln_idzona      NUMBER;
    ln_flg_zona    NUMBER;
    ls_codzona     operacion.zona_adc.codzona%TYPE;
    ln_flg_aobliga NUMBER;
  BEGIN
    po_indica := 0;
  
    -- validar plano / centro poblado --
    IF pi_idplano IS NOT NULL THEN
      BEGIN
        SELECT DISTINCT flg_adc, idzona
          INTO ln_flg_adc, ln_idzona
          FROM marketing.vtatabgeoref
         WHERE idplano = pi_idplano;
      EXCEPTION
        WHEN no_data_found THEN
          po_indica  := -1;
          po_codzona := NULL;
          -- Plano enviado no existe
          RETURN;
      END;
    END IF;
  
    IF nvl(ln_flg_adc, 0) = '1' THEN
      -- validar zona --
      BEGIN
        SELECT codzona, z.estado
          INTO ls_codzona, ln_flg_zona
          FROM operacion.zona_adc z
         WHERE idzona = ln_idzona;
      EXCEPTION
        WHEN no_data_found THEN
          -- zona configurada no existe --
          po_indica  := -4;
          po_codzona := NULL;
          RETURN;
      END;
      -- zona desactivada --
      IF ln_flg_zona = 0 THEN
        po_codzona := ls_codzona;
        po_indica  := 0;
        RETURN;
      END IF;
    ELSE
      po_codzona := NULL;
      po_indica  := 0;
      RETURN;
    END IF;
  
    IF pi_tiptra IS NULL THEN
      -- tipo de trabajo es nulo
      po_codzona := NULL;
      po_indica  := -5;
      RETURN;
    END IF;
  
    IF pi_tipsrv IS NULL THEN
      -- codigo de tipo de servicio es nulo
      po_codzona := NULL;
      po_indica  := -6;
      RETURN;
    END IF;
  
    IF pi_origen IS NULL THEN
      -- origen es nulo
      po_codzona := NULL;
      po_indica  := -7;
      RETURN;
    END IF;
  
    -- V : Modulo de Ventas / P : Modulo de Post-Venta / O : Modulo de Operaciones --
    BEGIN
      SELECT DISTINCT decode(pi_origen,
                             'V',
                             d.con_cap_v,
                             'P',
                             d.con_cap_p,
                             'O',
                             d.con_cap_o),
                      d.flgaobliga
        INTO ln_indicador, ln_flg_aobliga
        FROM operacion.matriz_tystipsrv_tiptra_adc d
       WHERE tipsrv = pi_tipsrv
         AND tiptra = pi_tiptra
         AND estado = 1;
    
      IF ln_indicador = 0 AND ln_flg_aobliga = 0 THEN
        ln_indicador := 0;
      ELSIF ln_indicador = 1 AND ln_flg_aobliga = 0 THEN
        ln_indicador := 1;
      ELSIF ln_indicador = 1 AND ln_flg_aobliga = 1 THEN
        ln_indicador := 2;
      END IF;
    
      po_codzona := ls_codzona;
      po_indica  := ln_indicador;
    EXCEPTION
      WHEN no_data_found THEN
        po_codzona := NULL;
        po_indica  := 0;
    END;
  
  END sgass_valflujozona_adc;

  /****************************************************************
  '* Nombre SP : SGASI_asigna_workflow
  '* Propósito : Asigna Workflow a la SOT
  '* Input : <pi_codsolot>  - Numero de Solicitud
  '* Output : <po_error_n>  - Numero de error
  '* Output : <po_error_v>  - Mensaje del error
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 18/09/2018
  '* Fec Actualización :
  '****************************************************************/
  PROCEDURE sgasi_asigna_workflow(pi_codsolot solot.codsolot%TYPE,
                                  po_error_n  OUT NUMBER,
                                  po_error_v  OUT VARCHAR2) IS
  
    ll_idwf   NUMBER;
    ll_cont   NUMBER;
    ll_wfdef  NUMBER;
    ls_estsol VARCHAR2(10);
    ll_tiptra NUMBER;
  
  BEGIN
  
    SELECT DISTINCT t.tiptra tiptra,
                    t.estsol estsol,
                    cusbra.f_br_sel_wf(t.codsolot) wfdef
      INTO ll_tiptra, ls_estsol, ll_wfdef
      FROM solot t
     WHERE t.codsolot = pi_codsolot;
  
    po_error_n := 0;
    po_error_v := '';
  
    SELECT COUNT(*)
      INTO ll_cont
      FROM wf f
     WHERE f.codsolot = pi_codsolot
       AND f.valido = 1;
  
    IF ll_cont > 0 THEN
      SELECT f.idwf
        INTO ll_idwf
        FROM wf f
       WHERE f.codsolot = pi_codsolot
         AND f.valido = 1;
      opewf.pq_wf.p_cancelar_wf(ll_idwf);
      opewf.pq_wf.p_del_wf(ll_idwf);
    END IF;
  
    BEGIN
    
      operacion.pq_solot.p_asig_wf(pi_codsolot, ll_wfdef);
    
      SELECT idwf
        INTO ll_idwf
        FROM wf
       WHERE codsolot = pi_codsolot
         AND valido = 1;
    
      UPDATE operacion.tmp_solot_codigo
         SET estado         = 4,
             fechaejecucion = SYSDATE,
             observacion    = 'Se realizo la asignacion del WF - ' ||
                              ll_idwf || ' a la SOT'
       WHERE codsolot = pi_codsolot
         AND estado <> 6;
    
      po_error_v := 'Se realizo la asignacion del WF - ' || ll_idwf ||
                    ' a la SOT';
    
    EXCEPTION
      WHEN OTHERS THEN
        po_error_n := -1;
        po_error_v := 'Error en la SOT ' || to_char(pi_codsolot) ||
                      dbms_utility.format_error_backtrace || ' - ' ||
                      SQLERRM;
      
    END;
  
  END sgasi_asigna_workflow;

  /****************************************************************
  '* Nombre SP : SGASS_buscar_cliente
  '* Propósito : Lista datos del cliente
  '* Input : <pi_codcli>  - codigo del cliente
  '* Input : <pi_nombre>  - Nombre del cliente
  '* Output : <po_cursor>  - Cursor con los datos obtenidos.
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 18/09/2018
  '* Fec Actualización :
  '****************************************************************/
  PROCEDURE sgass_buscar_cliente(pi_codcli IN VARCHAR2,
                                 pi_nombre IN VARCHAR2,
                                 po_cursor OUT gc_salida) IS
  BEGIN
    IF pi_codcli IS NULL THEN
      BEGIN
      
        OPEN po_cursor FOR
          SELECT vc.codcli, vc.nomcli, vc.dircli, vu.distrito_desc
            FROM vtatabcli vc
            LEFT JOIN v_ubicaciones vu
              ON vc.codubi = vu.codubi
           WHERE ((upper(vc.nomcli) LIKE pi_nombre) OR
                 (upper(vc.dircli) LIKE pi_nombre));
      END;
    ELSE
      BEGIN
        OPEN po_cursor FOR
          SELECT vc.codcli, vc.nomcli, vc.dircli, vu.distrito_desc
            FROM vtatabcli vc
            LEFT JOIN v_ubicaciones vu
              ON vc.codubi = vu.codubi
           WHERE vc.codcli = pi_codcli;
      END;
    END IF;
  
  END sgass_buscar_cliente;

  /****************************************************************
  '* Nombre SP : SGASS_datos_complement
  '* Propósito : Asigna Workflow a la SOT
  '* Input : <pi_codsolot>  - numero de sot
  '* Output : <po_codcli>  - codigo del cliente
  '* Output : <po_codsuc>  - codigo sucursal
  '* Output : <po_numslc>  - Numero de proyecto.
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 18/09/2018
  '* Fec Actualización :
  '****************************************************************/
  PROCEDURE sgass_datos_complement(pi_codsolot solot.codsolot%TYPE,
                                   po_codcli   OUT VARCHAR2,
                                   po_codsuc   OUT VARCHAR2,
                                   po_numslc   OUT VARCHAR2) AS
  BEGIN
  
    BEGIN
      SELECT DISTINCT i.codcli, i.codsuc, i.numslc
        INTO po_codcli, po_codsuc, po_numslc
        FROM operacion.inssrv    i,
             marketing.vtasuccli v,
             solotpto            p,
             operacion.solot     s
       WHERE i.codinssrv = p.codinssrv
         AND i.codcli = v.codcli
         AND i.codsuc = v.codsuc
         AND v.codcli = s.codcli
         AND p.codsolot = s.codsolot
         AND s.codsolot = pi_codsolot;
    
    EXCEPTION
      WHEN no_data_found THEN
        po_codcli := '';
        po_codsuc := '';
        po_numslc := '';
    END;
  
  END sgass_datos_complement;

  /****************************************************************
  '* Nombre SP : SGASS_idconsulta_x_solot
  '* Propósito : Obtiene el id_consulta en base a una SOT
  '* Input : <pi_codsolot>  - numero de solicitud
  '* Output : <po_cursor>  - cursor con la data
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 18/09/2018
  '* Fec Actualización :
  '****************************************************************/

  PROCEDURE sgass_idconsulta_xsot(pi_codsolot solot.codsolot%TYPE,
                                  po_cursor   OUT gc_salida) AS
  BEGIN
  
    OPEN po_cursor FOR
      SELECT res.id_consulta,
             pvta.codsolot,
             pvta.plano,
             pvta.subtipo_orden,
             pvta.fecha_progra,
             pvta.franja,
             pvta.idbucket
        FROM operacion.parametro_vta_pvta_adc pvta
       INNER JOIN sales.etadirect_req req
          ON pvta.plano = req.cod_plano
         AND pvta.subtipo_orden = req.subtipo_orden
         AND req.fecha_venta = pvta.fecha_progra
       INNER JOIN sales.etadirect_res res
          ON req.id_consulta = res.id_consulta
         AND pvta.franja = res.franja
         AND pvta.idbucket = res.id_bucket
         AND res.dia = pvta.fecha_progra
       WHERE pvta.codsolot = pi_codsolot
         AND rownum = 1
       ORDER BY res.id_consulta DESC;
  
  END sgass_idconsulta_xsot;

  --FIN v2.0

  --INI v3.0
  /**************************************************
  '* Nombre SP : SGASS_TIPO_ORDEN_ADC
  '* Proposito : Actualizar Notas 2 para la orden en TOA.
  '* Input: <pi_flg_tipo>         - FLG_TIPO
  '* Input: <pi_flg_indica>       - Indicador para filtro de estado
  '* Output: <po_cursor>          - Cursor de salida
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 21/11/2018
  '* Fec Actualizacion : -
  *********************************************/
  PROCEDURE sgass_tipo_orden_adc(pi_flg_tipo   NUMBER,
                                 pi_flg_indica NUMBER,
                                 po_cursor     OUT gc_salida)
  
   AS
  BEGIN
  
    IF pi_flg_indica = cn_estado_activo THEN
      OPEN po_cursor FOR
        SELECT id_tipo_orden,
               cod_tipo_orden,
               descripcion,
               tipo_tecnologia,
               estado,
               ipcre,
               ipmod,
               fecre,
               fecmod,
               usucre,
               usumod,
               tipo_servicio,
               flg_tipo
          FROM operacion.tipo_orden_adc
         WHERE operacion.tipo_orden_adc.flg_tipo = pi_flg_tipo
           AND estado = cn_estado_activo;
    ELSE
      OPEN po_cursor FOR
        SELECT id_tipo_orden,
               cod_tipo_orden,
               descripcion,
               tipo_tecnologia,
               estado,
               ipcre,
               ipmod,
               fecre,
               fecmod,
               usucre,
               usumod,
               tipo_servicio,
               flg_tipo
          FROM operacion.tipo_orden_adc
         WHERE operacion.tipo_orden_adc.flg_tipo = pi_flg_tipo;
    END IF;
  END;

  /**************************************************
  '* Nombre SP : SGASI_SGAT_IMPORT_CAB
  '* Proposito : Insert de la tabla operacion.sgat_importacion_masiva_cab
  '* Input: <pi_root_file_name>    - nombre del archivo
  '* Input: <pi_tabla>             - tabla
  '* Input: <pi_observacion>       - Observacion
  '* Output: <pi_idcab>            - impcn_idcab devuelto
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 21/11/2018
  '* Fec Actualizacion : -
  *********************************************/
  PROCEDURE sgasi_sgat_import_cab(pi_root_file_name IN VARCHAR2,
                                  pi_tabla          IN VARCHAR2,
                                  pi_observacion    IN VARCHAR2,
                                  pi_idcab          OUT NUMBER) AS
  BEGIN
  
    INSERT INTO operacion.sgat_importacion_masiva_cab
      (impcv_root_file_name, impcv_tabla, impcv_observacion)
    VALUES
      (pi_root_file_name, pi_tabla, pi_observacion)
    RETURNING impcn_idcab INTO pi_idcab;
  
  END;

  /**************************************************
  '* Nombre SP : SGASI_SGAT_IMPORT_DET
  '* Proposito : Insert de la tabla operacion.sgat_importacion_masiva_det
  '* Input: <pi_idcab>        - impcn_idcab de la tabla sgat_importacion_masiva_cab
  '* Input: <pi_idplano>      - plano
  '* Input: <pi_codubi>       - codigo de ubigeo
  '* Input: <pi_codzona>      - zona
  '* Input: <pi_flg_adc>      - flag adc
  '* Input: <pi_descripcion>  - descripcion
  '* Input: <pi_servicio>     - servicio
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 21/11/2018
  '* Fec Actualizacion : -
  ***********************************************/
  PROCEDURE SGASI_SGAT_IMPORT_DET (pi_idcab IN NUMBER,
                                 pi_idplano IN VARCHAR2,
                                 pi_codubi IN VARCHAR2,
                                 pi_codzona IN VARCHAR2,
                                 pi_flg_adc IN NUMBER,
                                 pi_descripcion IN VARCHAR2,
                                 pi_servicio IN VARCHAR2,
                                 pi_estado IN VARCHAR2,
                                 pi_idzona IN NUMBER)
AS
BEGIN

 INSERT INTO OPERACION.sgat_importacion_masiva_det 
 (impcn_idcab, impdv_idplano, impdv_codubi, impdv_codzona, impdn_flg_adc, impdv_descripcion, impdv_servicio, impdv_estado, impdn_idzona)
 VALUES (pi_idcab, pi_idplano, pi_codubi, pi_codzona, pi_flg_adc, pi_descripcion, pi_servicio, pi_estado, pi_idzona);

END;

  /**************************************************
  '* Nombre SP : SGASI_ZONA_ADC
  '* Proposito : Insert o Updata para las tablas operacion.zona_adc y marketing.vtatabgeoref
  '* Input: <pi_idcab>        - impcn_idcab de la tabla sgat_importacion_masiva_cab
  '* Input: <pi_tabla>        - indica sobre que tabla se va a realizar el insert o update
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 21/11/2018
  '* Fec Actualizacion : -
  *********************************************/
  PROCEDURE SGASI_ZONA_ADC_GEOREF  (pi_idcab IN NUMBER,
                                  pi_tabla IN VARCHAR2)
IS

ln_idzona number;
ln_find   number;

CURSOR c_det IS
    SELECT DISTINCT impdv_codzona, impdv_descripcion, impdv_servicio, impdv_estado, impdn_idzona
    FROM operacion.sgat_importacion_masiva_det
    WHERE impcn_idcab = pi_idcab;

CURSOR c_det_plano_zona IS
    SELECT DISTINCT impdv_idplano, impdv_codubi, impdv_codzona, impdn_flg_adc, impdv_descripcion
    FROM operacion.sgat_importacion_masiva_det
    WHERE impcn_idcab = pi_idcab;

BEGIN

  ln_idzona := 0;
  ln_find := 0;

  if pi_tabla = CV_TABLA_ZONA then
    FOR r IN c_det LOOP     
     
      r.impdv_codzona := substr(nvl(r.impdv_codzona,''),1,10);      

      select count(1) into ln_find from operacion.zona_adc
      where idzona = r.impdn_idzona;

      r.impdv_servicio := substr(nvl(r.impdv_servicio,''),1,3);
      r.impdv_descripcion := substr(nvl(r.impdv_descripcion,''),1,100);
      r.impdv_estado := substr(nvl(r.impdv_estado,'1'),1,1);

     if ln_find > 0 then         

       UPDATE operacion.zona_adc
       SET codzona = r.impdv_codzona, descripcion = r.impdv_descripcion, 
       servicio = r.impdv_servicio, estado = r.impdv_estado
       WHERE idzona = r.impdn_idzona;

     else

       INSERT INTO operacion.zona_adc (codzona, descripcion, servicio, estado)
       VALUES (r.impdv_codzona, r.impdv_descripcion, r.impdv_servicio, r.impdv_estado);

     end if;

   END LOOP;
 end if;

 if pi_tabla = CV_TABLA_PLANOZONA then

   FOR r IN c_det_plano_zona LOOP
     
     BEGIN
      SELECT idzona into ln_idzona FROM operacion.zona_adc 
      WHERE codzona = r.impdv_codzona;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
       ln_idzona := null;
      WHEN TOO_MANY_ROWS THEN
       ln_idzona := null;
      WHEN OTHERS THEN
       ln_idzona := null;
     END;

     select count(1) into ln_find from marketing.vtatabgeoref
     where idplano = r.impdv_idplano and codubi = r.impdv_codubi;

     if ln_find > 0 then
          --5.0 Se quita el campo estado del update
       UPDATE marketing.vtatabgeoref
             SET idzona = ln_idzona, flg_adc = r.impdn_flg_adc               
           WHERE idplano = r.impdv_idplano
             AND codubi = r.impdv_codubi;

     else

       if ln_idzona > 0 then

         INSERT INTO marketing.vtatabgeoref (idplano, codubi, idzona, flg_adc)
         VALUES (r.impdv_idplano, r.impdv_codubi, ln_idzona, r.impdn_flg_adc);

       end if;
     end if;

   END LOOP;

 end if;

END SGASI_ZONA_ADC_GEOREF;

  /**************************************************
  '* Nombre SP : SGASS_SGAT_IMPORT_CAB
  '* Proposito : Seleccionar datos de la tabla operacion.sgat_importacion_masiva_cab
  '* Input: <pi_idcab>        - impcn_idcab de la tabla sgat_importacion_masiva_cab
  '* Input: <pi_fecini>       - fecha de inicio
  '* Input: <pi_fecfin>       - fecha de fin
  '* Output: <po_cursor>      - cursor de salida
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 21/11/2018
  '* Fec Actualizacion : -
  ***********************************************/

  PROCEDURE sgass_sgat_import_cab(pi_idcab  IN NUMBER,
                                  pi_fecini IN VARCHAR2,
                                  pi_fecfin IN VARCHAR2,
                                  po_cursor OUT gc_salida) AS
  BEGIN
  
    OPEN po_cursor FOR
      SELECT impcn_idcab,
             impcv_root_file_name,
             impcv_tabla,
             impcv_observacion,
             impcv_estado,
             impcv_usercreation,
             impcd_fechacreate,
             impcv_usermodify,
             impcd_fechamodify
        FROM operacion.sgat_importacion_masiva_cab
       WHERE (impcn_idcab = pi_idcab OR pi_idcab IS NULL)
         AND to_char(impcd_fechacreate, 'YYYYMMDD') BETWEEN pi_fecini AND
             pi_fecfin;
  
  END sgass_sgat_import_cab;

  /**************************************************
  '* Nombre SP : SGASS_SGAT_IMPORT_CAB
  '* Proposito : Seleccionar datos de la tabla operacion.sgat_importacion_masiva_det
  '* Input: <pi_idcab>        - impcn_idcab de la tabla sgat_importacion_masiva_cab
  '* Output: <po_cursor>      - cursor de salida
  '* Creado por : Equipo de proyecto Equipo Claro Empresa
  '* Fec Creacion : 21/11/2018
  '* Fec Actualizacion : -
  ***********************************************/

  PROCEDURE SGASS_SGAT_IMPORT_DET  (pi_idcab IN NUMBER,                                   
                                  po_cursor OUT gc_salida)
AS
BEGIN

  OPEN po_cursor FOR 
    select impdn_idimport, impcn_idcab, impdv_idplano, impdv_codubi,
         impdv_codzona, impdn_flg_adc, impdv_descripcion, impdv_estado,
         impdv_servicio, impdv_usercreation, impdd_fechacreate,
         impdv_usermodify, impdd_fechamodify, impdn_idzona
    from operacion.sgat_importacion_masiva_det
    where impcn_idcab = pi_idcab;

END SGASS_SGAT_IMPORT_DET;

  /****************************************************************
  '* Nombre FN : SGAFUN_CODSRV_PTOADIC
  '* Proposito : Busca si el servicio enviado es el registrado en la
  '*             configuracion 'HFC CE Punto Adicional' y abreviacion 'PTOADIC'
  '* Input : <pi_codsrv>    - Codigo de Servicio
  '* Return: <LN_FIND>      - Cuenta 1 si lo encuentra y 0 si no
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 21/11/2018
  '* Fec Actualizacion :
  '****************************************************************/
  FUNCTION sgafun_codsrv_ptoadic(pi_codsrv IN VARCHAR2)
  
   RETURN INTEGER IS
    ln_find INTEGER;
  BEGIN
    ln_find := 0;
  
    SELECT COUNT(1)
      INTO ln_find
      FROM operacion.opedd o
     INNER JOIN operacion.tipopedd t
        ON o.tipopedd = t.tipopedd
       AND t.descripcion = 'HFC CE Punto Adicional'
       AND t.abrev = 'PTOADIC'
     WHERE o.codigon = to_number(pi_codsrv);
    RETURN ln_find;
  
  END;

  /****************************************************************
  '* Nombre FN : SGAFUN_TIPTRA_CODIGON
  '* Proposito : Busca dentro de la configuracion HFC CE Transacciones
  '*             Postventa el tipo de trabajo segun la abreviacion
  '* Input : <pi_abreviacion>  - Abreviacion
  '* Return: <LN_CODIGON>      - Devuelve el tipo de trabajo, si no se encuentra devuelve 0
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 21/11/2018
  '* Fec Actualizacion :
  '****************************************************************/
  FUNCTION sgafun_tiptra_codigon(pi_abreviacion IN VARCHAR2) RETURN INTEGER IS
    ln_codigon INTEGER;
  BEGIN
  
    BEGIN
      SELECT o.codigon
        INTO ln_codigon
        FROM operacion.opedd o
       INNER JOIN operacion.tipopedd t
          ON o.tipopedd = t.tipopedd
         AND t.descripcion = 'HFC CE Transacciones Postventa'
         AND t.abrev = 'CEHFCPOST'
       WHERE o.abreviacion = pi_abreviacion
      ;
    
    EXCEPTION
      WHEN no_data_found THEN
        ln_codigon := 0;
      WHEN OTHERS THEN
        ln_codigon := 0;
      
    END;
  
    RETURN ln_codigon;
  
  END;

--FIN 3.0

--INI v4.0
/****************************************************************
  '* Nombre FN : SGAFUN_GET_TASKPREDIAG
  '* Proposito : Busca dentro de la configuracion Tarea Prediagnotico
  '*             el tareadef de la tarea de prediagnostico
  '* Input : <pi_tarea>        - Tareadef a evaluar
  '* Return: <LN_CODIGON>      - Devuelve tareadef, si no se encuentra devuelve 0
  '* Creado por : Equipo de proyecto TOA
  '* Fec Creación : 28/11/2018
  '* Fec Actualizacion :
  '****************************************************************/
function SGAFUN_GET_TASKPREDIAG    (pi_tarea IN NUMBER)
RETURN INTEGER IS
    LN_CODIGON INTEGER;
BEGIN

  BEGIN
   select count(O.codigon) into LN_CODIGON from operacion.opedd o
   inner join operacion.tipopedd t on o.tipopedd = t.tipopedd
   and t.descripcion = 'Tarea Prediagnotico' and t.abrev = 'TASKPREDIAG'
   where O.codigon = pi_tarea;

 EXCEPTION
  WHEN NO_DATA_FOUND THEN
   LN_CODIGON := 0;
  WHEN OTHERS THEN
   LN_CODIGON := 0;

 END;

  RETURN LN_CODIGON;

END;

--FIN 4.0

END pkg_visita_sga_ce;
/