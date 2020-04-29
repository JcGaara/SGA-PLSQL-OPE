INSERT INTO OPERACION.TIPPROYECTO (tipproyecto, descripcion)  VALUES ((select max(tipproyecto)+1 from OPERACION.TIPPROYECTO), 'LTE');
commit;