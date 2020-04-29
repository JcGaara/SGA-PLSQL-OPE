CREATE TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB
(
  IDSOL           NUMBER(15)                    NOT NULL,
  CODSOLOT        NUMBER(8)                     NOT NULL,
  IDTIPO          NUMBER(5)                     NOT NULL,
  AREA_EJEC       NUMBER(4)                     NOT NULL,
  USU_EJEC        VARCHAR2(30 BYTE),
  AREA_RESP       NUMBER(4)                     NOT NULL,
  USU_JEFE_APROB  VARCHAR2(30 BYTE),
  USU_APROB       VARCHAR2(30 BYTE),
  ESTADO          NUMBER(4)                     DEFAULT 0,
  FEC_RETRO       DATE,
  FEC_REGUL       DATE,
  FEC_APROB       DATE,
  USUREG          VARCHAR2(30 BYTE)             DEFAULT USER,
  FECREG          DATE                          DEFAULT SYSDATE,
  USUMOD          VARCHAR2(30 BYTE)             DEFAULT USER,
  FECMOD          DATE                          DEFAULT SYSDATE,
  OBSERVACION     VARCHAR2(1000 BYTE),
  OBS_APROB       VARCHAR2(1000 BYTE),
  USU_ADM_REC     VARCHAR2(30 BYTE),
  OBS_ADM_REC     VARCHAR2(1000 BYTE),
  CORREO_ADM_REC  VARCHAR2(1000 BYTE)
);

COMMENT ON TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB IS 'ALMACENA LAS SOLICITUDES DE ACTIVACI�N QUE TIENEN FECHAS RETROACTIVAS';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.CODSOLOT IS 'C�digo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.IDSOL IS 'N�mero identificador de las solicitudes de activaci�n que tienen fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.IDTIPO IS 'Identificador de los tipos de restricciones de activacion';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.AREA_EJEC IS 'Area que solicita la aprobaci�n de activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.USU_EJEC IS 'Usuario que solicita activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.AREA_RESP IS 'Area que aprueba las solicitudes de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.USU_JEFE_APROB IS 'Usuario jefe del usuario aprobador de solicitudes de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.USU_APROB IS 'Usuario aprobador de solicitudes de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.ESTADO IS 'Estado de la solicitud de activaci�n retroactiva. 0: Pendiente de Aprobaci�n, 1: Aprobado, 2: Rechazado';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.FEC_RETRO IS 'Fecha de activaci�n retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.FEC_REGUL IS 'Fecha de regularizaci�n de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.FEC_APROB IS 'Fecha de aprobaci�n de solicitud de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.USUREG IS 'Usuario que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.FECREG IS 'Fecha que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.FECMOD IS 'Fecha que se modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.OBSERVACION IS 'Comentario de la solicitud';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.OBS_APROB IS 'Comentario del usuario aprobador';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.USU_ADM_REC IS 'Usuario administrador de solicitudes rechazadas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.OBS_ADM_REC IS 'Comentario del usuario administrador de solicitudes rechazadas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO_CAB.CORREO_ADM_REC IS 'Correo al cual se notificar� las solicitudes rechazadas';


