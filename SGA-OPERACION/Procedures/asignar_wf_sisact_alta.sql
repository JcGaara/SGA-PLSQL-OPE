CREATE OR REPLACE PROCEDURE OPERACION.asignar_wf_sisact_alta IS
  c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='operacion.pkg_asignar_wf.asignar_wf';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='53588';
  c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
begin
  operacion.pkg_asignar_wf2.asignar_wf;
  commit;
  soporte.sp_rep_registra_error_job( c_nom_proceso, c_id_proceso, sqlerrm , '0', c_sec_grabacion);
exception
  when others then
    soporte.sp_rep_registra_error_job( c_nom_proceso, c_id_proceso,sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
end asignar_wf_sisact_alta;
/
