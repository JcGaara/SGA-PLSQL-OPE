CREATE OR REPLACE FUNCTION OPERACION.f_get_estado_etapa(an_codsolot number, an_punto number) return varchar2 is
  Result varchar2(100);
begin
  select decode((select nvl(count(*),0)
                                                                  from solotptoeta,
                      etapa,
                      preusufas
                                                      where solotptoeta.codeta = etapa.codeta
                 and etapa.codeta = preusufas.codeta
                 and preusufas.codfas >= 3
                 and preusufas.codusu = user
                 and esteta >= 3
                 and codsolot = an_codsolot
                 and punto = an_punto),0,'Pendiente','Liquidado')
  into Result
  from dual;
  return(Result);
end f_get_estado_etapa;
/


