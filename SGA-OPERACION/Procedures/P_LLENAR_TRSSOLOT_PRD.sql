CREATE OR REPLACE PROCEDURE OPERACION."P_LLENAR_TRSSOLOT_PRD" ( a_opcion in number,
  a_codsolot in number default null,
   a_numslc in char default null,
   a_numpsp in char default null,
   a_idopc in char default null,
   a_codcli in char default null ) IS

/******************************************************************************
  Llena las transacciones dsde los proyectos o solicitudes segun corresponda

  opcion 0 : Transciones desde un proyecto, instalaciones ( Proyecto se saca de la oferta comercial ?? )
  opcion 1 : Suspensiones o Cancelaciones dando como referencia un proyecto
  opcion 2 : Bajas sin proyecto de referencia solo cliente
  opcion 3 : Llenar lo que esta en la solicitud de OT
  opcion 4 : averiguar de que se trata y llamar a uno de los anteriores

  TIPOS
  -----
  Tipo 1 : Puntos a activar desde proy
  Tipo 2 : Equipos a activar desde proy
  Tipo 3 : Puntos desde la solicitud

     Ver        Date        Author           Solicitado por         Description
     ---------  ----------  ---------------  --------------         ----------------------
     1.0        27/10/2010  Widmer Quispe    Edilberto Astulle      Req: 123054 y 123052 Asignación de plataforma de acceso
******************************************************************************/
l_codcli solot.codcli%type;
l_numslc solot.numslc%type;
l_numpsp vtatabpspcli.numpsp%type;
l_idopc vtatabpspcli.idopc%type;
l_cont number;
L_TIPTRS NUMBER(8);
l_flg_ef number;

cursor cur_sol is
select s.codsolot, t.tiptrs from solot s, tiptrabajo t where
s.numslc = a_numslc and s.numpsp = a_numpsp and s.idopc = a_idopc and s.tiptra = t.tiptra and s.estsol <> 13;


