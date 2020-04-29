-- Create table
create table OPERACION.OPE_SRV_REGINST_SISACT
(
  ID_SISACT     NUMBER(10) not null,
  NUMSEC        VARCHAR2(15),
  CODSOLOT      NUMBER(8),
  FECREGISTRO   DATE,
  BOUQUETS      VARCHAR2(1000),
  USUARIO       VARCHAR2(30),
  CODCON        NUMBER(6),
  CONTRATISTA   VARCHAR2(1000),
  INSTALADOR    VARCHAR2(1000),
  ESTSOL        NUMBER(2),
  ESTADO_SOT    VARCHAR2(100),
  TARJETA_SERIE VARCHAR2(1000),
  DECO_SERIE    VARCHAR2(1000),
  FECUSU        DATE default SYSDATE,
  CODUSU        VARCHAR2(30) default USER
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_SRV_REGINST_SISACT
  add constraint PK_ID_SISACT primary key (ID_SISACT);
