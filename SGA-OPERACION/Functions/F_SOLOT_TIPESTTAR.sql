CREATE OR REPLACE FUNCTION OPERACION.F_SOLOT_TIPESTTAR(as_query varchar2) return number is
  ln_cant number;
begin

  execute immediate as_query into ln_cant;

  return(ln_cant);

end f_solot_tipesttar;
/


