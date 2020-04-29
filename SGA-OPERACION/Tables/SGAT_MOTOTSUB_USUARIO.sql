-- Create table
create table OPERACION.SGAT_MOTOTSUB_USUARIO
(
  motuv_region   VARCHAR2(30) not null,
  motun_codmotot NUMBER not null,
  motun_submotot NUMBER not null,
  motuv_usureg   VARCHAR2(30) default user not null,
  motud_fecreg   DATE default sysdate not null,
  motuv_usumod   VARCHAR2(30) default user,
  motud_fecmod   DATE default sysdate
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
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motuv_region
  is 'Region: CAE_LIMA, CAE_SUR y CAE_NORTE';
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motun_codmotot
  is 'Codigo de motivo de orden de trabajo de postventa';
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motun_submotot
  is 'Codigo de submotivo de orden de trabajo de postventa';
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motuv_usureg
  is 'Usuario que registro';
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motud_fecreg
  is 'Fecha que se registro';
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motuv_usumod
  is 'Usuario que Modifica';
comment on column OPERACION.SGAT_MOTOTSUB_USUARIO.motud_fecmod
  is 'Fecha que se Modifica';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_MOTOTSUB_USUARIO
  add constraint PK_SGAT_MOTOTSUB_USUARIO primary key (MOTUV_REGION, MOTUN_CODMOTOT, MOTUN_SUBMOTOT)
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
alter table OPERACION.SGAT_MOTOTSUB_USUARIO
  add constraint FK_CODMOT foreign key (MOTUN_CODMOTOT)
  references OPERACION.MOTOT (CODMOTOT);
alter table OPERACION.SGAT_MOTOTSUB_USUARIO
  add constraint FK_SUBMOT foreign key (MOTUN_SUBMOTOT)
  references OPERACION.SGAT_MOTOTSUB (MOTON_SUBMOTOT);