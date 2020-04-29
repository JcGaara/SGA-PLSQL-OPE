CREATE OR REPLACE FUNCTION OPERACION.F_GET_URL_TV2(a_cid number)
return varchar is
ln_url varchar2(1000);
ln_codequipo number;
ln_equipo number;
ln_equiporpv number;
ls_servidor varchar2(1000);
ls_directorio varchar2(1000);
ls_tipequrep varchar2(1000);
ls_equipored varchar2(1000);
begin

  select s.codequipo, s.codequiporpv
  into   ln_equipo, ln_equiporpv
  from   metasolv.servxtrafixequipo s
  where  s.codequipo in (select codequipo from equipored where codequipo in (select codequipo from puertoxequipo where ide in (select ide from cidxide where cid = a_cid)));

  if ( (ln_equipo = ln_equiporpv) or (ln_equiporpv is null) ) then
     ln_codequipo := ln_equipo;
  else
     ln_codequipo := ln_equiporpv;
  end if;

  select (SELECT descripcion FROM OPEDD WHERE TIPOPEDD = 179 and codigon = s.servidor) servidor,
       (SELECT descripcion FROM OPEDD WHERE TIPOPEDD = 180 and codigon = s.directorio) directorio,
       (SELECT descripcion FROM OPEDD WHERE TIPOPEDD = 181 and codigon = s.tipequrep) tipequrep,
        lower(equipored)
  into   ls_servidor,
         ls_directorio,
         ls_tipequrep,
        ls_equipored
  from   metasolv.servxtrafixequipo s
  where  s.codequipo = ln_codequipo;

  ln_url := 'http://'||ls_servidor||'/~cricket/cricket/weekly.cgi?target=%2F'||ls_directorio||'%2F'||ls_tipequrep||'%2F'||ls_equipored||'%2Fcid'||to_char(a_cid)||';view=Trafico';

  return ln_url;
end F_GET_URL_TV2;
/


