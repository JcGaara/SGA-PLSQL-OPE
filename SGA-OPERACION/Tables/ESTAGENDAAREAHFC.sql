create table OPERACION.ESTAGENDAAREAHFC
(
  tiptra          NUMBER not null,
  areaini         NUMBER not null,
  areafin         NUMBER not null,
  estagendaini    NUMBER not null,
  estagendafin    NUMBER not null,
  aplica_bitacora NUMBER default 1,
  ipapp           VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp      VARCHAR2(30) default USER,
  fecusu          DATE default SYSDATE,
  pcapp           VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
comment on table OPERACION.ESTAGENDAAREAHFC
  is 'Secuencia estados agenda y area';
comment on column OPERACION.ESTAGENDAAREAHFC.tiptra
  is 'Tipo de trabajo';
comment on column OPERACION.ESTAGENDAAREAHFC.areaini
  is 'area inicial';
comment on column OPERACION.ESTAGENDAAREAHFC.areafin
  is 'area final';
comment on column OPERACION.ESTAGENDAAREAHFC.estagendaini
  is 'estado agenda inicial';
comment on column OPERACION.ESTAGENDAAREAHFC.estagendafin
  is 'estado agenda final';
comment on column OPERACION.ESTAGENDAAREAHFC.aplica_bitacora
  is 'Bitacora';
comment on column OPERACION.ESTAGENDAAREAHFC.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.ESTAGENDAAREAHFC.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.ESTAGENDAAREAHFC.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.ESTAGENDAAREAHFC.pcapp
  is 'PC Aplicacion';
alter table OPERACION.ESTAGENDAAREAHFC
  add constraint PK_ESTAGENDAAREAHFC01 primary key (TIPTRA, AREAINI, AREAFIN, ESTAGENDAINI, ESTAGENDAFIN)
  using index 
  tablespace OPERACION_DAT;
