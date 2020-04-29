
DELETE FROM operacion.opedd where codigon = '1' and UPPER(abreviacion) = 'CTRL_CANCELACION';
DELETE FROM operacion.opedd where codigon = '2'  and UPPER(abreviacion) = 'CTRL_DUP_TOA';
DELETE FROM operacion.opedd where codigon = '3'  and UPPER(abreviacion) = 'CTRL_DUP_RESERVA';


COMMIT;