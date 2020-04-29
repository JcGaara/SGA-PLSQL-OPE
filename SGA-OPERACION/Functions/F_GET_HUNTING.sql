CREATE OR REPLACE FUNCTION OPERACION.F_GET_HUNTING( ls_codnumtel in number) RETURN number IS

ls_hunting number;

BEGIN
   begin

   SELECT numtel.NUMERO INTO ls_hunting FROM HUNTING, INSSRV, NUMTEL
   WHERE ( INSSRV.CODINSSRV = NUMTEL.CODINSSRV ) and
         ( HUNTING.CODNUMTEL = NUMTEL.CODNUMTEL ) and
         ( ( NUMTEL.CODNUMTEL = ls_codnumtel ) );

      return ls_hunting;

      exception
          when others then
         return null;

   end;
END;
/


