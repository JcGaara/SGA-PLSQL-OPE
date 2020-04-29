-- Create table
create table OPERACION.SGAT_TRAZA_FACT
(
  trfan_idtraza     NUMBER(10) not null,
  trfav_nombapp     VARCHAR2(100),
  trfav_codproyecto VARCHAR2(50) not null,
  trfav_codsucursal VARCHAR2(50) not null,
  trfav_codubigeo   VARCHAR2(50) not null,
  trfav_nrovia      VARCHAR2(50),
  trfav_codtipovia  VARCHAR2(5) not null,
  trfav_nombrevia   VARCHAR2(50) not null,
  trfav_estado      NUMBER default 0 not null,
  trfad_fechareg    DATE default SYSDATE not null,
  trfav_usureg      VARCHAR2(50) default USER not null,
  trfad_fechcact    DATE,
  trfav_usuact      VARCHAR2(20),
  trfav_mzna        VARCHAR2(20),
  trfav_lote        VARCHAR2(20),
  trfav_sublote     VARCHAR2(20)
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
comment on column OPERACION.SGAT_TRAZA_FACT.trfan_idtraza
  is 'Id Traza';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_nombapp
  is 'Nombre aplicacion';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_codproyecto
  is 'Codigo Proyecto';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_codsucursal
  is 'Codigo Sucursal';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_codubigeo
  is 'Codigo Ubigeo';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_nrovia
  is 'Numero de via';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_codtipovia
  is 'Tipo de via';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_nombrevia
  is 'Nombre de via';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_estado
  is '0: Pendiente; 1: En Proceso; 2: Factibilidad con exito; 3: Factibilidad Manual; 4: Hilos Reservados; 5: Costeo; 6:Error; 7:Servicio Implemental; 8:Terminado;';
comment on column OPERACION.SGAT_TRAZA_FACT.trfad_fechareg
  is 'Fecha de Registro';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_usureg
  is 'Usuario de Registro';
comment on column OPERACION.SGAT_TRAZA_FACT.trfad_fechcact
  is 'Fecha de actualizacion';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_usuact
  is 'Usuario de Actualizacion';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_mzna
  is 'Número de Manzana.';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_lote
  is 'Número de Lote.';
comment on column OPERACION.SGAT_TRAZA_FACT.trfav_sublote
  is 'Número de Sublote.';