CREATE OR REPLACE PROCEDURE OPERACION.SP_ACTUALIZA_CODEDIFICIO is

CURSOR cur_edificio IS
   SELECT coordX, coordY, codigo
   FROM EDIFICIO;

BEGIN
   FOR registro IN cur_edificio LOOP
      UPDATE VTATABCLI
      SET codedificio = registro.codigo
      WHERE sqrt(POWER(registro.coordX - coordX,2) + POWER(registro.coordY - coordY,2)) BETWEEN 0 AND 1
            AND coordX is not null
            AND coordY is not null
            AND codedificio is null;
   END LOOP;

END;
/


