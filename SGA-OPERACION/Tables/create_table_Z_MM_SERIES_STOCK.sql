-- Create table
create table OPERACION.Z_MM_SERIES_STOCK
(
  material         VARCHAR2(18) not null,
  cantidad         NUMBER,
  centro           VARCHAR2(4) not null,
  almacen          VARCHAR2(4) not null,
  series           VARCHAR2(30) not null,
  status_sistema   VARCHAR2(40),
  status_usuario   VARCHAR2(40),
  tipo_stock       VARCHAR2(2),
  tipo_equipo      VARCHAR2(1),
  clase_valoracion VARCHAR2(10),
  mac1             VARCHAR2(30),
  mac2             VARCHAR2(30),
  mac3             VARCHAR2(30),
  mac4             VARCHAR2(30)
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
-- Create/Recreate indexes 
create index OPERACION.IDX1_PS_SERIESSTOCK_MATSER on OPERACION.Z_MM_SERIES_STOCK (MATERIAL, SERIES)
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
create index OPERACION.IDX2_PS_SERIESSTOCK_MATSER on OPERACION.Z_MM_SERIES_STOCK (CENTRO, ALMACEN, MATERIAL, SERIES)
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
-- Grant/Revoke object privileges 
grant select, insert, update, delete on OPERACION.Z_MM_SERIES_STOCK to R_SOAP_DB;
