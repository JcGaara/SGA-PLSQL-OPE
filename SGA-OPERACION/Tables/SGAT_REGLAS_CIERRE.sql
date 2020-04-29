-- Create table
create table OPERACION.SGAT_REGLAS_CIERRE
(
  regcn_estage_inicial NUMBER(3) not null,
  regcn_estage_final   NUMBER(3) not null,
  regcv_accion         VARCHAR2(100) not null,
  regcv_estado         CHAR(1) default '1' not null,
  regcv_usuario_reg    VARCHAR2(50) default user not null,
  regcd_fecha_reg      DATE default sysdate not null,
  regcv_usuario_act    VARCHAR2(50),
  regcd_fecha_act      DATE
)
tablespace OPERACION_DAT
;

-- Add comments to the columns 
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcn_estage_inicial
  is 'Estado de agendamiento inicial';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcn_estage_final
  is 'Estado de agendamiento final';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcv_accion
  is 'Acción';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcv_estado
  is 'Estado lógico del registro:
1: Activo
0: Inactivo
';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcv_usuario_reg
  is 'Usuario de registro';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcd_fecha_reg
  is 'Fecha de registro ';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcv_usuario_act
  is 'Usuario de actualización';
comment on column OPERACION.SGAT_REGLAS_CIERRE.regcd_fecha_act
  is 'Fecha de actualización';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_REGLAS_CIERRE
  add constraint FK_REGLAS_CIERRE_ESTAGENDA_1 foreign key (REGCN_ESTAGE_INICIAL)
  references OPERACION.ESTAGENDA (ESTAGE);
alter table OPERACION.SGAT_REGLAS_CIERRE
  add constraint FK_REGLAS_CIERRE_ESTAGENDA_2 foreign key (REGCN_ESTAGE_FINAL)
  references OPERACION.ESTAGENDA (ESTAGE);
