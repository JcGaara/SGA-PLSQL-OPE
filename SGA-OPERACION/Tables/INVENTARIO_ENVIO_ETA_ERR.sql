create table OPERACION.INVENTARIO_ENVIO_ETA_ERR
(
  id_recurso_ext   NUMBER(8) not null,
  fecha_inventario DATE not null,
  flg_rpta         NUMBER,
  des_error        VARCHAR2(600),
  usureg           VARCHAR2(50) default USER,
  fecreg           DATE default SYSDATE,
  usumod           VARCHAR2(50) default USER,
  fecmod           DATE default SYSDATE
)
tablespace OPERACION_DAT;

-- Add comments to the columns 
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.id_recurso_ext   is 'DNI del Técnico';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.fecha_inventario  is 'Fecha de Inventario';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.flg_rpta  is 'Flag de Respuesta ';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.des_error  is 'Observaciones';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.usureg  is 'Usuario creación';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.fecreg  is 'Fecha de creación';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.usumod  is 'Usuario modificación';
comment on column OPERACION.INVENTARIO_ENVIO_ETA_ERR.fecmod  is 'Fecha de Modificación';