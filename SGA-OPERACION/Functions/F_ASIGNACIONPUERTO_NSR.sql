CREATE OR REPLACE FUNCTION OPERACION.f_asignacionpuerto_nsr(pv_nsr in cidxide.nsr%type)
return varchar2 is
vv_pvnsr cidxide.nsr%type;
CURSOR c_nsr IS
     SELECT ide,rownum FROM CIDXIDE WHERE UPPER(trim(CIDXIDE.NSR)) like UPPER(vv_pvnsr);
v_cadena varchar2(500);
BEGIN
      vv_pvnsr := '%'||pv_nsr||'%';
      v_cadena := '';
      for lc_nsr in c_nsr loop
        if lc_nsr.rownum = 1 then
           v_cadena := TO_CHAR( lc_nsr.ide );
        else
           v_cadena := v_cadena ||',' || TO_CHAR( lc_nsr.ide );
        end if;
      end loop;
      RETURN v_cadena;
  exception
  when no_data_found then
   return '';
END;
/


