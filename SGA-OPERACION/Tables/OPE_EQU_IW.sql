-- Create table
create table OPERACION.OPE_EQU_IW
( ID_PRODUCTO        VARCHAR2(30) not null,
  ID_INTERFASE       VARCHAR2(30) not null,
  ID_CLIENTE         VARCHAR2(30) not null,
  IDTRANSACCION NUMBER,
  ID_ACTIVACION      VARCHAR2(100),
  MACADDRESS         VARCHAR2(100),
  SERIALNUMBER       VARCHAR2(100),
  MODELO             VARCHAR2(100),
  CODSOLOT           NUMBER,
  FECUSU  DATE default sysdate not null,
  CODUSU  VARCHAR2(30) default USER not null);
  
comment on column OPERACION.OPE_EQU_IW.ID_PRODUCTO
  is 'Id producto';
comment on column OPERACION.OPE_EQU_IW.ID_INTERFASE
  is 'Interfase';
comment on column OPERACION.OPE_EQU_IW.ID_CLIENTE
  is 'Código de cliente';
comment on column OPERACION.OPE_EQU_IW.IDTRANSACCION
  is 'ID transaccion';
comment on column OPERACION.OPE_EQU_IW.MACADDRESS
  is 'macaddress';
comment on column OPERACION.OPE_EQU_IW.SERIALNUMBER
  is 'numero de serie';
comment on column OPERACION.OPE_EQU_IW.MODELO
  is 'modelo';
comment on column OPERACION.OPE_EQU_IW.CODSOLOT
  is 'SOT';  
comment on column OPERACION.OPE_EQU_IW.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.OPE_EQU_IW.CODUSU
  is 'Usuario de registro';
 
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_EQU_IW
  add constraint PK_EQU_IW_OPE primary key (ID_PRODUCTO, ID_INTERFASE, ID_CLIENTE);