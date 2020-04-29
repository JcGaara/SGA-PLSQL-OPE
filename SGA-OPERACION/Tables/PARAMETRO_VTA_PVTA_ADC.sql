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
comment on table  OPERACION.PARAMETRO_VTA_PVTA_ADC IS 'Tabla de Par�metro de Informaci�n de Venta y Postventa para el Proceso de Oracle Field Service';
-- Add comments to the columns 
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.codsolot 		IS 'C�digo de Solicitud de Orden de Trabajo(SOT)';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.plano 			IS 'Identificador de Plano';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.idpoblado 		IS 'Identificador de Centro Poblado';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.subtipo_orden 	IS 'C�digo de SubTipo de Orden';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.fecha_progra 	IS 'Fecha de Programaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.franja 			IS 'C�digo de Franja Horaria del Oracle Field Service';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.idbucket 		IS 'Identificador del Bucket';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.dni_tecnico 		IS 'DNI del T�cnico';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.ipcre 			IS 'Direcci�n IP de Creaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.ipmod 			IS 'Direcci�n IP de Modificaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.usucre 			IS 'Usuario de Creaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.usumod 			IS 'Usuario de Modificaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.feccre 			IS 'Fecha de Creaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.fecmod 			IS 'Fecha de Modificaci�n';
COMMENT ON COLUMN OPERACION.PARAMETRO_VTA_PVTA_ADC.flg_puerta 		IS 'Flag Puerta a Puerta 1: Si ,  0  : No ';
