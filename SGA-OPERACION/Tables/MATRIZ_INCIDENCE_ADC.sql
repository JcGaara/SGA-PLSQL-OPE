-- Create table
create table OPERACION.MATRIZ_INCIDENCE_ADC
(
  codsubtype        NUMBER(8),
  codinctype        NUMBER(8),
  codincdescription NUMBER(8),
  codchannel        NUMBER(8),
  codtypeservice    NUMBER(8),
  codcase           NUMBER(8),
  estado            CHAR(1),
  feccre            DATE default SYSDATE,
  usucre            VARCHAR2(30) default USER,
  fecmod            DATE,
  usumod            VARCHAR2(30),
  ipcre             VARCHAR2(30),
  ipmod             VARCHAR2(30)
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
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.codsubtype
  is 'Código subtipo';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.codinctype
  is 'Tipo de incidencia';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.codincdescription
  is 'Codigo descripción de la incidencia';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.codchannel
  is 'Código de canal';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.codtypeservice
  is 'Código tipo de servicio';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.codcase
  is 'Código de caso';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.estado
  is 'Estado';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.feccre
  is 'Fecha de creación';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.usucre
  is 'Usuario de creación';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.fecmod
  is 'Fecha de modificación';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.usumod
  is 'Usuario que modifico';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.ipcre
  is 'IP que registro';
comment on column OPERACION.MATRIZ_INCIDENCE_ADC.ipmod
  is 'IP que modifico';
-- Create/Recreate indexes 
create index OPERACION.IDX_MATRIZ_INCIDENCE_ADC on OPERACION.MATRIZ_INCIDENCE_ADC (CODSUBTYPE, CODINCTYPE, CODINCDESCRIPTION, CODCHANNEL, CODTYPESERVICE)
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

GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.matriz_incidence_adc TO marketing;