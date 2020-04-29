CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SGA_BSCS IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_SGA_BSCS
   PROPOSITO:    Paquete de objetos necesarios para la conexion del SGA - BSCS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/11/2015                    00
    2.0       08/02/2016  Carlos Terán     Karen Velezmoro   SD-596715 (Alineacion)
    3.0       01/04/2016                                     SD-642508 Cambio de Plan
    4.0       28/04/2016                                     SD-642508-1 Cambio de Plan II
    5.0       02/05/2016  Antonio Astete A.                  Proy-19003 Canje de Puntos
    6.0        01/07/2016             SGA_SD-767463 Se asignan bolsas en Janus de clientes anteriores
    7.0       07/12/2016  Servicio Fallas-HITSS         SD_1040408
    8.0       19/01/2017  Servicio Fallas-HITSS             Migración WIMAX a LTE
    9.0       10/02/2017  Servicio Fallas-HITSS             INC000000703168
    10.0      07/04/2017  Juan Olivares                     PROY-28711 Mejorar la atención del proceso de mtto de los servicios HFC
    11.0      18/04/2017  Servicio Fallas-HITSS             INC000000677720
    12.0      04/07/2017  Juan Gonzales   Alfredo Yi        PROY-27792 - Cobro OCC punto Adicional
    13.0      08/08/2017  Servicio Fallas-HITSS             INC000000856062
    14.0      25/08/2017  Juan Gonzales   Alfredo Yi        PROY-27792 - Puero IP
    15.0      27/10/2017                  Alfredo Yi
    16.0      11/01/2018  Luis Flores     Jose Meza         PROY-27792.INC000001040503
    17.0      03/04/2018  Luis Flores     Luis Flores       Fallas de PostVenta HFC
    18.0      23/05/2019  Servicio Fallas-HITSS             INC000002064809
  *******************************************************************************************************/
  procedure p_desactiva_contrato_cplan(an_codsolot number,
                                       n_cod_id number,
                                       an_error out number,
                                       av_error out varchar2) is
  ln_status  varchar2(5);
  ln_contador number;
  ln_var number;
  error_general exception;
  an_coderror number;
  av_msgerror varchar2(4000);
  ln_flag  number;
  --Ini 5.0
  sga_customer_id number;
  sga_cod_id number;
  sga_cod_id_old number;
  ls_customer_id varchar2(10);
  ls_cod_id varchar2(10);
  ls_cod_id_old varchar2(10);
  li_cod_mens number;
  ls_mens varchar2(255);
  --Fin 5.0
  begin
    --validar estado de contrato
    select upper(ch_status)
      into ln_status
      from contract_history@dbl_bscs_bf c
     where c.co_id = n_cod_id
       and c.ch_seqno =
           (select max(ch_seqno) from contract_history@dbl_bscs_bf where co_id = c.co_id)
     group by ch_status, ch_pending;

    if ln_status <> 'D' then

      select to_number(c.valor) into ln_flag
      from constante c where c.constante = 'REGUREQUESTCOID';

      if ln_flag = 1 then
        p_libera_request_co_id(n_cod_id,an_coderror,av_msgerror);
      end if;

      --actualizar en la provision
      select count(1)
        into ln_contador
        from tim.pf_hfc_prov_bscs@dbl_bscs_bf
       where co_id = n_cod_id;

      if ln_contador > 0 then
        update tim.pf_hfc_prov_bscs@dbl_bscs_bf
           set estado_prv    = 5,
               fecha_rpt_eai = sysdate - 5 / 3600,
               errcode       = 0,
               errmsg        = 'Operation Success'
         where co_id = n_cod_id;
      end if;

      -- actualizar en la mdsrrtab
      select count(1) into ln_contador from mdsrrtab@dbl_bscs_bf where co_id = n_cod_id;

      if ln_contador > 0 then
        update mdsrrtab@dbl_bscs_bf set status = 15 where co_id = n_cod_id;
      end if;

      -- desactivar contrato
      tim.tim111_pkg_acciones_sga.sp_contr_desactiva@dbl_bscs_bf(n_cod_id,
                                                                 29,
                                                                 'USRSGA',
                                                                 ln_var);

      tim.tim111_pkg_acciones_sga.sp_contr_des_prov_iw@dbl_bscs_bf(n_cod_id,
                                                                   an_error,
                                                                   av_error);

      if an_error < 0 then
        raise error_general;
      end if;

      --Ini 9.0
      tim.tim111_pkg_acciones_sga.sp_desactiva@dbl_bscs_bf(n_cod_id, an_error, av_error);

      if an_error < 0 then
        raise error_general;
      end if;

      if ln_flag = 1 then
        p_libera_request_co_id(n_cod_id, an_coderror, av_msgerror);
      end if;
      --Fin 9.0

     an_error := 1;
     av_error := 'Exito al enviar la Desactivacion del Contrato por Cambio de Plan';

     p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                n_cod_id,
                'Desactiva Contrato - Cambio Plan');
  --INI 15.0
   else
     an_error := 1;
     av_error := 'Exito: El contrato ya se encuentra Desactivo';

     p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                n_cod_id,
                'Desactiva Contrato - Cambio Plan');
    --FIN 15.0
   end if;
   --Ini 5.0
   select customer_id,cod_id, cod_id_old
   into sga_customer_id,sga_cod_id, sga_cod_id_old
   from solot
   where codsolot=an_codsolot;

   SELECT TO_CHAR(sga_customer_id) into ls_customer_id FROM dual;
   SELECT TO_CHAR(sga_cod_id) into ls_cod_id FROM dual;
   SELECT TO_CHAR(sga_cod_id_old) into ls_cod_id_old FROM dual;

   TIM.TIM124_BONUS.CCLUBSI_CAMBPLAN_CLIHFC@dbl_bscs_bf(ls_customer_id,ls_cod_id,ls_cod_id_old,sysdate,li_cod_mens,ls_mens);
   --Fin 5.0
  exception
    when error_general then
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                n_cod_id,
                'Desactiva Contrato - Cambio Plan');
    when others then
      an_error := sqlcode;
      av_error := 'ERROR al enviar la Desactivacion del Contrato por Cambio de Plan - ' || sqlcode || ' ' || sqlerrm || ' - Linea (' ||
                            dbms_utility.format_error_backtrace || ')' ;

      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                n_cod_id,
                'Desactiva Contrato - Cambio Plan');
  end p_desactiva_contrato_cplan;

  procedure p_job_ws_baja_bscs is

    cursor c_tarea is
        select f.codsolot, tw.idtareawf, tw.mottarchg
        from solot s, wf f, tareawf tw
        where s.codsolot = f.codsolot
        and f.idwf = tw.idwf
        and f.valido = 1
        and tw.tareadef  in (select o.codigon from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                              and o.abreviacion = 'BAJA'
                              and t.abrev = 'TAREADEF_SRB'
                              and o.codigon_aux = 1) -- 2.0
        and tw.esttarea = 1;

    ln_coderror number;
    lv_msgerror varchar2(4000);
    cn_estcerrado constant number := 4;

  begin
     for c_t in c_tarea loop

       operacion.pq_sga_iw.p_envia_ws_desactiva_baja(c_t.codsolot, ln_coderror, lv_msgerror);

       if ln_coderror > 0 then
         PQ_WF.P_CHG_STATUS_TAREAWF(c_t.idtareawf,cn_estcerrado, cn_estcerrado, c_t.mottarchg,sysdate,sysdate);
       end if;
     end loop;
  end;

  /*INICIO - p_job_sus_sol_bscs*/
  procedure p_job_sus_sol_bscs is

  l_idtareawf       VARCHAR(50);
  l_idtareawf_param tareawf.idtareawf%TYPE;

  cursor c_tarea is
    select s.cod_id,
             tw.idtareawf,
             tw.mottarchg,
             f.idwf,
             tw.tarea,
             tw.tareadef
        from solot s, wf f, tareawf tw
       where s.codsolot = f.codsolot
         and f.idwf = tw.idwf
         and f.valido = 1
         and tw.tareadef in (select o.codigon
                               from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                                and o.abreviacion = 'SUSPENSION'
                                and t.abrev = 'TAREADEF_SRB'
                                and o.codigon_aux = 1) --2.0
         and tw.esttarea = 1;
              
  v_val         number;
  cn_estcerrado constant number := 4; 
  
  --  variables 2.0
  lv_destino varchar2(4000) := get_email_envio_sol_bscs();
  lv_cuerpo  opewf.cola_send_mail_job.cuerpo%TYPE;  
  TYPE tb_job_sus_sol_bscs IS TABLE OF c_tarea%ROWTYPE INDEX BY PLS_INTEGER; 
  l_tb_job_sus_sol_bscs         tb_job_sus_sol_bscs;  
  ltb_typ_reg_transaccion_sga   typ_reg_transaccion_sga;  
  ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA;  
  limit_in  NUMBER := 1000;  
  ln_cntrec NUMBER := 0;  
  ln_cnterr NUMBER := 0;  
  ln_cntok  NUMBER := 0; 
  le_mail EXCEPTION;  
  ln_coderror NUMBER;  
  lv_msgerror VARCHAR2(4000);   
  le_pq EXCEPTION;  

