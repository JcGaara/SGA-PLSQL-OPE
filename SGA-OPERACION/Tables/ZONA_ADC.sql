create table operacion.zona_adc
(
  idzona      NUMBER not null,
  codzona     VARCHAR2(10),
  descripcion VARCHAR2(100),
  estado      CHAR(1) default '1',
  ipcre       VARCHAR2(20),
  ipmod       VARCHAR2(20),
  feccre      DATE default sysdate,
  fecmod      DATE default sysdate,
  usucre      VARCHAR2(30) default user,
  usumod      VARCHAR2(30) default user
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.ZONA_ADC   is 'Tabla encargada de guardar las Zonas de Adm. de Cuadrilla';
-- Add comments to the columns 
comment on column OPERACION.ZONA_ADC.idzona   is 'Identificador de la Zona de Adm. de Cuadrilla';
comment on column OPERACION.ZONA_ADC.codzona  is 'Código de la Zona de Adm. de Cuadrilla para Oracle Field Service';
comment on column OPERACION.ZONA_ADC.descripcion is 'Descripción de la Zona de Adm. de Cuadrilla';
comment on column OPERACION.ZONA_ADC.estado  is 'Estado de la Zona de Adm. de Cuadrilla';
comment on column OPERACION.ZONA_ADC.ipcre  is 'Ip. de Creación';
comment on column OPERACION.ZONA_ADC.ipmod  is 'Ip. de Modificación';
comment on column OPERACION.ZONA_ADC.feccre  is 'Fecha de Creación';
comment on column OPERACION.ZONA_ADC.fecmod  is 'Fecha de Modificación';
comment on column OPERACION.ZONA_ADC.usucre  is 'Usuario de Creación';
comment on column OPERACION.ZONA_ADC.usumod  is 'Usuario de Modificación';