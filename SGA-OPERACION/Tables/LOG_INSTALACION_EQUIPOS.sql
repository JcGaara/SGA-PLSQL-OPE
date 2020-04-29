-- Create table
create table operacion.log_instalacion_equipos
(
  message_id   NUMBER not null,
  idagenda     NUMBER(8) not null,
  idinventario VARCHAR2(20),
  fecini_inst  DATE,
  fecfin_inst  DATE)
tablespace OPERACION_DAT;

-- Add comments to the columns 
COMMENT ON COLUMN OPERACION.LOG_INSTALACION_EQUIPOS.message_id   IS 'Identificador unico del Mensaje';
COMMENT ON COLUMN OPERACION.LOG_INSTALACION_EQUIPOS.idagenda     IS 'Codigo de la Agenda';
COMMENT ON COLUMN OPERACION.LOG_INSTALACION_EQUIPOS.idinventario IS 'Codigo del Inventario';
COMMENT ON COLUMN OPERACION.LOG_INSTALACION_EQUIPOS.fecini_inst  IS 'Fecha Inicio de la Instalacion';
COMMENT ON COLUMN OPERACION.LOG_INSTALACION_EQUIPOS.fecfin_inst  IS 'Fecha Fin de la Instalacion';