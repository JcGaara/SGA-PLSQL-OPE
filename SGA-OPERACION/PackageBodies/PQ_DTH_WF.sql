CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_DTH_WF AS
/******************************************************************************
   NAME:       PQ_CORTESERVICIO_CABLE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08/07/2008  Gustavo Ormeño.     1. Created this package.
   2.0        13/04/2009  Hector Huaman       REQ-89542: se modifico la excepcion del procedmiento p_verif_sol_reconexion para que envie la linea donde se cayo el procedmiento.
   3.0        15/04/2009  Hector Huaman       REQ-89813: se modifico los procedimientos p_verif_sol_corte y  p_verif_sol_corte para que filtren los clientes que cuentan con regarga virtual
   4.0        06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

/**********************************************************************
Ejecuta el envío de cortes de servicios DTH
**********************************************************************/
procedure p_ejecuta_wf_corte_dth
is

/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_DTH_WF.P_EJECUTA_WF_CORTE_DTH';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='942';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/


  cursor cur is
    select * from tmp_corte_dth where estado in (1, 2) -- estados GENERADO e INCOMPLETO
    and transaccion = 'CORTE';
  p_resultado VARCHAR2(50);
  p_mensaje   VARCHAR2(100);
  p_codsolot  solot.codsolot%type;

  l_var varchar2(1000);

begin
   l_var := '';
   BEGIN
              for c in cur loop
                p_resultado := '';
                p_mensaje := '';

                operacion.pq_dth.p_corte_dth( c.pid, p_resultado, p_mensaje) ;

                update tmp_corte_dth
                   set resultado = p_resultado, mensaje = p_mensaje
                 where codsolot = c.codsolot;

                if (p_resultado = 'OK') then
                  update tmp_corte_dth set estado = 3 where codsolot = c.codsolot; -- estado generación de archivo de CORTE COMPLETADO
                else
                  update tmp_corte_dth set estado = 2 where codsolot = c.codsolot; -- estado CORTE INCOMPLETO
                  p_envia_correo_c_attach('Cortes DTH','jose.ramos@claro.com.pe','No se completó con éxito el envío del comando de corte de servicio DTH, SOT: ' || c.codsolot || ', SID: ' || c.codinssrv ||', mensaje: ' || p_mensaje, null,'SGA');--4.0
                  p_envia_correo_c_attach('Cortes DTH','melvin.balcazar@claro.com.pe','No se completó con éxito el envío del comando de corte de servicio DTH, SOT: ' || c.codsolot || ', SID: ' || c.codinssrv ||', mensaje: ' || p_mensaje, null,'SGA');--4.0
                end if;

                commit;
              end loop;

  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
/*  sp_rep_registra_error
     (c_nom_proceso, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);*/
  --------------------------------------------------
     EXCEPTION
              WHEN OTHERS THEN
             -----------------------------------------
             ---PARA EL ENVIO DE CORREOS
/*                  sp_rep_registra_error
                     (c_nom_proceso, c_id_proceso,
                      sqlerrm , '1',c_sec_grabacion );*/
             -----------------------------------------
                   l_var := 'OPERACION.P_EJECUTA_WORKFLOW_CORTE_DTH - ÚLTIMA SOT EVALUADA: ' || p_codsolot ||
                 ' Revisar el JOB - Problema presentado: : ' || sqlerrm;

     END;
     if trim(l_var) <> '' then
           opewf.pq_send_mail_job.p_send_mail('Revisar JOB - atención automática de WFs de corte DTH',
                                           'DL-PE-ITSoportealNegocio@claro.com.pe',--4.0
                                           l_var);
     end if;

END;


/**********************************************************************
Ejecuta el envío de reconexiones de servicios DTH
**********************************************************************/
procedure p_ejecuta_wf_reconexion_dth(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number)
is
  cursor cur is
    select * from tmp_corte_dth where estado in (1, 2) -- estados GENERADO e INCOMPLETO
    and transaccion = 'RECONEXION';
  p_resultado VARCHAR2(50);
  p_mensaje   VARCHAR2(100);
  p_codsolot  solot.codsolot%type;

  l_var varchar2(1000);

