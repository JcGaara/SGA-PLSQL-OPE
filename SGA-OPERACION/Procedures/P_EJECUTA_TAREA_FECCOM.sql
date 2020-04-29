CREATE OR REPLACE PROCEDURE OPERACION.P_EJECUTA_TAREA_FECCOM
is
/********************************************************************************
  NOMBRE: P_EJECUTA_TAREA_FECCOM

  Creacion
  Ver     Fecha          Autor              Descripcion
 ------  ----------  ----------            --------------------
  1.0     27/10/2009  Hector Huaman M.    REQ-107236:procedimiento que cierra la tarea de activacion del servicio segun la fecha de compromiso
********************************************************************************/
------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='operacion.P_EJECUTA_TAREA_FECCOM';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
------------------------------------
ll_wfdef      wf.wfdef%type;
ll_fechaactual date;
ll_validaactiv number;
cursor c_tmp is
select s.feccom, s.codsolot, t.idtareawf
  from solot s, tareawf t, wf w
 where s.codsolot = w.codsolot
   and w.valido = 1
   and w.idwf = t.idwf
   and s.feccom is not null
   and w.wfdef = ll_wfdef
   and t.tareadef = 299
   and t.esttarea = 1;


begin
  begin
  select TO_NUMBER(VALOR)
    into ll_wfdef
    from constante
   where constante = 'TAREA_PROG';
  exception
    when no_data_found then
     ll_wfdef := NULL;
    end;

  ll_fechaactual:=sysdate;

 for lc_tmp in c_tmp loop
  select count(1)
    into ll_validaactiv
    from trssolot
   where codsolot = lc_tmp.codsolot;

   if (trunc(lc_tmp.feccom) <= trunc(ll_fechaactual)) and (ll_validaactiv >0) then
      opewf.pq_wf.P_CHG_STATUS_TAREAWF(lc_tmp.idtareawf,4,4,0,lc_tmp.feccom,lc_tmp.feccom);
   end if;
  end loop;

-- Este codigo se debe poner en todos los stores que se llaman con un job para ver si termino satisfactoriamente
sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);
------------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
end;
/


