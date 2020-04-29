CREATE OR REPLACE FUNCTION OPERACION.F_CREAR_SOLOT_VARIAS(a_numslc in char, a_estado in number,
 a_tipsrv in char default '0000' ,  a_numpsp in char default null, a_idopc in char default null, a_tipcon IN CHAR default null ) RETURN NUMBER IS
/******************************************************************************
 CREA una solicitud de OT en base a un proyecto
******************************************************************************/
ln_codsolot number;
ln_tiptra number;
ln_motivo number;
lc_tipsrv solot.tipsrv%type;
ln_codef  efpto.codef%type;
ln_cont number(3);

cursor cur_tipos is
select tiptra, count(*) from efpto where codef = ln_codef
group by tiptra
order by 2 desc;

BEGIN
	-- solo crea una OT por Proyecto
	ln_codef := to_number(a_numslc);
   ln_motivo := null;

   for lcur in cur_tipos loop
   	ln_tiptra := lcur.tiptra;
      exit;
   end loop;

   if ln_tiptra is null then
   	ln_tiptra := 1;
   end if;

   -- Se obtiene el servicio del EF
   select tipsrv into lc_tipsrv from ef where numslc = a_numslc;
   if lc_tipsrv is null or lc_tipsrv = '0000' then
      lc_tipsrv := a_tipsrv;
   end if;

   if lc_tipsrv is null then
      lc_tipsrv := '0000';
   end if;

   -- Se obtiene la llave
   select F_GET_CLAVE_SOLOT() into ln_codsolot from DUAL;
   -- Se inserta la cabecera
   insert into solot(codsolot,tiptra,codmotot, estsol,tipsrv,numslc,  numpsp, idopc , tipcon)
   values (ln_codsolot, ln_tiptra, ln_motivo, a_estado, a_tipsrv, a_numslc, a_numpsp, a_idopc, a_tipcon);

   p_llenar_solotpto_prod(ln_codsolot);

   P_LLENAR_TRSSOLOT_prd( 0, null, a_numslc, a_numpsp, a_idopc ) ;

   return ln_codsolot;
/*   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       return Null;
*/
END;
/


