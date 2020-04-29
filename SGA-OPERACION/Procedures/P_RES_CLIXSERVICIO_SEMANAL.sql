CREATE OR REPLACE PROCEDURE OPERACION.P_res_clixservicio_semanal ( a_fecha in date default sysdate) IS


------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_RES_CLIXSERVICIO_SEMANAL';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='343';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
  --------------------------------------------------


tmpVar NUMBER;
/******************************************************************************
******************************************************************************/
BEGIN

	insert into res_clixservicio_semanal (TIPSRV, DESC_SERVICIO, CANTIDAD, FECHA)
	select tipsrv tipo, servicio , count(*) cantidad, a_fecha
	 from V_SERVICIO_X_CLIENTE
	group by tipsrv, servicio;
    commit;


  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
  /*
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
    */
END;
/


