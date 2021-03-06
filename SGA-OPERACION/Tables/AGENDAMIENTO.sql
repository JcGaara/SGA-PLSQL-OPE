CREATE TABLE OPERACION.AGENDAMIENTO
(
  IDAGENDA           NUMBER(8)                  NOT NULL,
  CODSOLOT           NUMBER(8),
  CODCON             NUMBER,
  CODCLI             CHAR(8 BYTE),
  NUMSLC             CHAR(10 BYTE),
  DIRECCION          VARCHAR2(480 BYTE),
  FECHA_INSTALACION  DATE,
  OBSERVACION        VARCHAR2(500 BYTE),
  REFERENCIA         VARCHAR2(200 BYTE),
  FECPROG            DATE,
  FECAGENDA          DATE,
  HORAS              NUMBER,
  CODINCIDENCE       NUMBER(8),
  ESTAGE             NUMBER(2),
  CODUBI             CHAR(10 BYTE),
  TIPO_AGENDA        NUMBER(2),
  CODSUC             CHAR(10 BYTE),
  ACTA_INSTALACION   VARCHAR2(50 BYTE),
  OBSERVACIONES      VARCHAR2(4000 BYTE),
  CINTILLO           VARCHAR2(15 BYTE),
  SERSUT             CHAR(3 BYTE),
  NUMSUT             CHAR(8 BYTE),
  CARGO              NUMBER(8,2),
  CUOTA              NUMBER,
  CODCNT             CHAR(8 BYTE),
  INSTALADOR         VARCHAR2(50 BYTE),
  NOMCNT             VARCHAR2(80 BYTE),
  TIPDOCFAC          CHAR(3 BYTE),
  IDTAREAWF          NUMBER,
  USUREG             VARCHAR2(30 BYTE)          DEFAULT user                  NOT NULL,
  FECREG             DATE                       DEFAULT sysdate               NOT NULL,
  USUMOD             VARCHAR2(30 BYTE)          DEFAULT user                  NOT NULL,
  FECMOD             DATE                       DEFAULT sysdate               NOT NULL,
  FECHAAGENDAFIN     DATE,
  SUPERVISOR         VARCHAR2(30 BYTE),
  CODCASE            NUMBER,
  USUREAGENDA        VARCHAR2(30 BYTE),
  FECREAGENDA        DATE,
  AREA               NUMBER(4),
  IDPLANO            VARCHAR2(10 BYTE),
  IDPAQ              NUMBER,
  MOTSOL_INT         NUMBER,
  MOTSOL_INTCAB      NUMBER,
  MOTSOL_INTTEL      NUMBER,
  MOTSOL_INTTELCAB   NUMBER,
  MOTSOL_CAB         NUMBER,
  MOTSOL_CABINT      NUMBER,
  MOTSOL_TEL         NUMBER,
  MOTSOL_PEXT        NUMBER
);

COMMENT ON TABLE OPERACION.AGENDAMIENTO IS 'Agendamiento de Contratas';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.IDAGENDA IS 'Id de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODCON IS 'Codigo de la contrata';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.DIRECCION IS 'Direccion donde se realizara el trabajo';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECHA_INSTALACION IS 'Fecha de Instalaci�n';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.OBSERVACION IS 'Observaciones';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.REFERENCIA IS 'Referencia asociada a la direccion';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECPROG IS 'Fecha de programacion';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECAGENDA IS 'Fecha de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.HORAS IS 'Horas de Programaci�n';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODINCIDENCE IS 'Codigo de Incidencia';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.ESTAGE IS 'Estado de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODUBI IS 'Codigo del distrito referencial';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.TIPO_AGENDA IS 'Tipo de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODSUC IS 'Codigo de Sucursal';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.ACTA_INSTALACION IS 'Nro de acta de instalacion de la contrata';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.OBSERVACIONES IS 'Observaciones';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CINTILLO IS 'Cintillo';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CARGO IS 'Cargo de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CUOTA IS 'Cuotas de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODCNT IS 'Codigo del contacto de agendamiento';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.INSTALADOR IS 'Nombre del instalador';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.NOMCNT IS 'Nombre del contacto';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.TIPDOCFAC IS 'Tipo de Documento de Facturaci�n';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.IDTAREAWF IS 'Id de Tarea que genera Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.USUREG IS 'Usuario que insert� el registro';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECREG IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECMOD IS 'Fecha que se modific� el registro';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.SERSUT IS 'Serie sunat';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.NUMSUT IS 'Numero sunat';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECHAAGENDAFIN IS 'Fecha de Fin de Agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.SUPERVISOR IS 'Supervisor';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.CODCASE IS 'Codigo de Caso de Atenci�n desde la Incidencia';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.USUREAGENDA IS 'Ultimo usuario de asignaci�n de contrata';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.FECREAGENDA IS 'Ultima fecha de asignaci�n de contrata';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.AREA IS 'Area';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.IDPLANO IS 'Id Plano';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.IDPAQ IS 'Id Paquete';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_INT IS 'Motivo Solucion Internet';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_INTCAB IS 'Motivo Solucion Internet Cable';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_INTTEL IS 'Motivo Solucion Internet Telefonia';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_INTTELCAB IS 'Motivo Solucion Internet Telefonia Cable';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_CAB IS 'Motivo Solucion Cable';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_CABINT IS 'Motivo Solucion Cable Telefono';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_TEL IS 'Motivo Solucion Telefonia';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO.MOTSOL_PEXT IS 'Motivo Solucion Planta Externa';


