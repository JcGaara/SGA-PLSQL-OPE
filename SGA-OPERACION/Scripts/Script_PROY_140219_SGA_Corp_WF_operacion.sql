--script operacion

--Agregando agrupador de operaciones
  INSERT INTO OPERACION.TIPOPEDD (DESCRIPCION, ABREV) VALUES ('CIERRAUTOUPCORP','CIERAUTUPCRP');
  COMMIT;

--Insertando las tareas para el agrupador                    
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('PROV',(SELECT TAREADEF FROM TAREADEF 
                        WHERE DESCRIPCION = 'HFC - Upgrade Incognito'),'HFC - Upgrade Incognito',NULL,(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  COMMIT;
--
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('AUTO',(SELECT TAREADEF FROM TAREADEF 
                       WHERE DESCRIPCION = 'HFC - Upgrade SGA'),'HFC - Upgrade SGA',NULL,(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  COMMIT;
--
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('AUTO',(SELECT TAREADEF FROM TAREADEF 
                        WHERE DESCRIPCION = 'Activación/Desactivación del servicio '),'Activación/Desactivación del servicio','HFC',(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  COMMIT;                
--
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('INIFAC',(SELECT TAREADEF FROM TAREADEF 
                          WHERE DESCRIPCION = 'HFC - ACT/DES SGA'),'HFC - ACT/DES SGA',NULL,(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  COMMIT;

