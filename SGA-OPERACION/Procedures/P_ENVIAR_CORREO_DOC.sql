CREATE OR REPLACE PROCEDURE OPERACION.P_ENVIAR_CORREO_DOC  IS
ls_texto varchar2(4000);
ls_destino  varchar2(4000);

ls_mail varchar2(100);

cursor cur is
   select
		  'OT: '|| ot_ins.codot ||chr(10)||
        'CID: '|| solotpto.cid ||chr(10)||
       'Cliente: '||vtatabcli.nomcli ||chr(10)||
       'Sede: '||solotpto.descripcion ||chr(10)||
       'Direccion: '||solotpto.direccion ||chr(10) linea,
       solotpto_id.RESPONSABLE_DOC resp,
			ceil( sysdate - solotpto.fecinisrv ) dias_faltantes
   from solot ,
        solotpto,
        solotpto_id,
        tystipsrv e,
        tystabsrv f,
        vtatabcli,
        vtatabdst,
    (select codsolot, codot, tiptra, fecusu fecgen, feccom from ot where area = 21) ot_ins
   where
         solot.codcli = vtatabcli.codcli and
         solotpto.codsolot = solotpto_id.codsolot and
         solotpto.punto = solotpto_id.punto and
         solot.codsolot = solotpto.codsolot and
         solotpto.codubi = vtatabdst.codubi (+) and
         solotpto.codsrvnue = f.codsrv (+) and
         f.tipsrv = e.tipsrv (+) and
         solot.codsolot = ot_ins.codsolot
         and ceil( sysdate - solotpto.fecinisrv ) = 4
         and solotpto_id.RESPONSABLE_DOC  is not null;

BEGIN
   for lc1 in cur loop

   	ls_mail := null ;
      begin
	   	select email into ls_mail from usuarioope
			where usuario = lc1.resp;
      exception
      	when others then
         	ls_mail := null ;
      end;

      if ls_mail is not null then
         ls_texto := lc1.linea;
         P_envia_correo_de_texto_att('Documentacion pendiente', ls_mail , ls_texto);
--         P_envia_correo_de_texto_att('Documentacion pendiente', 'carlos.corrales@telmex.com' , ls_texto);
		end if;

   end loop;
END;
/


