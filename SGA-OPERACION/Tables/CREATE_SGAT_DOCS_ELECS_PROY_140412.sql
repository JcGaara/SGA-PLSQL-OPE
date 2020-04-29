-- Create table
create table OPERACION.SGAT_DOCS_ELECS
(
  adjn_documento_id     NUMBER not null,
  adjv_tipdoc           CHAR(3),
  adjv_sersut           VARCHAR2(5),
  adjv_numsut           CHAR(8),
  adjv_nombre_arch      VARCHAR2(60),
  adjc_tipo_lote        CHAR(3),
  adjv_estado           CHAR(1),
  adjv_observacion      VARCHAR2(200),
  adjd_fecha_registro   DATE,
  adjv_usuario_registro VARCHAR2(20)
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
comment on column OPERACION.SGAT_DOCS_ELECS.adjn_documento_id
  is 'ID SEQUENCIA SGAT_DOCS_ELECS_S';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_tipdoc
  is 'TIPO DE DOCUMENTO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_sersut
  is 'SERIE DE DOCUMENTO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_numsut
  is 'NUMERO DE DOCUMENTO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_nombre_arch
  is 'NOMBRE DE ARCHIVO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjc_tipo_lote
  is 'TIPO DE LOTE ENTREGADO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_estado
  is 'ESTADO DEL DOCUMENTO 1|ENVIADO 2|PENDIENTE 3|ERROR';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_observacion
  is 'DETALLE DEL ESTADO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjd_fecha_registro
  is 'FECHA REGISTRO';
comment on column OPERACION.SGAT_DOCS_ELECS.adjv_usuario_registro
  is 'USUARIO REGISTRO';
