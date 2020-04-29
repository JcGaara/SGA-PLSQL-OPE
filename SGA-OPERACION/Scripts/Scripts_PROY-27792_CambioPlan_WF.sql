--Script
declare
  ln_max_tareadef   number;
  ln_max_tareawfdef number;
  ln_tarea          number;
  ln_count          number;
begin
  --insertar la definicion de la tarea
  SELECT count(1) into ln_count FROM opewf.tareadef where descripcion = 'Cambio de Plan JANUS';
  
  IF ln_count = 0 THEN
    select max(tareadef) + 1 into ln_max_tareadef from opewf.tareadef;

    insert into opewf.tareadef (TAREADEF, TIPO, DESCRIPCION, PRE_PROC, CUR_PROC, CHG_PROC, POS_PROC, PRE_MAIL, POS_MAIL, FLG_FT, FLG_WEB, SQL_VAL)
    values (ln_max_tareadef, 2, 'Cambio de Plan JANUS', 'operacion.pq_siac_cambio_plan.SGASI_REGISTRO_JANUS', null, null, null, null, null, 0, null, null);
  END IF;
  --insertar tarea en workflow HFC (cambio de plan)
  SELECT count(1) into ln_count FROM opewf.tareawfdef where descripcion = 'Cambio de Plan JANUS';
  
  IF ln_count = 0 THEN
    select max(tarea) + 1 into ln_max_tareawfdef from opewf.tareawfdef;
    select tarea into ln_tarea from opewf.tareawfdef where descripcion = 'Asignar Número Telefónico CP' and wfdef = 1286;

    insert into opewf.tareawfdef (TAREA, DESCRIPCION, ORDEN, TIPO, AREA, RESPONSABLE, WFDEF, TAREADEF, PRE_MAIL, POS_MAIL, PRE_TAREAS, POS_TAREAS, PLAZO, ESTADO, FECREG, USUREG, AREA_FACTIBILIDAD, AGRUPA, FRECUENCIA, FLGANULAR, FLGCONDICION, CONDICION, REGLA_ASIG_CONTRATA, REGLA_ASIG_FECPROG, AREA_DERIVA_CORREO, TIPO_AGENDA, FLG_ASIGNAAREA, F_ASIGNAAREA, FLG_OPC, SQL_CONDICION_TAREA)
    values (ln_max_tareawfdef, 'Cambio de Plan JANUS', 0, 2, 330, null, 1286, ln_max_tareadef, null, null, ln_tarea, null, 1.00, 1, sysdate, user, null, null, null, 0, 0, null, null, null, null, null, null, null, 0, null);
    
    update opewf.tareawfdef set pos_tareas = pos_tareas||';'||ln_max_tareawfdef  where tarea = ln_tarea;
  END IF;
  
  update opewf.tareadef set pre_proc = 'operacion.pq_siac_cambio_plan.SGASI_GEST_RECURSOS' where tareadef = 1020;
  commit;
end;
/
