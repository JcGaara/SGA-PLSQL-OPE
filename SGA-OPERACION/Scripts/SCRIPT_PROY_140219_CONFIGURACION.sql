INSERT INTO OPEDD(tipopedd,codigoc,codigon,descripcion         ,abreviacion,codigon_aux)
VALUES  ( (SELECT T.tipopedd FROM TIPOPEDD T WHERE T.ABREV = 'TIPREGCONTIWSGABSCS')
                          ,'BSCS'   ,814   ,'HFC - UPGRADE SERVICIOS'    ,'HFC'      ,1   );   
commit; 