BEGIN
  IF A_OPCION = 0 THEN

     /* Primero se hara una validacion
         Si se tiene aprobado algun punto aprpobado => validar cuales faltan y cuales estan de mas
         Sino borrar e ingresar todo
      */

     select count(*) into l_cont from trssolot where numslc = a_numslc and esttrs = 2;
      if l_cont = 0 then -- Normal
        null;
      else -- se eliminan aquellos que no esten ejecutados
       delete trssolot where numslc = a_numslc and esttrs <> 2 ;
      end if;

      -- se recorren todas las solicitudes
      for lc1 in cur_sol loop

        select count(*) into l_flg_ef from solotpto where codsolot = lc1.codsolot and efpto is not null;
         if l_flg_ef > 0 then -- Tiene campos con efpto lleno

          insert into trssolot ( NUMSLC, NUMPTO, CODINSSRV, TIPO, ESTTRS, tiptrs, CODSRVNUE, BWNUE, codsolot,idplataforma --<1.0>
          )
          SELECT vtadetptoenl.numslc,
              vtadetptoenl.numpto,
              vtadetptoenl.numckt,
              1,
               1,
               lc1.tiptrs,
              vtadetptoenl.codsrv,
              vtadetptoenl.banwid,
               lc1.codsolot,
               nvl(vtadetptoenl.idplataforma,s.idplataforma) --1.0
          FROM  vtadetptoenl,
              ( select v.numslc, v.numpto from vtadetptoenl v
                 where v.numslc = a_numslc
                 minus
                 select t.numslc, t.numpto from trssolot t
                 where t.numslc = a_numslc and t.tipo = 1
               ) p,
             solotpto s
          WHERE
               vtadetptoenl.numslc = a_numslc and
              vtadetptoenl.numslc = p.numslc and
              vtadetptoenl.numpto = p.numpto and
               s.codsolot = lc1.codsolot and
               lpad(s.efpto,5,'0') = vtadetptoenl.numpto ;


         insert into trssolot ( NUMSLC, NUMPTO, CODINSSRV, TIPO, ESTTRS, tiptrs, CODSRVNUE, BWNUE , IDADD, codsolot,idplataforma --<1.0>
        )
         SELECT vtadetptoenl.numslc,
              vtadetptoenl.numpto,
              vtadetptoenl.numckt,
              2,
               1,
               lc1.tiptrs,
              vtadetptoenl.codsrv,
              vtadetptoenl.banwid,
              vtadetslcfacequ.idadd,
               lc1.codsolot,
              nvl(vtadetptoenl.idplataforma,s.idplataforma) --1.0
           FROM vtadetptoenl,
              ( select v.numslc, v.numpto from vtadetptoenl v
                 where v.numslc = a_numslc
                 minus
                 select t.numslc, t.numpto from trssolot t
                 where t.numslc = a_numslc and t.tipo = 2
               ) p,
              vtadetslcfacequ,
               solotpto s
          WHERE
              vtadetptoenl.numslc = a_numslc and
               vtadetslcfacequ.numslc = vtadetptoenl.numslc and
              vtadetslcfacequ.numpto = vtadetptoenl.numpto and
                vtadetptoenl.numslc = p.numslc and
              vtadetptoenl.numpto = p.numpto and
               s.codsolot = lc1.codsolot and
               lpad(s.efpto,5,'0') = vtadetptoenl.numpto ;

         else
          insert into trssolot ( NUMSLC, NUMPTO, CODINSSRV, TIPO, ESTTRS, tiptrs, CODSRVNUE, BWNUE, codsolot,idplataforma --<1.0>
          )
          SELECT distinct vtadetptoenl.numslc,
              vtadetptoenl.numpto,
              vtadetptoenl.numckt,
              1,
               1,
               lc1.tiptrs,
              vtadetptoenl.codsrv,
              vtadetptoenl.banwid,
               lc1.codsolot,
               nvl(vtadetptoenl.idplataforma,s.idplataforma) --1.0
          FROM  vtadetptoenl,
              ( select v.numslc, v.numpto from vtadetptoenl v
                 where v.numslc = a_numslc
                 minus
                 select t.numslc, t.numpto from trssolot t
                 where t.numslc = a_numslc and t.tipo = 1
               ) p,
             solotpto s
          WHERE
               vtadetptoenl.numslc = a_numslc and
              vtadetptoenl.numslc = p.numslc and
              vtadetptoenl.numpto = p.numpto and
               s.codsolot = lc1.codsolot and
               s.codinssrv = vtadetptoenl.numckt ;


         insert into trssolot ( NUMSLC, NUMPTO, CODINSSRV, TIPO, ESTTRS, tiptrs, CODSRVNUE, BWNUE , IDADD, codsolot,idplataforma --<1.0>
        )
         SELECT distinct vtadetptoenl.numslc,
              vtadetptoenl.numpto,
              vtadetptoenl.numckt,
              2,
               1,
               lc1.tiptrs,
              vtadetptoenl.codsrv,
              vtadetptoenl.banwid,
              vtadetslcfacequ.idadd,
               lc1.codsolot,
               nvl(vtadetptoenl.idplataforma,s.idplataforma) --1.0
           FROM vtadetptoenl,
              ( select v.numslc, v.numpto from vtadetptoenl v
                 where v.numslc = a_numslc
                 minus
                 select t.numslc, t.numpto from trssolot t
                 where t.numslc = a_numslc and t.tipo = 2
               ) p,
              vtadetslcfacequ,
               solotpto s
          WHERE
              vtadetptoenl.numslc = a_numslc and
               vtadetslcfacequ.numslc = vtadetptoenl.numslc and
              vtadetslcfacequ.numpto = vtadetptoenl.numpto and
                vtadetptoenl.numslc = p.numslc and
              vtadetptoenl.numpto = p.numpto and
               s.codsolot = lc1.codsolot and
               s.codinssrv = vtadetptoenl.numckt;

      end if;


      end loop;



  ELSIF  A_OPCION = 1 THEN
    null;
  ELSIF  A_OPCION = 2 THEN
    null;
  ELSIF  A_OPCION = 3 THEN

      delete trssolot where codsolot = a_codsolot and esttrs <> 2;

      select t.tiptrs INTO L_TIPTRS from solot s, tiptrabajo t where
    s.codsolot = a_codsolot and s.tiptra = t.tiptra;

     insert into trssolot ( NUMSLC, NUMPTO, CODINSSRV, TIPO, ESTTRS, TIPTRS, CODSRVNUE, BWNUE, codsolot,idplataforma --<1.0>
      )
     SELECT null,
           null,
           s.codinssrv,
           3,
            1,
            L_TIPTRS,
           s.codsrvnue,
           s.BWNUE,
            a_codsolot,
            s.idplataforma --1.0
     FROM  solotpto s
     WHERE
            s.codsolot = a_codsolot and s.codinssrv is not null and
            s.codinssrv not in ( select t.codinssrv from trssolot t where t.codsolot = a_codsolot and t.esttrs = 2 )
      union all -- Se inseratn aquellas que vengan por CID y no por CODINSSRV
           SELECT null,
           null,
           i.codinssrv,
           3,
            1,
            L_TIPTRS,
           s.codsrvnue,
           s.BWNUE,
            a_codsolot,
            s.idplataforma --1.0
     FROM  solotpto s,
            inssrv i
     WHERE s.cid = i.cid and
            s.codsolot = a_codsolot and s.codinssrv is null and s.cid is not null and
            i.codinssrv not in ( select t.codinssrv from trssolot t where t.codsolot = a_codsolot and t.esttrs = 2 );


  ELSIF  A_OPCION = 4 THEN
     if a_codsolot is not null then
        select codcli, numslc, numpsp, idopc into l_codcli, l_numslc, l_numpsp, l_idopc from solot where codsolot = a_codsolot ;
         if l_numpsp is null then -- se trata dej una sol manual
        P_LLENAR_TRSSOLOT_PRD ( 3, a_codsolot, null, null, null, null );
         else
        P_LLENAR_TRSSOLOT_PRD ( 0, null, l_numslc, l_numpsp, l_idopc , null );
         end if;

      end if;

  END IF;

END;
/


