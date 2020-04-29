create table OPERACION.MIGRT_AGENDAMIENTO
(  datan_id         NUMBER(10) not null,
  datac_codcli     CHAR(8),
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
  
   alter table OPERACION.MIGRT_AGENDAMIENTO
  add constraint PK_MIGRT_AGEN primary key (DATAN_ID);
