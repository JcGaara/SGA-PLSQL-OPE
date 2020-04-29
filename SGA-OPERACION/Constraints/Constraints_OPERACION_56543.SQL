-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MENSAJE_DTH_CAB
  add constraint PK_MENSAJE_DTH_CAB primary key (IDARCH)
  using index 
  tablespace OPERACION_IDX
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

alter table OPERACION.MENSAJE_DTH_DET
  add constraint PK_MENSAJE_DTH_DET primary key (IDARCH, CODTARJ)
  using index 
  tablespace OPERACION_IDX
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
  
alter table OPERACION.MENSAJE_DTH_DET
  add constraint FK_MENSAJE_DTH_DET foreign key (IDARCH)
  references OPERACION.MENSAJE_DTH_CAB (IDARCH);
  

alter table OPERACION.TAB_ARCH_MSG_DTH
  add constraint PK_TAB_ARCH_MSG_DTH primary key (ID_ARCHIVO, NOMBRE_FILE)
  using index 
  tablespace OPERACION_IDX
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
   
alter table OPERACION.TAB_ARCH_TMP
  add constraint PK_TAB_ARCH_TMP primary key (ID_ARCHIVO)
  using index 
  tablespace OPERACION_IDX
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
  
alter table OPERACION.TIP_MENSAJE
  add constraint PK_OPE_TIP_MENSAJE primary key (IDTIPMENS)
  using index 
  tablespace OPERACION_IDX
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