begin
   l_var := '';
   BEGIN
              l_var := '';
              for c in cur loop
                p_resultado := '';
                p_mensaje := '';
                operacion.pq_dth.p_reconexion_dth( c.pid, p_resultado, p_mensaje) ;
                update tmp_corte_dth
                   set resultado = p_resultado, mensaje = p_mensaje
                 where codsolot = c.codsolot;
                if (p_resultado = 'OK') then
                  update tmp_corte_dth set estado = 3 where codsolot = c.codsolot; -- estado generación de archivo de RECONEXIÓN COMPLETADA
                 else
                  update tmp_corte_dth set estado = 2 where codsolot = c.codsolot; -- estado RECONEXIÓN INCOMPLETA
                  p_envia_correo_c_attach('Reconexiones DTH',
                                          'joseramos.creo@claro.com.pe',--4.0
                                          'No se completó con éxito el envío del comando de reconexión de servicio DTH, SOT: ' ||
                                          c.codsolot || ', SID: ' || c.codinssrv ||
                                          ', mensaje: ' || p_mensaje,
                                          null,
                                          'SGA');--4.0
                  p_envia_correo_c_attach('Reconexiones DTH',
                                          'melvin.balcazar@claro.com.pe',--4.0
                                          'No se completó con éxito el envío del comando de reconexión de servicio DTH, SOT: ' ||
                                          c.codsolot || ', SID: ' || c.codinssrv ||
                                          ', mensaje: ' || p_mensaje,
                                          null,
                                          'SGA');--4.0
                end if;

                commit;
              end loop;
     EXCEPTION
              WHEN OTHERS THEN
                   l_var := 'OPERACION.P_EJECUTA_WORKFLOW_RECONEXIÓN_DTH - ÚLTIMA SOT EVALUADA: ' || p_codsolot ||
                 ' Revisar el JOB - Problema presentado: : ' || sqlerrm;

     END;
     if trim(l_var) <> '' then
           opewf.pq_send_mail_job.p_send_mail('Revisar JOB - atención automática de WFs de reconexión DTH',
                                           'DL-PE-ITSoportealNegocio@claro.com.pe',--4.0
                                           l_var);
     end if;

END;

/**********************************************************************
Confirma la ejecución en Chile de las transacciones de servicios DTH
**********************************************************************/
PROCEDURE p_verif_sol_corte
   is

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_DTH_WF.P_VERIF_SOL_CORTE';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='962';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------




 p_resultado         varchar2(20);
 p_mensaje           varchar2(1000);

 l_estado operacion.reginsdth.estado%TYPE;
 l_sot_corte solot.codsolot%TYPE;

 cursor c_numregins is
 select * from operacion.reginsdth
 where estado = '13'
 --REQ-89813
 and (flg_recarga is null or flg_recarga <> 1)
 order by numregistro;

 BEGIN

  FOR  c_numreginsconax IN c_numregins loop
    p_resultado := '';
    p_mensaje := '';
    operacion.pq_dth.p_proc_recu_filesxcli(c_numreginsconax.numregistro, 3, p_resultado,p_mensaje);
    commit;

-- Inicio corrección G. Ormeño 05/08/2008
    select estado into l_estado from operacion.reginsdth where numregistro =  c_numreginsconax.numregistro;

    select max(t.codsolot) into l_sot_corte
    from operacion.tmp_corte_dth t, solot s
    where t.pid = c_numreginsconax.pid
    and s.codsolot = t.codsolot
    and s.tiptra = 425
    and t.estado = 3 ;
