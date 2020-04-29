-- Create table
create table operacion.matriz_tystipsrv_tiptra_adc
(
  id_matriz   NUMBER(10) not null,
  tipsrv      CHAR(4),
  tiptra      NUMBER(4),
  con_cap_v   NUMBER(1) default 0,
  con_cap_p   NUMBER(1) default 0,
  con_cap_o   NUMBER(1) default 0,
  gen_ot_aut  CHAR(1) default 'A',
  tipo_agenda VARCHAR2(30),
  valida_mot  NUMBER(1) default 0,
  estado      NUMBER(1) default 0,
  ipcre       VARCHAR2(20),
  ipmod       VARCHAR2(20),
  fecre       DATE default sysdate,
  fecmod      DATE,
  usucre      VARCHAR2(30) default user,
  usumod      VARCHAR2(30)
)
TABLESPACE OPERACION_DAT;

-- Add comments to the table 
COMMENT ON TABLE  operacion.matriz_tystipsrv_tiptra_adc   			IS 'Tabla de configuracion de tipo de trabajo y servicio';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.id_matriz   IS 'id secuencial';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.tipsrv   	IS 'codigo del tipo de servicio';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.tiptra   	IS 'codigo del tipo de trabajo';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.con_cap_v   IS 'Consulta Capacidad de Ventas';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.con_cap_p   IS 'Consulta Capacidad de PostVenta';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.con_cap_o  	IS 'Consulta Capacidad de Operaciones';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.gen_ot_aut  IS 'Genera Orden de Trabajo en TOA - Automaticamente';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.tipo_agenda IS 'Tipo de Agenda';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.valida_mot  IS 'Validar Motivos';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.estado  	IS 'Estado de Trabajo';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.ipcre  		IS 'IP de Creacion ';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.ipmod  		IS 'IP de Modificacion';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.fecre  		IS 'Fecha Creacion';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.fecmod  	IS 'Fecha Modificacion';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.usucre  	IS 'Usuario Creacion';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.usumod  	IS 'Usuario Modificacion';
