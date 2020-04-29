CREATE OR REPLACE PROCEDURE ADMINJOB.ALINEACION_JANUS IS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CONT_REGULARIZACION.SP_ALINEACION_JANUS_JOB';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='53588';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
begin
OPERACION.PQ_CONT_REGULARIZACION.SP_ALINEACION_JANUS_JOB;
    commit;
    soporte.sp_rep_registra_error_job
       (c_nom_proceso, c_id_proceso,
          sqlerrm , '0', c_sec_grabacion);
exception
  when others then
      soporte.sp_rep_registra_error_job
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
end ALINEACION_JANUS;
/
