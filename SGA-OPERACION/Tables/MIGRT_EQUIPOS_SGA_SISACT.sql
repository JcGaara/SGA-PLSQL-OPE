create table OPERACION.MIGRT_EQUIPOS_SGA_SISACT
(
  datan_id              NUMBER(10) not null,
  datac_idequ_sga       CHAR(4),
  datav_eq_idequ_sisact VARCHAR2(10),
  datan_tipequ          NUMBER(6)
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

alter table OPERACION.MIGRT_EQUIPOS_SGA_SISACT
  add constraint PK_EQUIPOS_SGA_SISACT primary key (DATAN_ID);
