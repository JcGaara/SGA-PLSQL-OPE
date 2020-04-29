--REALIZAR LIMPIEZA TABLAS DE OPERACIONES
delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'CIERAUTUPCRP');
commit;

delete from operacion.tipopedd where abrev = 'CIERAUTUPCRP';
commit;

---------------------------------------------------------------------------------------------------------------------------------------

--Agregando agrupador de operaciones
  INSERT INTO OPERACION.TIPOPEDD (DESCRIPCION, ABREV) VALUES ('CIERRAUTOUPCORP','CIERAUTUPCRP');
  COMMIT;

--Insertando las tareas para el agrupador                    
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('PROV',(SELECT TAREADEF FROM OPEWF.TAREADEF 
                        WHERE DESCRIPCION = 'HFC - Upgrade Incognito'),'HFC - Upgrade Incognito',NULL,(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('AUTO',(SELECT TAREADEF FROM OPEWF.TAREADEF 
                       WHERE DESCRIPCION = 'HFC - Upgrade SGA'),'HFC - Upgrade SGA',NULL,(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('AUTO',(SELECT TAREADEF FROM OPEWF.TAREADEF 
                        WHERE DESCRIPCION = 'Activación/Desactivación del servicio Corp'),'Activación/Desactivación del servicio Corp','HFC',(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  INSERT INTO OPERACION.OPEDD (CODIGOC,CODIGON,DESCRIPCION,ABREVIACION,TIPOPEDD,CODIGON_AUX)
  VALUES('INIFAC',(SELECT TAREADEF FROM OPEWF.TAREADEF 
                          WHERE DESCRIPCION = 'HFC - ACT/DES SGA'),'HFC - ACT/DES SGA',NULL,(SELECT T.TIPOPEDD FROM OPERACION.TIPOPEDD T 
                                                                          WHERE T.ABREV = 'CIERAUTUPCRP'),4);
  COMMIT;
