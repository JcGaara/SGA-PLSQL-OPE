create table OPERACION.MIGRT_EQU_SGA_SISACT
(
  datan_id              NUMBER(10) not null,
  datac_idsrv_sga       CHAR(4),
  datan_monto_sga       NUMBER(18,4),
  datav_eq_idsrv_sisact VARCHAR2(5),
  datan_monto_sisact    NUMBER(18,4),
  datac_eq_idsrv_sga    CHAR(4),
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
  
  alter table OPERACION.MIGRT_EQU_SGA_SISACT
  add constraint PK_MIGRT_IDEQUI primary key (DATAN_ID);