-- Fin corrección G. Ormeño 05/08/2008

    if p_resultado = 'OK' and l_estado = '16' then
       operacion.p_ejecuta_activ_desactiv(l_sot_corte, 299 , sysdate);
       update operacion.tmp_corte_dth set estado = 4 where codsolot = l_sot_corte; -- procedimiento de CORTE ejecutado con éxito
    else
       p_envia_correo_c_attach('Cortes DTH',
                                          'joseramos.creo@claro.com.pe',--4.0
                                          'No se completó la verificación del corte  de servicio DTH, SOT de corte: ' ||
                                          l_sot_corte || ', PID: ' || c_numreginsconax.pid ||
                                          ', mensaje: ' || p_mensaje,
                                          null,
                                          'SGA');--4.0
       p_envia_correo_c_attach('Cortes DTH',
                                          'melvin.balcazar@claro.com.pe',--4.0
                                          'No se completó la verificación del corte  de servicio DTH, SOT de corte: ' ||
                                          l_sot_corte || ', PID: ' || c_numreginsconax.pid ||
                                          ', mensaje: ' || p_mensaje,
                                          null,
                                          'SGA');--4.0

    end if;

  END LOOP;


  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
  sp_rep_registra_error
     (c_nom_proceso, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);

  ------------------------
  exception
    when others then
        sp_rep_registra_error
           (c_nom_proceso, c_id_proceso,
            sqlerrm , '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);

  END p_verif_sol_corte;


/**********************************************************************
Confirma la ejecución en Chile de las transacciones de servicios DTH
**********************************************************************/
PROCEDURE p_verif_sol_reconexion
   is

/*------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_DTH_WF.P_VERIF_SOL_RECONEXION';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='963';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------*/


 p_resultado         varchar2(20);
 p_mensaje           varchar2(1000);

 l_estado operacion.reginsdth.estado%TYPE;
 l_sot_rec solot.codsolot%TYPE;

 cursor c_numregins is
 select * from operacion.reginsdth
 where estado = '14'
 --REQ-89813
 and (flg_recarga is null or flg_recarga <> 1)
 order by numregistro;

 BEGIN

  FOR  c_numreginsconax IN c_numregins loop
    p_resultado := '';
    p_mensaje := '';

    operacion.pq_dth.p_proc_recu_filesxcli(c_numreginsconax.numregistro, 4, p_resultado,p_mensaje);
    commit;

    select estado into l_estado from operacion.reginsdth where numregistro =  c_numreginsconax.numregistro;
-- Inicio corrección G. Ormeño 05/08/2008

    select max(t.codsolot) into l_sot_rec
    from operacion.tmp_corte_dth t, solot s
    where t.pid = c_numreginsconax.pid
    and s.codsolot = t.codsolot
    and s.tiptra = 428
    and t.estado = 3 ;
-- Fin corrección G. Ormeño 05/08/2008

    if p_resultado = 'OK' and l_estado = '17' then
       operacion.p_ejecuta_activ_desactiv(l_sot_rec, 299 , sysdate);
       update operacion.tmp_corte_dth set estado = 4 where codsolot = l_sot_rec; -- procedimiento de RECONEXIÓN ejecutado con éxito
    else
       p_envia_correo_c_attach('Reconexión DTH',
                                          'joseramos.creo@claro.com',--4.0
                                          'No se completó la verificación de la reconexión de servicio DTH, SOT de reconexión: ' ||
                                          l_sot_rec || ', PID: ' || c_numreginsconax.pid ||
                                          ', mensaje: ' || p_mensaje,
                                          null,
                                          'SGA');--4.0
       p_envia_correo_c_attach('Reconexión DTH',
                                          'melvin.balcazar@claro.com.pe',--4.0
                                          'No se completó la verificación de la reconexión de servicio DTH, SOT de reconexión: ' ||
                                          l_sot_rec || ', PID: ' || c_numreginsconax.pid ||
                                          ', mensaje: ' || p_mensaje,
                                          null,
                                          'SGA');--4.0
    end if;

  END LOOP;

  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
/*  sp_rep_registra_error
     (c_nom_proceso, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);*/

  ------------------------
/*  exception
    when others then
        sp_rep_registra_error
           (c_nom_proceso, c_id_proceso,
            --sqlerrm , '1',c_sec_grabacion );
        sqlerrm||' error(lineas) '||DBMS_UTILITY.format_error_backtrace, '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);*/
  END p_verif_sol_reconexion;

END PQ_DTH_WF;
/


