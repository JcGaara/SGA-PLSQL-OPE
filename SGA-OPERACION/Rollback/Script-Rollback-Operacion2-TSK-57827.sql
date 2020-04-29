/*ELIMINANDO PACKAGE*/
DROP PACKAGE ATCCORP.PQ_DTH_PAREO;

DROP PACKAGE OPERACION.SFTP;
/*ELIMINANDO JAVA*/
DROP JAVA SOURCE OPERACION.OPE_SFTP;

/*ELIMINANDO TABLAS*/
DROP TABLE atccorp.atc_estado_pareo;

DROP TABLE atccorp.atc_file_pareo_dth;

DROP TABLE atccorp.atc_file_pareo_enviado;

DROP TABLE atccorp.atc_solictud_pareo;

DROP TABLE historico.atc_file_pareo_dth_log;

DROP TABLE historico.atc_solictud_pareo_log;
/*ELIMINANDO SECUENCIAS*/
DROP sequence historico.sq_atc_solicitud_pareo_log;

DROP sequence historico.sq_atc_file_pareo_dth_log;
/*ELIMINANDO TYPE ATCCORP*/
declare 
  -- Local variables here
  i_exists_obj integer;
  i_exists_tbl integer;
  v_name_obj   varchar2(100);
  v_name_tbl   varchar2(100);
  v_sql        varchar2(3200);
  v_drop       varchar2(3200);
begin
  ---Iniciando recorrido para la eliminación de los type
  for i_row in 1..8 loop
    -- Asigno los TYPE a eliminar
    if i_row=1 then
      v_name_obj := 'cliente_pareo';
      v_name_tbl := 'cliente_pareo_tbl';
    elsif i_row=2 then
      v_name_obj := 'sot_cliente_pareo';
      v_name_tbl := 'sot_cliente_pareo_tbl';    
    elsif i_row=3 then
      v_name_obj := 'servicio_cliente_pareo';
      v_name_tbl := 'servicio_cliente_pareo_tbl';
    elsif i_row=4 then
      v_name_obj := 'tarjeta_cliente_pareo';
      v_name_tbl := 'tarjeta_cliente_pareo_tbl';
    elsif i_row=5 then
      v_name_obj := 'decodificador_cliente_pareo';
      v_name_tbl := 'deco_cliente_pareo_tbl';
    elsif i_row=6 then
      v_name_obj := 'solicitud_pareo_dth';
      v_name_tbl := 'solicitud_pareo_dth_tbl';
    elsif i_row=7 then
      v_name_obj := 'file_pareo_dth';
      v_name_tbl := 'file_pareo_dth_tbl';
    else
      v_name_obj := 'conex_intraway';
      v_name_tbl := '';
    end if;
    -- Se elimina los TYPE TABLE 
    v_sql      := 'SELECT COUNT(1) FROM ALL_OBJECTS WHERE LOWER(object_name) LIKE '||CHR(39)||'%_tbl'||CHR(39);
    v_sql      := v_sql||' AND object_type='||CHR(39)||'TYPE'||CHR(39);
    if i_row = 8 then
      v_sql      := v_sql||' AND owner='||CHR(39)||'OPERACION'||CHR(39);
    else
      v_sql      := v_sql||' AND owner='||CHR(39)||'ATCCORP'||CHR(39);
    end if;
    v_sql      := v_sql||' AND  LOWER(object_name)='||CHR(39)||v_name_tbl||CHR(39);
    
    EXECUTE IMMEDIATE v_sql INTO i_exists_tbl;
    
    if i_exists_tbl <> 0 then
      v_drop    := 'DROP TYPE ATCCORP.'||v_name_tbl;
      EXECUTE IMMEDIATE v_drop;
    end if;
    -- Se elimina los TYPE OBJECT
    v_sql      := 'SELECT COUNT(1) FROM ALL_OBJECTS WHERE LOWER(object_name) LIKE '||CHR(39)||'%_pareo'||CHR(39);
    v_sql      := v_sql||' AND object_type='||CHR(39)||'TYPE'||CHR(39);
    if i_row = 8 then
      v_sql      := v_sql||' AND owner='||CHR(39)||'OPERACION'||CHR(39);
    else
      v_sql      := v_sql||' AND owner='||CHR(39)||'ATCCORP'||CHR(39);
    end if;
    v_sql      := v_sql||' AND  LOWER(object_name)='||CHR(39)||v_name_obj||CHR(39);
    
    EXECUTE IMMEDIATE v_sql INTO i_exists_obj;
    
    if i_exists_tbl <> 0 then
      if i_row = 8 then
         v_drop    := 'DROP TYPE OPERACION.'||v_name_obj;
      else
         v_drop    := 'DROP TYPE ATCCORP.'||v_name_obj;
      end if;
      EXECUTE IMMEDIATE v_drop;
    end if;
   end loop;
end;
/
/*ELIMINANDO CONFIGURACION PAREO*/
DELETE opedd WHERE tipopedd IN (SELECT tipopedd FROM tipopedd WHERE abrev LIKE 'PAREO_DTH%');
COMMIT;

DELETE tipopedd WHERE abrev LIKE 'PAREO_DTH%';
COMMIT;

/*ELIMINANDO CONFIGURACION PARAMETROS*/
delete from OPERACION.OPEDD
where TIPOPEDD in (select TIPOPEDD from OPERACION.TIPOPEDD
                   where DESCRIPCION = 'Parametros de DTH');

delete from OPERACION.TIPOPEDD
where DESCRIPCION = 'Parametros de DTH';

COMMIT;
/
/*DESABILITANDO PERMISOS*/
declare
v_seq number;
begin
  select d.seq into v_seq
    from dba_java_policy d
   where d.grantee='OPERACION' and d.name='10.245.23.41:22' and d.type_name='java.net.SocketPermission' and d.action='connect,resolve';
  dbms_java.disable_permission(v_seq);
  dbms_java.delete_permission(v_seq);

  select d.seq into v_seq
    from dba_java_policy d
   where d.grantee='OPERACION' and d.name='/home/oracle/.ssh/known_hosts' and d.type_name='java.io.FilePermission' and d.action='read';
  dbms_java.disable_permission(v_seq);
  dbms_java.delete_permission(v_seq);
  
  select d.seq into v_seq
    from dba_java_policy d
   where d.grantee='OPERACION' and d.name='/u92/oracle/peprdrac1/dth/*' and d.type_name='java.io.FilePermission' and d.action='read';
  dbms_java.disable_permission(v_seq);
  dbms_java.delete_permission(v_seq);

  select d.seq into v_seq
    from dba_java_policy d
   where d.grantee='OPERACION' and d.name='/u03/oracle/PESGAPRD/UTL_FILE/*' and d.type_name='java.io.FilePermission' and d.action='read';
  dbms_java.disable_permission(v_seq);
  dbms_java.delete_permission(v_seq);

  select d.seq into v_seq
    from dba_java_policy d
   where d.grantee='OPERACION' and d.name='<<ALL FILES>>' and d.type_name='java.io.FilePermission' and d.action='execute';
  dbms_java.disable_permission(v_seq);
  dbms_java.delete_permission(v_seq);
  
end;
/
