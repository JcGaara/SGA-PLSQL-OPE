-- Create table
create table OPERACION.AREAOPE_QUERY
(
  codquery    NUMBER(8) not null,
  area        NUMBER(4) not null,
  descripcion VARCHAR2(100),
  tipo        NUMBER(1) default 1 not null,
  estado      NUMBER(1) default 1 not null,
  codusu      VARCHAR2(30) default user not null,
  fecusu      DATE default SYSDATE not null,
  flgcc       NUMBER(1) default 0,
  descabr     VARCHAR2(100),
  contrata    NUMBER default 0,
  syntaxdw    CLOB,
  querys      CLOB,
  filtrodw    CLOB
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
comment on column OPERACION.AREAOPE_QUERY.codquery
  is 'Código correlativo de la consulta';
comment on column OPERACION.AREAOPE_QUERY.area
  is 'Area a la cual pertenece la consulta';
comment on column OPERACION.AREAOPE_QUERY.descripcion
  is 'Descripción de l a consulta';
comment on column OPERACION.AREAOPE_QUERY.tipo
  is 'Tipo de Consulta: 1 = reporte / 0 = Control de Tareas';
comment on column OPERACION.AREAOPE_QUERY.estado
  is 'Estado de la consulta';
comment on column OPERACION.AREAOPE_QUERY.codusu
  is 'Usuario de registro';
comment on column OPERACION.AREAOPE_QUERY.fecusu
  is 'Fecha de registro';
comment on column OPERACION.AREAOPE_QUERY.syntaxdw
  is 'Código para crear el DataWindow';
comment on column OPERACION.AREAOPE_QUERY.querys
  is 'Consulta para crear el DataWindow';
comment on column OPERACION.AREAOPE_QUERY.filtrodw
  is 'Código para crear el Filtro que utilizará el DataWindow';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.AREAOPE_QUERY
  add constraint PK_AREAOPE_QUERY primary key (CODQUERY, AREA)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );