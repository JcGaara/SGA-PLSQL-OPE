-- Create table
create table OPERACION.SGAT_PORTOUTCORPLOG
(
  pocn_numero      NUMBER,
  pocv_cliente     VARCHAR2(8),
  pocv_tip_linea   VARCHAR2(12),
  pocv_tip_portout VARCHAR2(12),
  pocv_mensaje     VARCHAR2(400)
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
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocn_numero
  is 'Número de OPERACION.SGAT_PORTOUTCORPLOG';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocv_cliente
  is 'Código del cliente';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocv_tip_linea
  is 'Tipo de Linea';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocv_tip_portout
  is 'Tipo de Port Out';
comment on column OPERACION.SGAT_PORTOUTCORPLOG.pocv_mensaje
  is 'Mensaje.';
