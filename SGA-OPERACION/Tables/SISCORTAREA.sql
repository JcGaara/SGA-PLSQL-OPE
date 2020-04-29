CREATE TABLE OPERACION.SISCORTAREA
(
  IDTAREAWF        NUMBER(8)                    NOT NULL,
  TAREA            NUMBER(6)                    NOT NULL,
  IDWF             NUMBER(8)                    NOT NULL,
  TIPESTTAR        NUMBER(2)                    NOT NULL,
  ESTTAREA         NUMBER(4)                    NOT NULL,
  TAREADEF         NUMBER(6),
  AREA             NUMBER(4),
  RESPONSABLE      VARCHAR2(30 BYTE),
  FECCOM           DATE,
  FECINI           DATE,
  FECFIN           DATE,
  FECINISYS        DATE                         DEFAULT sysdate               NOT NULL,
  FECFINSYS        DATE,
  USUFIN           VARCHAR2(30 BYTE),
  OBSERVACION      VARCHAR2(1000 BYTE),
  FECUSUMOD        DATE                         DEFAULT sysdate,
  TAREADEF_DESC    VARCHAR2(100 BYTE),
  AREA_DESC        VARCHAR2(100 BYTE),
  ESTADO_DESC      VARCHAR2(30 BYTE),
  TIPOESTADO_DESC  VARCHAR2(30 BYTE),
  CODSOLOT         NUMBER(8),
  SOLOTCODUSU      VARCHAR2(30 BYTE),
  TIPTRA           NUMBER(4),
  TIPTRA_DESC      VARCHAR2(200 BYTE),
  CODCLI           CHAR(8 BYTE),
  CODCON           CHAR(8 BYTE),
  NOMCLI           VARCHAR2(200 BYTE),
  CODEQUIPO        NUMBER(6),
  CODSECTOR        NUMBER(6),
  MAC              VARCHAR2(30 BYTE),
  COORCLI          VARCHAR2(30 BYTE),
  FLAGLINEASCON    NUMBER(1),
  NCOS             NUMBER(6),
  FLAGCTRWEB       NUMBER(1),
  ESTSOL           NUMBER(2),
  ESTSOL_DESC      VARCHAR2(100 BYTE),
  COMENTARIO       VARCHAR2(2000 BYTE),
  FLAGEQUIPO       NUMBER(1)
);

COMMENT ON TABLE OPERACION.SISCORTAREA IS 'Tabla basada en tareawf con los campos descriptivos adicionales';

COMMENT ON COLUMN OPERACION.SISCORTAREA.IDTAREAWF IS 'ID de la tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.TAREA IS 'ID de la tarea para una definición de wf.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.IDWF IS 'ID de la instancia de workflow.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.TIPESTTAR IS 'Tipo de estado de tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.ESTTAREA IS 'Estado de la tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.TAREADEF IS 'Tipo de Tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.AREA IS 'Area responsable, solo los mienbros de esta area pueden cerrar la tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.RESPONSABLE IS 'Si esta definido solo el responsable puede cerrar la tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FECCOM IS 'Fecha de compromiso.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FECINI IS 'Fecha de inicio ingresada por el usuario.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FECFIN IS 'Fecha fin ingresada por usuario.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FECINISYS IS 'Fecha de inicio automatica.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FECFINSYS IS 'Fecha de cierre automatica';

COMMENT ON COLUMN OPERACION.SISCORTAREA.USUFIN IS 'Usuario que cierra la tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.OBSERVACION IS 'Observación de la tarea.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FECUSUMOD IS 'Fecha de ultima modificación del registro.';

COMMENT ON COLUMN OPERACION.SISCORTAREA.CODCON IS 'Codigo del contratista. Tabla sga contrata';

COMMENT ON COLUMN OPERACION.SISCORTAREA.CODEQUIPO IS 'codigo de equipo bts';

COMMENT ON COLUMN OPERACION.SISCORTAREA.MAC IS 'Mac del equipo instalado';

COMMENT ON COLUMN OPERACION.SISCORTAREA.FLAGCTRWEB IS 'flag control web = 1, se permite el cambio de estados con botones';

COMMENT ON COLUMN OPERACION.SISCORTAREA.ESTSOL IS 'id de estado de la solot';

COMMENT ON COLUMN OPERACION.SISCORTAREA.ESTSOL_DESC IS 'descripcion de estado de la solot';

COMMENT ON COLUMN OPERACION.SISCORTAREA.COMENTARIO IS 'comentarios de la tarea originado en SGA por fn';


