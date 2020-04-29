CREATE TABLE OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET
(
  IDPROGRAMACION    NUMBER(18)                  NOT NULL,
  IDARCHIVO         NUMBER(18)                  NOT NULL,
  FECHA_PROG        DATE,
  TIEMPO_DURACION   NUMBER(5),
  NRO_REPETICIONES  NUMBER(5),
  INTERVALO_TIEMPO  NUMBER(5),
  ESTADO            NUMBER(4)                   DEFAULT 1,
  USUREG            VARCHAR2(30 BYTE)           DEFAULT USER,
  FECREG            DATE                        DEFAULT SYSDATE,
  USUMOD            VARCHAR2(30 BYTE)           DEFAULT USER,
  FECMOD            DATE                        DEFAULT SYSDATE,
  NUMREGINS         VARCHAR2(10 BYTE)
);

COMMENT ON TABLE OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET IS 'Permite programar las fechas y la frecuencia de envio de archivos al servidor CONAX';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.IDPROGRAMACION IS 'N�mero identificador de la programaci�n del mensaje a enviar por el deco de TV Satelital';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.IDARCHIVO IS 'Identificador del mesaje enviado por los decos de TV Satelital';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.FECHA_PROG IS 'Fecha de Programaci�n de env�o de comandos al CONAX, y que ser�n enviados a los decos de TV Satelital';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.TIEMPO_DURACION IS 'Tiempo de duraci�n del mensaje';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.NRO_REPETICIONES IS 'N�mero de repetici�n del mensaje';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.INTERVALO_TIEMPO IS 'Intervalo de tiempo entre los mensajes';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.ESTADO IS 'Estado de la Programaci�n';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.USUREG IS 'Usuario que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.FECMOD IS 'Fecha que se modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_PROGRAMA_MENSAJE_TV_DET.NUMREGINS IS 'Identificador del archivo enviado al CONAX';

