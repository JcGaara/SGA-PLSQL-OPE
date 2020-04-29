CREATE TABLE OPERACION.INSPRDSLA
(
  IDINSPRDSLA     NUMBER,
  PID             NUMBER(10)                    NOT NULL,
  IDSLA           NUMBER(5),
  REPARACION      NUMBER(2),
  DISPONIBILIDAD  NUMBER(10,2),
  VALIDO          NUMBER                        DEFAULT 0,
  IDINSSLA        NUMBER(10),
  FECUSU          DATE                          DEFAULT sysdate,
  CODUSU          VARCHAR2(30 BYTE)             DEFAULT user
);

COMMENT ON TABLE OPERACION.INSPRDSLA IS 'Listado de las instancia de Servicio X SLA';

COMMENT ON COLUMN OPERACION.INSPRDSLA.PID IS 'Codigo de instancia de servicio';


