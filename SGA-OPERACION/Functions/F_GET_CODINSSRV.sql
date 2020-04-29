CREATE OR REPLACE FUNCTION OPERACION.F_GET_CODINSSRV(P_CODEF NUMBER,P_PUNTO NUMBER) return number
IS
v_codinssrv solotpto.codinssrv%type;
data solot.numslc%type;
begin
  data:= lpad(to_char(P_CODEF),10,'0');

            select 
            codinssrv into v_codinssrv
                 from solotpto, solot
                where solot.codsolot = solotpto.codsolot
                  and solotpto.efpto = P_PUNTO
                  and solot.numslc = data
                  and rownum = 1;

            return v_codinssrv;
exception
         when others then
            return null;
end;
/


