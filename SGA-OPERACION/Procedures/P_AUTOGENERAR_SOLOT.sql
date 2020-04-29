CREATE OR REPLACE PROCEDURE OPERACION.P_AUTOGENERAR_SOLOT(
   a_codsolot in number,
   a_tiptra in number,
   a_codcli in char,
   a_numslc in char,
   a_recosi in number,
   a_cliint in string default null,
   a_tiprec in char default null,
   a_codmotot in number default null,
   a_obs in varchar2 default null
) IS
tmpVar NUMBER;
l_origen char(1);
l_tiprec char(1);
l_punto number;
l_tipsrv solot.tipsrv%type;
BEGIN

   if a_recosi is not null then
      l_origen := 'R';
      l_tiprec := upper(nvl(a_tiprec, 'R'));

      select s.tipsrv
         into l_tipsrv
         from incidence i, TYPESERVICE_ATENTION s
         where
         i.codtypeservice = s.codtypeservice
         and i.codincidence = a_recosi;

   else
      l_origen := 'A';
      l_tiprec := null;
   end if;

   insert into solot(CODSOLOT, TIPTRA, ESTSOL, CODCLI, NUMSLC, DERIVADO,RECOSI, origen, cliint, tiprec, tipsrv, FECINI, CODMOTOT, OBSERVACION)
   values (a_codsolot,a_tiptra,11,a_codcli,a_numslc,1,a_recosi, l_origen, a_cliint, l_tiprec, l_tipsrv, SYSDATE, A_CODMOTOT, A_OBS);

   if a_recosi is not null then
      select nvl(max(punto),0) into l_punto from solotpto where codsolot = a_codsolot;

      insert into solotpto (codsolot, punto, codinssrv, cid, descripcion, direccion, codubi,
         codsrvnue, bwnue, codpostal, tipo, cantidad)
      select  a_codsolot, l_punto + rownum, i.codinssrv, i.cid, i.descripcion, i.direccion, i.codubi,
         i.codsrv, i.bw, i.codpostal, 2, 1
         from CUSTOMERXINCIDENCE ci,
            inssrv i
         where ci.SERVICENUMBER = i.codinssrv and ci.codincidence = a_recosi;
   end if;

END;
/


