CREATE OR REPLACE PACKAGE BODY OPERACION.pq_lcheck is
 /************************************************************
   NOMBRE:     pq_lcheck
   PROPOSITO:  Utilitario para la generación de dígito de validación.
   PROGRAMADO EN JOB:  NO

   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------
   1.0        06/03/2009  Joseph Asencios  REQ 85029
   ***********************************************************/
-- Function and procedure implementations
  function f_binario(a_int Integer) return Varchar2 is
    i Integer;
    j  Integer;
    ai Integer;
    s  Varchar2(10);
    t  Varchar2(10);

  begin
     i := 0;
     s := '';
     ai := a_int;
     while i <= 3 Loop
       i := i + 1;
       j := mod(ai,2);
       ai := (ai - j) / 2;
       if j = 0 then
          t := '0';
       else
          t := '1';
       end if;
       s := t || s;
     end loop;
     return s;
  end;


  function  f_xor (a_int1 in Integer, a_int2 in Integer) return Integer is
    i      Integer;
    j      Integer;
    k      Integer;
    s1     Varchar2(10);
    s2     Varchar2(10);
    s3     Varchar2(10);
  begin
    s1 := f_binario(a_int1);
    s2 := f_binario(a_int2);
    s3 := '';
    j := 0;
    for i in 1..4 Loop
      if substr(s1,i,1) = substr(s2,i,1) then
        s3 := s3 || '0';
      else
        s3 := s3 || '1';
      end if;
    End Loop;
    k := 8;
    j := 0;
    For i in 1..4 Loop
      if substr(s3,i,1) = '1' then
         j := j + k;
      end if;
      k := k / 2;
    End Loop;
    return j;
  end;

  function f_checksum(a_number Number) return Number is
    i        Integer;
    j        Integer;
    l        Integer;
    t        Integer;
    c        Integer;
    r        Varchar2(10);
    s        Varchar2(10);
  begin
    j := 0;
    s := To_Char(a_number);
    s := Trim(s);
    l := Length(s);
    t := To_Number(Substr(s,1,1));
    for i in 2..l Loop
      j := To_Number(Substr(s,i,1));
      t := f_xor(t,j);
    End Loop;
    if t > 9 then
       t := mod(t,10);
    end if;
    c := a_number * 10 + t;
    return c;
  end;

end pq_lcheck;
/


