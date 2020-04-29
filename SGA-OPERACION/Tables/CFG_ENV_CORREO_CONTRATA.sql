-- Crear Tabla
create table OPERACION.CFG_ENV_CORREO_CONTRATA
(
  IDCFG         NUMBER not null,
  FASE          VARCHAR2(30),
  NOMARCH       VARCHAR2(100),
  CUERPO        VARCHAR2(4000),
  QUERY         VARCHAR2(4000),
  CABECERA      VARCHAR2(300),
  DETALLE1      VARCHAR2(4000),
  DETALLE2      VARCHAR2(4000),
  CANT_COLUMNAS NUMBER default 0,
  GRUPO         VARCHAR2(300),
  TABLA         VARCHAR2(300),
  ESTADO        NUMBER default 1,
  FECUSU        DATE default SYSDATE,
  CODUSU        VARCHAR2(30) default USER
) ;
-- Comentarios
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.IDCFG
  is 'Id Configuracion';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.FASE
  is 'Fase o tipo';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.ESTADO
  is 'Estado de configuracion';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.NOMARCH
  is 'Nombre de archivo';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.CUERPO
  is 'Cuerpo de Correo';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.QUERY
  is 'Query de Caso';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.CABECERA
  is 'Cabecera de Correo';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.DETALLE1
  is 'Primer Detalle';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.DETALLE2
  is 'Segundo Detalle';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.CANT_COLUMNAS
  is 'Cantidad de Columnas a tomar por el proceso';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.FECUSU
  is 'Fecha Registro';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.CODUSU
  is 'Usuario Registro';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.GRUPO
  is 'Grupo de Envio';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.TABLA
  is 'Tabla';

-- Crear PK
alter table OPERACION.CFG_ENV_CORREO_CONTRATA
  add constraint PK_IDCFG_ENV_CORREO primary key (IDCFG) ;