BEGIN

  --agregar tabla de estados de los limites
    SELECT d.codigon
      INTO limit_in
      FROM tipopedd c, opedd d
     WHERE c.tipopedd = d.tipopedd
       AND c.abrev    = 'PRC_HFC_BULKCOLLECT_LIMIT'
       AND d.abreviacion = 'p_job_sus_sol_bscs';  
 
  OPEN c_tarea;
  LOOP
    FETCH c_tarea BULK COLLECT 
     INTO l_tb_job_sus_sol_bscs LIMIT limit_in;
  
    -- Ejecutar la lógica del negocio
    FOR c_t IN 1 .. l_tb_job_sus_sol_bscs.COUNT LOOP
      BEGIN
        
      ln_cntrec := ln_cntrec + 1;
    
      v_val := 0;
    
      operacion.pq_sga_iw.p_genera_corte_suspension(l_tb_job_sus_sol_bscs(c_t).idtareawf,
                                                    l_tb_job_sus_sol_bscs(c_t).idwf,
                                                    l_tb_job_sus_sol_bscs(c_t).tarea,
                                                    l_tb_job_sus_sol_bscs(c_t).tareadef);
    
      operacion.pq_sga_iw.p_actualiza_contrato_sp(l_tb_job_sus_sol_bscs(c_t).idtareawf,
                                                  l_tb_job_sus_sol_bscs(c_t).idwf,
                                                  l_tb_job_sus_sol_bscs(c_t).tarea,
                                                  l_tb_job_sus_sol_bscs(c_t).tareadef);
                        
      IF ln_coderror <> 0 THEN 
        RAISE le_pq;
      END IF;                                         
      v_val := 1; -- 2.0
    
      IF v_val > 0 THEN
        operacion.pq_sga_iw.p_genera_corte_suspension(l_tb_job_sus_sol_bscs(c_t).idtareawf,
                                                      l_tb_job_sus_sol_bscs(c_t).idwf,
                                                      l_tb_job_sus_sol_bscs(c_t).tarea,
                                                      l_tb_job_sus_sol_bscs(c_t).tareadef);
      
        operacion.pq_sga_iw.p_actualiza_contrato_sp(l_tb_job_sus_sol_bscs(c_t).idtareawf,
                                                    l_tb_job_sus_sol_bscs(c_t).idwf,
                                                    l_tb_job_sus_sol_bscs(c_t).tarea,
                                                    l_tb_job_sus_sol_bscs(c_t).tareadef);
                        
        IF ln_coderror <> 0 THEN 
          RAISE le_pq;
        END IF;           
      END IF;
       
      ln_cntok := ln_cntok + 1; 
           
      EXCEPTION 
        WHEN le_pq THEN
          ln_cnterr := ln_cnterr + 1;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).idtareawf   := l_tb_job_sus_sol_bscs(c_t).idtareawf;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := 'pq_sga_bscs.p_job_sus_sol_bscs_opt : ' ||
                                                                  ln_coderror || '- ' ||
                                                                  lv_msgerror;         

        WHEN OTHERS THEN        
          ln_cnterr := ln_cnterr + 1;
          l_idtareawf_param  := l_tb_job_sus_sol_bscs(c_t).idtareawf;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).idtareawf   := l_tb_job_sus_sol_bscs(c_t).idtareawf;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := 'pq_sga_bscs.p_job_sus_sol_bscs_opt : ' ||
                                                                  sqlcode || '- ' ||
                                                                  sqlerrm;
          
          l_idtareawf := l_idtareawf_param ||'-'|| l_idtareawf ;
                                                                                                                              
      END;
              
    END LOOP;
  
    EXIT WHEN c_tarea%notfound;
  
  END LOOP;

  CLOSE c_tarea; 

  -- Insertar el LOG 
  ltb_typ_reg_transaccion_sga(1).proceso_descripcion   := 'Solicita Suspension BSCS-SIAC';
  ltb_typ_reg_transaccion_sga(1).procedure_descripcion := 'p_job_sus_sol_bscs_opt';
  ltb_typ_reg_transaccion_sga(1).cantidad_registros    := ln_cntrec;
  ltb_typ_reg_transaccion_sga(1).registros_correctos   := ln_cntok;
  ltb_typ_reg_transaccion_sga(1).registros_incorrectos := ln_cnterr;

  operacion.pq_sga_bscs.p_reg_log_sga( ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

  IF ltb_typ_reg_transaccion_sga(1).registros_incorrectos > 0 THEN
    RAISE le_mail;
  END IF;

EXCEPTION 
  
  WHEN le_mail THEN
    
    lv_cuerpo := 'Se encontraron errores en la ejecucion del procedimiento ' || $$plsql_unit || chr(13) ||
                 '.p_job_sus_sol_bscs' || chr(13) ||
                 ' --------------------------------------------------------' || chr(13) || 
                 ' Idtareawf errados        : ' || l_idtareawf || chr(13) ||
                 ' Registros Procesados     : ' || ln_cntrec   || chr(13) ||
                 ' Registros sin errores    : ' || ln_cntok    || chr(13) ||
                 ' Registros con errores    : ' || ln_cnterr   || chr(13);

    PRODUCCION.P_ENVIA_CORREO_DE_TEXTO_ATT('Solicita Suspension BSCS-SIAC',
                                           lv_destino,
                                           lv_cuerpo);
                                        
  WHEN OTHERS THEN
    ROLLBACK;
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion   := 'Solicita Suspension BSCS-SIAC';
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := 'p_job_sus_sol_bscs_opt';
    operacion.pq_sga_bscs.p_reg_log_sga( ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);
    
END;
  /*FIN - p_job_sus_sol_bscs*/

  /*INICIO - p_job_rec_sol_bscs*/
  procedure p_job_rec_sol_bscs is

  l_idtareawf       VARCHAR(50);
  l_idtareawf_param tareawf.idtareawf%TYPE;

  cursor c_tarea is
      select s.cod_id, tw.idtareawf, tw.mottarchg, f.idwf, tw.tarea, tw.tareadef
      from solot s, wf f, tareawf tw
      where s.codsolot = f.codsolot
      and f.idwf       = tw.idwf
      and f.valido     = 1
      and tw.tareadef in (select o.codigon from tipopedd t, opedd o
                            where t.tipopedd = o.tipopedd
                            and o.abreviacion = 'RECONEXION'
                            and t.abrev = 'TAREADEF_SRB'
                            and o.codigon_aux = 1) -- 2.0
      and tw.esttarea = 1;

    v_val             number;
    cn_estcerrado     constant number := 4;
    p_tickler_code    varchar2(10); -- 2.0
    ln_existe_bloqueo number; -- 2.0
    v_customer_id     number; -- 2.0
    v_tickler_number  number; -- 2.0

  --  variables 2.0
  lv_destino varchar2(1500) := get_email_envio_sol_bscs();
  lv_cuerpo  opewf.cola_send_mail_job.cuerpo%TYPE;  
  TYPE tb_job_sus_sol_bscs IS TABLE OF c_tarea%ROWTYPE INDEX BY PLS_INTEGER; 
  l_tb_job_rec_sol_bscs         tb_job_sus_sol_bscs;  
  ltb_typ_reg_transaccion_sga   typ_reg_transaccion_sga;  
  ltb_typ_LOG_ERROR_TRANSAC_SGA typ_LOG_ERROR_TRANSACCION_SGA;  
  limit_in  NUMBER := 1000;  
  ln_cntrec NUMBER := 0;  
  ln_cnterr NUMBER := 0;  
  ln_cntok  NUMBER := 0; 
  le_mail EXCEPTION;  
  ln_coderror NUMBER;  
  lv_msgerror VARCHAR2(4000);   
  le_pq EXCEPTION;  
  
  begin
    --agregar tabla de estados de los limites
     SELECT d.codigon
       INTO limit_in
       FROM tipopedd c, opedd d
       WHERE c.tipopedd = d.tipopedd
         AND c.abrev    = 'PRC_HFC_BULKCOLLECT_LIMIT'
         AND d.abreviacion = 'p_job_rec_sol_bscs'; 

    select c.valor into p_tickler_code
    from constante c where c.constante = 'TICKLERCODEAPC'; -- 2.0   BLOQ_APC

    /*for c in c_tarea loop
     BEGIN*/
     OPEN c_tarea;
          LOOP
          FETCH c_tarea BULK COLLECT INTO l_tb_job_rec_sol_bscs LIMIT limit_in;
  
    -- Ejecutar la lógica del negocio
    FOR c_t IN 1 .. l_tb_job_rec_sol_bscs.COUNT LOOP
    BEGIN
   
      ln_cntrec := ln_cntrec + 1; 
      v_val := 0;
      
       /*ln_existe_bloqueo := operacion.pq_sga_iw.f_val_ticklerrecord_siac_open(c.cod_id, p_tickler_code); -- 2.0

       if ln_existe_bloqueo = 1 then  -- Ini 2.0
         SELECT tr.customer_id, tr.tickler_number INTO v_customer_id, v_tickler_number
           FROM SYSADM.tickler_records@dbl_bscs_bf tr
          WHERE tr.co_id = c.cod_id
            AND tr.tickler_code = p_tickler_code AND tr.tickler_status = 'OPEN';

          operacion.pq_sga_iw.p_genera_reconexion(c.idtareawf, c.idwf, c.tarea, c.tareadef);
*/        
        ln_existe_bloqueo := operacion.pq_sga_iw.f_val_ticklerrecord_siac_open(l_tb_job_rec_sol_bscs(c_t).cod_id,
                                                                               p_tickler_code); 
        IF ln_existe_bloqueo = 1 THEN 
        
          SELECT tr.customer_id, tr.tickler_number
            INTO v_customer_id, v_tickler_number
            FROM SYSADM.tickler_records@dbl_bscs_bf tr
           WHERE tr.co_id        = l_tb_job_rec_sol_bscs(c_t).cod_id
             AND tr.tickler_code = p_tickler_code
             AND tr.tickler_status = 'OPEN';
        
          OPERACION.PQ_SGA_IW.P_GENERA_RECONEXION(l_tb_job_rec_sol_bscs(c_t).idtareawf,
                                                  l_tb_job_rec_sol_bscs(c_t).idwf,
                                                  l_tb_job_rec_sol_bscs(c_t).tarea,
                                                  l_tb_job_rec_sol_bscs(c_t).tareadef);
        
          UPDATE tickler_records@dbl_bscs_bf tc
             SET tc.tickler_status = 'OPEN', tc.modified_by = null,
                 tc.closed_by = null, tc.closed_date = null, tc.modified_date = null
           WHERE tc.customer_id = v_customer_id and tc.tickler_number = v_tickler_number;

          /*operacion.pq_sga_iw.p_actualiza_contrato_rx(c.idtareawf, c.idwf, c.tarea, c.tareadef);
        end if; -- Fin 2.0*/
        
        OPERACION.PQ_SGA_IW.P_ACTUALIZA_CONTRATO_RX(l_tb_job_rec_sol_bscs(c_t).idtareawf,
                                                    l_tb_job_rec_sol_bscs(c_t).idwf,
                                                    l_tb_job_rec_sol_bscs(c_t).tarea,
                                                    l_tb_job_rec_sol_bscs(c_t).tareadef);
                                  
        IF ln_coderror <> 0 THEN -- 2.0
          RAISE le_pq;
        END IF;                                                            
                                
      END IF;
      
         v_val:=1;

         if v_val > 0 then
           /*PQ_WF.P_CHG_STATUS_TAREAWF(c.idtareawf, cn_estcerrado, cn_estcerrado, c.mottarchg, sysdate, sysdate);*/
            BEGIN -- 2.0
        
              PQ_WF.P_CHG_STATUS_TAREAWF(l_tb_job_rec_sol_bscs(c_t).idtareawf,
                                         cn_estcerrado,
                                         cn_estcerrado,
                                         l_tb_job_rec_sol_bscs(c_t).mottarchg,
                                         sysdate,
                                         sysdate);
            
              IF ln_coderror <> 0 THEN 
                RAISE le_pq;
              END IF;        
                     
            END; 
         end if;
       
       ln_cntok := ln_cntok + 1;  
           
      EXCEPTION 
        WHEN le_pq THEN
          ln_cnterr := ln_cnterr + 1;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).idtareawf   := l_tb_job_rec_sol_bscs(c_t).idtareawf;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := 'pq_sga_bscs.p_job_rec_sol_bscs_opt : ' ||
                                                                  ln_coderror || '- ' ||
                                                                  lv_msgerror;         
        WHEN OTHERS THEN        
          ln_cnterr := ln_cnterr + 1;
          l_idtareawf_param  := l_tb_job_rec_sol_bscs(c_t).idtareawf;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).idtareawf   := l_tb_job_rec_sol_bscs(c_t).idtareawf;
          ltb_typ_LOG_ERROR_TRANSAC_SGA(ln_cnterr).observacion := 'pq_sga_bscs.p_job_rec_sol_bscs_opt : ' ||
                                                                  sqlcode || '- ' ||
                                                                  sqlerrm;
          l_idtareawf := l_idtareawf_param ||'-'|| l_idtareawf ;
          END;
              
    END LOOP;
  
    EXIT WHEN c_tarea%notfound;
  
  END LOOP;

  CLOSE c_tarea; 

  -- Insertar el LOG 
  ltb_typ_reg_transaccion_sga(1).proceso_descripcion    := 'Solicita Reconexion BSCS-SIAC';
  ltb_typ_reg_transaccion_sga(1).procedure_descripcion  := 'p_job_rec_sol_bscs_opt';
  ltb_typ_reg_transaccion_sga(1).cantidad_registros     := ln_cntrec;
  ltb_typ_reg_transaccion_sga(1).registros_correctos    := ln_cntok;
  ltb_typ_reg_transaccion_sga(1).registros_incorrectos  := ln_cnterr;

  OPERACION.PQ_SGA_BSCS.P_REG_LOG_SGA(ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);

  IF ltb_typ_reg_transaccion_sga(1).registros_incorrectos > 0 THEN
    RAISE le_mail;
  END IF;

EXCEPTION 
  
  WHEN le_mail THEN
    lv_cuerpo := 'Se encontraron errores en la ejecucion del procedimiento ' || $$plsql_unit || chr(13) ||
                 '.p_job_rec_sol_bscs' || chr(13) ||
                 ' --------------------------------------------------------' || chr(13) || 
                 ' Idtareawf errados        : ' || l_idtareawf || chr(13) ||
                 ' Registros Procesados     : ' || ln_cntrec   || chr(13) ||
                 ' Registros sin errores    : ' || ln_cntok    || chr(13) ||
                 ' Registros con errores    : ' || ln_cnterr   || chr(13);
    PRODUCCION.P_ENVIA_CORREO_DE_TEXTO_ATT('Solicita Reconexion BSCS-SIAC',
                                           lv_destino,
                                           lv_cuerpo);
                                           
  WHEN OTHERS THEN
    ROLLBACK;
    ltb_typ_reg_transaccion_sga(1).proceso_descripcion   := 'Solicita Reconexion BSCS-SIAC';
    ltb_typ_reg_transaccion_sga(1).procedure_descripcion := 'p_job_rec_sol_bscs_opt';
    OPERACION.PQ_SGA_BSCS.P_REG_LOG_SGA( ltb_typ_reg_transaccion_sga, ltb_typ_LOG_ERROR_TRANSAC_SGA);
    
END;

