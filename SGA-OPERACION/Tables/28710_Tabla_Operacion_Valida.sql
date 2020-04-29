-- Create table
create table OPERACION.SGAS_CONF_VALIDASOT
(
  covsv_id        NUMBER not null,
  covsv_estbscs   VARCHAR2(5) not null,
  covsv_tiptra    NUMBER(4) not null,
  covsv_tipestsol NUMBER(2) not null,
  covsv_estsol    NUMBER(2),
  covsv_estsolnew NUMBER(2),
  covsv_estsrvnew NUMBER(2),
  covsv_estado    NUMBER(2),
  covsv_codusu    VARCHAR2(30) default USER,
  covsv_fecusu    DATE default SYSDATE,
  covsv_dias      NUMBER(8) default 0
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
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_id
  is 'ID_CORRELATIVO';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_estbscs
  is 'ESTADO QUE DEVUELVE BSCS O, A, S, D';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_tiptra
  is 'TIPO DE TRABAJO DE LA SOT';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_tipestsol
  is 'TIPO DE ESTADO DE LA SOT';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_estsol
  is 'ESTADO DE LA SOT';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_estsolnew
  is 'NUEVO ESTADO DE LA SOT';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_estsrvnew
  is 'NUEVO ESTADO DE LOS SERVICIOS Y PRODUCTOS';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_estado
  is 'ESTADO DE LA CONFIGURACIÓN (0 ANULADO / 1 ACTIVO)';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_codusu
  is 'CODIGO DEL USUARIO QUE REALIZO EL REGISTRO';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_fecusu
  is 'FECHA EN LA QUE SE REALIZO EL REGISTRO';
comment on column OPERACION.SGAS_CONF_VALIDASOT.covsv_dias
  is 'CONFIGURACION DE DIAS';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAS_CONF_VALIDASOT
  add constraint PK_SGAS_CONF_VALIDASOT primary key (COVSV_ID)
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
