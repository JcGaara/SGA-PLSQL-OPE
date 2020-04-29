CREATE OR REPLACE TRIGGER OPERACION.SGATRI_MATRIZ_SERV BEFORE INSERT
ON  OPERACION.SGAT_MATRIZ_SERV
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla OPERACION.SGAT_MATRIZ_SERV
REVISIONES:
Versión         Fecha          Autor               Descripción
---------       ----------     ---------------     -----------------------
1.0             07/02/2020     Wendy Tamayo       Obtener datos para la tabla SGAT_MATRIZ_SERV

**********************************************************************************/
BEGIN
   IF :NEW.servn_id IS NULL THEN
      SELECT OPERACION.SGASEQ_MATRIZ_SERV.NEXTVAL into :NEW.servn_id FROM DUAL;
   END IF;
END;

/
CREATE OR REPLACE TRIGGER OPERACION.SGATRI_MATRIZ_FOTO BEFORE INSERT
ON  OPERACION.SGAT_MATRIZ_FOTO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla OPERACION.SGAT_MATRIZ_FOTO
REVISIONES:
Versión         Fecha          Autor               Descripción
---------       ----------     ---------------     -----------------------
1.0             07/02/2020     Wendy Tamayo       Obtener datos para la tabla SGAT_MATRIZ_FOTO

**********************************************************************************/
BEGIN
   IF :NEW.foton_id IS NULL THEN
      SELECT OPERACION.SGASEQ_MATRIZ_FOTO.NEXTVAL into :NEW.foton_id FROM DUAL;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER OPERACION.SGATRI_MATRIZ_REPORT BEFORE INSERT
ON  OPERACION.SGAT_MATRIZ_REPORT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla OPERACION.SGAT_MATRIZ_REPORT
REVISIONES:
Versión         Fecha          Autor               Descripción
---------       ----------     ---------------     -----------------------
1.0             07/02/2020     Wendy Tamayo       Obtener datos para la tabla SGAT_MATRIZ_REPORT

**********************************************************************************/
BEGIN
   IF :NEW.reportn_id IS NULL THEN
      SELECT OPERACION.SGASEQ_MATRIZ_REPORT.NEXTVAL into :NEW.reportn_id FROM DUAL;
   END IF;
END;
/