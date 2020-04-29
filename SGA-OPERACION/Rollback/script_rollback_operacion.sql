DECLARE 
 LN_CANT NUMBER;
 LN_COUNT_1 NUMBER;
 LN_COUNT_2 NUMBER;
BEGIN 
  
-- CONFIGURACION IP
  SELECT count(1)
    INTO LN_CANT
    FROM TIPOPEDD
   WHERE UPPER(ABREV) = 'ASIG_IP/MASK_SGA';

  IF LN_CANT > 0 THEN
     delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='ASIG_IP/MASK_SGA');
     delete from tipopedd where upper(abrev) = 'ASIG_IP/MASK_SGA';
  END IF;
  
-- CONFIGURACION DE TIPO DE TRABAJO FITEL
  SELECT count(1)
    INTO LN_CANT
    FROM TIPOPEDD
   WHERE UPPER(ABREV) = 'TRANS_TIPTRA_FITEL';
     
  IF LN_CANT > 0 THEN
     delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='TRANS_TIPTRA_FITEL');
     delete from tipopedd where upper(abrev) = 'TRANS_TIPTRA_FITEL';
  END IF;
  COMMIT;

  /*INICIO ROLLBACK OPEDD */
  SELECT COUNT(*)
    INTO LN_COUNT_1
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF');

  SELECT COUNT(*)
    INTO LN_COUNT_2
    FROM OPERACION.TIPOPEDD
   WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF';

  IF LN_COUNT_1 > 0 THEN
    DELETE FROM OPERACION.OPEDD DET
     WHERE DET.TIPOPEDD IN
           (SELECT TIPOPEDD
              FROM OPERACION.TIPOPEDD
             WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF');
    COMMIT;
  END IF;

  IF LN_COUNT_2 > 0 THEN
    DELETE FROM OPERACION.TIPOPEDD WHERE UPPER(ABREV) = 'TIPEQU_FITEL_TLF';
    COMMIT;
  END IF;
  
  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
     AND DET.CODIGOC = 'E371542';

  IF LN_CANT > 0 THEN
    DELETE FROM OPERACION.OPEDD DET
     WHERE DET.TIPOPEDD IN
           (SELECT TIPOPEDD
              FROM OPERACION.TIPOPEDD
             WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
       AND DET.CODIGOC = 'E371542';
    COMMIT;
  END IF;

  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
     AND DET.CODIGOC = 'E371672';

  IF LN_CANT > 0 THEN
    DELETE FROM OPERACION.OPEDD DET
     WHERE DET.TIPOPEDD IN
           (SELECT TIPOPEDD
              FROM OPERACION.TIPOPEDD
             WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
       AND DET.CODIGOC = 'E371672';
    COMMIT;
  END IF;

  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
     AND DET.CODIGOC = 'E371495';

  IF LN_CANT > 0 THEN
    DELETE FROM OPERACION.OPEDD DET
     WHERE DET.TIPOPEDD IN
           (SELECT TIPOPEDD
              FROM OPERACION.TIPOPEDD
             WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
       AND DET.CODIGOC = 'E371495';
    COMMIT;
  END IF;

  SELECT COUNT(*)
    INTO LN_CANT
    FROM OPERACION.OPEDD DET
   WHERE DET.TIPOPEDD IN
         (SELECT TIPOPEDD
            FROM OPERACION.TIPOPEDD
           WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
     AND DET.CODIGOC = 'E371606';

  IF LN_CANT > 0 THEN
    DELETE FROM OPERACION.OPEDD DET
     WHERE DET.TIPOPEDD IN
           (SELECT TIPOPEDD
              FROM OPERACION.TIPOPEDD
             WHERE UPPER(ABREV) = 'DESHATABCONTRATOS')
       AND DET.CODIGOC = 'E371606';
    COMMIT;
  END IF;
  
  /*FIN ROLLBACK OPEDD */
  


END; 
/
drop package OPERACION.PKG_TRANSACCIONES_SGA;
drop table OPERACION.SGAT_APROVISION_LOG;