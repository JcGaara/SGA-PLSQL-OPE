create table OPERACION.MIGRT_CLIENTES_A_MIGRAR
(  datac_codcli     CHAR(8) not null,
  datad_fec_baja   DATE default SYSDATE,
  datad_fec_alta   DATE default SYSDATE,
  datad_fec_janus  DATE default SYSDATE,
  datac_tipoagenda CHAR(2),
  datan_campon     NUMBER(10),
  datav_campov     VARCHAR2(500)
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
