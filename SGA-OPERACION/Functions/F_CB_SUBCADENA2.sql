CREATE OR REPLACE FUNCTION OPERACION.F_CB_subcadena2 (parametro in varchar2, posicion in number) return varchar2 AS
-- CAMS - 03/07/2001
-- Creada para extraer un elemento de una lista separada por comas
-- ejemplo: origen    -> F_CB_subcadena('ABC,DEF,GH,123,TWS',4)
--          resultado -> '123'

  ls_original  varchar2(500);
  ls_subcadena varchar2(500);

  li_longitud number(3,0);
  i           number(3,0);
  j           number(3,0);
  p           number(3,0);

BEGIN
     ls_original := parametro;
     p           := posicion;
     j           := 1;

     li_longitud := length(ls_original);
     FOR i IN 1..li_longitud LOOP
         IF (substr(ls_original,i,1)<> ',') THEN
            IF j = p THEN
               ls_subcadena := ls_subcadena||substr(ls_original,i,1);
            END IF;
         ELSE
            j := j +1;
         END IF;
     END LOOP;
     return ls_subcadena;
END;
/


