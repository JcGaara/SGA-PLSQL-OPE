CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTO_AD
AFTER DELETE ON SOLOTPTO
FOR EACH ROW
DECLARE
l_idubi preubi.IDUBI%type;
l_codpre preubi.CODPRE%type;
BEGIN
   BEGIN
   SELECT idubi, codpre into l_idubi, l_codpre from preubi where  preubi.CODSOLOT=:old.codsolot and preubi.PUNTO=:old.punto;
   delete from preubieta where codpre=l_codpre and idubi=l_idubi;
   delete from preubi where preubi.CODSOLOT=:old.codsolot and preubi.PUNTO=:old.punto;
   EXCEPTION
     WHEN OTHERS THEN
       Null;
   END;
END T_SOLOTPTO_AD;
/



