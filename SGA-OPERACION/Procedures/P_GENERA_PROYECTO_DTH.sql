CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_PROYECTO_DTH
is
/* Modificado Mbalcazar 29/08/2008 : Inicio
p_resultado varchar2(30);
p_mensaje   varchar2(300);
p_fecini    varchar2(12);
p_fecfin    varchar2(12);
Modificado Mbalcazar: Fin 29/08/2008 */
------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso

LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_GENERA_PROYECTO_DTH';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='1142';
c_sec_grabacion float:=

fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
------------------------------------
/* Modificado Mbalcazar 29/08/2008 : Inicio
cursor c_tmp_no_valido is
select numregistro,idpaq,idtarjeta from reginsdth
where estado = '02'
and flg_facturable=1
and flg_validado=0
and trunc(fecusumod) = trunc(sysdate)
and codsolot is null;
Modificado Mbalcazar: Fin 29/08/2008 */

begin

     --Generación Automática de Proyectos
     SALES.P_GENERA_PRYOPE_DTH;


/* Modificado Mbalcazar 29/08/2008 : Inicio
    -Se cambio el criterio de validacion para la generacion de proyectos - Sol. Rafael Dominguez

     select TO_CHAR(trunc(sysdate,'MM'),'yyyymmdd') || '0000' into p_fecini  from dual;
     select TO_CHAR(trunc(last_day(sysdate)),'yyyymmdd') || '0000' into p_fecfin from dual;

    --Cambio de Estado de los Registros de Instalación con Flag de validación igual a 0

     for c_reg in c_tmp_no_valido loop
        update operacion.reginsdth set estado = '01'
        where numregistro = c_reg.numregistro;

        commit;
        --Desactivación de los Bouquets de la Tarjeta
        operacion.pq_dth.p_baja_serviciodthxcliente(c_reg.idpaq,p_fecini,p_fecfin,c_reg.numregistro,c_reg.idtarjeta,p_resultado,p_mensaje);

     end loop;

Modificado Mbalcazar: Fin 29/08/2008 */

-- Este codigo se debe poner en todos los stores que se llaman con unjob para ver si termino satisfactoriamente

/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);
------------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/
      
end;
/


