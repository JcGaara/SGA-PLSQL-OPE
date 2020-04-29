-- Create table
create table OPERACION.PARAMETRO_INCIDENCE_ADC
(
  codincidence       NUMBER(8),
  subtipo_orden      VARCHAR2(10),
  fecha_programacion DATE,
  franja             VARCHAR2(10),
  idbucket           VARCHAR2(50),
  plano              VARCHAR2(10),
  feccre             DATE default SYSDATE,
  usucre             VARCHAR2(30) default USER,
  ipcre              VARCHAR2(30),
  fecmod             DATE,
  usumod             VARCHAR2(30),
  ipmod              VARCHAR2(30)
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
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.codincidence
  is 'Código de Incidencia';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.subtipo_orden
  is 'Código de SubTipo de Orden';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.fecha_programacion
  is 'Fecha de Programación';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.franja
  is 'Código de Franja Horaria del Oracle Field Service';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.idbucket
  is 'Identificador de Plano';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.plano
  is 'Identificador del BUCKET';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.feccre
  is 'Fecha de Modificación';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.usucre
  is 'Usuario de Modificación';
comment on column OPERACION.PARAMETRO_INCIDENCE_ADC.ipcre
  is 'Dirección IP de Modificación';
-- Create/Recreate indexes 
create index OPERACION.IDX_CODINCIDENCE_ADC on OPERACION.PARAMETRO_INCIDENCE_ADC (CODINCIDENCE)
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
GRANT SELECT, INSERT, UPDATE, DELETE ON operacion.parametro_incidence_adc to r_prod;