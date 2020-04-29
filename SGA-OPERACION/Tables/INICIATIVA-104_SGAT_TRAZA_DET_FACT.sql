-- Create table
create table OPERACION.SGAT_TRAZA_DET_FACT
(
  tdfan_idtrazadt   NUMBER(10) not null,
  trfan_idtraza     NUMBER(10) not null,
  tdfac_tramainput  CLOB,
  tdfac_tramaoutput CLOB,
  tdfav_estado      NUMBER not null,
  tdfav_actividad   VARCHAR2(100),
  tdfav_descripcion VARCHAR2(250),
  trfad_fechareg    DATE default sysdate,
  trfav_usureg      VARCHAR2(50) default user,
  trfad_fecact      DATE,
  trfav_usuact      VARCHAR2(20)
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
comment on column OPERACION.SGAT_TRAZA_DET_FACT.tdfav_estado
  is '0: Registrado; 1: En Proceso; 2: Factibilidad con exito; 3: Factibilidad Manual; 4: Hilos Reservados; 5: Costeo; 6:Error; 7:Servicio Implemental; 8:Terminado;';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.tdfan_idtrazadt
  is 'Id de Traza Cabecera';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.trfan_idtraza
  is 'Id de Traza Cabecera';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.tdfac_tramainput
  is 'Trama de Entrada';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.tdfac_tramaoutput
  is 'Trama de Salida';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.tdfav_actividad
  is 'Actividad';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.tdfav_descripcion
  is 'Descripcion';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.trfad_fechareg
  is 'Fecha de Registro';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.trfav_usureg
  is 'Usuario de Registro';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.trfad_fecact
  is 'Fecha de Actualizacion';
comment on column OPERACION.SGAT_TRAZA_DET_FACT.trfav_usuact
  is 'Usuario de Actuizacion';
/