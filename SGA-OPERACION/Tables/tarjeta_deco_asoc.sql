-- Create table
create table OPERACION.TARJETA_DECO_ASOC
(
  ID_ASOC           NUMBER not null,
  CODSOLOT          NUMBER(8),
  IDDET_DECO        NUMBER(10),
  NRO_SERIE_DECO    VARCHAR2(50),
  IDDET_TARJETA     NUMBER(10),
  NRO_SERIE_TARJETA VARCHAR2(50),
  USUREG            VARCHAR2(30) default user not null,
  FECREG            DATE default sysdate not null,
  USUMOD            VARCHAR2(30) default user not null,
  FECMOD            DATE default sysdate not null
);
-- Add comments to the table 
comment on table OPERACION.TARJETA_DECO_ASOC
  is 'Tabla de asociacion entre tarjetas y decos.';
-- Add comments to the columns 
comment on column OPERACION.TARJETA_DECO_ASOC.ID_ASOC
  is 'id';
comment on column OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_DECO
  is 'mac del decodificador';
comment on column OPERACION.TARJETA_DECO_ASOC.NRO_SERIE_TARJETA
  is 'nro. serie de la tarjeta';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TARJETA_DECO_ASOC
  add constraint PK_TARJETA_DECO_ASOC primary key (ID_ASOC);
