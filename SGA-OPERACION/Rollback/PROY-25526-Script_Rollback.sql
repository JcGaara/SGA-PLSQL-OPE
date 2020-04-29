--Rollback
drop index OPERACION.IX_SGAT_ERROR_CAM_CICLO_001;
drop index OPERACION.IX_SGAT_ERROR_CAM_CICLO_002;
revoke select, insert, update, delete on OPERACION.SGAT_ERROR_CAM_CICLO from R_PROD;
drop table OPERACION.SGAT_ERROR_CAM_CICLO;
drop package OPERACION.PKG_CAMBIO_CICLO_FACT;


declare
begin
  --actualizar tareas de workflows DTH
  update opewf.tareadef td
     set td.chg_proc = ''
   where td.tareadef in (1144);
   
  commit;
end;
/