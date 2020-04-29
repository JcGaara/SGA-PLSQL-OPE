create table OPERACION.MIGRT_ERROR_MIGRACION
(
  datan_id      NUMBER(10) not null,
  datan_idcab   NUMBER(10),
  datav_numdoc  VARCHAR2(15),
  datan_solot   NUMBER(8),
  datav_proceso VARCHAR2(10),
  datav_destino VARCHAR2(2000),
  datav_asunto  VARCHAR2(500),
  datav_mensaje VARCHAR2(1000),
  datav_usureg  VARCHAR2(30) default USER not null,
  datad_fecreg  DATE default SYSDATE not null
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

comment on column OPERACION.MIGRT_ERROR_MIGRACION.datan_id
  is 'IDENTIFICADOR DE LA TABLA';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datav_numdoc
  is 'DNI DEL CLIENTE';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datan_solot
  is 'SOT: DE BAJA O DE ALTA';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datav_proceso
  is 'TIPO DE PROCESO: BAJA, SISACT, ALTA, IW';  
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datav_destino
  is 'DESTINATARIOS DEL MENSAJE ENVIADO';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datav_asunto
  is 'ASUNTO DEL MENSAJE ENVIADO';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datav_mensaje
  is 'DETALLE DEL MENSAJE ENVIADO';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datav_usureg
  is 'USUARIO CREACION';
comment on column OPERACION.MIGRT_ERROR_MIGRACION.datad_fecreg
  is 'FECHA CREACION';

alter table OPERACION.MIGRT_ERROR_MIGRACION
  add constraint PK_MIGRT_ID primary key (DATAN_ID)
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
