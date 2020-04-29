create table operacion.PARAMETRO_VTA_PVTA_ADC
(
  codsolot      NUMBER not null,
  plano         VARCHAR2(10),
  idpoblado     VARCHAR2(20),
  subtipo_orden VARCHAR2(10),
  fecha_progra  DATE,
  franja        VARCHAR2(10),
  idbucket      VARCHAR2(50),
  dni_tecnico   VARCHAR2(20),
  ipcre         VARCHAR2(20),
  ipmod         VARCHAR2(20),
  usucre        VARCHAR2(30) default USER,
  usumod        VARCHAR2(30) default USER,
  feccre        DATE default SYSDATE,
  fecmod        DATE default SYSDATE,
  flg_puerta    NUMBER(1) default 0
)
tablespace OPERACION_DAT;

-- Add comments to the table 
comment on table  OPERACION.PARAMETRO_VTA_PVTA_ADC IS 'Tabla de Parámetro de Información de Venta y Postventa para el Proceso de Oracle Field Service';
-- Add comments to the columns 
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.codsolot 		IS 'Código de Solicitud de Orden de Trabajo(SOT)';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.plano 			IS 'Identificador de Plano';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.idpoblado 		IS 'Identificador de Centro Poblado';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.subtipo_orden 	IS 'Código de SubTipo de Orden';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.fecha_progra 	IS 'Fecha de Programación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.franja 			IS 'Código de Franja Horaria del Oracle Field Service';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.idbucket 		IS 'Identificador del Bucket';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.dni_tecnico 		IS 'DNI del Técnico';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.ipcre 			IS 'Dirección IP de Creación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.ipmod 			IS 'Dirección IP de Modificación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.usucre 			IS 'Usuario de Creación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.usumod 			IS 'Usuario de Modificación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.feccre 			IS 'Fecha de Creación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.fecmod 			IS 'Fecha de Modificación';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.flg_puerta 		IS 'Flag Puerta a Puerta 1: Si ,  0  : No ';