/*FIN - p_job_rec_sol_bscs*/

 /*INICIO - p_reg_log_sga*/
 PROCEDURE p_reg_log_sga( atyp_reg_transaccion_sga typ_reg_transaccion_sga, atyp_LOG_ERROR_TRANSACCION_SGA typ_LOG_ERROR_TRANSACCION_SGA ) IS
    ln_idlog NUMBER := 1;

    BEGIN
      SELECT OPERACION.SQ_REG_TRANSACCION_SGA.NEXTVAL
        INTO ln_idlog
        FROM DUAL;

      INSERT INTO OPERACION.REG_TRANSACCION_SGA( IDLOG, PROCESO_DESCRIPCION, PROCEDURE_DESCRIPCION, CANTIDAD_REGISTROS, REGISTROS_CORRECTOS, registros_incorrectos )
           VALUES ( ln_idlog, atyp_reg_transaccion_sga(1).proceso_descripcion , atyp_reg_transaccion_sga(1).procedure_descripcion, atyp_reg_transaccion_sga(1).CANTIDAD_REGISTROS,
                    atyp_reg_transaccion_sga(1).REGISTROS_CORRECTOS, atyp_reg_transaccion_sga(1).REGISTROS_INCORRECTOS);

      FOR c_t IN 1 .. atyp_LOG_ERROR_TRANSACCION_SGA.COUNT LOOP
        INSERT INTO HISTORICO.LOG_ERROR_TRANSACCION_SGA ( IDLOG, IDLOGCAB, codsolot, co_id, customer_id, observacion)
             VALUES ( OPERACION.SQ_LOG_ERROR_TRANSAC_SGA.NEXTVAL, ln_idlog, atyp_LOG_ERROR_TRANSACCION_SGA(c_t).codsolot,
                      atyp_LOG_ERROR_TRANSACCION_SGA(c_t).co_id, atyp_LOG_ERROR_TRANSACCION_SGA(c_t).customer_id,
                      atyp_LOG_ERROR_TRANSACCION_SGA(c_t).observacion);
      END LOOP;

      COMMIT;

  END;
 /*FIN - p_reg_log_sga*/
 
 /*INICIO - get_email_envio_sol_bscs*/
 FUNCTION get_email_envio_sol_bscs RETURN opedd.descripcion%TYPE IS
    l_correo opedd.descripcion%TYPE;

  BEGIN
    SELECT b.descripcion
      INTO l_correo
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_PQ_SGA'
       AND b.abreviacion = 'BSCS_CORREO_SOL_BSCS';

    RETURN l_correo;
  END;
 /*FIN - get_email_envio_sol_bscs*/
 
  procedure p_reg_log(ac_codcli      operacion.solot.codcli%type,
            an_customer_id number,
            an_idtrs       number,
            an_codsolot    number,
            an_idinterface number,
            an_error       number,
            av_texto       varchar2,
            an_cod_id      number default 0,
            av_proceso     varchar default '') is
    pragma autonomous_transaction;
  begin

    insert into operacion.log_trs_interface_iw
      (codcli,
       idtrs,
       codsolot,
       idinterface,
       error,
       texto,
       customer_id,
       cod_id,
       proceso)
    values
      (ac_codcli,
       an_idtrs,
       an_codsolot,
       an_idinterface,
       an_error,
       av_texto,
       an_customer_id,
       an_cod_id,
       av_proceso);
    commit;

  end p_reg_log;

  procedure p_consulta_motivoxtiptra(an_tiptra in number, srv_cur out sys_refcursor) is

  ln_count number;

  begin

    select count(distinct o.codigon_aux) into ln_count
        from tipopedd t, opedd o
       where t.tipopedd = o.tipopedd
         and t.abrev = 'TIPTRABAJASIACMOTOT'
         and o.codigon_aux = an_tiptra;

    if ln_count > 0 then

      open srv_cur for
        select m.codmotot codmotot, m.descripcion motivo
          from tipopedd t, opedd o, motot m
         where t.tipopedd = o.tipopedd
           and t.abrev = 'TIPTRABAJASIACMOTOT'
           and m.codmotot = o.codigon
           and o.codigon_aux = an_tiptra
        order by m.descripcion;

    else
      open srv_cur for
          select codmotot, descripcion motivo
            from operacion.motot
           WHERE DESCRIPCION LIKE 'HFC%'
        OR DESCRIPCION LIKE '%INT -%'
        OR DESCRIPCION LIKE '%TEL -%'
        OR DESCRIPCION LIKE '%CATV -%'
      ORDER BY DESCRIPCION;
    end if;

  end p_consulta_motivoxtiptra;

  PROCEDURE P_BAJA_DECO_STB (L_CLIENTE IN VARCHAR2,--CUSTOMER_ID
                              L_IDPRODUCTO IN NUMBER,
                              L_IDVENTA IN NUMBER, --SIEMPRE ES 0
                              L_SOT IN NUMBER,
                              L_SID IN NUMBER,--codinssrv / co_id
                              L_ENVIO IN NUMBER, --DEFAULT 1
                              L_ERROR OUT NUMBER,
                              L_MENSAJE OUT VARCHAR2
                            ) IS

         c_1 l_sald;
         C_2 l_sald;
         L_ERR NUMBER;
         L_MENS VARCHAR2(500);
         L_ACTVCODE VARCHAR2(20);--activationcode,
         L_SERIAL VARCHAR2(40);--serialnumber,
         L_DEFCONFIG VARCHAR2(40);--DEFAULTCONFIGIDCRM,
         L_TYPECRM VARCHAR2(40);--STBTYPECRMID,
         L_DISABLE NUMBER;--disabled,
         L_PRODUCTCRM VARCHAR2(40);--PRODUCTCRMID,
         L_CHANNELM VARCHAR2(40);--channelmapcrmid

         L_ERRVOD NUMBER;
         L_MENSVOD VARCHAR2(500);
         L_IDPRODUCTOVOD NUMBER;
         L_IDVENTAVOD NUMBER;
         L_PROFILECRMIDVOD VARCHAR2(40);
         X_VOD NUMBER;
         Y_VOD VARCHAR2(500);
         Z_VOD VARCHAR2(500);
         L_CENTVOD NUMBER;

         X VARCHAR2(1000);
         Y VARCHAR2(1000);
         Z NUMBER;

       BEGIN

           L_CENTVOD := 0;
           L_ERRVOD := NULL;

          INTRAWAY.PQ_MIGRACENTRAL.P_TRAESTB(L_CLIENTE,
                                             L_IDPRODUCTO,
                                             L_IDVENTA,
                                             L_ERR,
                                             L_MENS,
                                             c_1
                                            );

          IF L_ERR > 0 THEN
              LOOP
                FETCH C_1 INTO L_ACTVCODE,L_SERIAL,L_DEFCONFIG,L_TYPECRM,L_DISABLE,L_PRODUCTCRM,L_CHANNELM;
                 EXIT WHEN C_1%NOTFOUND;
                 IF L_SERIAL IS NOT NULL THEN --ACTIVO (CON EQUIPO)
                    IF L_DEFCONFIG NOT IN('VES_DSP') THEN --DISTINTO A ONPLANT
                   --  baja VOD
                       L_CENTVOD := 0;
                       INTRAWAY.PQ_CONSULTAITW.P_INT_EXTRAEVOD(L_SERIAL,L_ERRVOD, L_MENSVOD,C_2);
                        IF L_ERRVOD = 0 THEN
                          FETCH C_2 INTO L_IDPRODUCTOVOD,L_IDVENTAVOD,L_PROFILECRMIDVOD;
                            EXIT WHEN C_2%NOTFOUND;
                             INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_CREAVOD(0,L_CLIENTE,L_IDPRODUCTOVOD,L_IDPRODUCTOVOD,L_IDPRODUCTO,L_PROFILECRMIDVOD,4,
                                                                    L_SOT,L_SID,L_ENVIO,L_IDVENTAVOD,L_IDVENTA,X_VOD,Y_VOD,Z_VOD);

                             IF X_VOD = 1 THEN
                               L_CENTVOD := L_CENTVOD + 0;
                             ELSE
                               L_CENTVOD := L_CENTVOD + 1;
                               L_ERRVOD := Y_VOD||' | '||L_ERRVOD;
                             END IF;
                        END IF;

                        IF L_CENTVOD = 0 THEN
                           Z := 0;
                           IF L_DISABLE = 0 THEN
                             INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_CREASTB(4,
                                                                    L_CLIENTE,
                                                                    L_IDPRODUCTO,
                                                                    L_IDPRODUCTO,
                                                                    L_ACTVCODE,
                                                                    L_PRODUCTCRM,
                                                                    L_CHANNELM,
                                                                    L_DEFCONFIG,
                                                                    'TRUE',
                                                                    4,
                                                                    L_SOT,
                                                                    L_SID,
                                                                    X,
                                                                    Y,
                                                                    Z,
                                                                    L_ENVIO,
                                                                    L_IDVENTA
                                                                    );
                          END IF;

                          IF Z = 0 THEN
                               INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_CREASTB(2,
                                                                      L_CLIENTE,
                                                                      L_IDPRODUCTO,
                                                                      L_IDPRODUCTO,
                                                                      L_ACTVCODE,
                                                                      L_PRODUCTCRM,
                                                                      L_CHANNELM,
                                                                      'VES_DSP',
                                                                      'TRUE',
                                                                      4,
                                                                      L_SOT,
                                                                      L_SID,
                                                                      X,
                                                                      Y,
                                                                      Z,
                                                                      L_ENVIO,
                                                                      L_IDVENTA
                                                                     );
                              IF Z = 0 THEN
                                  INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_CREASTB(0,
                                                                         L_CLIENTE,
                                                                         L_IDPRODUCTO,
                                                                         L_IDPRODUCTO,
                                                                         L_ACTVCODE,
                                                                         L_PRODUCTCRM,
                                                                         L_CHANNELM,
                                                                         'VES_DSP',
                                                                         'FALSE',
                                                                         4,
                                                                         L_SOT,
                                                                         L_SID,
                                                                         X,
                                                                         Y,
                                                                         Z,
                                                                         L_ENVIO,
                                                                         L_IDVENTA
                                                                        );
                                   IF Z = 0 THEN
                                     L_ERROR := 1;
                                     L_MENSAJE := 'BAJA EFECTUADA '||X||'-'||Y;
                                   ELSE
                                     L_ERROR := 0;
                                     L_MENSAJE := 'ERROR PARA ELIMINAR LA RESERVA'||X||'-'||Y;
                                   END IF;

                              ELSE
                                 L_ERROR := 0;
                                 L_MENSAJE := 'ERROR CON EL CAMBIO A OFFPLANT '||X||'-'||Y;
                              END IF;


                          ELSE
                            L_ERROR := 0;
                            L_MENSAJE := 'ERROR CON LA DESACTIVACIÿN DEL STB '||X||'-'||Y;
                          END IF;


                        ELSE
                          L_ERROR := 0;
                          L_MENSAJE := 'ERROR CON LA BAJA DEL VOD '||L_ERRVOD;
                        END IF;

                    ELSE
                      L_ERROR := 0;
                      L_MENSAJE := 'EL SERVICIO SE ENCUENTRA EN OFFPLANT(VES_DSP), NO ES FACTIBLE EFECTUAR LA DESINSTALACIÿN DEL SERVICIO';
                    END IF;
                 ELSE
                   --BAJA DE VOD
                     L_CENTVOD := 0;
                    INTRAWAY.PQ_CONSULTAITW.P_INT_EXTRAEVOD(L_SERIAL,L_ERRVOD, L_MENSVOD,C_2);
                        IF L_ERRVOD = 0 THEN
                          FETCH C_2 INTO L_IDPRODUCTOVOD,L_IDVENTAVOD,L_PROFILECRMIDVOD;
                            EXIT WHEN C_2%NOTFOUND;
                             INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_CREAVOD(0,L_CLIENTE,L_IDPRODUCTOVOD,L_IDPRODUCTOVOD,L_IDPRODUCTO,L_PROFILECRMIDVOD,4,
                                                                    L_SOT,L_SID,L_ENVIO,L_IDVENTAVOD,L_IDVENTA,X_VOD,Y_VOD,Z_VOD);

                             IF X_VOD = 1 THEN
                               L_CENTVOD := L_CENTVOD + 0;
                             ELSE
                               L_CENTVOD := L_CENTVOD + 1;
                               L_ERRVOD := Y_VOD||' | '||L_ERRVOD;
                             END IF;
                        END IF;

                      IF L_CENTVOD = 0 THEN

                          INTRAWAY.PQ_CONT_HFCBSCS.P_CONT_CREASTB(0,
                                                                 L_CLIENTE,
                                                                 L_IDPRODUCTO,
                                                                 L_IDPRODUCTO,
                                                                 L_ACTVCODE,
                                                                 L_PRODUCTCRM,
                                                                 L_CHANNELM,
                                                                 L_DEFCONFIG,
                                                                 'FALSE',
                                                                 4,
                                                                 L_SOT,
                                                                 L_SID,
                                                                 X,
                                                                 Y,
                                                                 Z,
                                                                 L_ENVIO,
                                                                 L_IDVENTA
                                                                );

                        IF Z = 0 THEN
                           L_ERROR := 1;
                           L_MENSAJE := 'BAJA EFECTUADA '||X||'-'||Y;
                         ELSE
                           L_ERROR := 0;
                           L_MENSAJE := 'ERROR PARA ELIMINAR LA RESERVA'||X||'-'||Y;
                         END IF;
                      END IF;



                 END IF;
               END LOOP;
          ELSE
            L_ERROR := 0;
            L_MENSAJE := 'EL SERVICIO NO SE ENCUENTRA REGISTRADO EN INTRAWAY';
          END IF;
       END;

  Procedure p_baja_deco_bscs(n_cod_id    operacion.solot.cod_id%type,
                             n_codsolot  operacion.solot.codsolot%type,
                             n_idproducto number, --11.0
                             L_ERROR     OUT NUMBER,
                             L_MENSAJE   OUT VARCHAR2) is


  n_cont             number;
  ARR_AREGLO         TIM.PP021_VENTA_HFC.ARR_SERV_HFC2@DBL_BSCS_BF;
  n_resultado        number;
  v_mensaje          varchar2(2000);
  ln_customer_id number; --2.0

  CURSOR cur_srv(n_customer_id number) IS
   --Ini 11.0
   select distinct '|||||||||||||' || t.v_serialnumber || '|' || t.v_modelo || '|' ||
                   t.macaddress || '|' || 'FALSE' as nro_ctv,
                   t.id_producto,
                   tw.id_producto_padre,
                   tw.tip_interfase
     from intraway.servicio_activos_iw t,
          solotpto                     sp,
          insprd                       pid,
          operacion.trs_interface_iw   tw
    where t.customer_id = n_customer_id
      and t.id_producto = n_idproducto
      and t.v_servicio = 'CAB'
      and sp.codsolot = operacion.pq_sga_iw.f_max_sot_x_cod_id(n_cod_id)
      and sp.codinssrv = pid.codinssrv
      and pid.pid = tw.pidsga
      and tw.id_producto = t.id_producto;
   --Fin 11.0

  BEGIN

  select s.customer_id into ln_customer_id  from solot s where s.codsolot = n_codsolot; --2.0

  n_cont:=1;
    for c_s in cur_srv(ln_customer_id) loop -- 2.0

      ARR_AREGLO(n_cont).tipo_serv:=c_s.tip_interfase;
      ARR_AREGLO(n_cont).prod_id:=c_s.id_producto;
      ARR_AREGLO(n_cont).prod_id_padre:=c_s.id_producto_padre;
      ARR_AREGLO(n_cont).valores:=c_s.nro_ctv;
      n_cont:=n_cont+1;
    end loop;


   tim.tim111_pkg_acciones_sga.sp_baja_deco_adic@DBL_BSCS_BF(n_cod_id,
                                                             ARR_AREGLO,
                                                             n_resultado,
                                                             v_mensaje);
  END;

 -- Ini 2.0
 PROCEDURE P_REGULARIZA_SOT_BAJA(an_sot_baja operacion.solot.codsolot%TYPE,
                              an_error  OUT INTEGER,
                              av_error  OUT VARCHAR2) IS

  ln_punto NUMBER;
  lv_codcli operacion.solot.codcli%TYPE;
  le_regularizacion EXCEPTION;
  le_noexistealta EXCEPTION;
  lv_sot_alta operacion.solot.codsolot%TYPE;
  le_errordepuracion EXCEPTION;

  -- Identificar los codinssrv no incluidos en la SOT de Baja
  CURSOR c_1(an_sot_alta VARCHAR2, an_sot_baja VARCHAR2) IS
  SELECT DISTINCT i.codinssrv
        FROM solot a,
             solotpto b,
             inssrv i
     WHERE a.codsolot = b.codsolot
       AND b.codinssrv = i.codinssrv
       AND a.codsolot = an_sot_alta
       and i.estinssrv in (1,2)
       AND i.codinssrv NOT IN (SELECT i.codinssrv
                                FROM solot a,
                                     solotpto b,
                                     inssrv i
                                WHERE a.codsolot = b.codsolot
                                AND b.codinssrv = i.codinssrv
                                AND a.codsolot = an_sot_baja
                                GROUP BY i.codinssrv );

   -- Identificar el registro en la SOLOTPTO
  CURSOR c_2(an_sot_alta VARCHAR2, an_codinssrv NUMBER) IS
    SELECT b.codsolot, b.tiptrs, b.codsrvant, b.bwant, b.codsrvnue, b.bwnue, b.codusu, b.codinssrv, b.cid,
                    b.descripcion, b.direccion, b.tipo, b.estado, b.visible, b.puerta, b.pop, b.codubi, b.fecini, b.fecfin,
                    b.fecinisrv, b.feccom, b.tiptraef, b.tipotpto, b.efpto, b.pid, b.pid_old, b.cantidad, b.codpostal,
                    b.flgmt, b.codinssrv_tra, b.mediotx, b.provenlace, b.flg_agenda, b.cintillo, b.ncos_old, b.ncos_new,
                    b.idplataforma, b.idplano, b.codincidence, b.cell_id, b.segment_name
             FROM solot a,
                  solotpto b,
                  inssrv i
             WHERE a.codsolot = b.codsolot
             AND b.codinssrv = i.codinssrv
             AND a.codsolot = an_sot_alta
             AND i.codinssrv = an_codinssrv
             AND i.estinssrv IN (1,2)
             AND rownum = 1;

  BEGIN
     -- Eliminar los CODINSSRV repetivos y poner los PID en null
     P_DEPURA_SOT_BAJA (an_sot_baja, an_error, av_error );

     IF an_error = -1 THEN
       RAISE le_errordepuracion;
     END IF;

     an_error:=0;
     av_error:='OK';

     -- Obtener el cliente
     SELECT codcli
            INTO lv_codcli
            FROM OPERACION.SOLOT
            WHERE codsolot = an_sot_baja;

     lv_sot_alta := F_OBTENER_SOT_ALTA(lv_codcli, an_sot_baja  );

     IF lv_sot_alta IS NULL THEN
       RAISE le_noexistealta;
     END IF;

     -- Identificar el correlativo PUNTO
     SELECT NVL(MAX(punto), 0)
         INTO ln_punto
         FROM operacion.solotpto
         WHERE codsolot = an_sot_baja;

     FOR a IN c_1(lv_sot_alta, an_sot_baja) LOOP
      FOR s IN c_2(lv_sot_alta, a.codinssrv) LOOP
          s.codsolot := an_sot_baja;
          ln_punto:= ln_punto + 1;

          INSERT INTO operacion.solotpto
           ( codsolot, punto, tiptrs, codsrvant, bwant, codsrvnue, bwnue, codusu, codinssrv, cid,
             descripcion, direccion, tipo, estado, visible, puerta, pop, codubi, fecini, fecfin,
             fecinisrv, feccom, tiptraef, tipotpto, efpto, pid, pid_old, cantidad, codpostal,
             flgmt, codinssrv_tra, mediotx, provenlace, flg_agenda, cintillo, ncos_old, ncos_new,
             idplataforma, idplano, codincidence, cell_id, segment_name)
          VALUES
           ( s.codsolot, ln_punto, s.tiptrs, s.codsrvant, s.bwant, s.codsrvnue, s.bwnue, s.codusu, s.codinssrv, s.cid,
             s.descripcion, s.direccion, s.tipo, s.estado, s.visible, s.puerta, s.pop, s.codubi, s.fecini, s.fecfin,
             s.fecinisrv, s.feccom, s.tiptraef, s.tipotpto, s.efpto, null, s.pid_old, s.cantidad, s.codpostal,
             s.flgmt, s.codinssrv_tra, s.mediotx, s.provenlace, s.flg_agenda, s.cintillo, s.ncos_old, s.ncos_new,
             s.idplataforma, s.idplano, s.codincidence, s.cell_id, s.segment_name );

          IF SQL%ROWCOUNT = 0 THEN
             RAISE le_regularizacion;
          END IF;
       END LOOP;

  END LOOP;

  EXCEPTION
    WHEN le_errordepuracion THEN
      ROLLBACK;
    WHEN le_noexistealta THEN
       an_error := -1;
       av_error := $$plsql_unit || ': No se encontró la SOT de Alta' ;
       ROLLBACK;
    WHEN le_regularizacion THEN
       an_error := -1;
       av_error := $$plsql_unit || ': Ocurrio un error al regularizar reg. en la SOT de Baja: ' || sqlerrm;
       ROLLBACK;
    WHEN OTHERS THEN
       an_error := sqlcode;
       av_error := $$plsql_unit || ': ' || sqlerrm;
       ROLLBACK;

 END P_REGULARIZA_SOT_BAJA;

 PROCEDURE P_DEPURA_SOT_BAJA(an_sot_baja operacion.solot.codsolot%TYPE,
                              an_error  out integer,
                              av_error  out varchar2)IS
 le_depuracion EXCEPTION;

 BEGIN
       an_error:=0;
       av_error:='OK';

       DELETE FROM SOLOTPTO A
       WHERE ROWID > ( SELECT MIN(ROWID)
                          FROM SOLOTPTO B
                          WHERE B.CODSOLOT = A.CODSOLOT
                          AND B.CODINSSRV = A.CODINSSRV )
       AND A.CODSOLOT = an_sot_baja
       AND A.CODINSSRV IN ( SELECT C.CODINSSRV
                          FROM SOLOTPTO C
                          WHERE C.CODSOLOT = A.CODSOLOT
                          GROUP BY C.CODINSSRV
                          HAVING COUNT(*) > 1 );

      UPDATE operacion.solotpto
             SET pid = NULL
             WHERE codsolot =  an_sot_baja;

      EXCEPTION
        WHEN OTHERS THEN
         an_error := -1;
         av_error := $$plsql_unit || ': Ocurrio un error al eliminar reg. duplicados en la SOT de Baja: ' || sqlerrm;
         ROLLBACK;
 END;

 FUNCTION F_OBTENER_SOT_ALTA(av_codcli operacion.solot.codcli%TYPE, an_sot_baja operacion.solot.codsolot%TYPE) RETURN NUMBER IS
   lv_codsolot operacion.solot.codsolot%TYPE;
  BEGIN

  SELECT MAX(a.codsolot) codsolot
         INTO lv_codsolot
      FROM solot a,
           solotpto b,
           inssrv i,
           tiptrabajo t
   WHERE a.codsolot = b.codsolot
     AND b.codinssrv = i.codinssrv
     AND a.tiptra = t.tiptra
     AND a.codcli = av_codcli
     AND a.tiptra IN ( SELECT o.codigon
                       FROM operacion.opedd o,
                            operacion.tipopedd t
                       WHERE o.tipopedd = t.tipopedd
                       AND t.abrev     = 'SOT_ALTA_MIGRA')
     AND a.estsol IN (12, 29)
     AND t.tiptrs = 1
     AND i.estinssrv in (1,2)
     AND i.codinssrv IN ( SELECT i.codinssrv
                              FROM solot a,
                                   solotpto b,
                                   inssrv i
                              WHERE a.codsolot = b.codsolot
                              AND b.codinssrv = i.codinssrv
                              AND a.codsolot = an_sot_baja
                              GROUP BY i.codinssrv );
     RETURN lv_codsolot;
  END;

  function f_val_exis_sot_serv_adic(an_codinssrv in number,
                                   an_tiptra in number) return number is
 ln_count number;
 begin
   select count(ins.codinssrv) into ln_count
   from inssrv ins, solotpto pto, solot s
   where ins.codinssrv = pto.codinssrv
   and pto.codsolot = s.codsolot
   and s.tiptra = an_tiptra
   and ins.codinssrv = an_codinssrv
   and s.estsol in (select o.codigon
                    from tipopedd t, opedd o
                    where t.tipopedd = o.tipopedd
                    and t.abrev = 'CONFSERVADICIONAL'
                    and o.abreviacion = 'ESTSOL_SADIC');

  return ln_count;
 end;

 procedure p_genera_sot_cont_sga(an_tiptra       in solot.tiptra%type,
                                 an_codsolot     in solot.codsolot%type,
                                 an_tipo         in number,
                                 an_codinssrv    in inssrv.codinssrv%type,
                                 an_coderror     out number,
                                 av_msgerror     out varchar2,
                                 an_out_codsolot out solot.codsolot%type) is
   ln_customer_id  solot.customer_id%type;
   lv_codcli       solot.codcli%type;
   ln_cod_id       solot.cod_id%type;
   lv_tipsrv       solot.tipsrv%type;
   ln_areasol      solot.areasol%type;
   ln_out_codsolot solot.codsolot%type;

   le_error_sot  exception;
   le_existe_sot exception;
   ln_resultado  number;
   lc_mensaje    varchar2(2000);
   ln_puntos     number;
   lv_desctiptra tiptrabajo.descripcion%type;
   ln_wfdef      number;
   ln_codmotot   number;
   lv_obs        solot.observacion%type;

   ln_sid inssrv.codinssrv%type;
   le_error_codinsrv exception;
   ln_auto_wfdef number;
 begin

   ln_auto_wfdef := operacion.pq_sga_janus.f_get_constante_conf('FAUTO_WFIP_P25');

   select t.descripcion
     into lv_desctiptra
     from tiptrabajo t
    where t.tiptra = an_tiptra;
   select o.area into ln_areasol from usuarioope o where o.usuario = user;

   select s.customer_id, s.codcli, s.cod_id, s.tipsrv
     into ln_customer_id, lv_codcli, ln_cod_id, lv_tipsrv
     from solot s
    where s.codsolot = an_codsolot;

   ln_sid := an_codinssrv;

   if nvl(ln_sid, 0) = 0 then
     begin
       SELECT distinct d.codinssrv
         into ln_sid
         FROM solotpto b, inssrv d
        where d.codinssrv = b.codinssrv
          and d.tipsrv = '0006' -- INT
          and d.estinssrv = 1 -- Solo Activo
          and b.codsolot = an_codsolot;

     exception
       when others then
         raise le_error_codinsrv;
     end;
   end if;

   if f_val_exis_sot_serv_adic(ln_sid, an_tiptra) > 0 then
     raise le_existe_sot;
   end if;

   begin
     select o.codigon_aux
       into ln_codmotot
       from tipopedd t, opedd o, tiptrabajo tt
      where t.tipopedd = o.tipopedd
        and t.abrev = 'CONFSERVADICIONAL'
        and tt.tiptra = o.codigon
        and o.abreviacion = 'MOTOTXTIPTRASADIC'
        and o.codigon = an_tiptra;
   exception
     when others then
       select to_number(o.valor)
         into ln_codmotot
         from constante o
        where o.constante = 'MOTOTXTIPTRASAD';
   end;

   begin
     select t.descripcion || ' ( ' || t.abreviacion || ' )'
       into lv_obs
       from opedd t
      where t.tipopedd = 1435
        and t.codigon_aux = an_tiptra
        and t.codigon = an_tipo;
   exception
     when others then
       lv_obs := null;
   end;

   lv_obs := 'Generacion de SOT de ' || lv_desctiptra || ' - ' || lv_obs;

   p_insert_sot_cont_sga(lv_codcli,
                         an_tiptra,
                         lv_tipsrv,
                         ln_codmotot,
                         ln_areasol,
                         ln_customer_id,
                         ln_cod_id,
                         lv_obs,
                         ln_out_codsolot);

   p_insert_solotpto_cont_sga(ln_out_codsolot,
                              an_codsolot,
                              lv_codcli,
                              ln_sid,
                              an_tipo,
                              ln_resultado,
                              lc_mensaje,
                              ln_puntos);

   if ln_puntos = 0 then
     an_coderror := ln_resultado;
     av_msgerror := lc_mensaje;
     raise le_error_sot;
   end if;

   update solot s
      set s.feccom = sysdate
    where s.codsolot = ln_out_codsolot;

   pq_solot.p_chg_estado_solot(ln_out_codsolot, 11);

   if ln_auto_wfdef = 1 then
     ln_wfdef := cusbra.f_br_sel_wf(ln_out_codsolot);

     if ln_wfdef is not null then
       pq_solot.p_asig_wf(ln_out_codsolot, ln_wfdef);
     end if;
   end if;

   an_coderror     := 1;
   av_msgerror     := 'OK';
   an_out_codsolot := ln_out_codsolot;

 exception
   when le_existe_sot then
     an_coderror := -2;
     av_msgerror := 'No es posible generar la solicitud debido a que cuenta con una SOT en Ejecución';
   when le_error_codinsrv then
     an_coderror := -2;
     av_msgerror := 'ERROR: No se logro recuperar el SID de Internet Activo del SGA';
   when le_error_sot then
     an_coderror := -2;
     av_msgerror := 'ERROR: No se Inserto en el detalle de la SOT';
   when others then
     an_coderror := -1;
     av_msgerror := 'ERROR: ' || sqlerrm || ' - Linea (' ||
                    dbms_utility.format_error_backtrace || ')';
 end p_genera_sot_cont_sga;

 procedure p_insert_sot_cont_sga(v_codcli       in solot.codcli%type,
                                 v_tiptra       in solot.tiptra%type,
                                 v_tipsrv       in solot.tipsrv%type,
                                 v_motivo       in solot.codmotot%type,
                                 v_areasol      in solot.areasol%type,
                                 an_customer_id in solot.customer_id%type,
                                 an_cod_id      in solot.cod_id%type,
                                 av_observacion in solot.observacion%type,
                                 a_codsolot     out number) IS

 begin
   a_codsolot := F_GET_CLAVE_SOLOT();
    insert into solot(codsolot, codcli, estsol, tiptra, tipsrv, codmotot,
                      areasol, customer_id,cod_id, observacion)
    values(a_codsolot,v_codcli,10,v_tiptra,v_tipsrv,v_motivo,v_areasol,
                      an_customer_id, an_cod_id,av_observacion);
 end p_insert_sot_cont_sga;

  procedure p_insert_solotpto_cont_sga(an_codsolot     in solot.codsolot%type,
                                      an_codsolot_b    in solot.codsolot%type,
                                      av_codcli        in solot.codcli%type,
                                      an_codinssrv     in inssrv.codinssrv%type,
                                      av_ncos_new      in solotpto.ncos_new%type,
                                      an_resultado     out number,
                                      ac_mensaje       out varchar2,
                                      an_puntos        out number) is
    l_cont         number;

    cursor cur_detalle_sot is
      select distinct i.codsrv      codsrvnue,
                      i.bw          bwnue,
                      i.numero,
                      i.codinssrv,
                      i.cid,
                      i.descripcion,
                      i.direccion,
                      2             tipo,
                      1             estado,
                      1             visible,
                      i.codubi,
                      1             flgmt
        from inssrv i
        inner join solotpto s
          on i.codinssrv = s.codinssrv
       where i.codcli = av_codcli
         and s.codsolot = an_codsolot_b
         and i.codinssrv = an_codinssrv;

  begin
    l_cont := 0;
    for c_det in cur_detalle_sot loop

      l_cont := l_cont + 1;

      insert into solotpto
        (codsolot,
         punto,
         codsrvnue,
         bwnue,
         codinssrv,
         cid,
         descripcion,
         direccion,
         tipo,
         estado,
         visible,
         codubi,
         flgmt,
         ncos_new)
      values
        (an_codsolot,
         l_cont,
         c_det.codsrvnue,
         c_det.bwnue,
         c_det.codinssrv,
         c_det.cid,
         c_det.descripcion,
         c_det.direccion,
         c_det.tipo,
         c_det.estado,
         c_det.visible,
         c_det.codubi,
         c_det.flgmt,
         av_ncos_new);

    end loop;

    an_resultado := 1;
    ac_mensaje   := 'OK';
    an_puntos    := l_cont;

  exception
    when others then
      an_resultado := -1;
      ac_mensaje   := sqlerrm;
      an_puntos    := 0;
  end p_insert_solotpto_cont_sga;

  procedure p_alinea_reconexion_bscs is

  v_update_prog number;

  cursor cur1 is
         select a.SERVD_FECHAPROG, ch.co_id, upper(ch.ch_status) ch_status, upper(ch.ch_pending) ch_pending, ch.userlastmod, ch.request,
         (select count(1) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='OPEN'
                 and t.co_id=ch.co_id) tic_all,
         (select count(1) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='OPEN'
                 and t.tickler_code like '%COB' and t.co_id=a.co_id) tic_cob,
         (select count(1) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='OPEN'
                 and t.tickler_code like 'BLOQ_APC' and t.co_id=ch.co_id) tic_apc,
         (select count(1) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='OPEN'
                 and t.tickler_code like 'SUSP_APC' and t.co_id=ch.co_id) tic_susp,
         (select nvl(max(t.tickler_number),0) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='OPEN'
                 and t.tickler_code like 'BLOQ_APC' and t.co_id=ch.co_id) max_apc,
         (select nvl(max(t.tickler_number),0) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='OPEN'
                 and t.tickler_code like 'SUSP_APC' and t.co_id=ch.co_id) max_susp,
         (select nvl(max(t.tickler_number),0) from tickler_records@DBL_BSCS_BF t where t.tickler_code <> 'SYSTEM' and t.tickler_status='CLOSED'
                 and t.tickler_code like 'BLOQ_APC' and t.co_id=ch.co_id) max_apc_close,
         (select count(1)  from tim.pf_hfc_prov_bscs@DBL_BSCS_BF p where p.co_id =ch.co_id) prov_hfc,
         (select count(1)  from mdsrrtab@DBL_BSCS_BF m where m.co_id =ch.co_id and m.request=ch.request) mds_req,
         a.SERVC_ESTADO,a.SERVV_MEN_ERROR men,a.SERVV_COD_ERROR cod_err, a.SERVD_FECHA_REG
         from contract_history@DBL_BSCS_BF ch, USRACT.postt_servicioprog_fija@DBL_TIMEAI a
         where ch.co_id = a.co_id
         and a.servi_cod = 4
         --and a.servc_estado=1
         and ch.ch_seqno=(select max(cc.ch_seqno) from contract_history@DBL_BSCS_BF cc where cc.co_id=ch.co_id)
         and a.SERVD_FECHAPROG >= trunc(sysdate-1)
         ---and a.co_id in (11994439,10721780)
         and a.SERVD_FECHAPROG <= trunc (sysdate)
         order by a.SERVD_FECHAPROG;

  begin

    for c1 in cur1 loop

      v_update_prog:=0;

      if c1.ch_status = 'A' and c1.ch_pending is not null and c1.userlastmod = 'USRPVU' then

          if c1.tic_apc=0 and c1.tic_susp=0 then

            update tickler_records@DBL_BSCS_BF t set
            t.tickler_status ='OPEN', t.modified_by=null, t.modified_date=null, t.closed_by=null, t.closed_date=null
            where t.tickler_code='BLOQ_APC' and t.tickler_status ='CLOSED' and t.co_id=c1.co_id and t.tickler_number=c1.max_apc_close;
            commit;

            v_update_prog:=1;

         end if;

         if c1.tic_apc>0  and c1.tic_susp=0 then

            update tickler_records@DBL_BSCS_BF t set
            t.tickler_status ='CLOSED', t.modified_by='USRSIACP', t.modified_date=sysdate, t.closed_by='USRSIACP', t.closed_date=sysdate
            where t.tickler_code='BLOQ_APC' and t.tickler_status ='OPEN' and t.co_id=c1.co_id
            and t.tickler_number <> c1.max_apc;
            commit;
            v_update_prog:=1;

         end if;

         if c1.tic_susp>0 then

          update tickler_records@DBL_BSCS_BF t set
          t.tickler_status ='CLOSED', t.modified_by='USRSIACP', t.modified_date=sysdate, t.closed_by='USRSIACP', t.closed_date=sysdate
          where t.tickler_code in ('BLOQ_APC', 'SUSP_APC') and t.tickler_status ='OPEN' and t.co_id=c1.co_id and t.tickler_number <> c1.max_susp;

          update tickler_records@DBL_BSCS_BF t set
          t.tickler_code='BLOQ_APC'
          where t.tickler_code='SUSP_APC' and t.tickler_status ='OPEN' and t.co_id=c1.co_id and t.tickler_number=c1.max_susp;
          commit;
          v_update_prog:=1;

         end if;

        if c1.mds_req=1 then
           contract.cancel_request@DBL_BSCS_BF(c1.request);
           update mdsrrtab@DBL_BSCS_BF set status = 9 where request = c1.request;
           commit;
        end if;

     end if;

     if c1.ch_status = 'S' and c1.ch_pending is null and c1.tic_all=0 and c1.max_apc_close<>0 then

          update tickler_records@DBL_BSCS_BF t set
          t.tickler_status ='OPEN', t.modified_by=null, t.modified_date=null, t.closed_by=null, t.closed_date=null
          where t.tickler_code='BLOQ_APC' and t.tickler_status ='CLOSED' and t.co_id=c1.co_id and t.tickler_number=c1.max_apc_close;
          commit;
          v_update_prog:=1;

     end if;

     if c1.ch_status = 'S' and c1.ch_pending is null and c1.tic_apc>0 and c1.tic_susp>0 and c1.max_susp<>0 then


          update tickler_records@DBL_BSCS_BF t set
          t.tickler_status ='CLOSED', t.modified_by='USRSIACP', t.modified_date=sysdate, t.closed_by='USRSIACP', t.closed_date=sysdate
          where t.tickler_code in ('BLOQ_APC', 'SUSP_APC') and t.tickler_status ='OPEN' and t.co_id=c1.co_id and t.tickler_number <> c1.max_susp;

          update tickler_records@DBL_BSCS_BF t set
          t.tickler_code='BLOQ_APC'
          where t.tickler_code='SUSP_APC' and t.tickler_status ='OPEN' and t.co_id=c1.co_id and t.tickler_number=c1.max_susp;
          commit;
          v_update_prog:=1;

     end if;

     if v_update_prog=1 then

        update USRACT.postt_servicioprog_fija@DBL_TIMEAI x set x.SERVC_ESTADO=1, x.SERVV_MEN_ERROR=null,x.SERVV_COD_ERROR=0
        where x.servi_cod=4 and x.co_id=c1.co_id and x.SERVD_FECHA_REG >= c1.SERVD_FECHA_REG;
        commit;

        delete from tim.pf_hfc_prov_bscs@DBL_BSCS_BF p where p.co_id =c1.co_id;
        commit;
     end if;

    end loop;
   commit;
 end p_alinea_reconexion_bscs;
  -- Fin 2.0

 procedure p_libera_request_co_id(an_cod_id in number,
                                  an_coderror out number,
                                  av_msgerror out varchar2) is

    cursor cur1 is
      select m.request,
             m.co_id,
             m.status,
             (select count(distinct pr.request_id)
                from pr_serv_status_hist@dbl_bscs_bf pr
               where pr.co_id = m.co_id
                 and pr.request_id = m.request) existe_pr
        from mdsrrtab@dbl_bscs_bf m
       where m.co_id in (an_cod_id)
         and m.request_update is null
         and m.request not in (select distinct n.request
                                 from mdsrrtab@dbl_bscs_bf n
                                where n.co_id = m.co_id
                                  and n.request_update is not null
                                  and n.status in (7, 9))
       order by m.co_id, m.request;

  BEGIN

    for c1 in cur1 loop
      if c1.existe_pr = 0 then
        delete from mdsrrtab@dbl_bscs_bf m
         where m.request = c1.request
           and m.co_id = c1.co_id;
        commit;
      end if;
      if c1.existe_pr = 1 and c1.status = 9 then
        contract.cancel_request@dbl_bscs_bf(c1.request);
        update mdsrrtab@dbl_bscs_bf set status = 9 where request = c1.request;
        commit;
      end if;
      if c1.existe_pr = 1 and c1.status <> 9 then
        begin
          contract.finish_request@dbl_bscs_bf(c1.request);
          update mdsrrtab@dbl_bscs_bf set status = 7 where request = c1.request;
          commit;
        exception
          when others then
            update mdsrrtab@dbl_bscs_bf
               set status = 15, request_update = 'F'
             where request = c1.request;
            commit;
        end;
      end if;
    end loop;

    an_coderror := 1;
    av_msgerror := 'OK';

  exception
    when others then
      an_coderror := -1;
      av_msgerror := sqlerrm || ' Linea : (' ||dbms_utility.format_error_backtrace ||')' ;
  end;

  function f_val_existe_contract_sercad(an_cod_id number) return number is
    ln_return number;
  begin

    SELECT count(CSC.CO_ID)
        into ln_return
        FROM CONTR_SERVICES_CAP@dbl_bscs_bf CSC,
             DIRECTORY_NUMBER@dbl_bscs_bf   DN
       WHERE CSC.CO_ID = an_cod_id
         AND CSC.DN_ID = DN.DN_ID
         AND CSC.CS_DEACTIV_DATE IS NULL;

    return ln_return;
  end;

  procedure p_reg_contr_services_cap(an_cod_id number,
                                     av_numero varchar2,
                                     an_error  out integer,
                                     av_error  out varchar2) is

    v_valida        integer;
    v_rpt           integer;
    V_PEND_REQUEST  integer;
    V_STATUS_HISTNO INTEGER;
    V_SPCODE_HISTNO INTEGER;
    V_TRANSACTIONNO INTEGER;
    V_PROCESS_DATE  DATE := SYSDATE;
    a_sncode        tim.pp017_siac_migraciones.ARR_SERVICIOS@DBL_BSCS_BF;
    a_spcode        tim.pp017_siac_migraciones.ARR_SERVICIOS@DBL_BSCS_BF;

    ln_cont number;
    dn_id   number;

    V_PROFILE_ID   number:=0;
    V_STATUS_SN varchar2(1);
    V_REQUEST_ID number;
    V_SPCODE_ANT number;
    V_SNCODE NUMBER;
    V_SPCODE NUMBER;
    V_CO_ID  NUMBER;
    V_MD_REQUEST NUMBER;

    ln_existe_csc NUMBER; --17.0

  CURSOR cur_li(an_codid NUMBER, av_num VARCHAR2) IS
    select ch.co_id,
           dn.dn_num,
           ch.ch_status status2,
           ch.request request,
           ch.ch_pending,
           dn.dn_id,
           dn.dn_status
      from contract_all@dbl_bscs_bf     ca,
           contract_history@dbl_bscs_bf ch,
           directory_number@dbl_bscs_bf dn
     where ca.co_id = ch.co_id
       and ch.ch_seqno = (select max(h.ch_seqno)
                            from contract_history@dbl_bscs_bf h
                           where h.co_id = ch.co_id)
       and dn.dn_num = av_num
       and ca.co_id = an_codid
       and ca.sccode = 6;

    BEGIN

      v_pend_request := 0;

      a_sncode(1) := 500;
      a_spcode(1) := 1122;

      V_SNCODE := 500;
      V_SPCODE := 1122;

      V_CO_ID  := an_cod_id;

      V_MD_REQUEST := 1;

      select count(1)
        into ln_cont
        from directory_number@dbl_bscs_bf d
       where d.dn_num = av_numero;

      if ln_cont = 0 then
        tim.tim120_reg_nro_fijo@DBL_BSCS_BF(av_numero, dn_id);
        commit;
      end if;

      FOR l in cur_li(an_cod_id, av_numero) LOOP

        SELECT COUNT(1)
          INTO v_valida
          FROM profile_service@DBL_BSCS_BF ps
         WHERE ps.co_id = l.co_id
           AND ps.sncode = 500;

        IF v_valida = 0 then

          IF lower(l.status2) = 'a' and l.ch_pending is null then

            v_rpt := TIM.TFUN108_REG_SERVICIOS_HFC@DBL_BSCS_BF(l.co_id,
                                                               a_sncode,
                                                               a_spcode,
                                                               'A');

            if v_rpt >= 0 then

              insert into contr_services_cap@dbl_bscs_bf
                (co_id,
                 sncode,
                 seqno,
                 dn_id,
                 main_dirnum,
                 cs_status,
                 rec_version,
                 profile_id,
                 dn_shown_in_bill,
                 CS_REQUEST)
              values
                (l.co_id, 500, 1, l.dn_id, 'X', 'O', 1, 0, 'X', v_rpt);

              UPDATE directory_NUMBER@DBL_BSCS_BF dn
                 SET dn.dn_status = 'a', dn.dn_status_mod_date = sysdate
               WHERE dn.dn_id = l.dn_id;

              UPDATE contr_services_cap@DBL_BSCS_BF cc
                 SET cc.cs_activ_date =
                     (SELECT c.ch_validfrom
                        FROM contract_history@DBL_BSCS_BF c
                       WHERE c.co_id = l.co_id
                         AND c.ch_seqno =
                             (SELECT max(ch.ch_seqno)
                                FROM contract_history@DBL_BSCS_BF ch
                               WHERE ch.co_id = c.co_id)
                         AND upper(c.ch_status) = 'A')
               WHERE cc.co_id = l.co_id;

              an_error := 1;
              av_error := 'OK';

            ELSE
              an_error := -1;
              av_error := 'ER';
            END IF;

          ELSIF (lower(l.status2) = 'a' and l.ch_pending is not null) then

            V_RPT := 0;

            V_REQUEST_ID := l.request;

            BEGIN
                  BEGIN
                     SELECT SSH.STATUS, SPH.SPCODE
                       INTO V_STATUS_SN, V_SPCODE_ANT
                       FROM PROFILE_SERVICE@DBL_BSCS_BF PS, PR_SERV_STATUS_HIST@DBL_BSCS_BF SSH,
                            PR_SERV_SPCODE_HIST@DBL_BSCS_BF SPH
                      WHERE PS.CO_ID = V_CO_ID
                        AND PS.SNCODE = V_SNCODE
                        AND PS.CO_ID = SSH.CO_ID
                        AND PS.SNCODE = SSH.SNCODE
                        AND PS.STATUS_HISTNO = SSH.HISTNO
                        AND PS.CO_ID = SPH.CO_ID
                        AND PS.SNCODE = SPH.SNCODE
                        AND PS.SPCODE_HISTNO = SPH.HISTNO;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                         V_STATUS_SN  := 'N';
                         V_SPCODE_ANT := 0;
                  END;

                IF V_STATUS_SN = 'N' THEN
                   BEGIN
                     -- SELECCIONAR SECUENCIAS A INSERTAR
                     SELECT PR_SERV_STATUS_HISTNO_SEQ.NEXTVAL@DBL_BSCS_BF
                       INTO V_STATUS_HISTNO
                       FROM DUAL;

                     SELECT PR_SERV_SPCODE_HISTNO_SEQ.NEXTVAL@DBL_BSCS_BF
                       INTO V_SPCODE_HISTNO
                       FROM DUAL;

                     SELECT PR_SERV_TRANS_NO_SEQ.NEXTVAL@DBL_BSCS_BF
                       INTO V_TRANSACTIONNO
                       FROM DUAL;

                     INSERT INTO CONTRACT_SERVICE@DBL_BSCS_BF(CO_ID, SNCODE) VALUES (V_CO_ID, V_SNCODE);

                     INSERT INTO PROFILE_SERVICE@DBL_BSCS_BF( PROFILE_ID, CO_ID, SNCODE, SPCODE_HISTNO, STATUS_HISTNO,
                                                             ENTRY_DATE, CHANNEL_NUM, OVW_ACC_FIRST, ON_CBB, DATE_BILLED,
                                                             SN_CLASS, OVW_SUBSCR, SUBSCRIPT, OVW_ACCESS, OVW_ACC_PRD,
                                                             ACCESSFEE, CHANNEL_EXCL, DIS_SUBSCR, INSTALL_DATE,
                                                             TRIAL_END_DATE, PRM_VALUE_ID, CURRENCY, SRV_TYPE,
                                                             SRV_SUBTYPE, OVW_ADV_CHARGE, ADV_CHARGE, ADV_CHARGE_PRD,
                                                             DELETE_FLAG, REC_VERSION, BACKUP_CS_OVW_ACCESS,
                                                             BACKUP_CS_OVW_ACC_PRD, BACKUP_CS_OVW_ACC_FIRST, BACKUP_CS_ACCESS)
                                                    VALUES ( V_PROFILE_ID, V_CO_ID, V_SNCODE, V_SPCODE_HISTNO, V_STATUS_HISTNO,
                                                             V_PROCESS_DATE, NULL, NULL, NULL, NULL,
                                                             V_SNCODE, NULL, 0, NULL, 0,
                                                             NULL, NULL, NULL, NULL,
                                                             NULL, NULL, 1, NULL,
                                                             NULL, 'N', 0, 0,
                                                             NULL, 0, NULL,
                                                             NULL, NULL, NULL);

                      INSERT INTO PR_SERV_SPCODE_HIST@DBL_BSCS_BF( PROFILE_ID, CO_ID, SNCODE, HISTNO, SPCODE, TRANSACTIONNO,
                                                        VALID_FROM_DATE, ENTRY_DATE, REC_VERSION)
                                               VALUES ( V_PROFILE_ID, V_CO_ID, V_SNCODE, V_SPCODE_HISTNO, V_SPCODE, V_TRANSACTIONNO,
                                                        V_PROCESS_DATE, V_PROCESS_DATE, 0);

                      INSERT INTO PR_SERV_STATUS_HIST@DBL_BSCS_BF( PROFILE_ID, CO_ID, SNCODE, HISTNO, STATUS, REASON,
                                                        TRANSACTIONNO, VALID_FROM_DATE, ENTRY_DATE,
                                                        REC_VERSION, INITIATOR_TYPE)
                                               VALUES ( V_PROFILE_ID, V_CO_ID, V_SNCODE, V_STATUS_HISTNO, 'O', 0,
                                                        V_TRANSACTIONNO, V_PROCESS_DATE, V_PROCESS_DATE,
                                                        0, 'C');

                      UPDATE CONTRACT_ALL@DBL_BSCS_BF CA
                         SET CA.CO_TIMM_MODIFIED = 'X'
                       WHERE CA.CO_ID = V_CO_ID;

                   EXCEPTION
                     WHEN OTHERS THEN
                          DBMS_OUTPUT.PUT_LINE('ERROR REGISTRO ON HOLD '||V_SNCODE||'('||TO_CHAR(SQLCODE)||': '||SQLERRM||')');
                          V_RPT := -6;
                   END;
                END IF;

                IF V_RPT = 0 AND (V_STATUS_SN = 'D' OR V_STATUS_SN = 'N') THEN

                   SELECT PR_SERV_TRANS_NO_SEQ.NEXTVAL@DBL_BSCS_BF
                     INTO V_TRANSACTIONNO
                     FROM DUAL;

                   IF V_STATUS_SN = 'D' AND V_SPCODE_ANT <> V_SPCODE THEN  --> ACTUALIZAMOS SPCODE DE SERVICIO.
                      BEGIN
                        SELECT PR_SERV_SPCODE_HISTNO_SEQ.NEXTVAL@DBL_BSCS_BF
                          INTO V_SPCODE_HISTNO
                          FROM DUAL;

                        INSERT INTO PR_SERV_SPCODE_HIST@DBL_BSCS_BF( PROFILE_ID, CO_ID, SNCODE, HISTNO, SPCODE, TRANSACTIONNO,
                                                          VALID_FROM_DATE, ENTRY_DATE, REQUEST_ID, REC_VERSION)
                                                 VALUES ( V_PROFILE_ID, V_CO_ID, V_SNCODE, V_SPCODE_HISTNO, V_SPCODE, V_TRANSACTIONNO,
                                                          V_PROCESS_DATE, V_PROCESS_DATE, V_REQUEST_ID, 0);

                        UPDATE PROFILE_SERVICE@DBL_BSCS_BF PS
                           SET PS.SPCODE_HISTNO = V_SPCODE_HISTNO
                         WHERE PS.CO_ID = V_CO_ID
                           AND PS.SNCODE = V_SNCODE;

                      EXCEPTION
                        WHEN OTHERS THEN
                             DBMS_OUTPUT.PUT_LINE('ERROR CAMBIO SPCODE DE SNCODE '||V_SNCODE||'('||TO_CHAR(SQLCODE)||': '||SQLERRM||')');
                             ROLLBACK;
                             V_RPT := -7;
                      END;
                   END IF;

                   BEGIN
                     --REGISTRAMOS ALTA DE SERVICIO
                     SELECT PR_SERV_STATUS_HISTNO_SEQ.NEXTVAL@DBL_BSCS_BF
                       INTO V_STATUS_HISTNO
                       FROM DUAL;

                     IF V_MD_REQUEST > 0 THEN
                        INSERT INTO PR_SERV_STATUS_HIST@DBL_BSCS_BF( PROFILE_ID, CO_ID, SNCODE, HISTNO, STATUS, REASON,
                                                          TRANSACTIONNO, ENTRY_DATE, REQUEST_ID, REC_VERSION,
                                                          INITIATOR_TYPE)
                                                 VALUES ( V_PROFILE_ID, V_CO_ID, V_SNCODE, V_STATUS_HISTNO, 'A', 1,
                                                          V_TRANSACTIONNO, V_PROCESS_DATE, V_REQUEST_ID, 0, 'C');
                     ELSE

                        INSERT INTO PR_SERV_STATUS_HIST@DBL_BSCS_BF( PROFILE_ID, CO_ID, SNCODE, HISTNO, STATUS, REASON,
                                                          TRANSACTIONNO, VALID_FROM_DATE, ENTRY_DATE, REQUEST_ID,
                                                          REC_VERSION, INITIATOR_TYPE)
                                                 VALUES ( V_PROFILE_ID, V_CO_ID, V_SNCODE, V_STATUS_HISTNO, 'A', 1,
                                                          V_TRANSACTIONNO, V_PROCESS_DATE, V_PROCESS_DATE, V_REQUEST_ID, 0, 'C');

                        UPDATE PROFILE_SERVICE@DBL_BSCS_BF PS
                           SET PS.STATUS_HISTNO = V_STATUS_HISTNO
                         WHERE PS.CO_ID = V_CO_ID
                           AND PS.SNCODE = V_SNCODE;

                     END IF;

                   EXCEPTION
                     WHEN OTHERS THEN
                          DBMS_OUTPUT.PUT_LINE('ERROR REGISTRO ACTIVACION DE '||V_SNCODE||'('||TO_CHAR(SQLCODE)||': '||SQLERRM||')');
                          V_RPT := -7;
                   END;
                END IF;

                if V_RPT = 0 then
                    insert into contr_services_cap@dbl_bscs_bf
                      (co_id,
                       sncode,
                       seqno,
                       dn_id,
                       main_dirnum,
                       cs_status,
                       rec_version,
                       profile_id,
                       dn_shown_in_bill,
                       cs_request)

                    values
                      (l.co_id, 500, 1, l.dn_id, 'X', 'O', 1, 0, 'X', V_REQUEST_ID);

                    update directory_number@DBL_BSCS_BF dn
                       set dn.dn_status = 'a', dn.dn_status_mod_date = sysdate
                     where dn.dn_id = l.dn_id;

                    UPDATE contr_services_cap@DBL_BSCS_BF cc
                       SET cc.cs_activ_date =
                           (SELECT c.ch_validfrom
                              FROM contract_history@DBL_BSCS_BF c
                             WHERE c.co_id = l.co_id
                               AND c.ch_seqno =
                                   (SELECT max(ch.ch_seqno)
                                      FROM contract_history@DBL_BSCS_BF ch
                                     WHERE ch.co_id = c.co_id)
                               AND upper(c.ch_status) = 'A')
                     WHERE cc.co_id = l.co_id;

                  an_error := 1;
                  av_error := 'OK';

                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
                  an_error := -1;
                  av_error := 'EI';
            END;

          ELSE
            an_error := -1;
            av_error := 'RP';
          END IF;
        ELSE
          --ini 17.0
          V_REQUEST_ID := l.request;

          --Validamos que se registre en la CONTR_SERVICES_CAP
          ln_existe_csc := operacion.pq_sga_bscs.f_val_existe_contract_sercad(l.co_id);

          --Insertamos en la Contr_servicas si no existe
          if ln_existe_csc = 0 then
            begin
              insert into contr_services_cap@dbl_bscs_bf
                      (co_id,
                       sncode,
                       seqno,
                       dn_id,
                       main_dirnum,
                       cs_status,
                       rec_version,
                       profile_id,
                       dn_shown_in_bill,
                       cs_request)

                    values
                      (l.co_id, 500, 1, l.dn_id, 'X', 'O', 1, 0, 'X', V_REQUEST_ID);

                    update directory_number@DBL_BSCS_BF dn
                       set dn.dn_status = 'a', dn.dn_status_mod_date = sysdate
                     where dn.dn_id = l.dn_id;

                    UPDATE contr_services_cap@DBL_BSCS_BF cc
                       SET cc.cs_activ_date =
                           (SELECT c.ch_validfrom
                              FROM contract_history@DBL_BSCS_BF c
                             WHERE c.co_id = l.co_id
                               AND c.ch_seqno =
                                   (SELECT max(ch.ch_seqno)
                                      FROM contract_history@DBL_BSCS_BF ch
                                     WHERE ch.co_id = c.co_id)
                               AND upper(c.ch_status) = 'A')
                     WHERE cc.co_id = l.co_id;

                  an_error := 1;
                  av_error := 'OK';
            exception
              when others then
                an_error := -1;
                av_error := 'Error al Registrar en la contr_services_cap : ' ||
                            sqlcode || ' ' || sqlerrm || ' (' ||
                            dbms_utility.format_error_backtrace || ')';
            end;
          end if;
          --fin 17.0

          an_error := -1;
          av_error := 'IC';
        END IF;
      END LOOP;
    END;

   function f_get_is_cp_hfc(an_codsolot number) return number is
     ln_return number;
   begin
     select count(1)
       into ln_return
       from solot s
      where s.codsolot = an_codsolot
        and exists (select 1
               from tipopedd t, opedd o
              where t.tipopedd = o.tipopedd
                and t.abrev = 'PAR_VAL_OAC_BSR'
                and o.codigoc = 'CPOAC'
                and o.codigon_aux = 1
                and o.codigon = s.tiptra);

     return ln_return;

   end;

   procedure p_act_prov_bscs_reserv_hfc(an_co_id    number,
                                        an_coderror out number,
                                        av_error    out varchar2) is
   begin

     update tim.pf_hfc_prov_bscs@dbl_bscs_bf
        set estado_prv    = 5,
            fecha_rpt_eai = sysdate - 5 / 3600,
            errcode       = 0,
            errmsg        = 'Operation Success'
      where co_id = an_co_id
        and action_id in (1, 8);

     an_coderror := 1;
     av_error    := 'OK';

   exception
     when others then
       an_coderror := -1;
       av_error    := 'ERROR : ' || sqlerrm || ' - Linea (' ||
                      dbms_utility.format_error_backtrace || ')';
   end;
