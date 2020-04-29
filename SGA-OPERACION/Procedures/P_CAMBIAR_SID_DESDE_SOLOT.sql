CREATE OR REPLACE PROCEDURE OPERACION.p_cambiar_sid_desde_solot(an_codsolot solot.codsolot%type,  an_punto_origen otpto.punto%type,  an_punto_destino otpto.punto%type) IS
l_codcli char(8);
l_sid inssrv.codinssrv%type;

cursor cur_puntos is
select codot from ot where codsolot = an_codsolot;

BEGIN

/*
   -- SE HARAN UNAS VALIDACIONES PORSIACA
   SELECT A.CODCLI into l_codcli FROM SOLOT a where a.codsolot = an_codsolot;

   begin
      select codinssrv into l_sid from inssrv where codinssrv = an_punto_origen and codcli = l_codcli;
   exception
      when others then
         raise_application_error(-20500, 'Punto origen no corresponde');
   end;

   begin
      select codinssrv into l_sid from inssrv  where codinssrv = an_punto_destino and codcli = l_codcli;
   exception
      when others then
         raise_application_error(-20500, 'Punto destino no corresponde');
   end;
*/
   -- Se inserta todos los detalles
   insert into solotpto (CODSOLOT, PUNTO, TIPTRS, CODSRVANT, BWANT, CODSRVNUE, BWNUE, CODUSU, FECUSU, CODINSSRV, CID, DESCRIPCION, DIRECCION, TIPO, ESTADO, VISIBLE, PUERTA, POP, CODUBI, FECINI, FECFIN, FECINISRV, FECCOM, TIPTRAEF, TIPOTPTO)
   select an_codsolot, an_punto_destino, TIPTRS, CODSRVANT, BWANT, CODSRVNUE, BWNUE, CODUSU, FECUSU, CODINSSRV, CID, DESCRIPCION, DIRECCION, TIPO, ESTADO, VISIBLE, PUERTA, POP, CODUBI, FECINI, FECFIN, FECINISRV, FECCOM, TIPTRAEF, TIPOTPTO
   from solotpto where codsolot = an_codsolot and punto = an_punto_origen;

   for lc in cur_puntos loop
      p_cambiar_sid_ot(lc.codot, an_punto_origen ,  an_punto_destino );
   end loop;

   p_cambiar_sid_pre(an_codsolot , an_punto_origen ,  an_punto_destino );

   delete solotpto where codsolot = an_codsolot and punto = an_punto_origen;

END ;
/


