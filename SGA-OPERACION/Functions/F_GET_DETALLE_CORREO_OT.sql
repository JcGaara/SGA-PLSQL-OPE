CREATE OR REPLACE FUNCTION OPERACION.F_GET_DETALLE_CORREO_OT(a_solicitud in number) RETURN varchar2 IS
lc_men varchar2(4000);
lc_temp varchar2(4000);
cursor cur_sol is
  SELECT 'CID: '||nvl(to_char(solotpto.CID),'...')||' '||solotpto.descripcion||' en '||solotpto.direccion||'  Servicio: '||rtrim(tystabsrv.dscsrv) linea
    FROM inssrv,
         solotpto,
         tystabsrv
   WHERE solotpto.codinssrv = inssrv.codinssrv and
         solotpto.codsrvnue = tystabsrv.codsrv and inssrv.tipinssrv = 1 and
         solotpto.codsolot = a_solicitud;
BEGIN


select vtatabcli.nomcli into lc_temp from vtatabcli, solot where solot.codsolot = a_solicitud and vtatabcli.codcli (+) = solot.codcli;

lc_men := lc_temp || chr(13) || chr(13);

for lcur in cur_sol loop
   lc_men := lc_men || chr(13) || lcur.linea;
end loop;
return lc_men;
exception
  when others then
     return '';

END;
/


