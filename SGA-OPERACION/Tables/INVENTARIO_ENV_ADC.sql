create table OPERACION.INVENTARIO_ENV_ADC
(
  id_inventario    NUMBER(15) not null,
  tecnologia       VARCHAR2(6),
  descripcion      VARCHAR2(250),
  modelo           VARCHAR2(150),
  tipo_inventario  VARCHAR2(255),
  codigo_sap       VARCHAR2(20),
  invsn            VARCHAR2(32),
  mta_mac_cm       VARCHAR2(50),
  mta_mac          VARCHAR2(50),
  unit_addr        VARCHAR2(250),
  nro_tarjeta      VARCHAR2(250),
  inddependencia   VARCHAR2(1),
  id_recurso_ext   VARCHAR2(8),
  observacion      VARCHAR2(400),
  quantity         NUMBER(1),
  fecha_inventario DATE,
  flg_carga        NUMBER(1) default '0',
  envio_eta        VARCHAR2(1) default '0',
  archivo          VARCHAR2(500),
  usureg           VARCHAR2(50) default USER,
  fecreg           DATE default SYSDATE,
  usumod           VARCHAR2(50) default USER,
  fecmod           DATE default SYSDATE
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.INVENTARIO_ENV_ADC   is 'Tabla de inventario cargado a TOA para la activacion de servicios.';
-- Add comments to the columns 
comment on column OPERACION.INVENTARIO_ENV_ADC.id_inventario   is 'Código de inventario';
comment on column OPERACION.INVENTARIO_ENV_ADC.tecnologia  is 'Tecnologia a usar.';
comment on column OPERACION.INVENTARIO_ENV_ADC.descripcion  is 'Descripcion.';
comment on column OPERACION.INVENTARIO_ENV_ADC.modelo  is 'Modelo de equipo (solo aplica enviar para HFC).';
comment on column OPERACION.INVENTARIO_ENV_ADC.tipo_inventario  is 'Tipo de inventario.';
comment on column OPERACION.INVENTARIO_ENV_ADC.codigo_sap  is 'Código SAP.';
comment on column OPERACION.INVENTARIO_ENV_ADC.invsn  is 'Numero Serial.';
comment on column OPERACION.INVENTARIO_ENV_ADC.mta_mac_cm  is 'MAC Address- Exclusivo para Internet.';
comment on column OPERACION.INVENTARIO_ENV_ADC.mta_mac  is 'MAC Address- Exclusivo para Telefonia.';
comment on column OPERACION.INVENTARIO_ENV_ADC.unit_addr  is 'Unit. Address.';
comment on column OPERACION.INVENTARIO_ENV_ADC.nro_tarjeta  is 'Número de tarjeta.';
comment on column OPERACION.INVENTARIO_ENV_ADC.inddependencia  is 'Indicador de Dependencia';
comment on column OPERACION.INVENTARIO_ENV_ADC.id_recurso_ext  is 'Código de Recurso Externo.';
comment on column OPERACION.INVENTARIO_ENV_ADC.observacion  is 'Observación.';
comment on column OPERACION.INVENTARIO_ENV_ADC.quantity  is 'Cantidad.';
comment on column OPERACION.INVENTARIO_ENV_ADC.fecha_inventario  is 'Fecha de inventario.';
comment on column OPERACION.INVENTARIO_ENV_ADC.flg_carga  is 'Flag de carga correcta.';
comment on column OPERACION.INVENTARIO_ENV_ADC.envio_eta  is 'Envio ETA.';
comment on column OPERACION.INVENTARIO_ENV_ADC.archivo  is 'Ubicación del archivo.';
comment on column OPERACION.INVENTARIO_ENV_ADC.usureg  is 'Es el usuario que genere el monto en disputa';
comment on column OPERACION.INVENTARIO_ENV_ADC.fecreg  is 'Es la fecha en que se genere el monto en disputa';
comment on column OPERACION.INVENTARIO_ENV_ADC.usumod  is 'Usuario de modificación';
comment on column OPERACION.INVENTARIO_ENV_ADC.fecmod  is 'Fecha de modificación';
