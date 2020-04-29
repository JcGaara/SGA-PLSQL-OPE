
create table OPERACION.TRS_PPTO_DET
(
  idseq         NUMBER not null,
  tipo          NUMBER(1),
  total         NUMBER(15,2),
  manparno      VARCHAR2(40),
  procesado     VARCHAR2(1),
  codsolot      NUMBER,
  pep           VARCHAR2(40),
  proveedor_sap VARCHAR2(30),
  centro        VARCHAR2(4),
  almacen       VARCHAR2(4),
  punto         NUMBER,
  orden         NUMBER,
  ipaplicacion  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion  VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu        VARCHAR2(30) default user,
  fecusu        DATE default sysdate,
  idloteppto    NUMBER,
  idppto        NUMBER
)
tablespace OPERACION_DAT;
-- Create/Recreate indexes 
create index OPERACION.IDK_TRS_PPTO_DET001 on OPERACION.TRS_PPTO_DET (TIPO, PEP, PROVEEDOR_SAP)
  tablespace OPERACION_IDX;
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRS_PPTO_DET
  add constraint PK_TRS_PPTO_DET primary key (IDSEQ);
