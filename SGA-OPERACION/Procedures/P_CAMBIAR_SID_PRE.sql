CREATE OR REPLACE PROCEDURE OPERACION.p_cambiar_sid_pre(an_codsolot solot.codsolot%type,  an_punto_origen inssrv.codinssrv%type,  an_punto_destino inssrv.codinssrv%type) IS
l_codcli char(8);
l_sid inssrv.codinssrv%type;
l_pre preubi.codpre%type;
tmpvar number;


BEGIN

   -- SE HARAN UNAS VALIDACIONES PORSIACA
   SELECT A.CODCLI into l_codcli FROM SOLOT a where a.codsolot =  an_codsolot ;

/*
   begin
      select codinssrv into l_sid from inssrv where codinssrv = an_punto_origen and codcli = l_codcli;
   exception
      when others then
         raise_application_error(-20500, 'Punto origen no corresponde');
   end;
*/
   begin
      select codinssrv into l_sid from inssrv  where codinssrv = an_punto_destino and codcli = l_codcli;
   exception
      when others then
         raise_application_error(-20500, 'Punto destino no corresponde');
   end;


   select count(*) into tmpvar from presupuesto where codsolot = an_codsolot ;
   if tmpvar > 0 then
      select codpre into l_pre from presupuesto where codsolot = an_codsolot ;

	   update preubi set codinssrv =  an_punto_destino, cid = (select to_number(numero) from inssrv where codinssrv = an_punto_destino )
   	where  codpre = l_pre and codinssrv = an_punto_origen;
   else
   	null;
   end if;

/*   -- Se inserta todos los detalles
   insert into preubi (CODPRE, CODINSSRV, IDUBI, CID, CODUBIRED, DISOBRA, DIROBRA,  FECINI, FECFIN, FECUSU, CODUSU, DESCRIPCION, ESTUBI, CODCON)
   select l_pre, an_punto_destino, null, CID, CODUBIRED, DISOBRA, DIROBRA,  FECINI, FECFIN, FECUSU, CODUSU, DESCRIPCION, ESTUBI, CODCON
   from preubi where codpre = l_pre and codinssrv = an_punto_origen;

   update preubi set cid = (select to_number(numero) from inssrv where codinssrv = preubi.codinssrv )
   where  codpre = l_pre and codinssrv = an_punto_destino;

   -- se borra todo rastro del cid anterior
   delete preubi where codpre = l_pre and codinssrv = an_punto_origen;
*/

END ;
/


