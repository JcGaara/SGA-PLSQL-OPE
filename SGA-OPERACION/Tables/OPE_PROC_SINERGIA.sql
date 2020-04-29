create table OPERACION.OPE_PROC_SINERGIA
(
  idproceso    NUMBER not null,
  proceso      VARCHAR2(30),
  fecfin       DATE,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;

comment on column OPERACION.OPE_PROC_SINERGIA.idproceso
  is 'Id Proceso';
comment on column OPERACION.OPE_PROC_SINERGIA.proceso
  is 'Proceso';
comment on column OPERACION.OPE_PROC_SINERGIA.fecfin
  is 'Fecha Fin';
comment on column OPERACION.OPE_PROC_SINERGIA.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.OPE_PROC_SINERGIA.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.OPE_PROC_SINERGIA.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.OPE_PROC_SINERGIA.fecusu
  is 'Fecha de creacion del resgitro';

alter table OPERACION.OPE_PROC_SINERGIA
  add constraint PK_OPE_PROC_SINERGIA1 primary key (IDPROCESO)
  using index 
  tablespace OPERACION_IDX;