-- INI 8.0
   procedure p_reg_nro_lte_bscs(av_numero in varchar2,
                                an_error  out number,
                                av_error  out varchar2) is
     ln_cont number;
      ln_dn_id   number;
      ln_plcode  number;
      ln_hlcode  number;
      ln_dn_type number;
      ln_hmcode  number;
   begin

     an_error := 1;
     av_error := 'OK';

      ln_plcode  := operacion.pq_sga_bscs.f_get_obtiene_param_lte('PLCODE_LTE');
      ln_hlcode  := operacion.pq_sga_bscs.f_get_obtiene_param_lte('HLCODE_LTE');
      ln_dn_type := operacion.pq_sga_bscs.f_get_obtiene_param_lte('DN_TYPE_LTE');
      ln_hmcode  := operacion.pq_sga_bscs.f_get_obtiene_param_lte('HMCODE_LTE');

     select count(1)
       into ln_cont
       from directory_number@dbl_bscs_bf d
      where d.dn_num = av_numero;

     if ln_cont = 0 then
        tim.tim120_reg_nro_fijo@DBL_BSCS_BF(av_numero, ln_dn_id);

       update sysadm.directory_number@dbl_bscs_bf d
           set d.plcode  = ln_plcode,
               d.hlcode  = ln_hlcode,
               d.dn_type = ln_dn_type,
               d.hmcode  = ln_hmcode
         where d.dn_id = ln_dn_id;

      else

        select d.dn_id
          into ln_dn_id
          from directory_number@dbl_bscs_bf d
         where d.dn_num = av_numero;

       update sysadm.directory_number@dbl_bscs_bf d
           set d.plcode  = ln_plcode,
               d.hlcode  = ln_hlcode,
               d.dn_type = ln_dn_type,
               d.hmcode  = ln_hmcode
         where d.dn_id = ln_dn_id;

     end if;
   exception
     when others then
       an_error := 1;
       av_error := 'ERROR : ' || SQLERRM || ' - Linea (' ||
                   dbms_utility.format_error_backtrace || ')';
   end;

   function f_get_obtiene_param_lte(av_cadena varchar2) return number is

     ln_valor number;

   begin
     select o.codigon
       into ln_valor
       from tipopedd t, opedd o
      where t.tipopedd = o.tipopedd
        and t.abrev = 'NUM_LTE_REG_BSCS'
        and o.codigoc = av_cadena;

     return ln_valor;
   exception
     when no_data_found then
       raise_application_error(sqlcode,
                               'Error al obtener parametro LTE : ' ||
                               sqlerrm);
   end;
