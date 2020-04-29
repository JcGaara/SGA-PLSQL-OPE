-- Create table
create table OPERACION.SGAT_QUERY_HIS
(
  codquery NUMBER(8) not null,
  area     NUMBER(4) not null,
  tipo     NUMBER(1) not null,
  codusu   VARCHAR2(30) default user not null,
  fecusu   DATE default SYSDATE not null,
  querys   CLOB
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column OPERACION.SGAT_QUERY_HIS.codquery
  is 'Código de la consulta';
comment on column OPERACION.SGAT_QUERY_HIS.area
  is 'Area a la cual pertenece la consulta';
comment on column OPERACION.SGAT_QUERY_HIS.tipo
  is 'Tipo de Consulta: 1 = reporte / 0 = Control de Tareas';
comment on column OPERACION.SGAT_QUERY_HIS.codusu
  is 'Usuario de registro';
comment on column OPERACION.SGAT_QUERY_HIS.fecusu
  is 'Fecha de registro';
comment on column OPERACION.SGAT_QUERY_HIS.querys
  is 'Consulta para el DataWindow';