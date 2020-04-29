CREATE TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS
(
  IDSEC           NUMBER(18)                    NOT NULL,
  IDSOL           NUMBER(15),
  CODSOLOT        NUMBER(8),
  IDTIPO          NUMBER(5),
  AREA_EJEC       NUMBER(4),
  USU_EJEC        VARCHAR2(30 BYTE),
  AREA_RESP       NUMBER(4),
  USU_JEFE_APROB  VARCHAR2(30 BYTE),
  USU_APROB       VARCHAR2(30 BYTE),
  ESTADO          NUMBER(3),
  FEC_RETRO       DATE,
  FEC_REGUL       DATE,
  FEC_APROB       DATE,
  OBSERVACION     VARCHAR2(1000 BYTE),
  OBS_APROB       VARCHAR2(1000 BYTE),
  USU_ADM_REC     VARCHAR2(30 BYTE),
  OBS_ADM_REC     VARCHAR2(1000 BYTE),
  CORREO_ADM_REC  VARCHAR2(1000 BYTE),
  TIPO            CHAR(1 BYTE),
  USUMOD          VARCHAR2(50 BYTE)             DEFAULT user,
  FECMOD          DATE                          DEFAULT sysdate,
  TIPOUSU         NUMBER,
  CAMPO           NUMBER                        DEFAULT 1
);

COMMENT ON TABLE OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS IS 'Tabla de almacenamiento de los cambios de estado y fecha retroactiva por los que paso las solicitudes de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.IDSEC IS 'N�mero secuencial que identifica a un registro de cambio del estado de la solicitud';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.IDSOL IS 'N�mero identificador de las solicitudes de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.CODSOLOT IS 'C�digo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.IDTIPO IS 'Identificador de los tipos de restricciones de activacion';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.AREA_EJEC IS 'Area que solicita la aprobaci�n de activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.USU_EJEC IS 'Usuario que solicita activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.AREA_RESP IS 'Area que aprueba las solicitudes de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.USU_JEFE_APROB IS 'Usuario jefe del usuario aprobador de solicitudes de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.USU_APROB IS 'Usuario aprobador de solicitudes de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.ESTADO IS 'Estado de la solicitud de activaci�n retroactiva. 0: Pendiente de Aprobaci�n, 1: Aprobado, 2: Rechazado';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.FEC_RETRO IS 'Fecha de activaci�n retroactivas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.FEC_REGUL IS 'Fecha de regularizaci�n de activaci�n';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.FEC_APROB IS 'Fecha de aprobaci�n de solicitud de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.OBSERVACION IS 'Comentario de la solicitud';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.OBS_APROB IS 'Comentario del usuario aprobador';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.USU_ADM_REC IS 'Usuario administrador de solicitudes rechazadas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.OBS_ADM_REC IS 'Comentario del usuario administrador de solicitudes rechazadas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.CORREO_ADM_REC IS 'Correo al cual se notificar� las solicitudes rechazadas';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.TIPO IS 'Indica el tipo de operaci�n que afect� el registro. I: Insert, U: Update, D: Delete';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.FECMOD IS 'Fecha que se modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.TIPOUSU IS 'Tipo de usuario. 1: Usuario solicitador, 2: Usuario aprobador, 3: Usuario administrador de rechazos';

COMMENT ON COLUMN OPERACION.OPE_SOLICITUD_FECHA_RETRO2_HIS.CAMPO IS 'Identifica el campo de la solicitud de activaci�n que estamos cambiando. 1:Estado, 2:Fecha retroactiva';


