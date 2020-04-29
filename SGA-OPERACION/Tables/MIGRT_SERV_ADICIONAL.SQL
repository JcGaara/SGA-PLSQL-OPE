create table OPERACION.MIGRT_SERV_ADICIONAL
(
  datan_id              NUMBER(10) not null,
  datac_idsrv_sga       CHAR(4),
  datav_eq_idsrv_sisact VARCHAR2(5),
  datan_eq_plan_sisact  NUMBER
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

comment on table OPERACION.MIGRT_SERV_ADICIONAL
  is 'TABLA DE SERVICIOS ADICIONALES PARA MIGRACION SGA BSCS';
comment on column OPERACION.MIGRT_SERV_ADICIONAL.datac_idsrv_sga
  is 'codigo de servicio adicional SGA';
comment on column OPERACION.MIGRT_SERV_ADICIONAL.datav_eq_idsrv_sisact
  is 'codigo de servicio adicional equivalente SISACT';

alter table OPERACION.MIGRT_SERV_ADICIONAL
  add constraint PK_MIGRT_IDSRV primary key (DATAN_ID)
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