-- FIN 8.0

  function f_is_marketlte(p_co_id in number) return boolean is
    v_is_lte boolean := false;
    v_market pls_integer := 0;
    v_plcode pls_integer := 0;
  begin

    select ca.sccode, ca.plcode
      into v_market, v_plcode
      from contract_all@dbl_bscs_bf ca
     where ca.co_id = p_co_id;

    if v_market = c_market_lte and c_plcode_lte = v_plcode then
      v_is_lte := true;
    end if;

    return v_is_lte;
  end;

  procedure sp_get_contract_dnnum(p_co_id  in integer,
                                  p_dn_num out varchar2) is
  begin
    begin
      p_dn_num := tim.tfun051_get_dnnum_from_coid@dbl_bscs_bf(p_co_id);
    exception
      when others then
        p_dn_num := '';
    end;
  end sp_get_contract_dnnum;


  procedure p_anular_venta_lte(p_co_id     in integer,
                               p_resultado out integer,
                               p_msgerr    out varchar2) is
    v_customer_id integer := 0;
    v_cant        integer;
    v_dn_id       integer;
    v_fecha       date;
    ln_csc_num    number := 0;

  begin
    p_resultado := 0;
    p_msgerr    := 'OK';

    begin
      select co.customer_id
        into v_customer_id
        from contract_all@dbl_bscs_bf co
       where co.co_id = p_co_id
         and co.sccode = c_market_lte
         and co.tmcode in (select x.valor1
                             from tim.tim_parametros@dbl_bscs_bf x
                            where x.campo = 'PLAN_LTE');
    exception
      when no_data_found then
        v_customer_id := 0;
    end;

    if v_customer_id = 0 then
      p_resultado := -1;
      p_msgerr    := 'EL CONTRATO BSCS 3PLAY NO EXISTE';
      return;
    end if;

    select count(*)
      into v_cant
      from curr_co_status@dbl_bscs_bf ch
     where co_id = p_co_id
       and ch_status = 'o';

    if v_cant = 0 then
      p_resultado := -2;
      p_msgerr    := 'EL CONTRATO NO SE ENCUENTRA EN ON-HOLD O PRE-ACTIVO';
      return;
    end if;

    begin
      select count(dn_id)
        into v_dn_id
        from contr_services_cap@dbl_bscs_bf
       where co_id = p_co_id;
    exception
      when no_data_found then
        v_dn_id := 0;
    end;

    if v_dn_id > 0 then

      begin
        delete from sysadm.profile_service_adv_charge@dbl_bscs_bf
         where co_id = p_co_id;
      exception
        when others then
          dbms_output.put_line(sqlerrm || '**' || p_co_id);
          null;
      end;

      delete from sysadm.pr_serv_status_hist@dbl_bscs_bf
       where co_id = p_co_id
         and sncode = c_sncode_tlf;

      delete from sysadm.pr_serv_spcode_hist@dbl_bscs_bf
       where co_id = p_co_id
         and sncode = c_sncode_tlf;

      delete from sysadm.profile_service@dbl_bscs_bf
       where co_id = p_co_id
         and sncode = c_sncode_tlf;

      delete from sysadm.contract_service@dbl_bscs_bf
       where co_id = p_co_id
         and sncode = c_sncode_tlf;

      delete from sysadm.contr_services_cap@dbl_bscs_bf
       where co_id = p_co_id
         and sncode = c_sncode_tlf;

      for nu in (select dn_id, co_id
                   from contr_services_cap@dbl_bscs_bf
                  where co_id = p_co_id) loop

        select count(csc.co_id)
          into ln_csc_num
          from contr_services_cap@dbl_bscs_bf csc,
               directory_number@dbl_bscs_bf   dn
         where csc.dn_id = dn.dn_id
           and csc.co_id != nu.co_id
           and operacion.pq_sga_iw.f_val_status_contrato(csc.co_id) in
               (1, 2, 3)
           and dn.dn_id = nu.dn_id;

        if ln_csc_num = 0 then
          update directory_number@dbl_bscs_bf
             set dn_status = 'r'
           where dn_id = nu.dn_id;
        end if;
      end loop;

      for nu in (select cd.co_id, cd.port_id
                   from contr_devices@dbl_bscs_bf cd
                  where cd.co_id = p_co_id) loop

        select count(ccd.co_id)
          into ln_csc_num
          from contr_devices@dbl_bscs_bf ccd, port@dbl_bscs_bf p
         where ccd.port_id = p.port_id
           and ccd.co_id != nu.co_id
           and ccd.port_id = nu.port_id
           and operacion.pq_sga_iw.f_val_status_contrato(ccd.co_id) in
               (1, 2, 3);

        if ln_csc_num = 0 then
          delete from sysadm.contr_devices@dbl_bscs_bf
           where co_id = nu.co_id
             and port_id = nu.port_id;

          update sysadm.port@dbl_bscs_bf
             set port_status = 'r'
           where port_id = nu.port_id;

          begin

            update sysadm.storage_medium@dbl_bscs_bf sm
               set sm.sm_status = 'r'
             where sm.sm_id in (select po.sm_id
                                  from port@dbl_bscs_bf po
                                 where po.port_id = nu.port_id);

          exception
            when others then
              p_resultado := -1;
              p_msgerr    := 'ERROR : ' || sqlerrm;
          end;

        end if;
      end loop;
    end if;

    insert into gmd_request_history@dbl_bscs_bf
      select request,
             plcode,
             9,
             ts,
             userid,
             customer_id,
             vmd_retry,
             error_retry,
             co_id,
             insert_date,
             request_update,
             priority,
             action_date,
             switch_id,
             sccode,
             worker_pid,
             gmd_market_id,
             action_id,
             data_1,
             data_2,
             data_3,
             error_code,
             parent_request,
             provisioning_flag,
             rating_flag
        from mdsrrtab@dbl_bscs_bf
       where co_id = p_co_id;

    delete from mdsrrtab@dbl_bscs_bf where co_id = p_co_id;

    insert into contract_history@dbl_bscs_bf
    values
      (p_co_id, 3, 'd', 31, sysdate, null, v_fecha, 'USRPVU', NULL, 1, 'C');

    select count(*)
      into v_cant
      from contract_all@dbl_bscs_bf co
     where co.customer_id = v_customer_id
       and co.co_id <> p_co_id
       and exists (select 1
              from curr_co_status@dbl_bscs_bf
             where co_id = co.co_id
               and ch_status <> 'd');

    if v_cant = 0 then
      update customer_all@dbl_bscs_bf
         set csdeactivated = trunc(sysdate),
             cstype        = 'd',
             cstype_date   = sysdate,
             csmoddate     = sysdate,
             USER_LASTMOD  = 'USRBATCH',
             csreason      = 3
       where customer_id = v_customer_id;
    end if;
  end;

  procedure p_anula_contrato_bscs_lte(p_co_id     in integer,
                                      p_ch_reason in integer,
                                      p_resultado out integer,
                                      p_msgerr    out varchar2)

   as
    v_status_histno integer;
    v_transactionno integer;
    v_ch_status     varchar2(1);
    v_ch_pending    varchar2(1);
    v_ch_validfrom  date;
    v_dn_id         integer;
    v_request       number;
    v_date1         date;
    v_co_id         integer;
    v_count1        number;
    v_count2        number;

    cursor cur2(vp_co_id in integer) is
      select c.co_id, ps.sncode, c.ch_status, c.ch_pending
        from contract_history@dbl_bscs_bf c, profile_service@dbl_bscs_bf ps
       where c.co_id = ps.co_id
         and c.ch_seqno = (select max(b.ch_seqno)
                             from contract_history@dbl_bscs_bf b
                            where b.co_id = c.co_id)
         and c.co_id = vp_co_id;

    cursor cur3(vp_co_id in integer) is
      select c.co_id, ps.sncode, c.ch_status, c.ch_pending
        from contract_history@dbl_bscs_bf c, profile_service@dbl_bscs_bf ps
       where c.co_id = ps.co_id
         and c.ch_seqno = (select max(b.ch_seqno)
                             from contract_history@dbl_bscs_bf b
                            where b.co_id = c.co_id)
         and c.co_id = vp_co_id;

  begin

    p_resultado := 0;
    P_MSGERR    := 'PROCESO SATISFACTORIO';
    v_count1    := 0;
    v_count2    := 0;

    begin
      select c.ch_status, c.ch_pending, c.ch_validfrom, c.request
        into v_ch_status, v_ch_pending, v_ch_validfrom, v_request
        from contract_history@dbl_bscs_bf c
       where c.co_id = p_co_id
         and c.ch_seqno = (select max(b.ch_seqno)
                             from contract_history@dbl_bscs_bf b
                            where b.co_id = c.co_id);
    exception
      when others then
        p_resultado := -1;
        p_msgerr    := 'NO EXISTE CONTRATO PARA ANULAR EN BSCS';
        return;
    end;

    if f_is_marketlte(p_co_id) then
      sp_get_contract_dnnum(p_co_id, v_dn_id);
    else
      begin
        select ca.co_id, dn.dn_num
          into v_co_id, v_dn_id
          from directory_number@dbl_bscs_bf   dn,
               contr_services_cap@dbl_bscs_bf cs,
               contract_all@dbl_bscs_bf       ca
         where ca.co_id = cs.co_id
           and dn.dn_id = cs.dn_id
           and ca.co_id = p_co_id
           and rownum < 2;
      exception
        when no_data_found then
          p_resultado := -1;
          p_msgerr    := 'NO EXISTE CONTRATO RELACIONADO A UN NUMERO EN BSCS';
          return;
      end;
    end if;

    if (v_ch_status = 'o' and v_ch_pending is null) or
       (v_ch_status = 'a' and v_ch_pending is not null) then

      if (v_ch_status = 'a' and v_ch_pending is not null) then
        /* cancelamos el request */
        contract.cancel_request@dbl_bscs_bf(v_request);
      end if;

      /* anulamos la venta, liberamos el contrato y la linea */
      p_anular_venta_lte(p_co_id, p_resultado, p_msgerr);

      if p_resultado <> 0 then
        p_resultado := -1;
        p_msgerr    := 'ERROR AL ANULAR VENTA EN BSCS';
        return;
      else
        p_msgerr := 'PROCESO SATISFACTORIO';
      end if;

      /* insertamos una fila con estado a*/
      insert into contract_history@dbl_bscs_bf
        (co_id,
         ch_seqno,
         ch_status,
         ch_reason,
         ch_validfrom,
         entdate,
         userlastmod,
         rec_version,
         initiator_type)
      values
        (p_co_id, 2, 'a', 1, sysdate, sysdate, 'USRPVU', 2, 'C');

      select y.ch_validfrom
        into v_date1
        from sysadm.contract_history@dbl_bscs_bf y
       where y.co_id = p_co_id
         and y.ch_status = 'd';

      update sysadm.contract_history@dbl_bscs_bf a
         set a.entdate = v_date1
       where a.co_id = p_co_id
         and a.ch_status = 'd';

      /* bucle que recorre cada instancia del servicio */
      for c2 in cur2(p_co_id) loop

        select count(1)
          into v_count1
          from sysadm.pr_serv_status_hist@dbl_bscs_bf p
         where p.co_id = c2.co_id
           and p.sncode = c2.sncode
           and upper(p.status) = 'A';

        if v_count1 = 0 then

          sysadm.nextfree.getvalue@dbl_bscs_bf('PR_SERV_STATUS_HISTNO',
                                               V_STATUS_HISTNO);
          SYSADM.nextfree.getvalue@DBL_BSCS_BF('PR_SERV_TRANS_NO',
                                               v_transactionno);

          insert into pr_serv_status_hist@dbl_bscs_bf
            (profile_id,
             co_id,
             sncode,
             histno,
             status,
             reason,
             transactionno,
             valid_from_date,
             entry_date,
             rec_version,
             initiator_type)
          values
            (0,
             c2.co_id,
             c2.sncode,
             v_status_histno,
             'A',
             0,
             v_transactionno,
             sysdate,
             sysdate,
             0,
             'C');

        END IF;

      end loop;

      /* bucle que recorre cada instancia del servicio */
      for c3 in cur3(p_co_id) loop

        select count(1)
          into v_count2
          from sysadm.pr_serv_status_hist@dbl_bscs_bf p
         where p.co_id = c3.co_id
           and p.sncode = c3.sncode
           and upper(p.status) = 'D';

        if (v_count2 = 0) then

          nextfree.getvalue@DBL_BSCS_BF('PR_SERV_STATUS_HISTNO',
                                        v_status_histno);
          nextfree.getvalue@DBL_BSCS_BF('PR_SERV_TRANS_NO',
                                        v_transactionno);

          INSERT INTO pr_serv_status_hist@DBL_BSCS_BF
            (profile_id,
             co_id,
             sncode,
             histno,
             status,
             reason,
             transactionno,
             valid_from_date,
             entry_date,
             rec_version,
             initiator_type)
          VALUES
            (0,
             c3.co_id,
             c3.sncode,
             v_status_histno,
             'D',
             0,
             v_transactionno,
             sysdate,
             sysdate,
             0,
             'C');

          update sysadm.profile_service@DBL_BSCS_BF ps
             set ps.status_histno = v_status_histno
           where ps.co_id = c3.co_id
             and ps.sncode = c3.sncode;

        END IF;

      END LOOP;

      /* Actualizamos la fecha y reason para la ultima fila insertada*/
      UPDATE CONTRACT_HISTORY@DBL_BSCS_BF C
         SET C.CH_VALIDFROM = SYSDATE, C.ENTDATE = SYSDATE, C.CH_SEQNO = 3
       WHERE C.CO_ID = P_CO_ID
         AND lower(C.CH_STATUS) = 'd';

    ELSE
      P_RESULTADO := -1;
      P_MSGERR    := 'EL ESTADO DEL CONTRATO: ' || P_CO_ID ||
                     ' NO ESTA CONTEMPLADO PARA EL PROCESO';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_RESULTADO := -1;
      P_MSGERR    := 'ERROR IN SP_ANULA_CONTRATO_BSCS [NRO: ' ||
                     TO_CHAR(SQLCODE) || ' - MSG:' || SQLERRM || '] ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END;
  -- Ini 10.0
  --------------------------------------------------------------------------------
  function get_codsrv_bscs(p_sncode varchar2) return varchar2 is
    l_cod_siac varchar2(20);
    l_codsrv   sales.servicio_sisact.codsrv%type;

  begin
    if p_sncode is not null then
      select servv_codigo
        into l_cod_siac
        from usrpvu.sisact_ap_servicio@dbl_pvudb
       where servv_id_bscs = p_sncode;

      if l_cod_siac is not null then
        select ss.codsrv
          into l_codsrv
          from sales.servicio_sisact ss
         where ss.idservicio_sisact = l_cod_siac;
      end if;
    end if;

    return l_codsrv;
  end;

  --------------------------------------------------------------------------------
  procedure lista_srv_bscs(p_cod_id number, p_serv_bscs out sys_refcursor) is
  begin
    open p_serv_bscs for
      select distinct 0 procesar,
                      p.customer_id as customer_id,
                      p.co_id,
                      tim.tfun051_get_dnnum_from_coid@dbl_bscs_bf(p.co_id) tn,
                      serv.desc_plan,
                      serv.desc_serv,
                      serv.status,
                      serv.tipo_servicio,
                      serv.sncode,
                      cu.billcycle
        from sysadm.contract_all@dbl_bscs_bf p,
             sysadm.customer_all@dbl_bscs_bf cu,
             (select ssh.co_id,
                     rp.des desc_plan,
                     ssh.sncode,
                     sn.des desc_serv,
                     ssh.status,
                     operacion.pq_cont_regularizacion.f_val_tipo_servicio_bscs(ssh.sncode) tipo_servicio
                from sysadm.pr_serv_status_hist@dbl_bscs_bf ssh,
                     sysadm.mpusntab@dbl_bscs_bf            sn,
                     sysadm.profile_service@dbl_bscs_bf     ps,
                     sysadm.contract_all@dbl_bscs_bf        ca,
                     sysadm.rateplan@dbl_bscs_bf            rp
               where ssh.sncode = sn.sncode
                 and ssh.co_id = ca.co_id
                 and ssh.co_id = ps.co_id
                 and ssh.co_id = p_cod_id
                 and ssh.sncode = ps.sncode
                 and ssh.histno = ps.status_histno
                 and ca.tmcode = rp.tmcode) serv
       where p.co_id = serv.co_id
         and cu.customer_id = p.customer_id
         and p.co_id = p_cod_id;
  end;
  --------------------------------------------------------------------------------
  procedure lista_equ_bscs(p_cod_id number, p_equ_bscs out sys_refcursor) is
  begin
    open p_equ_bscs for
      select equi.co_id,
             equi.tipo_serv,
             equi.id_producto,
             equi.id_producto_padre,
             (case
               when equi.tipo_serv = 'CTV' then
                equi.mac_address
               else
                equi.numero_serie
             end) mac_address,
             equi.modelo,
             equi.codigo_ext,
             equi.reserva_act,
             equi.instal_act,
             equi.estado_recurso
        from (select int.co_id,
                     'INT' tipo_serv,
                     int.id_producto,
                     int.id_producto_padre,
                     '' numero_serie,
                     int.mac_address,
                     '' modelo,
                     (select d.campo01
                        from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                       where d.id_producto = int.id_producto
                         and d.co_id = int.co_id) codigo_ext,
                     int.reserva_act,
                     int.instal_act,
                     int.estado_recurso
                from tim.pf_hfc_internet@dbl_bscs_bf int
               where int.co_id = p_cod_id
              union
              select tlf.co_id,
                     'TLF' tipo_serv,
                     tlf.id_producto,
                     tlf.id_producto_padre,
                     '' numero_serie,
                     tlf.mac_address mac,
                     tlf.mta_model_crm_id modelo,
                     (select d.campo01
                        from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                       where d.id_producto = tlf.id_producto
                         and d.co_id = tlf.co_id) codigo_ext,
                     tlf.reserva_act,
                     tlf.instal_act,
                     tlf.estado_recurso
                from tim.pf_hfc_telefonia@dbl_bscs_bf tlf
               where tlf.co_id = p_cod_id
              union
              select tlf.co_id,
                     d.tipo_serv,
                     d.id_producto,
                     d.id_producto_padre,
                     '' numero_serie,
                     tlf.mac_address mac,
                     tlf.mta_model_crm_id modelo,
                     (select d.campo01
                        from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                       where d.id_producto_padre = tlf.id_producto
                         and d.co_id = tlf.co_id) codigo_ext,
                     tlf.reserva_act,
                     tlf.instal_act,
                     tlf.estado_recurso
                from tim.pf_hfc_telefonia@dbl_bscs_bf  tlf,
                     tim.pf_hfc_datos_serv@dbl_bscs_bf d
               where tlf.co_id = d.co_id
                 and tlf.id_producto = d.id_producto_padre
                 and d.tipo_serv = 'TEP'
                 and tlf.co_id = p_cod_id
              union
              select ctv.co_id,
                     'CTV' tipo_serv,
                     ctv.id_producto,
                     ctv.id_producto_padre,
                     ctv.serial_number numero_serie,
                     '' mac,
                     ctv.stb_type_crm_id modelo,
                     (select d.campo02
                        from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                       where d.id_producto = ctv.id_producto
                         and d.co_id = ctv.co_id) codigo_ext,
                     ctv.reserva_act,
                     ctv.instal_act,
                     ctv.estado_recurso
                from tim.pf_hfc_cable_tv@dbl_bscs_bf ctv
               where ctv.co_id = p_cod_id) equi;
  end;
  -- Fin 10.0
  -- INI 12.0
  /* **********************************************************************************************/
  PROCEDURE SIACSI_REG_OCC(K_IDTAREAWF IN NUMBER,
                           K_IDWF      IN NUMBER,
                           K_TAREA     IN NUMBER,
                           K_TAREADEF  IN NUMBER) IS

    c_codsolot      solot.codsolot%TYPE;
    c_monto_occ     operacion.shfct_det_tras_ext.shfcv_monto%TYPE;
    c_codocc        operacion.shfct_det_tras_ext.shfcv_codocc%TYPE;
    c_flag_occ      NUMBER;
    c_customer_id   operacion.shfct_det_tras_ext.shfci_customer_id%TYPE;
    v_cod_error     NUMBER;
    v_des_error     VARCHAR2(500);
    c_remark        VARCHAR2(3000);
    v_error_general EXCEPTION;
    c_tiptra        solot.tiptra%TYPE;

  BEGIN

    SELECT a.codsolot
      INTO c_codsolot
      FROM wf a, solot b
     WHERE a.idwf = k_idwf
       AND a.codsolot = b.codsolot
       AND a.valido = 1;

    BEGIN
      SELECT h.shfcv_monto,
             h.shfcv_codocc,
             h.shfcv_flag_cobro_occ,
             h.shfci_customer_id,
             s.tiptra
        INTO c_monto_occ, c_codocc, c_flag_occ, c_customer_id, c_tiptra
        FROM operacion.shfct_det_tras_ext h, solot s
       WHERE h.shfcn_codsolot = s.codsolot
         AND h.shfcn_codsolot = c_codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           c_flag_occ := 0;
    END;

    IF c_flag_occ = 1 and c_monto_occ > 0 THEN

      SELECT o.descripcion
        INTO c_remark
        FROM tipopedd t, opedd o
       WHERE t.tipopedd = o.tipopedd
         AND t.abrev = 'REMARK_COBRO_OCC'
         AND o.abreviacion = 'COBRO_OCC'
         AND o.codigon_aux = 1
         AND o.codigon = c_tiptra;

      v_cod_error := TIM.TFUN026_REGISTRA_OCC@DBL_BSCS_BF(c_customer_id,
                                                          c_codocc,
                                                          1,
                                                          c_monto_occ,
                                                          SYSDATE,
                                                          c_remark,
                                                          v_cod_error,
                                                          v_des_error);

      IF v_cod_error < 0 THEN
         v_des_error := 'Error al realizar '||c_remark||' :' || v_des_error;
         RAISE v_error_general;
      END IF;
    END IF;

  EXCEPTION
    WHEN v_error_general THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SIACSI_REG_OCC: ' ||
                              SQLERRM || v_des_error);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SIACSI_REG_OCC: ' ||
                              SQLERRM);

  END;
  /* **********************************************************************************************/
  -- FIN 12.0
  -- Ini 13.0
  --------------------------------------------------------------------------------
  procedure relanza_reserva(p_cod_id    number,
                            p_codsolot  number,
                            p_resultado out integer,
                            p_msgerr    out varchar2) is
    l_tipo_serv   operacion.trs_interface_iw.tip_interfase%type;
    l_id_producto operacion.trs_interface_iw.id_producto%type;

    cursor c_int_iw is
      select distinct tip_interfase,
                      id_producto
        from operacion.trs_interface_iw
       where cod_id = p_cod_id
         and codsolot = p_codsolot;

  begin
    if p_cod_id is null or p_codsolot is null then
      p_resultado := -1;
      p_msgerr    := 'DATOS INVALIDOS';
      return;
    end if;

    for c_int in c_int_iw
    loop
      l_tipo_serv   := c_int.tip_interfase;
      l_id_producto := c_int.id_producto;
      p_reg_log(null, null, null, null, null, l_id_producto, l_tipo_serv,
                p_cod_id, 'Eliminar Reserva');

      tim.tim111_pkg_acciones_sga.SP_ELIMINA_RESERVA@dbl_bscs_bf(p_cod_id,
                                                                 l_tipo_serv,
                                                                 l_id_producto,
                                                                 p_resultado,
                                                                 p_msgerr);
    end loop;

    if p_resultado = 1 then
      webservice.pq_ws_hfc.p_gen_reservahfc(p_cod_id, p_codsolot, p_resultado,
                                            p_msgerr);
      if p_resultado is null then
        p_resultado := 1;
        p_msgerr    := 'Relanzamiento realizado con exito';
      else
        p_resultado := -1;
        p_msgerr    := 'No se realizo el Relanzamiento';
        return;
      end if;
    else
      return;
    end if;
  end;
  -- Fin 13.0
  -- INI 15.0
  function f_get_tarfif_prov_tlf_hfc(an_cod_id number) return varchar2 is
    lv_tarfif_prov varchar2(200);
  begin

    select plj.param1 || '|' || plj.param2
      into lv_tarfif_prov
      from profile_service@dbl_bscs_bf       ps,
           contract_all@dbl_bscs_bf          ca,
           tim.pf_hfc_parametros@dbl_bscs_bf plj,
           pr_serv_status_hist@dbl_bscs_bf   pr
     where ps.co_id = ca.co_id
       and ca.sccode = 6
       and pr.co_id = ps.co_id
       and pr.sncode = ps.sncode
       and pr.histno = ps.status_histno
       and ps.sncode = plj.cod_prod1
       and plj.campo = 'SERV_TELEFONIA'
       and ca.co_id = an_cod_id
       and pr.status = 'A'
       and rownum = 1;

    return lv_tarfif_prov;

  exception
    when others then
      return '-1';
  end;
 --FIN 15.0
 
 -- LFLORES
 function f_get_tarfif_prov_tlf_lte(an_cod_id number) return varchar2 is
    lv_tarfif_prov varchar2(200);
  begin
    select plj.param1 || '|' || plj.param2
      into lv_tarfif_prov
      from profile_service@dbl_bscs_bf       ps,
           contract_all@dbl_bscs_bf          ca,
           tim.pf_hfc_parametros@dbl_bscs_bf plj
     where ps.co_id = ca.co_id
       and ca.tmcode in (SELECT x.valor1
                                FROM tim.tim_parametros@dbl_bscs_bf x
                               WHERE x.campo = 'PLAN_LTE')
       and ps.sncode = plj.cod_prod1
       and plj.campo = 'SERV_TELEFONIA_LTE'
       and ca.co_id = an_cod_id;

     return lv_tarfif_prov;

  exception
    when others then
      return '-1';
  end;
 --------------
  
END PQ_SGA_BSCS;
/