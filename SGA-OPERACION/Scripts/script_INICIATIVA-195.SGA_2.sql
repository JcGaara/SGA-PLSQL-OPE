-- Cambios en la Tabla
ALTER TABLE OPERACION.SGAT_RESERVA_TOA modify RESTV_NRO_ORDEN VARCHAR2(30) not null;
ALTER TABLE OPERACION.SGAT_RESERVA_TOA ADD RESTN_NUM_SEC NUMBER(20) DEFAULT 0;
COMMENT ON COLUMN OPERACION.SGAT_RESERVA_TOA.RESTN_ESTADO IS 'estado: 0 cuando se cancela reserva,estado: 1 cuando se crea la reserva, estado: 2 actualiza la orden, estado: 3 cancelado  desde SGA';
commit;
\