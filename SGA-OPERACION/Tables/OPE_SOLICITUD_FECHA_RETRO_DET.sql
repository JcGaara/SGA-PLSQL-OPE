CREATE TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET
(
  IDDETSOL   NUMBER(18)                         NOT NULL,
  IDSOL      NUMBER(15)                         NOT NULL,
  CODSOLOT   NUMBER(8)                          NOT NULL,
  FEC_RETRO  DATE,
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT USER,
  FECREG     DATE                               DEFAULT SYSDATE,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT USER,
  FECMOD     DATE                               DEFAULT SYSDATE,
  LOTETRS    NUMBER(18)                         NOT NULL,
  CODTRS     NUMBER(10)                         NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET IS 'Almacena el detalle de las solicitudes de activaci�n que tienen fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.IDDETSOL IS 'N�mero identificador de los detalles de las solicitudes de activaci�n que tienen fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.IDSOL IS 'N�mero identificador de las solicitudes de activaci�n que tienen fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.CODSOLOT IS 'C�digo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.FEC_RETRO IS 'Fecha de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.USUREG IS 'Usuario que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.FECREG IS 'Fecha que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.FECMOD IS 'Fecha que se modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.LOTETRS IS 'N� de lote de las transacciones pendientes de aprobaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_DET.CODTRS IS 'C�digo de la transacci�n pendiente de aprobaci�n';


