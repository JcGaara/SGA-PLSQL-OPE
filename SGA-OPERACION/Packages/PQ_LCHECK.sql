CREATE OR REPLACE PACKAGE OPERACION.pq_lcheck is

  function f_binario(a_int in Integer) return Varchar2;
  function  f_xor (a_int1 in Integer, a_int2 in Integer) return Integer;
  function f_checksum(a_number Number) return Number;

end pq_lcheck;
/


