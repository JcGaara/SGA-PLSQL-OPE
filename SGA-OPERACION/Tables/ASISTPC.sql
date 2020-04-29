CREATE TABLE OPERACION.ASISTPC
(
  PID        NUMBER(10)                         NOT NULL,
  CODCLI     CHAR(8 BYTE)                       NOT NULL,
  ESTINSSRV  VARCHAR2(1 BYTE),
  ESTENV     NUMBER,
  NUMINT     NUMBER,
  ERROR      VARCHAR2(1000 BYTE),
  NUMSRV     VARCHAR2(3 BYTE),
  FLGCORREO  NUMBER
);

COMMENT ON COLUMN OPERACION.ASISTPC.ESTINSSRV IS 'estado del servicio (I: Instalado, S: Suspendido, R: Reconectado, B: Baja)';

COMMENT ON COLUMN OPERACION.ASISTPC.ESTENV IS 'flag de envio (0: sin enviar, 1: enviado)';

COMMENT ON COLUMN OPERACION.ASISTPC.NUMINT IS 'numero de intentos de envio';

COMMENT ON COLUMN OPERACION.ASISTPC.NUMSRV IS 'numero del servicio (correlativo por cliente)';


