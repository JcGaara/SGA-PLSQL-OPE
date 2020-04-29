CREATE TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS
(
  IDSEC        NUMBER(18)                       NOT NULL,
  IDSOL        NUMBER(15)                       NOT NULL,
  TIPO         NUMBER(1)                        NOT NULL,
  ESTADO       NUMBER(3)                        NOT NULL,
  OBSERVACION  VARCHAR2(2000 BYTE),
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user,
  FECREG       DATE                             DEFAULT sysdate,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user,
  FECMOD       DATE                             DEFAULT sysdate,
  FEC_RETRO    DATE,
  CAMPO        NUMBER                           DEFAULT 1
);

COMMENT ON TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS IS 'Tabla de almacenamiento de los cambios de estado y fecha retroactiva por los que paso las solictudes de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.IDSEC IS 'N�mero secuencial que identifica a un registro de cambio del estado de la solicitud';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.IDSOL IS 'N�mero identificador de las solicitudes de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.TIPO IS 'Tipo de usuario. 1: Usuario solicitador, 2: Usuario aprobador, 3: Usuario administrador de rechazos';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.ESTADO IS 'Estado de la solicitud de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.OBSERVACION IS 'Comentario acerca del cambio del estado de la solicitud de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.USUREG IS 'Usuario que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.FECREG IS 'Fecha que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.FECMOD IS 'Fecha que se modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.FEC_RETRO IS 'Fecha de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_HIS.CAMPO IS 'Identifica el campo de la solicitud  de activaci�n que estamos cambiando. 1:Estado, 2:Fecha retroactiva';


