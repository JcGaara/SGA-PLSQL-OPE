create or replace package body OPERACION.PKG_MIGRACION_SGA_BSCS is

-------------------------------------------------------------------

procedure MIGRSS_LISTA_MIGRACION(K_FECHA  DATE,
                                 K_NERROR OUT INTEGER,
                                 K_VERROR OUT VARCHAR2 ) is
/*****************************************************************
'* Nombre SP : MIGRSS_LISTA_MIGRACION
'* Propósito : listar los Clientes Masivos Activos junto con sus Servicios y generar Sots de Baja Administrativa
'* Input : Fecha de Proceso
'* Output : Codigo y Mensaje de Error, si lo hubiera
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_CODRESULTADO   PLS_INTEGER;
  V_RESULTADO      VARCHAR2(4000);/**/
  V_RESULT         VARCHAR2(1000);
  V_DATOS_CLIENTE  T_DATOSXCLIENTE;
  V_CONTROL        PLS_INTEGER;
  V_RETORNO        BOOLEAN;
  V_PRINC_PROCESS  PLS_INTEGER;
  V_FECHA          DATE;
  V_IDCAB          NUMBER(10);
  V_SOTEMPBAJA     NUMBER(8);
  V_CLIENTE        T_CLIENTE;
  V_CANTIDAD       PLS_INTEGER;
  V_CANT_CLI_MIGRA PLS_INTEGER;
  V_CANT_CLI_PROC  PLS_INTEGER;
  V_CANT_DIF_CLI   PLS_INTEGER;
  V_ERRORS         EXCEPTION;
  V_ERRORMIGRA     EXCEPTION;
  V_ERRORSERV      EXCEPTION;
  V_ERRDETSERV     EXCEPTION;

  cursor lista_clientesBD(P_CODCLI vtatabcli.codcli%type) is
     select DATAC_TIPO_PERSONA   tipopersona,
            DATAV_NOMABR         nombreabr,
            DATAV_NOMCLI         nomcli,
            DATAV_APEPAT         apepat,
            DATAV_APEMAT         apemat,
            DATAC_TIPDOC         idtipodoc,
            DATAV_DESCDOC        tipodoc,
            DATAV_NUMDOC         doccliente,
            DATAD_FECNAC         fechanac,
            DATAD_FECHAINI       fechaini,
            DATAD_FECHAFIN       fechafin,
            DATAV_EMAILPRINC     emailprinc,
            DATAV_EMAIL1         email1,
            DATAV_EMAIL2         email2,
            DATAC_TIPSRV         tipsrv,
            DATAV_DESCTIPSRV     familiaserv,
            DATAN_CODCAMP        codcampania,
            DATAV_DESCAMP        campania,
            DATAN_CODPLAZO       codplazo,
            DATAV_DESCPLAZO      plazo,
            DATAN_IDSOLUCION     idsolucion,
            DATAV_SOLUCION       solucion,
            DATAN_IDPAQ          idpaq,
            DATAV_PAQUETE        paquete,
            DATAC_TIPPROD        tipprod,
            DATAV_DESCTIPPROD    tipoproducto,
            DATAN_IDPROD         idprod,
            DATAV_PROD           producto,
            DATAV_EQ_PROD_SISACT eqprod_sisact,
            DATAC_CODSRV         codsrv,
            DATAV_SERVICIO       servicio,
            DATAV_EQ_SERV_SISACT eqserv_sisact,
            DATAV_DESCPLAN       descplan,
            DATAV_TIPOSERVICIO   tiposervicio,
            DATAN_IDESTSERV      idestado,
            DATAV_DESCESTSERV    estado,
            DATAN_IDTIPINSS      idtipoinssrv,
            DATAV_TIPINSS        tipoinssrv,
            DATAN_CODINSSRV      codinssrv,
            DATAN_PID            pid,
            DATAN_IDMARCAEQUIPO  idmarcaeq,
            DATAV_MARCAEQUIPO    marcaeq,
            DATAC_CODTIPEQU      codtipequ,
            DATAN_TIPEQU         tipequ,
            DATAV_TIPO_EQUIPO    tipoequipo,
            DATAV_EQU_TIPO       equ_tipo,
            DATAC_COD_EQUIPO     codequipo,
            DATAV_MODELO_EQUIPO  modeloequipo,
            DATAV_TIPO           tipo,
            DATAV_NUMERO         numero,
            DATAN_CONTROL        control,
            DATAC_IDPROYECTO     numslc,
            DATAV_PLAY           play,
            DATAN_CARGOFIJO      cargo,
            DATAN_CANTIDAD       cantidad,
            DATAC_PUBLICAR       publicar,
            DATAN_IDCICLO        idciclo,
            DATAV_DESCICLO       ciclo,
            DATAN_BW             bw,
            DATAN_CIDVENTA       cid,
            DATAC_CODSUCURSAL    codsucursal,
            DATAC_CODUBIGEO      codubi,
            DATAV_DIRVENTA       DirecVenta,
            DATAV_CODPOSVENTA    CodpostalVenta,
            DATAV_DESCVENTA      desc_venta,
            DATAC_COD_EV         id_vendedor,
            DATAC_IDTIPDOC_EV    idtipodoc_vendedor,
            DATAV_TIPDOC_EV      tipodoc_vendedor,
            DATAV_NUMDOC_EV      doc_vendedor,
            DATAV_NOM_EV         vendedor,
            DATAC_IDTIPVEN       idtipo_venta,
            DATAV_TIPVEN         tipo_venta,
            DATAV_IDCONT         nrodoc_venta,
            DATAN_NROCART        carta,
            DATAC_CODOPE         codope,
            DATAV_OPERADOR       operador,
            DATAN_PRESUS         presuscribir,
            DATAN_PUBLI          publicardoc,
            DATAN_IDTIPENVIO     idtipo_envio,
            DATAV_TIPENVIO       tipo_envio,
            DATAV_CORELEC        correo_envio,
            DATAV_IDDEP_DIRCLI   iddep_dircli,
            DATAC_IDPROV_DIRCLI  idprov_dircli,
            DATAC_IDDIST_DIRCLI  iddist_dircli,
            DATAV_DEPA_DIRCLI    dep_dircli,
            DATAV_PROV_DIRCLI    prov_dircli,
            DATAV_DIST_DIRCLI    dist_dircli,
            DATAV_DIRCLI         dircli,
            DATAC_CODUBIDIR      codubidir,
            DATAC_UBIGEODIR      ubigeodir,
            DATAC_IDTIPOVIADIR   idtipoviadir,
            DATAV_TIPOVIADIR     tipoviadir,
            DATAV_NOMVIADIR      nomviadir,
            DATAV_NUMVIADIR      numviadir,
            DATAN_IDTIPODOMIDIR  idtipodomidir,
            DATAV_TIPODOMIDIR    tipodomidir,
            DATAV_NOMURBDIR      nomurbdir,
            DATAN_IDZONADIR      idzonadir,
            DATAV_ZONADIR        zonadir,
            DATAV_REFERENCIADIR  referenciadir,
            DATAV_TELF1DIR       telf1dir,
            DATAV_TELF2DIR       telf2dir,
            DATAV_CODPOSDIR      codposdir,
            DATAV_MANZANADIR     manzanadir,
            DATAV_LOTEDIR        lotedir,
            DATAV_SECTORDIR      sectordir,
            DATAN_CODEDIFDIR     codedifdir,
            DATAV_EDIFICDIR      edificdir,
            DATAN_PISODIR        pisodir,
            DATAV_INTERIORDIR    interiordir,
            DATAV_NUM_INTERIORDIR num_interiordir,
            DATAV_IDPLANODIR     idplanodir,
            DATAV_PLANODIR       planodir,
            DATAV_IDDEPI         iddepartamentoi,
            DATAC_IDPROVI        idprovinciai,
            DATAC_IDDISTI        iddistritoi,
            DATAV_DEPARTAMENTOI  departamentoi,
            DATAV_PROVINCIAI     provinciai,
            DATAV_DISTRITOI      distritoi,
            DATAV_DIRSUCI        dirsuci,
            DATAV_NOMSUCI        nomsuci,
            DATAC_UBISUCI        ubisuci,
            DATAC_UBIGEOI        ubigeoi,
            DATAC_IDTIPOVIAI     idtipoviai,
            DATAV_TIPOVIAI       tipoviai,
            DATAV_NOMVIAI        nomviai,
            DATAV_NUMVIAI        numviai,
            DATAN_IDTIPODOMII    idtipodomii,
            DATAV_TIPODOMII      tipodomii,
            DATAN_IDTIPURBI      idtipourbi,
            DATAV_NOMURBI        nomurbi,
            DATAN_IDZONAI        idzonai,
            DATAV_ZONAI          zonai,
            DATAV_REFERENCIAI    referenciai,
            DATAV_TELF1I         telf1i,
            DATAV_TELF2I         telf2i,
            DATAV_CODPOSI        codposi,
            DATAV_MANZANAI       manzanai,
            DATAV_LOTEI          lotei,
            DATAV_SECTORI        sectori,
            DATAN_CODEDIFI       codedifi,
            DATAV_EDIFICIOI      edificioi,
            DATAN_PISOI          pisoi,
            DATAV_INTERIORI      interiori,
            DATAV_NUM_INTERIORI  num_interiori,
            DATAV_IDPLANOI       idplanoi,
            DATAV_PLANOI         planoi,
            DATAV_IDDEPF         iddepartamentof,
            DATAC_IDPROVF        idprovinciaf,
            DATAC_IDDISTF        iddistritof,
            DATAV_DEPARTAMENTOF  departamentof,
            DATAV_PROVINCIAF     provinciaf,
            DATAV_DISTRITOF      distritof,
            DATAV_DIRSUCF        dirsucf,
            DATAV_NOMSUCF        nomsucf,
            DATAC_UBISUCF        ubisucf,
            DATAC_UBIGEOF        ubigeof,
            DATAC_IDTIPOVIAF     idtipoviaf,
            DATAV_TIPOVIAF       tipoviaf,
            DATAV_NOMVIAF        nomviaf,
            DATAV_NUMVIAF        numviaf,
            DATAN_IDTIPODOMIF    idtipodomif,
            DATAV_TIPODOMIF      tipodomif,
            DATAN_IDTIPURBF      idtipourbf,
            DATAV_NOMURBF        nomurbf,
            DATAN_IDZONAF        idzonaf,
            DATAV_ZONAF          zonaf,
            DATAV_REFERENCIAF    referenciaf,
            DATAV_TELF1F         telf1f,
            DATAV_TELF2F         telf2f,
            DATAV_CODPOSF        codposf,
            DATAV_MANZANAF       manzanaf,
            DATAV_LOTEF          lotef,
            DATAV_SECTORF        sectorf,
            DATAN_CODEDIFF       codediff,
            DATAV_EDIFICIOF      edificiof,
            DATAN_PISOF          pisof,
            DATAV_INTERIORF      interiorf,
            DATAV_NUM_INTERIORF  num_interiorf,
            DATAV_IDPLANOF       idplanof,
            DATAV_PLANOF         planof,
            DATAN_SOLOTACTV      codsolotact,
            DATAI_TIPOAGENDA     tipo_agenda
       from OPERACION.MIGRT_DATAPRINC
      where DATAC_CODCLI         = P_CODCLI
        and nvl(DATAI_PROCESADO,0) != 1
        order by DATAC_TIPSRV, DATAC_TIPPROD, DATAV_TIPOSERVICIO desc;

  cursor lista_clientes_migrar(P_FECHA DATE) is
       select DATAC_CODCLI codcli
         from OPERACION.MIGRT_CLIENTES_A_MIGRAR
        where trunc(DATAD_FEC_BAJA) = trunc(P_FECHA)
        order by DATAC_CODCLI;

begin
   V_FECHA := trunc(K_FECHA);
   if V_FECHA is null then
     V_FECHA := trunc(SYSDATE);
   end if;

   for listamigrar in lista_clientes_migrar(V_FECHA) loop
       V_CONTROL := 0; V_RESULT := ''; V_RESULTADO := '';V_IDCAB := null; V_SOTEMPBAJA := null;

       if MIGRFUN_EXISTE_EN_LISTA(listamigrar.codcli) then

           for listaBD in lista_clientesBD(listamigrar.codcli) loop
                  V_DATOS_CLIENTE.DATAC_TIPSRV       := listaBD.Tipsrv;
                  V_DATOS_CLIENTE.DATAN_CIDVENTA     := listaBD.Cid;
                  V_DATOS_CLIENTE.DATAC_CODSUCURSAL  := listaBD.Codsucursal;
                  V_DATOS_CLIENTE.DATAC_CODUBIGEO    := listaBD.Codubi;
                  V_DATOS_CLIENTE.DATAV_DIRVENTA     := listaBD.DirecVenta;
                  V_DATOS_CLIENTE.DATAV_CODPOSVENTA  := listaBD.CodpostalVenta;
                  V_DATOS_CLIENTE.DATAV_DESCVENTA    := listaBD.Desc_Venta;
                  V_CODRESULTADO := 0; V_CANTIDAD := 0; V_RETORNO := false;/**/

                  if V_CONTROL = 0 then
                    V_DATOS_CLIENTE.DATAC_TIPO_PERSONA := listaBD.Tipopersona;
                    V_DATOS_CLIENTE.DATAC_CODCLI       := listamigrar.codcli;
                    V_DATOS_CLIENTE.DATAV_NOMABR       := listaBD.Nombreabr;
                    V_DATOS_CLIENTE.DATAV_NOMCLI       := listaBD.nomcli;
                    V_DATOS_CLIENTE.DATAV_APEPAT       := listaBD.Apepat;
                    V_DATOS_CLIENTE.DATAV_APEMAT       := listaBD.Apemat;
                    V_DATOS_CLIENTE.DATAC_TIPDOC       := listaBD.idtipodoc;
                    V_DATOS_CLIENTE.DATAV_DESCDOC      := listaBD.Tipodoc;
                    V_DATOS_CLIENTE.DATAV_NUMDOC       := listaBD.doccliente;
                    V_DATOS_CLIENTE.DATAD_FECNAC       := listaBD.Fechanac;
                    V_DATOS_CLIENTE.DATAD_FECHAINI     := listaBD.Fechaini;
                    V_DATOS_CLIENTE.DATAD_FECHAFIN     := listaBD.Fechafin;
                    V_DATOS_CLIENTE.DATAV_EMAILPRINC   := listaBD.Emailprinc;
                    V_DATOS_CLIENTE.DATAV_EMAIL1       := listaBD.Email1;
                    V_DATOS_CLIENTE.DATAV_EMAIL2       := listaBD.Email2;
                    V_DATOS_CLIENTE.DATAC_IDPROYECTO   := listaBD.Numslc;
                    V_DATOS_CLIENTE.DATAV_PLAY         := listaBD.Play;
                    V_DATOS_CLIENTE.DATAC_COD_EV       := listaBD.Id_Vendedor;
                    V_DATOS_CLIENTE.DATAC_IDTIPDOC_EV  := listaBD.Idtipodoc_Vendedor;
                    V_DATOS_CLIENTE.DATAV_TIPDOC_EV    := listaBD.Tipodoc_Vendedor;
                    V_DATOS_CLIENTE.DATAV_NUMDOC_EV    := listaBD.Doc_Vendedor;
                    V_DATOS_CLIENTE.DATAV_NOM_EV       := listaBD.Vendedor;
                    V_DATOS_CLIENTE.DATAC_IDTIPVEN     := listaBD.Idtipo_Venta;
                    V_DATOS_CLIENTE.DATAV_TIPVEN       := listaBD.Tipo_Venta;
                    V_DATOS_CLIENTE.DATAV_IDCONT       := listaBD.Nrodoc_Venta;
                    V_DATOS_CLIENTE.DATAN_NROCART      := listaBD.Carta;
                    V_DATOS_CLIENTE.DATAC_CODOPE       := listaBD.Codope;
                    V_DATOS_CLIENTE.DATAV_OPERADOR     := listaBD.Operador;
                    V_DATOS_CLIENTE.DATAN_PRESUS       := listaBD.Presuscribir;
                    V_DATOS_CLIENTE.DATAN_PUBLI        := listaBD.Publicardoc;
                    V_DATOS_CLIENTE.DATAN_IDTIPENVIO   := listaBD.Idtipo_Envio;
                    V_DATOS_CLIENTE.DATAV_TIPENVIO     := listaBD.Tipo_Envio;
                    V_DATOS_CLIENTE.DATAV_CORELEC      := listaBD.Correo_Envio;
                    V_DATOS_CLIENTE.DATAV_IDDEP_DIRCLI := listaBD.Iddep_Dircli;
                    V_DATOS_CLIENTE.DATAC_IDPROV_DIRCLI:= listaBD.Idprov_Dircli;
                    V_DATOS_CLIENTE.DATAC_IDDIST_DIRCLI:= listaBD.Iddist_Dircli;
                    V_DATOS_CLIENTE.DATAV_DEPA_DIRCLI  := listaBD.Dep_Dircli;
                    V_DATOS_CLIENTE.DATAV_PROV_DIRCLI  := listaBD.Prov_Dircli;
                    V_DATOS_CLIENTE.DATAV_DIST_DIRCLI  := listaBD.Dist_Dircli;
                    V_DATOS_CLIENTE.DATAV_DIRCLI       := listaBD.Dircli;
                    V_DATOS_CLIENTE.DATAC_CODUBIDIR    := listaBD.Codubidir;
                    V_DATOS_CLIENTE.DATAC_UBIGEODIR    := listaBD.Ubigeodir;
                    V_DATOS_CLIENTE.DATAC_IDTIPOVIADIR := listaBD.Idtipoviadir;
                    V_DATOS_CLIENTE.DATAV_TIPOVIADIR   := listaBD.Tipoviadir;
                    V_DATOS_CLIENTE.DATAV_NOMVIADIR    := listaBD.Nomviadir;
                    V_DATOS_CLIENTE.DATAV_NUMVIADIR    := listaBD.Numviadir;
                    V_DATOS_CLIENTE.DATAN_IDTIPODOMIDIR:= listaBD.Idtipodomidir;
                    V_DATOS_CLIENTE.DATAV_TIPODOMIDIR  := listaBD.Tipodomidir;
                    V_DATOS_CLIENTE.DATAV_NOMURBDIR    := listaBD.Nomurbdir;
                    V_DATOS_CLIENTE.DATAN_IDZONADIR    := listaBD.Idzonadir;
                    V_DATOS_CLIENTE.DATAV_ZONADIR      := listaBD.Zonadir;
                    V_DATOS_CLIENTE.DATAV_REFERENCIADIR:= listaBD.Referenciadir;
                    V_DATOS_CLIENTE.DATAV_TELF1DIR     := listaBD.Telf1dir;
                    V_DATOS_CLIENTE.DATAV_TELF2DIR     := listaBD.Telf2dir;
                    V_DATOS_CLIENTE.DATAV_CODPOSDIR    := listaBD.Codposdir;
                    V_DATOS_CLIENTE.DATAV_MANZANADIR   := listaBD.Manzanadir;
                    V_DATOS_CLIENTE.DATAV_LOTEDIR      := listaBD.Lotedir;
                    V_DATOS_CLIENTE.DATAV_SECTORDIR    := listaBD.Sectordir;
                    V_DATOS_CLIENTE.DATAN_CODEDIFDIR   := listaBD.Codedifdir;
                    V_DATOS_CLIENTE.DATAV_EDIFICDIR    := listaBD.Edificdir;
                    V_DATOS_CLIENTE.DATAN_PISODIR      := listaBD.Pisodir;
                    V_DATOS_CLIENTE.DATAV_INTERIORDIR  := listaBD.Interiordir;
                    V_DATOS_CLIENTE.DATAV_NUM_INTERIORDIR:= listaBD.Num_Interiordir;
                    V_DATOS_CLIENTE.DATAV_IDPLANODIR   := listaBD.Idplanodir;
                    V_DATOS_CLIENTE.DATAV_PLANODIR     := listaBD.Planodir;
                    V_DATOS_CLIENTE.DATAV_IDDEPI       := listaBD.Iddepartamentoi;
                    V_DATOS_CLIENTE.DATAC_IDPROVI      := listaBD.Idprovinciai;
                    V_DATOS_CLIENTE.DATAC_IDDISTI      := listaBD.Iddistritoi;
                    V_DATOS_CLIENTE.DATAV_DEPARTAMENTOI:= listaBD.Departamentoi;
                    V_DATOS_CLIENTE.DATAV_PROVINCIAI   := listaBD.Provinciai;
                    V_DATOS_CLIENTE.DATAV_DISTRITOI    := listaBD.Distritoi;
                    V_DATOS_CLIENTE.DATAV_DIRSUCI      := listaBD.Dirsuci;
                    V_DATOS_CLIENTE.DATAV_NOMSUCI      := listaBD.Nomsuci;
                    V_DATOS_CLIENTE.DATAC_UBISUCI      := listaBD.Ubisuci;
                    V_DATOS_CLIENTE.DATAC_UBIGEOI      := listaBD.Ubigeoi;
                    V_DATOS_CLIENTE.DATAC_IDTIPOVIAI   := listaBD.Idtipoviai;
                    V_DATOS_CLIENTE.DATAV_TIPOVIAI     := listaBD.Tipoviai;
                    V_DATOS_CLIENTE.DATAV_NOMVIAI      := listaBD.Nomviai;
                    V_DATOS_CLIENTE.DATAV_NUMVIAI      := listaBD.Numviai;
                    V_DATOS_CLIENTE.DATAN_IDTIPODOMII  := listaBD.Idtipodomii;
                    V_DATOS_CLIENTE.DATAV_TIPODOMII    := listaBD.Tipodomii;
                    V_DATOS_CLIENTE.DATAN_IDTIPURBI    := listaBD.Idtipourbi;
                    V_DATOS_CLIENTE.DATAV_NOMURBI      := listaBD.Nomurbi;
                    V_DATOS_CLIENTE.DATAN_IDZONAI      := listaBD.Idzonai;
                    V_DATOS_CLIENTE.DATAV_ZONAI        := listaBD.Zonai;
                    V_DATOS_CLIENTE.DATAV_REFERENCIAI  := listaBD.Referenciai;
                    V_DATOS_CLIENTE.DATAV_TELF1I       := listaBD.Telf1i;
                    V_DATOS_CLIENTE.DATAV_TELF2I       := listaBD.Telf2i;
                    V_DATOS_CLIENTE.DATAV_CODPOSI      := listaBD.Codposi;
                    V_DATOS_CLIENTE.DATAV_MANZANAI     := listaBD.Manzanai;
                    V_DATOS_CLIENTE.DATAV_LOTEI        := listaBD.Lotei;
                    V_DATOS_CLIENTE.DATAV_SECTORI      := listaBD.Sectori;
                    V_DATOS_CLIENTE.DATAN_CODEDIFI     := listaBD.Codedifi;
                    V_DATOS_CLIENTE.DATAV_EDIFICIOI    := listaBD.Edificioi;
                    V_DATOS_CLIENTE.DATAN_PISOI        := listaBD.Pisoi;
                    V_DATOS_CLIENTE.DATAV_INTERIORI    := listaBD.Interiori;
                    V_DATOS_CLIENTE.DATAV_NUM_INTERIORI:= listaBD.Num_Interiori;
                    V_DATOS_CLIENTE.DATAV_IDPLANOI     := listaBD.Idplanoi;
                    V_DATOS_CLIENTE.DATAV_PLANOI       := listaBD.Planoi;
                    V_DATOS_CLIENTE.DATAV_IDDEPF       := listaBD.Iddepartamentof;
                    V_DATOS_CLIENTE.DATAC_IDPROVF      := listaBD.Idprovinciaf;
                    V_DATOS_CLIENTE.DATAC_IDDISTF      := listaBD.Iddistritof;
                    V_DATOS_CLIENTE.DATAV_DEPARTAMENTOF:= listaBD.Departamentof;
                    V_DATOS_CLIENTE.DATAV_PROVINCIAF   := listaBD.Provinciaf;
                    V_DATOS_CLIENTE.DATAV_DISTRITOF    := listaBD.Distritof;
                    V_DATOS_CLIENTE.DATAV_DIRSUCF      := listaBD.Dirsucf;
                    V_DATOS_CLIENTE.DATAV_NOMSUCF      := listaBD.Nomsucf;
                    V_DATOS_CLIENTE.DATAC_UBISUCF      := listaBD.Ubisucf;
                    V_DATOS_CLIENTE.DATAC_UBIGEOF      := listaBD.Ubigeof;
                    V_DATOS_CLIENTE.DATAC_IDTIPOVIAF   := listaBD.Idtipoviaf;
                    V_DATOS_CLIENTE.DATAV_TIPOVIAF     := listaBD.Tipoviaf;
                    V_DATOS_CLIENTE.DATAV_NOMVIAF      := listaBD.Nomviaf;
                    V_DATOS_CLIENTE.DATAV_NUMVIAF      := listaBD.Numviaf;
                    V_DATOS_CLIENTE.DATAN_IDTIPODOMIF  := listaBD.Idtipodomif;
                    V_DATOS_CLIENTE.DATAV_TIPODOMIF    := listaBD.Tipodomif;
                    V_DATOS_CLIENTE.DATAN_IDTIPURBF    := listaBD.Idtipourbf;
                    V_DATOS_CLIENTE.DATAV_NOMURBF      := listaBD.Nomurbf;
                    V_DATOS_CLIENTE.DATAN_IDZONAF      := listaBD.Idzonaf;
                    V_DATOS_CLIENTE.DATAV_ZONAF        := listaBD.Zonaf;
                    V_DATOS_CLIENTE.DATAV_REFERENCIAF  := listaBD.Referenciaf;
                    V_DATOS_CLIENTE.DATAV_TELF1F       := listaBD.Telf1f;
                    V_DATOS_CLIENTE.DATAV_TELF2F       := listaBD.Telf2f;
                    V_DATOS_CLIENTE.DATAV_CODPOSF      := listaBD.Codposf;
                    V_DATOS_CLIENTE.DATAV_MANZANAF     := listaBD.Manzanaf;
                    V_DATOS_CLIENTE.DATAV_LOTEF        := listaBD.Lotef;
                    V_DATOS_CLIENTE.DATAV_SECTORF      := listaBD.Sectorf;
                    V_DATOS_CLIENTE.DATAN_CODEDIFF     := listaBD.Codediff;
                    V_DATOS_CLIENTE.DATAV_EDIFICIOF    := listaBD.Edificiof;
                    V_DATOS_CLIENTE.DATAN_PISOF        := listaBD.Pisof;
                    V_DATOS_CLIENTE.DATAV_INTERIORF    := listaBD.Interiorf;
                    V_DATOS_CLIENTE.DATAV_NUM_INTERIORF:= listaBD.Num_Interiorf;
                    V_DATOS_CLIENTE.DATAV_IDPLANOF     := listaBD.Idplanof;
                    V_DATOS_CLIENTE.DATAV_PLANOF       := listaBD.Planof;
                    V_DATOS_CLIENTE.DATAN_SOLOTACTV    := listaBD.codsolotact;
                    V_DATOS_CLIENTE.DATAI_TIPOAGENDA   := listaBD.Tipo_Agenda;

                     select count(1)
                       into V_CANTIDAD
                       from OPERACION.MIGRT_DATAPRINC
                      where DATAC_CODCLI = V_DATOS_CLIENTE.DATAC_CODCLI
                        and datac_tipsrv = V_DATOS_CLIENTE.DATAC_TIPSRV
                        and DATAV_TIPOSERVICIO = 'Principal'
                        and DATAC_TIPPROD = '0062';

                     if V_CANTIDAD > 0 then --si hubiera servicio principal de Cable
                         begin--No migrar, si Cliente no tiene algun Equipo de Cable
                                select count(1)
                                  into V_CANTIDAD
                                  from OPERACION.MIGRT_DATAPRINC
                                 where DATAC_CODCLI = V_DATOS_CLIENTE.DATAC_CODCLI
                                   and datac_tipsrv = V_DATOS_CLIENTE.DATAC_TIPSRV
                                   and DATAV_TIPO = 'Equipo'
                                   and DATAC_TIPPROD = '0062';

                                if V_CANTIDAD is null then
                                   V_CANTIDAD := 0;
                                end if;

                                exception
                                  when others then
                                     V_CANTIDAD := 0;
                            end;

                            if V_CANTIDAD = 0 then
                               V_RESULTADO   := V_RESULTADO||'El Cliente ' || V_DATOS_CLIENTE.DATAC_CODCLI || '-' ||V_DATOS_CLIENTE.DATAV_NOMABR||' no tiene ningun Equipo de Cable |';
                            end if;
                        end if;

                        begin--No migrar, si Cliente no tiene algun Servicio Principal
                            select count(1)
                              into V_CANTIDAD
                              from OPERACION.MIGRT_DATAPRINC
                             where DATAC_CODCLI = V_DATOS_CLIENTE.DATAC_CODCLI
                               and datac_tipsrv = V_DATOS_CLIENTE.DATAC_TIPSRV
                               and DATAV_TIPOSERVICIO = 'Principal'
                               and exists (select 1
                                            from opedd o, tipopedd t
                                           where o.tipopedd = t.tipopedd
                                             and t.abrev = 'MIGR_SGA_BSCS'
                                             and o.ABREVIACION = 'TIPOS_SERV'
                                             and o.codigoc = DATAC_TIPPROD);

                            if V_CANTIDAD is null then
                               V_CANTIDAD := 0;
                            end if;

                             exception
                                  when others then
                                     V_CANTIDAD := 0;
                        end;

                        if V_CANTIDAD = 0 then
                           V_RESULTADO   := V_RESULTADO||'El Cliente ' || V_DATOS_CLIENTE.DATAC_CODCLI || '-' ||V_DATOS_CLIENTE.DATAV_NOMABR||' no tiene ningun Servicio Principal |';
                        end if;

                                  MIGRSS_VALIDA_CLIENTES(V_DATOS_CLIENTE, V_CODRESULTADO, V_RESULT);
                                  MIGRSU_ACT_PREREQ(V_DATOS_CLIENTE, V_CODRESULTADO,1);

                                  if V_CODRESULTADO = -1 then--error en prerequisitos
                                     V_RESULTADO := V_RESULTADO||V_RESULT;
                                  end if;

                                  MIGRSS_BLACKLIST_CLIENTE (V_DATOS_CLIENTE, V_RETORNO, V_CODRESULTADO);--Verificar si se encuentra en BlackList de Clientes o el de Planes

                                  if V_RETORNO then--Si se encuentra en BlackList de Clientes
                                       V_RESULTADO := V_RESULTADO||'El Cliente '||V_DATOS_CLIENTE.DATAC_CODCLI||'-'||V_DATOS_CLIENTE.DATAV_NOMCLI||' se encuentra en el BlackList de Clientes |';
                                       MIGRSS_ACT_BLACKLIST(V_DATOS_CLIENTE, V_CODRESULTADO);
                                  end if;

                                  if trim(V_RESULTADO) is not null then
                                     GOTO REINICIA;
                                  end if;
                  end if;

                  V_CONTROL := 1;

                  V_DATOS_CLIENTE.DATAV_DESCTIPSRV   := listaBD.Familiaserv;
                  V_DATOS_CLIENTE.DATAN_CODCAMP      := listaBD.Codcampania;
                  V_DATOS_CLIENTE.DATAV_DESCAMP      := listaBD.Campania;
                  V_DATOS_CLIENTE.DATAN_CODPLAZO     := listaBD.Codplazo;
                  V_DATOS_CLIENTE.DATAV_DESCPLAZO    := listaBD.Plazo;
                  V_DATOS_CLIENTE.DATAN_IDSOLUCION   := listaBD.Idsolucion;
                  V_DATOS_CLIENTE.DATAV_SOLUCION     := listaBD.Solucion;
                  V_DATOS_CLIENTE.DATAN_IDPAQ        := listaBD.Idpaq;
                  V_DATOS_CLIENTE.DATAV_PAQUETE      := listaBD.Paquete;
                  V_DATOS_CLIENTE.DATAC_TIPPROD      := listaBD.Tipprod;
                  V_DATOS_CLIENTE.DATAV_DESCTIPPROD  := listaBD.Tipoproducto;
                  V_DATOS_CLIENTE.DATAN_IDPROD       := listaBD.Idprod;
                  V_DATOS_CLIENTE.DATAV_PROD         := listaBD.Producto;
                  V_DATOS_CLIENTE.DATAV_EQ_PROD_SISACT := listaBD.Eqprod_Sisact;
                  V_DATOS_CLIENTE.DATAC_CODSRV       := listaBD.Codsrv;
                  V_DATOS_CLIENTE.DATAV_SERVICIO     := listaBD.Servicio;
                  V_DATOS_CLIENTE.DATAV_EQ_SERV_SISACT := listaBD.Eqserv_Sisact;
                  V_DATOS_CLIENTE.DATAV_DESCPLAN     := listaBD.Descplan;
                  V_DATOS_CLIENTE.DATAV_TIPOSERVICIO := listaBD.Tiposervicio;
                  V_DATOS_CLIENTE.DATAN_IDESTSERV    := listaBD.Idestado;
                  V_DATOS_CLIENTE.DATAV_DESCESTSERV  := listaBD.Estado;
                  V_DATOS_CLIENTE.DATAN_IDTIPINSS    := listaBD.Idtipoinssrv;
                  V_DATOS_CLIENTE.DATAV_TIPINSS      := listaBD.Tipoinssrv;
                  V_DATOS_CLIENTE.DATAN_CODINSSRV    := listaBD.codinssrv;
                  V_DATOS_CLIENTE.DATAN_PID          := listaBD.Pid;
                  V_DATOS_CLIENTE.DATAN_IDMARCAEQUIPO:= listaBD.Idmarcaeq;
                  V_DATOS_CLIENTE.DATAV_MARCAEQUIPO  := listaBD.Marcaeq;
                  V_DATOS_CLIENTE.DATAC_CODTIPEQU    := listaBD.Codtipequ;
                  V_DATOS_CLIENTE.DATAN_TIPEQU       := listaBD.Tipequ;
                  V_DATOS_CLIENTE.DATAV_TIPO_EQUIPO  := listaBD.Tipoequipo;
                  V_DATOS_CLIENTE.DATAV_EQU_TIPO     := listaBD.Equ_Tipo;
                  V_DATOS_CLIENTE.DATAC_COD_EQUIPO   := listaBD.Codequipo;
                  V_DATOS_CLIENTE.DATAV_MODELO_EQUIPO:= listaBD.Modeloequipo;
                  V_DATOS_CLIENTE.DATAV_TIPO         := listaBD.Tipo;
                  V_DATOS_CLIENTE.DATAV_NUMERO       := listaBD.Numero;
                  V_DATOS_CLIENTE.DATAN_CONTROL      := listaBD.Control;
                  V_DATOS_CLIENTE.DATAN_CARGOFIJO    := listaBD.Cargo;
                  V_DATOS_CLIENTE.DATAN_CANTIDAD     := listaBD.Cantidad;
                  V_DATOS_CLIENTE.DATAC_PUBLICAR     := listaBD.Publicar;
                  V_DATOS_CLIENTE.DATAN_IDCICLO      := listaBD.Idciclo;
                  V_DATOS_CLIENTE.DATAV_DESCICLO     := listaBD.Ciclo;
                  V_DATOS_CLIENTE.DATAN_BW           := listaBD.Bw;

                  begin
                    select count(1)
                      into V_PRINC_PROCESS
                      from opedd o, tipopedd t
                     where o.tipopedd = t.tipopedd
                       and t.abrev = 'MIGR_SGA_BSCS'
                       and o.ABREVIACION = 'TIPOS_SERV'
                       and codigoc = V_DATOS_CLIENTE.DATAC_TIPPROD;

                      exception
                        when others then
                          V_PRINC_PROCESS := 0;
                  end;

                  if V_PRINC_PROCESS = 0 then--Si Servicio Principal no es Telefonia Fija, Internet o Cable u otro configurado, no se tomara para la sot de baja adm
                          MIGRSU_ACT_SOT(V_DATOS_CLIENTE,null,V_FECHA,1);

                          MIGRSI_REG_SOTEMPCAB(V_DATOS_CLIENTE, V_FECHA, V_IDCAB, V_CODRESULTADO,V_RESULT);--crear cabecera de SOT temporal

                          if V_CODRESULTADO = -1 then
                             V_RESULTADO := V_RESULTADO||'El Cliente '||V_DATOS_CLIENTE.DATAC_CODCLI||'-'||V_DATOS_CLIENTE.DATAV_NOMCLI||' tuvo el siguiente error al generarse la cabecera de la temporal: '||V_RESULT||' |';
                          end if;

                          if V_CODRESULTADO != -1 then
                              MIGRSI_REG_SOTEMPDET(V_IDCAB, V_DATOS_CLIENTE, V_CODRESULTADO,V_RESULT);--crear detalle de SOT temporal

                              if V_CODRESULTADO = -1 then
                                 V_SOTEMPBAJA := MIGRFUN_SOTBAJAADM(V_DATOS_CLIENTE);
                                 V_RESULTADO := V_RESULTADO||'El Cliente '||V_DATOS_CLIENTE.DATAC_CODCLI||'-'||V_DATOS_CLIENTE.DATAV_NOMCLI||' tuvo el siguiente error al generarse el detalle de la temporal: '||V_RESULT||' |';
                              end if;
                          end if;
                  else

                          if not MIGRFUN_ERRONEO(V_DATOS_CLIENTE) then--si no estuvo erroneo el Cliente o su Plan, continuar con proceso

                                        MIGRSS_VALIDA_SERVICIOS(V_DATOS_CLIENTE, V_CODRESULTADO, V_RESULT);
                                        MIGRSU_ACT_PREREQ(V_DATOS_CLIENTE, V_CODRESULTADO,2);

                                        if V_CODRESULTADO = -1 then--error en prerequisitos
                                           V_RESULTADO := V_RESULTADO||V_RESULT;
                                        end if;

                                        MIGRSS_BLACKLIST_PLAN (V_DATOS_CLIENTE, V_RETORNO, V_CODRESULTADO);--Verificar si se encuentra en BlackList de Clientes o el de Planes

                                        if V_RETORNO then--Si se encuentra en BlackList de Planes
                                             V_RESULTADO := V_RESULTADO||'El Cliente '||V_DATOS_CLIENTE.DATAC_CODCLI||'-'||V_DATOS_CLIENTE.DATAV_NOMCLI||' tiene el Servicio/Plan '||V_DATOS_CLIENTE.DATAC_CODSRV||'-'||V_DATOS_CLIENTE.DATAV_SERVICIO||' que se encuentra en el BlackList de Planes |';
                                             MIGRSS_ACT_BLACKLIST(V_DATOS_CLIENTE, V_CODRESULTADO);
                                        end if;

                                        if not V_RETORNO then /**/
                                            MIGRSI_REG_SOTEMPCAB(V_DATOS_CLIENTE, V_FECHA, V_IDCAB, V_CODRESULTADO,V_RESULT);--crear cabecera de SOT temporal

                                            if V_CODRESULTADO = -1 then
                                                V_RESULTADO := V_RESULTADO||'El Cliente '||V_DATOS_CLIENTE.DATAC_CODCLI||'-'||V_DATOS_CLIENTE.DATAV_NOMCLI||' tuvo el siguiente error al generarse la cabecera de la temporal: '||V_RESULT||' |';
                                            end if;

                                            if V_CODRESULTADO != -1 then
                                                MIGRSI_REG_SOTEMPDET(V_IDCAB, V_DATOS_CLIENTE, V_CODRESULTADO,V_RESULT);--crear detalle de SOT temporal

                                                if V_CODRESULTADO = -1 then
                                                   V_SOTEMPBAJA := MIGRFUN_SOTBAJAADM(V_DATOS_CLIENTE);
                                                   V_RESULTADO := V_RESULTADO||'El Cliente '||V_DATOS_CLIENTE.DATAC_CODCLI||'-'||V_DATOS_CLIENTE.DATAV_NOMCLI||' tuvo el siguiente error al generarse el detalle de la temporal: '||V_RESULT||' |';
                                                end if;
                                            end if;
                                        end if;  /**/
                     end if;

             end if;

          end loop;

       else
           --registrar error de no existencia de Cliente en Lista Final Principal
           V_CLIENTE := MIGRFUN_CLIENTE(listamigrar.codcli);
           V_DATOS_CLIENTE.DATAV_NOMABR := V_CLIENTE.DATAV_NOMABR;/**/
           V_DATOS_CLIENTE.DATAV_NUMDOC := V_CLIENTE.DATAV_NUMDOC;/**/
           V_RESULTADO := 'El Cliente no existe en la Lista Final Principal: '||listamigrar.codcli||'-'||V_CLIENTE.DATAV_NOMABR;

       end if;

       <<REINICIA>>
        null;

        if trim(V_RESULTADO) is not null then
           MIGRSI_REGISTRA_ERROR(V_IDCAB,V_DATOS_CLIENTE.DATAV_NUMDOC,V_SOTEMPBAJA,'BAJA', V_RESULTADO);
        end if;
       commit;

   end loop;

   MIGRSU_ACT_EQU_SISACT(V_FECHA, V_CODRESULTADO, V_RESULTADO);--obtencion de equivalencias de servicios de Sisact y actualizacion de flag migrar
   commit;

   MIGRSS_PROCESA_SOTBAJA(V_FECHA); --crear sots de baja administrativa
   commit;

   V_CANT_CLI_MIGRA := MIGRFUN_CLIENTES_MIGRA(V_FECHA);
   V_CANT_CLI_PROC  := MIGRFUN_CLIENTES_PROC(V_FECHA);

   if V_CANT_CLI_MIGRA = 0 then
       K_NERROR := -1;
       K_VERROR := 'No existen Clientes a migrar con la Fecha '||V_FECHA;
   else
       if V_CANT_CLI_PROC = 0 then
           K_NERROR := -1;
           K_VERROR := 'No se procesó ningun Cliente, verificar log de errores OPERACION.MIGRT_ERROR_MIGRACION con la fecha '||V_FECHA;
       else
         if V_CANT_CLI_MIGRA > V_CANT_CLI_PROC then
             V_CANT_DIF_CLI := V_CANT_CLI_MIGRA - V_CANT_CLI_PROC;
             K_NERROR := -1;
             K_VERROR := 'Hubo '||V_CANT_DIF_CLI||' Clientes con errores de Migracion de un Total de '||V_CANT_CLI_MIGRA||' lanzados, verificar log de errores OPERACION.MIGRT_ERROR_MIGRACION con la fecha '||V_FECHA;
         else
             K_NERROR := 0;
             K_VERROR := 'Proceso exitoso de Generacion de Sots de Baja Administrativa, hubo '||V_CANT_CLI_PROC||' Clientes Procesados, verificar tablas OPERACION.MIGRT_CAB_TEMP_SOT y OPERACION.MIGRT_DET_TEMP_SOT con la fecha '||V_FECHA;
         end if;
       end if;
   end if;

end;
-------------------------------------------------------------------

procedure MIGRSI_REGISTRA_ERROR(K_ID_CAB      NUMBER,
                                K_DOC_CLIENTE VARCHAR2,
                                K_SOLOT       NUMBER,
                                K_PROCESO     VARCHAR2,
                                K_MENSAJE     VARCHAR2 ) is
/*****************************************************************
'* Nombre SP : MIGRSI_REGISTRA_ERROR
'* Propósito : Registra cualquier error de la migracion y envia correo
'* Input : K_DATOS_CLIENTE Datos del Cliente, K_DOC_CLIENTE NumDoc de Cliente, K_SOLOT Num de Sot, K_PROCESO Tipo de Proceso (BAJA, SISACT, ALTA, IW), K_MENSAJE Mensaje de Error
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_MAIL     VARCHAR2(1000);
    V_CODCLI   CHAR(8);

begin
      select T.DATAC_CODCLI
        into V_CODCLI
        from OPERACION.MIGRT_DATAPRINC T
       where DATAV_NUMDOC = K_DOC_CLIENTE
         and ROWNUM = 1;

      --para registrar log de errores
      insert into OPERACION.MIGRT_ERROR_MIGRACION
        (DATAN_IDCAB,
         DATAV_NUMDOC,
         DATAN_SOLOT,
         DATAV_PROCESO,
         DATAV_DESTINO,
         DATAV_ASUNTO,
         DATAV_MENSAJE,
         DATAC_CODCLI)
      values
        (K_ID_CAB,
         K_DOC_CLIENTE,
         K_SOLOT,
         K_PROCESO,
         V_MAIL,
         'ERROR EN LA MIGRACION DE SGA A BSCS',
         K_MENSAJE,
         V_CODCLI);

end;
-------------------------------------------------------------------

function MIGRFUN_ERRONEO(K_DATOS_CLIENTE  T_DATOSXCLIENTE)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_ERRONEO
'* Propósito : Verifica si ya estuvo erroneo el Cliente o su Plan
'* Output : Booleano
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CANTIDAD PLS_INTEGER;

  begin
      select count(1)
        into V_CANTIDAD
        from OPERACION.MIGRT_DATAPRINC
       where DATAC_CODCLI     = K_DATOS_CLIENTE.DATAC_CODCLI
         and DATAI_BLACKLISTCLI = 1;

      if V_CANTIDAD = 0 then
            select count(1)
            into V_CANTIDAD
            from OPERACION.MIGRT_DATAPRINC
           where DATAC_CODCLI     = K_DATOS_CLIENTE.DATAC_CODCLI
             and DATAC_TIPSRV      = K_DATOS_CLIENTE.DATAC_TIPSRV
             and DATAN_IDPROD      = K_DATOS_CLIENTE.DATAN_IDPROD
             and DATAC_CODSRV      = K_DATOS_CLIENTE.DATAC_CODSRV
             and DATAI_BLACKLISTPLAN = 1;
       end if;

       return V_CANTIDAD > 0;

     exception
       when others then
           return false;
  end;
-------------------------------------------------------------------

procedure MIGRSU_ACT_PREREQ (K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                             K_IDRESULTADO    PLS_INTEGER,
                             K_TIPO           PLS_INTEGER) is
/*****************************************************************
'* Nombre SP : MIGRSU_ACT_PREREQ
'* Propósito : Actualizar Flag cuando no aprueba los prerequisitos
'* Input : K_DATOS_CLIENTE Datos del Cliente, K_IDRESULTADO Resultado 0 No Procesado - -1 Error - 1 OK
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
  if K_TIPO = 1 then
      update OPERACION.MIGRT_DATAPRINC
         set DATAI_PREREQUISITO = K_IDRESULTADO, DATAI_PROCESADO = 0
       where DATAC_CODCLI      = K_DATOS_CLIENTE.DATAC_CODCLI
         and DATAC_TIPSRV      = K_DATOS_CLIENTE.DATAC_TIPSRV;
   else
       update OPERACION.MIGRT_DATAPRINC
         set DATAI_PREREQUISITO = K_IDRESULTADO, DATAI_PROCESADO = 0
       where DATAC_CODCLI      = K_DATOS_CLIENTE.DATAC_CODCLI
         and DATAC_TIPSRV      = K_DATOS_CLIENTE.DATAC_TIPSRV
         and DATAN_IDPROD      = K_DATOS_CLIENTE.DATAN_IDPROD
         and DATAC_CODSRV      = K_DATOS_CLIENTE.DATAC_CODSRV
         and DATAN_CODINSSRV   = K_DATOS_CLIENTE.DATAN_CODINSSRV
         and DATAN_PID         = K_DATOS_CLIENTE.DATAN_PID;
   end if;
end;
-------------------------------------------------------------------

procedure MIGRSS_ACT_BLACKLIST (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                K_TIPO          PLS_INTEGER) is
/*****************************************************************
'* Nombre SP : MIGRSS_ACT_BLACKLIST
'* Propósito : Actualizar Flag cuando Cliente o Plan se encuentra en BlackList
'* Input : K_DATOS_CLIENTE Datos del Cliente, K_TIPO Tipo de Actualizacion
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
    if K_TIPO = 1 then
        MIGRSU_ACT_BLACKCLI (K_DATOS_CLIENTE);
    else
        MIGRSU_ACT_BLACKPLAN (K_DATOS_CLIENTE);
    end if;
end;
-------------------------------------------------------------------

procedure MIGRSU_ACT_BLACKCLI (K_DATOS_CLIENTE T_DATOSXCLIENTE) is
/*****************************************************************
'* Nombre SP : MIGRSU_ACT_BLACKCLI
'* Propósito : Actualizar Flag cuando Cliente se encuentra en BlackList
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
  update OPERACION.MIGRT_DATAPRINC
     set DATAI_BLACKLISTCLI = 1, DATAI_BLACKLISTPLAN = 1, DATAI_PROCESADO = 0
   where DATAC_CODCLI      = K_DATOS_CLIENTE.DATAC_CODCLI;

end;
-------------------------------------------------------------------

procedure MIGRSU_ACT_BLACKPLAN (K_DATOS_CLIENTE T_DATOSXCLIENTE) is
/*****************************************************************
'* Nombre SP : MIGRSU_ACT_BLACKPLAN
'* Propósito : Actualizar Flag cuando Plan de Cliente se encuentra en BlackList
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
  update OPERACION.MIGRT_DATAPRINC
     set DATAI_BLACKLISTPLAN = 1, DATAI_PROCESADO = 0
   where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
     and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
     and DATAN_IDPROD = K_DATOS_CLIENTE.DATAN_IDPROD
     and DATAC_CODSRV = K_DATOS_CLIENTE.DATAC_CODSRV;
end;
-------------------------------------------------------------------

procedure MIGRSU_ACT_SOT(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                         K_CODSOLOTBAJA  NUMBER,
                         K_FECHA         DATE,
                         K_PROCESO       PLS_INTEGER) is
/*****************************************************************
'* Nombre SP : MIGRSU_ACT_SOT
'* Propósito : Actualizar Flag de Procesado
'* Input : K_DATOS_CLIENTE Datos del Cliente, K_CODSOLOTBAJA Sot de Baja Administrativa generada, K_FECHA Fecha de Proceso, K_PROCESO Tipo Proceso 2 Temporal - 1 Final
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_FECHA   DATE;
  V_PROCESO PLS_INTEGER;

  begin

     V_FECHA := K_FECHA;
     V_PROCESO := K_PROCESO;

   update OPERACION.MIGRT_DATAPRINC
      set DATAI_PROCESADO     = V_PROCESO,
          DATAD_FECPROCESO    = V_FECHA,
          DATAN_CODSOTBAJAADM = K_CODSOLOTBAJA
    where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
      and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
      and DATAN_IDPROD = K_DATOS_CLIENTE.DATAN_IDPROD
      and DATAC_CODSRV = K_DATOS_CLIENTE.DATAC_CODSRV
      and DATAN_CODINSSRV = K_DATOS_CLIENTE.DATAN_CODINSSRV
      and DATAN_PID = K_DATOS_CLIENTE.DATAN_PID
      and nvl(DATAI_BLACKLISTPLAN,0) != 1
      and nvl(DATAI_PREREQUISITO, 0) != -1;

    if MIGRFUN_VERIF_PROC(K_DATOS_CLIENTE, K_PROCESO) then--si procesaron todos los registros de tabla Final del Cliente
        update OPERACION.MIGRT_CAB_TEMP_SOT--actualizar en cabecera
        set DATAI_PROCESADO     = V_PROCESO,
            DATAD_FECPROC       = V_FECHA,
            DATAN_CODSOTBAJAADM = K_CODSOLOTBAJA
        where datac_codcli      = K_DATOS_CLIENTE.DATAC_CODCLI
          and datac_tipsrv      = K_DATOS_CLIENTE.DATAC_TIPSRV;

        update OPERACION.MIGRT_DATAPRINC --actualizar en TABLA PRINCIPAL
           set DATAI_PROCESADO     = V_PROCESO,
               DATAD_FECPROCESO    = V_FECHA,
               DATAN_CODSOTBAJAADM = K_CODSOLOTBAJA
         where datac_codcli = K_DATOS_CLIENTE.DATAC_CODCLI
           and datac_tipsrv = K_DATOS_CLIENTE.DATAC_TIPSRV
           and nvl(DATAI_BLACKLISTPLAN,0) != 1;

    end if;
  end;
-------------------------------------------------------------------

procedure MIGRSS_PRE_REQUISTOS(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                               K_IDRESULTADO   out PLS_INTEGER,
                               K_RESULTADO     out VARCHAR2 ) is
/*****************************************************************
'* Nombre SP : MIGRSS_PRE_REQUISTOS
'* Propósito : Verificar consistencia de datos enviados y validaciones
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_IDRESULTADO Codigo de Error, K_RESULTADO Mensaje de Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

    V_TIPO_PERS   CHAR(1);
    V_NOMABR_CLIENTE VARCHAR2(150);
    V_CLIENTE     VARCHAR2(200);
    V_TIPO_DOC    VARCHAR2(10);
    V_NUM_DOC     VARCHAR2(15);
    V_TIPSRV      CHAR(4);
    V_CODCAMP     NUMBER(6);
    V_DESCAMP     VARCHAR2(200);
    V_CODPLAZO    NUMBER(4);
    V_DESCPLAZO   VARCHAR2(80);
    V_IDSOLUCION  NUMBER(10);
    V_IDPAQ       NUMBER(10);
    V_PRODUCTO    VARCHAR2(50);
    V_CODSRV      CHAR(4);
    V_SERVICIO    VARCHAR2(50);
    V_CODINSSRV   NUMBER(10);
    V_PID         NUMBER(10);
    V_IDPROYECTO  CHAR(10);
    V_CODSUCURSAL CHAR(10);
    V_CODUBIGEO   CHAR(10);
    V_DIRCLI      VARCHAR2(480);
    V_UBIGEODIR   CHAR(6);
    V_TIPOVIADIR  VARCHAR2(30);
    V_NOMVIADIR   VARCHAR2(60);
    V_NUMVIADIR   VARCHAR2(50);
    V_DIRSUCI     VARCHAR2(1000);
    V_UBIGEOI     CHAR(6);
    V_TIPOVIAI    VARCHAR2(30);
    V_NOMVIAI     VARCHAR2(60);
    V_NUMVIAI     VARCHAR2(50);
    V_CANTIDAD    PLS_INTEGER;
    V_EVAL        PLS_INTEGER;
    V_DATOS_SOT   T_DATOSXSOT;
    V_EQUIV_SISACT T_EQUIV_SISACT;
    V_RESULTADO   VARCHAR2(1000);
    V_DATOS_CLIENTE T_DATOSXCLIENTE;
    V_NOM_EV      VARCHAR2(60);
    V_TIPVEN      VARCHAR2(50);
    V_IDCONT      VARCHAR2(15);
    V_CODSOLOTACT NUMBER(8);
    V_SOLOTACT    NUMBER(8);

begin
  K_IDRESULTADO := 1;

  V_NOMABR_CLIENTE := trim(K_DATOS_CLIENTE.DATAV_NOMABR);
  if V_NOMABR_CLIENTE is null then--Nombre Abreviado de Cliente Nulo
    K_IDRESULTADO := -1;
    K_RESULTADO   := K_RESULTADO||'El Nombre Abreviado del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||' es nulo'||CHR(10);
  end if;

if K_DATOS_CLIENTE.DATAC_TIPSRV='0061' then
    V_CLIENTE := trim(K_DATOS_CLIENTE.DATAV_NOMCLI);
     if V_CLIENTE is null then--Nombre de Cliente Nula
         K_IDRESULTADO := -1;
         K_RESULTADO   := K_RESULTADO||'El Nombre del Cliente NOMCLI con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||' es nulo'||CHR(10);
    end if;
 end if;

  if K_IDRESULTADO != -1 then
      V_TIPO_PERS := trim(K_DATOS_CLIENTE.DATAC_TIPO_PERSONA);
      if V_TIPO_PERS is null then--Tipo de Persona Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Tipo de Persona es nulo del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_TIPO_DOC := trim(K_DATOS_CLIENTE.DATAV_DESCDOC);
      if V_TIPO_DOC is null then--Tipo de Documento Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Tipo de Documento es nulo del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_NUM_DOC := trim(K_DATOS_CLIENTE.DATAV_NUMDOC);
      if V_NUM_DOC is null then--Numero de Documento del Cliente Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Numero de Documento es nulo del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_TIPSRV := trim(K_DATOS_CLIENTE.DATAC_TIPSRV);
      if V_TIPSRV is null then--Familia de Servicio Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Familia de Servicio TIPSRV enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODCAMP := K_DATOS_CLIENTE.DATAN_CODCAMP;
      if V_CODCAMP is null then--Codigo de Campaña Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Codigo de Campaña enviado es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_DESCAMP := trim(K_DATOS_CLIENTE.DATAV_DESCAMP);
      if V_DESCAMP is null then--Campaña Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Campaña enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODPLAZO := K_DATOS_CLIENTE.DATAN_CODPLAZO;
      if V_CODPLAZO is null then--Codigo de Plazo Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Codigo de Plazo enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_DESCPLAZO := trim(K_DATOS_CLIENTE.DATAV_DESCPLAZO);
      if V_DESCPLAZO is null then--Plazo Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Plazo enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_IDSOLUCION := K_DATOS_CLIENTE.DATAN_IDSOLUCION;
      if V_IDSOLUCION is null then--Codigo de Solucion Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Solucion enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_IDPAQ := K_DATOS_CLIENTE.DATAN_IDPAQ;
      if V_IDPAQ is null then--Codigo de Paquete Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Paquete enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_PRODUCTO := trim(K_DATOS_CLIENTE.DATAV_PROD);
      if V_PRODUCTO is null then--Producto Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Producto enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODSRV := trim(K_DATOS_CLIENTE.DATAC_CODSRV);
      if V_CODSRV is null then--Codigo de Servicio Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Codigo de Servicio/Plan CODSRV enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_SERVICIO := trim(K_DATOS_CLIENTE.DATAV_SERVICIO);
      if V_SERVICIO is null then--Servicio Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Servicio/Plan enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODINSSRV := K_DATOS_CLIENTE.DATAN_CODINSSRV;
      if V_CODINSSRV is null then--Codigo de Instancia de Servicio Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Instancia de Servicio CODINSSRV enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_PID := K_DATOS_CLIENTE.DATAN_PID;
      if V_PID is null then--Codigo de Instancia de Producto Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Codigo de Instancia de Producto PID enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_IDPROYECTO := trim(K_DATOS_CLIENTE.DATAC_IDPROYECTO);
      if V_IDPROYECTO is null then--Proyecto Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Proyecto anterior activo enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODSUCURSAL := trim(K_DATOS_CLIENTE.DATAC_CODSUCURSAL);
      if V_CODSUCURSAL is null then--Sucursal Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Sucursal CODSUCURSAL asociado a la Venta enviada es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODUBIGEO := trim(K_DATOS_CLIENTE.DATAC_CODUBIGEO);
      if V_CODUBIGEO is null then--Ubigeo Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Ubicacion CODUBIGEO asociado a la Venta enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_NOM_EV := trim(K_DATOS_CLIENTE.DATAV_NOM_EV);
      if V_NOM_EV is null then--Vendedor Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Vendedor enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_TIPVEN := trim(K_DATOS_CLIENTE.DATAV_TIPVEN);
      if V_TIPVEN is null then--Tipo Venta Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Tipo de Venta es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_IDCONT := trim(K_DATOS_CLIENTE.DATAV_IDCONT);
      if V_IDCONT is null then--Numero de Venta Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Numero de Venta IDCONT es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_DIRCLI := trim(K_DATOS_CLIENTE.DATAV_DIRCLI);
      if V_DIRCLI is null then--Direccion de Cliente Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Direccion es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_UBIGEODIR := trim(K_DATOS_CLIENTE.DATAC_UBIGEODIR);
      if V_UBIGEODIR is null then--Ubigeo de la Direccion del Cliente Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Ubigeo de la Direccion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_TIPOVIADIR := trim(K_DATOS_CLIENTE.DATAV_TIPOVIADIR);
      if V_TIPOVIADIR is null then--Tipo de Via de la Direccion del Cliente  Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Tipo de Via de la Direccion del Cliente es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_NOMVIADIR := trim(K_DATOS_CLIENTE.DATAV_NOMVIADIR);
      if V_NOMVIADIR is null then--Nombre de Via de la Direccion del Cliente Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Nombre de Via de la Direccion del Cliente es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_NUMVIADIR := trim(K_DATOS_CLIENTE.DATAV_NUMVIADIR);
      if V_NUMVIADIR is null then--Numero de Via de la Direccion del Cliente Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Numero de Via de la Direccion del Cliente es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_DIRSUCI := trim(K_DATOS_CLIENTE.DATAV_DIRSUCI);
      if V_DIRSUCI is null then--Sucursal de Instalacion Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Sucursal de Instalacion es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_UBIGEOI := trim(K_DATOS_CLIENTE.DATAC_UBIGEOI);
      if V_UBIGEOI is null then--Ubigeo de la Sucursal de Instalacion Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Ubigeo de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_TIPOVIAI := trim(K_DATOS_CLIENTE.DATAV_TIPOVIAI);
      if V_TIPOVIAI is null then--Tipo de Via de la Sucursal de Instalacion Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Tipo de Via de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_NOMVIAI := trim(K_DATOS_CLIENTE.DATAV_NOMVIAI);
      if V_NOMVIAI is null then--Nombre de Via de la Sucursal de Instalacion Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Nombre de Via de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_NUMVIAI := trim(K_DATOS_CLIENTE.DATAV_NUMVIAI);
      if V_NUMVIAI is null then--Numero de Via de la Sucursal de Instalacion Nulo
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'El Numero de Via de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_CODSOLOTACT := trim(K_DATOS_CLIENTE.DATAN_SOLOTACTV);
      if V_CODSOLOTACT is null then--Ultima Sot Activa Nula
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Ultima Sot Activa enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      end if;

      V_SOLOTACT := MIGRFUN_ULTIMA_SOT_ACTV(V_CODINSSRV);
      if V_SOLOTACT = 0 then
        K_IDRESULTADO := -1;
        K_RESULTADO   := K_RESULTADO||'La Ultima Sot Activa del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' no tiene Detalle, verificar.'||CHR(10);
      end if;
  end if;

  if K_IDRESULTADO != -1 then
      if MIGRFUN_PROCESADO(K_DATOS_CLIENTE, 1) then--Si ya esta procesado el Cliente con su Plan--modif
         K_IDRESULTADO := -1;
         K_RESULTADO   := K_RESULTADO||'El Cliente ya fue procesado: ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
      else

          if not atccorp.PQ_ORDEN_VIS_VALID.esta_activo_servicio_sga(K_DATOS_CLIENTE.DATAC_CODCLI, V_CODINSSRV) then--Si no esta activo el Servicio
             K_IDRESULTADO := -1;
             K_RESULTADO   := K_RESULTADO||'El Servicio '||V_CODINSSRV||' No esta Activo del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
          end if;

          V_CANTIDAD := MIGRFUN_TIENE_PLAY(V_IDPROYECTO,V_CODSUCURSAL,K_DATOS_CLIENTE.DATAC_CODCLI);
          if V_CANTIDAD = 0 then--Verificar Play con solo Telefonia Fija, Internet o Cable
             K_IDRESULTADO := -1;
             K_RESULTADO   := K_RESULTADO||'No tiene Servicio Principal Activo de 1, 2 o 3Play, el Cliente: ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
          end if;

          if K_DATOS_CLIENTE.DATAN_SOLOTACTV != V_SOLOTACT then--Sot no es la Ultima Activa
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'La Sot enviada no es la ultima Sot Activa del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||'(Enviada: '||K_DATOS_CLIENTE.DATAN_SOLOTACTV||' - Deberia enviar: '||V_SOLOTACT||')'||CHR(10);
          end if;

       /*   if not MIGRFUN_ES_CLIENTE_SGA(K_DATOS_CLIENTE.DATAN_SOLOTACTV) then--Si Cliente no es Masivo SGA
             K_IDRESULTADO := -1;
             K_RESULTADO   := K_RESULTADO||'El Cliente no es Masivo SGA: ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
          end if;*/

          MIGRSS_VALIDA_SOT(K_DATOS_CLIENTE.DATAC_CODCLI,K_DATOS_CLIENTE.DATAC_TIPSRV, V_EVAL, V_DATOS_SOT);
          if V_EVAL = -1 then--Si ultima Sot de Cliente fuera de Suspension, Corte, Baja Total, Mantenimiento en cualquier estado o Reconexion (sin cerrar)
             K_IDRESULTADO := -1;
             K_RESULTADO   := K_RESULTADO||'Existe una ultima Sot del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' que no esta aceptada para continuar el proceso: Sot->'||V_DATOS_SOT.DATAN_SOT||'-Tipo->'||V_DATOS_SOT.DATAV_TIPOSOT||CHR(10);
          end if;
          if V_EVAL = -2 then--Si hubo problemas al obtener ultima Sot de Cliente
             K_IDRESULTADO := -1;
             K_RESULTADO   := K_RESULTADO||'Hubo problemas al quererse obtener ultima Sot del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||CHR(10);
          end if;
          if MIGRFUN_VARIAS_SUC(K_DATOS_CLIENTE) then--Si tiene mas de una Sucursal
             K_IDRESULTADO := -1;
             K_RESULTADO   := K_RESULTADO||'El Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' tiene varias Sucursales'||CHR(10);
          end if;

          if K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Principal' then
              V_DATOS_CLIENTE.DATAC_TIPPROD     := K_DATOS_CLIENTE.DATAC_TIPPROD;
              V_DATOS_CLIENTE.DATAC_CODSRV    := K_DATOS_CLIENTE.DATAC_CODSRV;
              V_DATOS_CLIENTE.DATAN_CARGOFIJO := K_DATOS_CLIENTE.DATAN_CARGOFIJO;
              V_DATOS_CLIENTE.DATAV_SERVICIO  := K_DATOS_CLIENTE.DATAV_SERVICIO;
              V_DATOS_CLIENTE.DATAN_MONTO_SGA := MIGRFUN_MONTO_CIGV(K_DATOS_CLIENTE.DATAN_CARGOFIJO);
              V_DATOS_CLIENTE.DATAC_COD_EQUIPO := K_DATOS_CLIENTE.DATAC_COD_EQUIPO;
              V_DATOS_CLIENTE.DATAN_TIPEQU := K_DATOS_CLIENTE.DATAN_TIPEQU;
              V_DATOS_CLIENTE.DATAV_MODELO_EQUIPO  := K_DATOS_CLIENTE.DATAV_MODELO_EQUIPO;
              V_DATOS_CLIENTE.DATAV_TIPO        := K_DATOS_CLIENTE.DATAV_TIPO;
              V_DATOS_CLIENTE.DATAN_PID         := K_DATOS_CLIENTE.DATAN_PID;
              V_DATOS_CLIENTE.DATAV_TIPOSERVICIO := K_DATOS_CLIENTE.DATAV_TIPOSERVICIO;
              V_DATOS_CLIENTE.DATAV_TIPO_EQUIPO := K_DATOS_CLIENTE.DATAV_TIPO_EQUIPO;

              MIGRSS_EQUIVALENCIAS (V_DATOS_CLIENTE, V_EQUIV_SISACT, V_EVAL, V_RESULTADO);
              if V_EVAL = -1 then
                 K_IDRESULTADO := V_EVAL;
                 K_RESULTADO   := K_RESULTADO||V_RESULTADO||CHR(10);
              end if;
          end if;
      end if;
  end if;

end;
-------------------------------------------------------------------

procedure MIGRSS_VALIDA_SOT(K_CODCLI    CHAR,
                            K_TIPSRV    CHAR,
                            K_EVAL      out pls_integer,
                            K_DATOS_SOT out T_DATOSXSOT) is
/*****************************************************************
'* Nombre SP : MIGRSS_VALIDA_SOT
'* Propósito : Valida Ultima Sot de un Cliente que no sea de Suspension, Corte, Baja Total, Mantenimiento ni Reconexion no Cerrada
'* Input : K_CODCLI Codigo de Cliente, K_TIPSRV Familia de Servicio
'* Output : K_EVAL Codigo de Evaluacion -1 Error,0 Correcto, K_SOT Ultima Sot del Cliente, K_TIPOSOT Tipo de la Ultima Sot del Cliente
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
      V_ESTSOLEVAL NUMBER(2);
      V_CANTIDAD   PLS_INTEGER;
      V_NO_SOT     EXCEPTION;

begin

     K_DATOS_SOT := MIGRFUN_ULT_SOT(K_CODCLI, K_TIPSRV);

     if K_DATOS_SOT.DATAN_SOT = 0 then
       RAISE V_NO_SOT;
     end if;

      V_CANTIDAD := MIGRFUN_VERIF_SOT(K_DATOS_SOT.DATAN_TIPTRA);

      if V_CANTIDAD = 0 then
          V_ESTSOLEVAL := MIGRFUN_EST_EVAL();

          if K_DATOS_SOT.DATAN_ESTSOL != V_ESTSOLEVAL then--si sot no esta con estado de evaluacion
              V_CANTIDAD := MIGRFUN_EVAL_REC(K_DATOS_SOT.DATAN_TIPTRA);

              if V_CANTIDAD > 0 then
                K_EVAL := -1;
              else
                K_EVAL := 0;
              end if;
           end if;
      else
          K_EVAL := -1;
      end if;

      exception
         when V_NO_SOT then
           K_EVAL := -2;

         when others then
           K_EVAL := 0;

end;
-------------------------------------------------------------------

function MIGRFUN_VARIAS_SUC(K_DATOS_CLIENTE T_DATOSXCLIENTE)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_VARIAS_SUC
'* Propósito : Verificar si hay mas de una Sucursal de Instalacion para un Cliente
'* Output : boolean
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_CANTOTAL PLS_INTEGER;

begin
   select count(1)
     into V_CANTOTAL
     from (select distinct DATAC_CODSUCURSAL
             from OPERACION.MIGRT_DATAPRINC
            where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
              and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV);

   return V_CANTOTAL > 1;

   exception
     when others then
       return false;

end;
-------------------------------------------------------------------

function MIGRFUN_VERIF_PROC(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                            K_PROCESO       PLS_INTEGER)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_VERIF_PROC
'* Propósito : Verificar si cantidad de registros por cliente es igual a cantidad de registros procesados del mismo cliente
'* Output : boolean
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_CANTOTAL PLS_INTEGER;
  V_CANTPROC PLS_INTEGER;

begin
   select count(1)
     into V_CANTOTAL
     from OPERACION.MIGRT_DATAPRINC
    where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
      and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
      and nvl(DATAI_BLACKLISTPLAN,0) != 1
      and exists (select 1 from opedd o, tipopedd t
                     where o.tipopedd = t.tipopedd
                       and t.abrev = 'MIGR_SGA_BSCS'
                       and o.ABREVIACION = 'TIPOS_SERV'
                       and o.codigoc = DATAC_TIPPROD);

   select count(1)
     into V_CANTPROC
     from OPERACION.MIGRT_DATAPRINC
    where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
      and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
      and nvl(DATAI_PROCESADO,0) = K_PROCESO
      and nvl(DATAI_BLACKLISTPLAN,0) != 1
      and exists (select 1 from opedd o, tipopedd t
                     where o.tipopedd = t.tipopedd
                       and t.abrev = 'MIGR_SGA_BSCS'
                       and o.ABREVIACION = 'TIPOS_SERV'
                       and o.codigoc = DATAC_TIPPROD);

   if V_CANTOTAL = V_CANTPROC then
      select count(1)
        into V_CANTOTAL
        from OPERACION.MIGRT_DATAPRINC
       where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
         and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
         and nvl(DATAI_BLACKLISTPLAN, 0) != 1
         and nvl(DATAI_PREREQUISITO,0) = -1
         and exists (select 1
                      from opedd o, tipopedd t
                     where o.tipopedd = t.tipopedd
                       and t.abrev = 'MIGR_SGA_BSCS'
                       and o.ABREVIACION = 'TIPOS_SERV'
                       and o.codigoc = DATAC_TIPPROD);

       if V_CANTOTAL > 0 then
          return false;
       else
          return true;
       end if;
   else
       return false;
   end if;

   exception
     when others then
       return false;

end;
-------------------------------------------------------------------

function MIGRFUN_VERIF_MENSAJE(K_MENSAJE VARCHAR2)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_VERIF_MENSAJE
'* Propósito : Verificar si ya existe mensaje en log de errores
'* Output : boolean
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_CANTIDAD pls_integer;

begin
    select count(1)
      into V_CANTIDAD
      from OPERACION.MIGRT_ERROR_MIGRACION
     where DATAV_MENSAJE = K_MENSAJE;

    return V_CANTIDAD > 0;
end;
-------------------------------------------------------------------

function MIGRFUN_CLIENTES_MIGRA(K_FECHA DATE )
  return PLS_INTEGER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_CLIENTES_MIGRA
'* Propósito : Obtiene cantidad de Clientes a migrar
'* Output : PLS_INTEGER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_CANTIDAD pls_integer;

begin
      select count(1)
        into V_CANTIDAD
        from OPERACION.MIGRT_CLIENTES_A_MIGRAR cm
       where trunc(DATAD_FEC_BAJA) = trunc(K_FECHA)
         and not exists (select 1
                           from OPERACION.MIGRT_BLACKLIST_CLIENTES bc
                           where cm.datac_codcli = bc.datac_codcli );

      return V_CANTIDAD;

end;
-------------------------------------------------------------------

function MIGRFUN_CLIENTES_PROC(K_FECHA DATE )
  return PLS_INTEGER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_CLIENTES_PROC
'* Propósito : Obtiene cantidad de Clientes migrados con exito
'* Output : PLS_INTEGER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_CANTIDAD pls_integer;

begin
      select count(1)
        into V_CANTIDAD
        from (select DATAC_CODCLI
                from OPERACION.MIGRT_CAB_TEMP_SOT cts
               where trunc(DATAD_FECPROC) = trunc(K_FECHA)
                 and nvl(DATAI_PROCESADO, 0) = 1
                 and not exists (select 1
                                   from OPERACION.MIGRT_BLACKLIST_CLIENTES bc
                                  where cts.datac_codcli = bc.datac_codcli )
               group by DATAC_CODCLI);

      return V_CANTIDAD;

end;
-------------------------------------------------------------------

function MIGRFUN_CANT_PROC(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                           K_PROCESO       PLS_INTEGER)
  return PLS_INTEGER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_CANT_PROC
'* Propósito : Obtiene cantidad de registros procesados por Cliente
'* Output : PLS_INTEGER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_CANTIDAD pls_integer;

begin
    select count(1)
      into V_CANTIDAD
      from OPERACION.MIGRT_DATAPRINC d
     where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
     and NVL(DATAI_PROCESADO, 0) = K_PROCESO
     and nvl(DATAI_BLACKLISTPLAN,0) != 1
     and nvl(DATAI_PREREQUISITO, 0) != -1
     and exists (select 1
                  from opedd o, tipopedd t
                 where o.tipopedd = t.tipopedd
                   and t.abrev = 'MIGR_SGA_BSCS'
                   and o.ABREVIACION = 'TIPOS_SERV'
                   and o.codigoc = d.DATAC_TIPPROD);

     return V_CANTIDAD;
end;
-------------------------------------------------------------------

function MIGRFUN_CANT_REG(K_DATOS_CLIENTE T_DATOSXCLIENTE)
  return PLS_INTEGER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_CANT_REG
'* Propósito : Obtiene cantidad de registros por Cliente
'* Output : PLS_INTEGER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_CANTIDAD pls_integer;

begin

      select count(1)
      into V_CANTIDAD
        from OPERACION.MIGRT_DATAPRINC d
       where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
         and nvl(DATAI_BLACKLISTPLAN,0) != 1
         and exists (select 1
                      from opedd o, tipopedd t
                     where o.tipopedd = t.tipopedd
                       and t.abrev = 'MIGR_SGA_BSCS'
                       and o.ABREVIACION = 'TIPOS_SERV'
                       and o.codigoc = d.DATAC_TIPPROD);

      return V_CANTIDAD;

end;

-------------------------------------------------------------------

function MIGRFUN_CLIENTE(K_CODCLI CHAR )
  return T_CLIENTE is
/*****************************************************************
'* Nombre FUN : MIGRFUN_CLIENTE
'* Propósito : Obtiene datos del Cliente
'* Output : T_CLIENTE
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_CLIENTE T_CLIENTE;

begin
     select NTDIDE, NOMABR
       into V_CLIENTE.DATAV_NUMDOC, V_CLIENTE.DATAV_NOMABR
       from VTATABCLI
      where CODCLI = K_CODCLI;

      return V_CLIENTE;

      exception
        when others then
          V_CLIENTE.DATAV_NUMDOC := '';
          V_CLIENTE.DATAV_NOMABR := '';
          return V_CLIENTE;
end;
-------------------------------------------------------------------

function MIGRFUN_EVAL_REC(K_TIPTRA NUMBER)
  return PLS_INTEGER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_EVAL_REC
'* Propósito : Verifica si Ultima Sot no es de Reconexion
'* Output : PLS_INTEGER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CANTIDAD pls_integer;

begin
    select count(1) --verificar si no es sot de reconexion
      into V_CANTIDAD
      from opedd o, tipopedd t
     where o.tipopedd = t.tipopedd
       and o.CODIGON = K_TIPTRA
       and o.ABREVIACION = 'SOTS_CERRADA'
       and t.abrev = 'MIGR_SGA_BSCS';

     return V_CANTIDAD;

     exception
       when others then
           V_CANTIDAD := 0;
           return V_CANTIDAD;
end;
-------------------------------------------------------------------

function MIGRFUN_EST_EVAL
  return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_EST_EVAL
'* Propósito : Obtiene Estado de Evaluacion para Sot: Cerrada
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_ESTSOLEVAL NUMBER(2);

begin
    select CODIGON --obtener estado de sot de evaluacion
      into V_ESTSOLEVAL
      from opedd o, tipopedd t
     where o.tipopedd = t.tipopedd
       and o.ABREVIACION = 'ESTADO_SOT_EVAL'
       and t.abrev = 'MIGR_SGA_BSCS';

    return V_ESTSOLEVAL;
end;
-------------------------------------------------------------------

function MIGRFUN_VERIF_SOT(K_TIPTRA NUMBER)
  return PLS_INTEGER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_VERIF_SOT
'* Propósito : Verifica si ultima sot no es de suspension, corte, baja total o mantenimiento
'* Output : PLS_INTEGER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_CANTIDAD pls_integer;

begin
     select count(1)--verificar si ultima sot no es de suspension, corte, baja total o mantenimiento
       into V_CANTIDAD
       from opedd o, tipopedd t
      where o.tipopedd = t.tipopedd
        and o.CODIGON = K_TIPTRA
        and o.ABREVIACION = 'SOTS_VALIDA'
        and t.abrev = 'MIGR_SGA_BSCS';

     return V_CANTIDAD;

     exception
       when others then
           V_CANTIDAD := 0;
           return V_CANTIDAD;
end;
-------------------------------------------------------------------

function MIGRFUN_ULT_SOT(K_CODCLI CHAR,
                         K_TIPSRV CHAR)
  return T_DATOSXSOT is
/*****************************************************************
'* Nombre FUN : MIGRFUN_ULT_SOT
'* Propósito : Obtiene Ultima Sot de Cliente
'* Output : Obtiene datos de la ultima Sot del Cliente
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_DATOS_SOT T_DATOSXSOT;

begin
      select s.tiptra, t.descripcion, s.estsol, s.codsolot --tomar ultima sot del cliente que no este anulada ni rechazada
        into V_DATOS_SOT.DATAN_TIPTRA, V_DATOS_SOT.DATAV_TIPOSOT, V_DATOS_SOT.DATAN_ESTSOL, V_DATOS_SOT.DATAN_SOT
        from solot s, tiptrabajo t
       where  s.tiptra = t.tiptra
         and codsolot =
             (select max(s.codsolot)
                from solot s
               where s.codcli = K_CODCLI
                 and s.TIPSRV = K_TIPSRV
                 and exists (select 1
                              from estsol e
                             where e.estsol = s.estsol
                               and e.tipestsol not in
                                   (select o.codigon
                                      from opedd o, tipopedd ti
                                     where o.tipopedd = ti.tipopedd
                                       and o.ABREVIACION = 'TIPOS_EST_SOT'
                                       and ti.abrev = 'MIGR_SGA_BSCS')) ); --Sot con Estado de 7 Rechazada, 5 Anulada

     return V_DATOS_SOT;

     exception
       when others then
         V_DATOS_SOT.DATAN_SOT := 0;
         return V_DATOS_SOT;
end;
-------------------------------------------------------------------

function MIGRFUN_TIENE_PLAY(K_IDPROYECTO  CHAR,
                            K_CODSUCURSAL CHAR,
                            K_CODCLI      CHAR)
    return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_TIENE_PLAY
'* Propósito : Verifica si Cliente tiene Servicios de 1,2 o 3Play
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_CANTIDAD PLS_INTEGER;

begin
     select count(1) --decode(count(1), 1, '1Play', 2, '2Play', 3, '3Play')
       into V_CANTIDAD
       from inssrv x, tystabsrv y, tystipsrv z
      where x.numslc = K_IDPROYECTO
        and x.codsuc = K_CODSUCURSAL
        and x.codcli = K_CODCLI
        and exists (select 1
                      from opedd o, tipopedd t
                     where o.tipopedd = t.tipopedd
                       and t.abrev = 'MIGR_SGA_BSCS'
                       and o.ABREVIACION = 'ESTADO_INSSRV'
                       and o.codigon = x.estinssrv)--Con estado 1 Activo o 2 Suspendido
        and x.codsrv = y.codsrv
        and y.tipsrv = z.tipsrv
        and exists (select 1
                     from opedd o, tipopedd t
                    where o.tipopedd = t.tipopedd
                      and t.abrev = 'MIGR_SGA_BSCS'
                      and o.ABREVIACION = 'TIPOS_SERV'
                      and o.codigoc = z.tipsrv); --con Play '0004' Telefonia Fija, '0006' Internet y/o '0062' Cable

       return V_CANTIDAD;

       exception
         when others then
            V_CANTIDAD := 0;
            return V_CANTIDAD;

end;
-------------------------------------------------------------------

function MIGRFUN_ULTIMA_SOT_ACTV(K_SERVICIO NUMBER)
  return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_ULTIMA_SOT_ACTV
'* Propósito : Obtiene Ultima Sot Activa de un Cliente a traves de un Servicio
'* Output : Ultimo Codigo de Sot Activo de Cliente
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CODSOLOT NUMBER(8);

  begin
       select nvl(max(s.codsolot),0)
         into V_CODSOLOT
         from solot s, solotpto pto
        where s.codsolot    = pto.codsolot
          and pto.codinssrv = K_SERVICIO
          and exists (select 1
                        from tipopedd t, opedd o
                       where t.tipopedd    = o.tipopedd
                         and t.abrev       = 'CONFSERVADICIONAL'
                         and o.abreviacion = 'TIPTRAVAL'
                         and o.codigon     = s.tiptra)
          and exists (select 1 from estsol e
                       where e.estsol = s.estsol
                         and e.tipestsol in (1,2,3,4,6));

       return V_CODSOLOT;

       exception
         when others then
           V_CODSOLOT := 0;
           return V_CODSOLOT;
  end;
-------------------------------------------------------------------

function MIGRFUN_EXISTE_EN_LISTA(K_CODCLI CHAR)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_EXISTE_EN_LISTA
'* Propósito : Verifica si Cliente se encuentra en Lista Principal
'* Output : Booleano
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CANTIDAD PLS_INTEGER;

  begin
      select count(1)
        into V_CANTIDAD
        from OPERACION.MIGRT_DATAPRINC
       where DATAC_CODCLI = K_CODCLI;

       return V_CANTIDAD > 0;

     exception
       when others then
           return false;
  end;
-------------------------------------------------------------------

function MIGRFUN_PROCESADO(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                           K_PROCESO       PLS_INTEGER)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_PROCESADO
'* Propósito : Verifica si al Cliente se le proceso todos sus registros correctos
'* Output : Booleano
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CANT_REG  PLS_INTEGER;
     V_CANT_PROC PLS_INTEGER;

  begin

     V_CANT_REG := MIGRFUN_CANT_REG(K_DATOS_CLIENTE);

     V_CANT_PROC := MIGRFUN_CANT_PROC(K_DATOS_CLIENTE, K_PROCESO);

     return V_CANT_REG = V_CANT_PROC;

  end;
-------------------------------------------------------------------

procedure MIGRSS_BLACKLIST (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                            K_RETORNO       out BOOLEAN,
                            K_TIPO          out PLS_INTEGER) is
/*****************************************************************
'* Nombre SP : MIGRSS_BLACKLIST
'* Propósito : Verificar si Cliente o Plan se encuentra en BlackList
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_RETORNO Boolean, K_TIPO Tipo de Validacion
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
   if not MIGRFUN_BLACKLIST_CLI(K_DATOS_CLIENTE.DATAC_CODCLI) then
     if not MIGRFUN_BLACKLIST_PLAN(K_DATOS_CLIENTE.DATAC_CODSRV) then
        K_TIPO    := 0;
        K_RETORNO := false;
     else
        K_TIPO    := 2;
        K_RETORNO := true;
     end if;
   else
     K_TIPO    := 1;
     K_RETORNO := true;
   end if;

end;
-------------------------------------------------------------------
------------------------------------------------------------------
procedure MIGRSS_BLACKLIST_CLIENTE (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                    K_RETORNO       out BOOLEAN,
                                    K_TIPO          out PLS_INTEGER) is
/*****************************************************************
'* Nombre SP : MIGRSS_BLACKLIST_CLIENTE
'* Propósito : Verificar si Cliente se encuentra en BlackList
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_RETORNO Boolean, K_TIPO Tipo de Validacion
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
   if not MIGRFUN_BLACKLIST_CLI(K_DATOS_CLIENTE.DATAC_CODCLI) then
      K_TIPO    := 0;
      K_RETORNO := false;
   else
      K_TIPO    := 1;
      K_RETORNO := true;
   end if;

end;
-------------------------------------------------------------------
procedure MIGRSS_BLACKLIST_PLAN (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                 K_RETORNO       out BOOLEAN,
                                 K_TIPO          out PLS_INTEGER) is
/*****************************************************************
'* Nombre SP : MIGRSS_BLACKLIST_PLAN
'* Propósito : Verificar si Plan se encuentra en BlackList
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_RETORNO Boolean, K_TIPO Tipo de Validacion
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
   if not MIGRFUN_BLACKLIST_PLAN(K_DATOS_CLIENTE.DATAC_CODSRV) then
      K_TIPO    := 0;
      K_RETORNO := false;
   else
      K_TIPO    := 2;
      K_RETORNO := true;
   end if;

end;
-------------------------------------------------------------------

function MIGRFUN_BLACKLIST_CLI(K_CODCLI CHAR)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_BLACKLIST_CLI
'* Propósito : Verifica si Cliente se encuentra en BlackList de Clentes es decir Clientes que no deberian migrar
'* Output : Booleano
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CANTIDAD PLS_INTEGER;

  begin
      select count(1)
        into V_CANTIDAD
        from OPERACION.MIGRT_BLACKLIST_CLIENTES
       where DATAC_CODCLI = K_CODCLI;

       return V_CANTIDAD > 0;

     exception
       when others then
           return false;
  end;
-------------------------------------------------------------------

function MIGRFUN_BLACKLIST_PLAN(K_CODSRV CHAR)
  return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_BLACKLIST_PLAN
'* Propósito : Verifica si Plan de Cliente se encuentra en BlackList de Planes es decir Planes del Cliente que no deberian migrar
'* Output : Booleano
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     V_CANTIDAD PLS_INTEGER;

  begin
      select count(1)
        into V_CANTIDAD
        from OPERACION.MIGRT_BLACKLIST_PLANES
       where DATAC_CODSRV = K_CODSRV;

       return V_CANTIDAD > 0;

     exception
       when others then
           return false;
  end;
-------------------------------------------------------------------

function MIGRFUN_ES_CLIENTE_SGA(K_CODSOLOT NUMBER)
    return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_ES_CLIENTE_SGA
'* Propósito : Verifica si Cliente es Masivo SGA
'* Output : Booleano
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
       V_CODIGO   pls_integer;
       V_TIPO_CLI pls_integer;
       V_TIPSRV   solot.tipsrv%type;

  begin
       select tipsrv into V_TIPSRV from solot where codsolot = K_CODSOLOT;

       if V_TIPSRV = '0061' then --masivo
             select operacion.pq_sga_iw.f_val_tipo_serv_sot(K_CODSOLOT)
               into V_CODIGO
               from dual;

          select codigon
            into V_TIPO_CLI
            from opedd o, tipopedd t
           where o.tipopedd = t.tipopedd
             and o.abreviacion = 'TIPO_CLIENTE'
             and t.abrev = 'MIGR_SGA_BSCS';
         else
            if V_TIPSRV = '0058' then
             return true;
           end if;
       end if;

      if V_CODIGO = V_TIPO_CLI then--2 Masivo SGA
        return true;
      else--3 Masivo SISACT, 1 Corporativo SGA
        return false;
      end if;

  end;
-------------------------------------------------------------------

function MIGRFUN_EST_APROB
  return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_EST_APROB
'* Propósito : Obtiene Estado de Aprobado de la Sot
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_EST_SOT NUMBER(2);

begin
    select codigon
      into V_EST_SOT --11 estado Aprobado
      from opedd o, tipopedd t
     where o.tipopedd = t.tipopedd
       and o.abreviacion = 'ESTADO_SOT_APROB'
       and t.abrev = 'MIGR_SGA_BSCS';

     return V_EST_SOT;
end;
-------------------------------------------------------------------

function MIGRFUN_TIPTRA_BAJA
  return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_TIPTRA_BAJA
'* Propósito : Obtiene Tipo de Trabajo para la Sot de Baja Administrativa
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_TIPTRA NUMBER(4);

begin
     select codigon
        into V_TIPTRA --680 HFC - BAJA ADMINISTRATIVA MIGRACION A SISACT
        from opedd o, tipopedd t
       where o.tipopedd = t.tipopedd
         and o.abreviacion = 'TIPO_BAJA_ADM'
         and t.abrev = 'MIGR_SGA_BSCS';

     return V_TIPTRA;

end;
-------------------------------------------------------------------

function MIGRFUN_MOTIVO_BAJA
  return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_TIPTRA_BAJA
'* Propósito : Obtiene Motivo para la Sot de Baja Administrativa
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
      V_MOTIVO NUMBER;

begin
      select codigon
        into V_MOTIVO --668 HFC - BAJA ADMINISTRATIVA POR MIGRACION
        from opedd o, tipopedd t
       where o.tipopedd = t.tipopedd
         and o.abreviacion = 'MOTIVO_BAJA_ADM'
         and t.abrev = 'MIGR_SGA_BSCS';

      return V_MOTIVO;
end;
-------------------------------------------------------------------

function MIGRFUN_EST_GEN
   return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_EST_GEN
'* Propósito : Obtiene Estado de Generado de la Sot
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_ESTADO NUMBER(2);

begin
      select codigon
         into V_ESTADO --10 Generada
         from opedd o, tipopedd t
        where o.tipopedd = t.tipopedd
          and o.abreviacion = 'ESTADO_SOT_GEN'
          and t.abrev = 'MIGR_SGA_BSCS';

      return V_ESTADO;
end;
-------------------------------------------------------------------

function MIGRFUN_CODCLIENTE(K_SOT NUMBER)
   return CHAR is
/*****************************************************************
'* Nombre FUN : MIGRFUN_CLIENTE
'* Propósito : Obtiene Cliente de la Sot
'* Output : CHAR
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_CODCLI CHAR(8);

begin
    -- Obtener el cliente
     select codcli
       into V_CODCLI
       from OPERACION.SOLOT
      where codsolot = K_SOT;

     return V_CODCLI;

end;
-------------------------------------------------------------------

function MIGRFUN_PTO_SOT(K_SOT NUMBER)
   return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_PTO_SOT
'* Propósito : Obtiene el Maximo correlativo PUNTO del Detalle de la Sot
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_PUNTO NUMBER(10);

begin
     -- Identificar el correlativo PUNTO
     select NVL(max(punto), 0)
       into V_PUNTO
       from operacion.solotpto
      where codsolot = K_SOT;

      return V_PUNTO;
end;
-------------------------------------------------------------------

function MIGRFUN_VERIF_MIGRAR(K_DATOS_CLIENTE T_DATOSXCLIENTE)
   return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_VERIF_MIGRAR
'* Propósito : Verifica si el Servicio se va a Migrar
'* Output : BOOLEAN
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_MIGRAR pls_integer := 0;
   V_COUNT  PLS_INTEGER;
   V_FLAG   PLS_INTEGER;/**/

begin
      select count(*)
       into V_COUNT
       from opedd o, tipopedd t
      where o.tipopedd = t.tipopedd
        and t.abrev = 'MIGR_SGA_BSCS'
        and o.ABREVIACION = 'TIPOS_SERV'
        and o.codigoc = K_DATOS_CLIENTE.DATAC_TIPPROD
        and o.codigon_aux is null;

     if K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Principal' and V_COUNT > 0 then
        V_MIGRAR := 1;
     else
        V_MIGRAR := 0;
     end if;

     if K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Equipos' then
        if K_DATOS_CLIENTE.DATAC_TIPPROD = '0062' then--Cable
           select count(1)
             into V_COUNT
             from opedd
            where tipopedd = (select tipopedd
                                from tipopedd
                               where abrev = 'MIGR_SGA_BSCS')
              and ABREVIACION = 'SERV_EQUI_MIGRA'
              and CODIGOC = K_DATOS_CLIENTE.DATAC_CODSRV;

            if V_COUNT > 0 then--Si es Servicio de Alquiler o Venta de Equipos entonces migrar
               V_MIGRAR := 1;
            else
               V_MIGRAR := 0;
            end if;
        else
            V_MIGRAR := 0;
        end if;
    end if;

    if K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Adicionales' or K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Puerto 25' or K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'IP Público' then
          if K_DATOS_CLIENTE.DATAC_TIPPROD != '0062' then--si es un servicio adicional que no sea de Cable
            V_MIGRAR := 0;
          end if;

          select codigon
            into V_FLAG
            from OPEDD
           where TIPOPEDD = (select TIPOPEDD
                               from TIPOPEDD
                              where ABREV = 'MIGR_SGA_BSCS')
             and ABREVIACION = 'ADIC_TELFIJA';/**/

          if V_FLAG = 1 and K_DATOS_CLIENTE.DATAC_TIPPROD = '0004' then/**/--Telefonia Fija
              V_MIGRAR := 1;/**/--si esta configurado, migrar servicios adicionales de Telefonia Fija
          end if;/**/

          if K_DATOS_CLIENTE.DATAC_TIPPROD = '0062' then--Cable
                select count(1)
                  into V_COUNT
                  from OPEDD
                 where ABREVIACION = ('MIGRA_SERVICIOS')
                   and TIPOPEDD =
                       (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
                   and CODIGOC = K_DATOS_CLIENTE.DATAC_CODSRV;

               if V_COUNT > 0 then
                  V_MIGRAR := 1;
               else
                  if K_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT is null then
                      V_MIGRAR := 0;
                  else

                        select count(1)
                          into V_COUNT
                          from OPEDD
                         where ABREVIACION in ('CABLE_HBO','CABLE_MAX')
                           and TIPOPEDD =
                               (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
                           and CODIGOC = K_DATOS_CLIENTE.DATAC_CODSRV;

                       if V_COUNT = 0 then
                           select count(1)
                             into V_COUNT
                             from OPEDD
                            where ABREVIACION in
                                  ('CABLE_HD', 'CABLE_VOD', 'CABLE_FOX')
                              and TIPOPEDD =
                                  (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
                              and CODIGOC = K_DATOS_CLIENTE.DATAC_CODSRV;

                           if V_COUNT = 0 then
                                V_MIGRAR := 1;
                           else
                                select count(1)
                                 into V_COUNT
                                 from OPEDD
                                where ABREVIACION = 'SISACT_FULL_HD'
                                  and TIPOPEDD =
                                      (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
                                  and CODIGON = K_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT;

                                 if V_COUNT = 0 then
                                   V_MIGRAR := 1;
                                 else
                                   V_MIGRAR := 0;
                                 end if;
                           end if;
                       else
                            select count(1)
                             into V_COUNT
                             from OPEDD
                            where ABREVIACION in ('SISACT_CINE_HD', 'SISACT_FULL_HD')
                              and TIPOPEDD =
                                  (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
                              and CODIGON = K_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT;

                             if V_COUNT = 0 then
                               V_MIGRAR := 1;
                             else
                               V_MIGRAR := 0;
                             end if;

                       end if;

                 end if;

              end if;
          end if;
    END IF;

    return V_MIGRAR = 1;

     exception
        when others then
           return false;
end;
-------------------------------------------------------------------

function MIGRFUN_VERIF_TOPE(K_DATOS_CLIENTE T_DATOSXCLIENTE)
   return BOOLEAN is
/*****************************************************************
'* Nombre FUN : MIGRFUN_VERIF_TOPE
'* Propósito : Verificar si aplica Tope 0 o sin Tope
'* Output : BOOLEAN
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_CANTIDAD PLS_INTEGER;

begin
     select count(1)
       into V_CANTIDAD
       from OPERACION.MIGRT_DATAPRINC
      where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
        and DATAC_CODUBIGEO = K_DATOS_CLIENTE.DATAC_CODUBIGEO
        and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
        and DATAC_IDPROYECTO = K_DATOS_CLIENTE.DATAC_IDPROYECTO
        and DATAC_CODSUCURSAL = K_DATOS_CLIENTE.DATAC_CODSUCURSAL
        and DATAN_CONTROL = 1;

      return V_CANTIDAD > 0;

     exception
        when others then
           return false;
end;

-------------------------------------------------------------------

function MIGRFUN_SOTBAJAADM(K_DATOS_CLIENTE T_DATOSXCLIENTE)
   return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_IDCAB
'* Propósito : Obtiene el ID de la Cabecera de Tabla Temporal
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_CODSOTBAJAADM NUMBER(8);

begin
     select DATAN_CODSOTBAJAADM
       into V_CODSOTBAJAADM
       from OPERACION.MIGRT_CAB_TEMP_SOT
      where DATAC_CODCLI = K_DATOS_CLIENTE.DATAC_CODCLI
        and DATAC_CODUBI = K_DATOS_CLIENTE.DATAC_CODUBIGEO
        and DATAC_TIPSRV = K_DATOS_CLIENTE.DATAC_TIPSRV
        and DATAC_IDPROYECTO = K_DATOS_CLIENTE.DATAC_IDPROYECTO
        and DATAC_CODSUCURSAL = K_DATOS_CLIENTE.DATAC_CODSUCURSAL;

      return V_CODSOTBAJAADM;

     exception
        when others then
           V_CODSOTBAJAADM := 0;
           return V_CODSOTBAJAADM;
end;
-------------------------------------------------------------------

function MIGRFUN_MONTO_CIGV(K_MONTO NUMBER)
   return NUMBER is
/*****************************************************************
'* Nombre FUN : MIGRFUN_MONTO_CIGV
'* Propósito : Obtiene el Monto Con IGV
'* Output : NUMBER
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_MONTO NUMBER;

begin
     select K_MONTO * 0.18 + K_MONTO
       into V_MONTO
       from DUAL;

      return V_MONTO;

     exception
        when others then
           V_MONTO := 0;
           return V_MONTO;
end;
-------------------------------------------------------------------

procedure MIGRSS_PROCESA_SOTBAJA(K_FECHA DATE) is
/*****************************************************************
'* Nombre SP : MIGRSS_PROCESA_SOTBAJA
'* Propósito : Registrar Sot de Baja Administrativa
'* Input : K_FECHA Fecha de Proceso
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
     cursor lista_SotsTempCab(P_FECHA DATE) is
       select DATAN_ID,
              DATAC_CODCLI,
              DATAC_CODUBI,
              DATAC_TIPSRV,
              DATAV_DIRECCION,
              DATAD_FECPROC,
              DATAC_IDPROYECTO
         from OPERACION.MIGRT_CAB_TEMP_SOT
        where trunc(DATAD_FECPROC)   = trunc(P_FECHA)
          order by DATAC_CODCLI;

      cursor lista_SotsTempDet(P_IDCAB NUMBER) is
       select DATAC_CODSRV,
              DATAC_CODUBI,
              DATAN_BW,
              DATAN_CID,
              DATAN_CODINSSRV,
              DATAV_CODPOSTAL,
              DATAV_DESCVENTA,
              DATAV_DIRVENTA,
              DATAV_IDPLANO,
              DATAN_PID,
              DATAC_CODSUCURSAL,
              DATAN_IDPROD
         from OPERACION.MIGRT_DET_TEMP_SOT
        where DATAN_IDCAB = P_IDCAB
        order by DATAN_PID;

      V_CODSOLOTBAJA  NUMBER(8);
      V_SOLOTCAB      OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;
      V_SOLOTPTO      OPERACION.MIGRT_DET_TEMP_SOT%rowtype;
      V_DATOS_CLIENTE T_DATOSXCLIENTE;
      V_EST_SOT       NUMBER(2);
      V_CANTIDAD      PLS_INTEGER;

  begin
      for listaSots in lista_SotsTempCab(K_FECHA) loop
          V_SOLOTCAB.DATAC_CODCLI         := listaSots.Datac_Codcli;
          V_SOLOTCAB.DATAN_ID             := listaSots.DATAN_ID;/**/
          V_SOLOTCAB.DATAC_CODUBI         := listaSots.Datac_Codubi;
          V_SOLOTCAB.DATAC_TIPSRV         := listaSots.Datac_Tipsrv;
          V_SOLOTCAB.DATAV_DIRECCION      := listaSots.Datav_Direccion;
          V_SOLOTCAB.DATAD_FECPROC        := listaSots.Datad_Fecproc;
          V_SOLOTCAB.DATAC_IDPROYECTO     := listaSots.Datac_Idproyecto;

          V_DATOS_CLIENTE.DATAC_CODCLI      := listaSots.Datac_Codcli;
          V_DATOS_CLIENTE.DATAC_TIPSRV      := listaSots.Datac_Tipsrv;
          V_DATOS_CLIENTE.DATAC_IDPROYECTO  := listaSots.Datac_Idproyecto;

          if MIGRFUN_PROCESADO(V_DATOS_CLIENTE, 2) then--si fueron procesados todos sus registros correctos--modif
              begin
                select count(1)
                  into V_CANTIDAD
                  from OPERACION.MIGRT_CAB_TEMP_SOT c, OPERACION.MIGRT_DET_TEMP_SOT d
                 where c.datan_id = d.datan_idcab
                   and c.DATAC_CODCLI = V_SOLOTCAB.DATAC_CODCLI
                   and c.datac_tipsrv = V_SOLOTCAB.DATAC_TIPSRV
                   and d.DATAV_TIPOSERVICIO = 'Principal'
                   and exists (select 1
                                from opedd o, tipopedd t
                               where o.tipopedd = t.tipopedd
                                 and t.abrev = 'MIGR_SGA_BSCS'
                                 and o.ABREVIACION = 'TIPOS_SERV'
                                 and o.codigoc = d.DATAC_TIPPROD);

                exception
                  when others then
                      V_CANTIDAD := 0 ;
              end;

              if V_CANTIDAD > 0 then--generar sot baja administrativa solo si hay servicios principales
                  MIGRSI_REGISTRA_SOTCAB(V_SOLOTCAB, V_CODSOLOTBAJA);--Registra Cabecera de Sot

                  for listaDetSot in lista_SotsTempDet(listaSots.Datan_Id) loop
                        V_SOLOTPTO.DATAC_CODSRV     := listaDetSot.Datac_Codsrv;
                        V_SOLOTPTO.DATAN_BW         := listaDetSot.Datan_Bw;
                        V_SOLOTPTO.DATAN_CODINSSRV  := listaDetSot.Datan_Codinssrv;
                        V_SOLOTPTO.DATAN_CID        := listaDetSot.Datan_Cid;
                        V_SOLOTPTO.DATAV_DESCVENTA  := listaDetSot.Datav_Descventa;
                        V_SOLOTPTO.DATAV_DIRVENTA   := listaDetSot.Datav_Dirventa;
                        V_SOLOTPTO.DATAC_CODUBI     := listaDetSot.Datac_Codubi;
                        V_SOLOTPTO.DATAV_CODPOSTAL  := listaDetSot.Datav_Codpostal;
                        V_SOLOTPTO.DATAV_IDPLANO    := listaDetSot.Datav_Idplano;
                        V_SOLOTPTO.DATAN_PID        := listaDetSot.Datan_Pid;

                        MIGRSI_REGISTRA_SOTDET(V_CODSOLOTBAJA, V_SOLOTPTO);--Registra Detalle de Sot

                        V_DATOS_CLIENTE.DATAC_CODUBIGEO   := listaDetSot.Datac_Codubi;
                        V_DATOS_CLIENTE.DATAC_CODSRV      := listaDetSot.Datac_Codsrv;
                        V_DATOS_CLIENTE.DATAN_CODINSSRV   := listaDetSot.Datan_Codinssrv;
                        V_DATOS_CLIENTE.DATAC_CODSUCURSAL := listaDetSot.Datac_Codsucursal;
                        V_DATOS_CLIENTE.DATAN_IDPROD      := listaDetSot.Datan_Idprod;
                        V_DATOS_CLIENTE.DATAN_PID         := listaDetSot.Datan_Pid;

                        MIGRSU_ACT_SOT(V_DATOS_CLIENTE, V_CODSOLOTBAJA, K_FECHA, 1/*2*/);

                  end loop;

                  V_EST_SOT := MIGRFUN_EST_APROB();--11 estado Aprobado

                  OPERACION.PQ_SOLOT.P_CHG_ESTADO_SOLOT(V_CODSOLOTBAJA,V_EST_SOT );--cambiar estado de Sot de Baja, asignar WF 1196 y ejecutar algunas tareas

                  MIGRSU_ACT_AREA_SOT (V_CODSOLOTBAJA);

                  --actualizar cantidad de equipos para Cable por cada Cliente con Sot Baja Adm generada
                  select sum(nvl(d.datan_cantidad,0))/**/
                    into V_CANTIDAD
                    from operacion.migrt_det_temp_sot d, operacion.migrt_cab_temp_sot c
                   where c.datan_id = d.datan_idcab
                     and d.datac_tipprod = '0062'
                     and d.datav_tiposervicio = 'Equipos'
                     and c.datan_codsotbajaadm is not null
                     and c.datac_codcli = V_DATOS_CLIENTE.DATAC_CODCLI
                     and c.datan_id = V_SOLOTCAB.DATAN_ID;

                    if  V_CANTIDAD > 0 then/**/
                        V_CANTIDAD := V_CANTIDAD - 1;/**/
                    end if;/**/

                    update operacion.migrt_cab_temp_sot/**/
                       set DATAN_ESTSOTBAJA = V_CANTIDAD
                     where datan_id = V_SOLOTCAB.DATAN_ID;

             end if;
          end if;
      end loop;
  end;
-------------------------------------------------------------------

procedure MIGRSU_ACT_AREA_SOT (K_CODSOLOTBAJA  NUMBER )
  is
/*****************************************************************
'* Nombre SP : MIGRSU_ACT_AREA_SOT
'* Propósito : Registrar Area a OPERACIONES HFC en Sot de Baja Administrativa
'* Input : K_CODSOLOTBAJA Sot Baja Adm
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
    update solot s
       set s.areasol = 200--OPERACIONES HFC
     where codsolot = K_CODSOLOTBAJA;

   exception
     when others then
       null;
end;
-------------------------------------------------------------------

procedure MIGRSI_REGISTRA_SOTCAB(K_DATOS_CLIENTE OPERACION.MIGRT_CAB_TEMP_SOT%rowtype,
                                 K_CODSOLOTBAJA  out NUMBER ) is
/*****************************************************************
'* Nombre SP : MIGRSI_REGISTRA_SOTCAB
'* Propósito : Registrar Cabecera de Sot de Baja Administrativa
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_CODSOLOTBAJA Sot de Baja Administrativa generada
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
      V_SOLOT  solot%rowtype;
      V_TIPTRA NUMBER(4);
      V_MOTIVO NUMBER;
      V_ESTADO NUMBER(2);

  begin
      V_TIPTRA := MIGRFUN_TIPTRA_BAJA(); --680 HFC - BAJA ADMINISTRATIVA MIGRACION A SISACT
      V_MOTIVO := MIGRFUN_MOTIVO_BAJA(); --668 HFC - BAJA ADMINISTRATIVA POR MIGRACION
      V_ESTADO := MIGRFUN_EST_GEN();--10 Generada

      begin
         select codsolot
           into K_CODSOLOTBAJA
           from solot s
          where CODCLI   = K_DATOS_CLIENTE.DATAC_CODCLI
            and codubi   = K_DATOS_CLIENTE.DATAC_CODUBI
            and tipsrv   = K_DATOS_CLIENTE.DATAC_TIPSRV
            and feccom   = K_DATOS_CLIENTE.DATAD_FECPROC
            and tiptra   = V_TIPTRA
            and codmotot = V_MOTIVO;

         exception
           when others then
              K_CODSOLOTBAJA := 0;
      end;

      if K_CODSOLOTBAJA = 0 then
          V_SOLOT.tiptra      := V_TIPTRA;--HFC - BAJA ADMINISTRATIVA MIGRACION A SISACT
          V_SOLOT.codmotot    := V_MOTIVO;--HFC - BAJA ADMINISTRATIVA POR MIGRACION
          V_SOLOT.estsol      := V_ESTADO;
          V_SOLOT.tipsrv      := K_DATOS_CLIENTE.DATAC_TIPSRV;
          V_SOLOT.codcli      := K_DATOS_CLIENTE.DATAC_CODCLI;
          V_SOLOT.cliint      := null;
          V_SOLOT.fecini      := null;
          V_SOLOT.tiprec      := 'S';
          V_SOLOT.feccom      := K_DATOS_CLIENTE.DATAD_FECPROC;
          V_SOLOT.codubi      := K_DATOS_CLIENTE.DATAC_CODUBI;
          V_SOLOT.direccion   := K_DATOS_CLIENTE.DATAV_DIRECCION;
          V_SOLOT.observacion := 'Baja Administrativa por Migracion a BSCS';

          operacion.pq_solot.p_insert_solot(V_SOLOT, K_CODSOLOTBAJA);
      end if;
  end;
-------------------------------------------------------------------

procedure MIGRSI_REGISTRA_SOTDET(K_CODSOLOTBAJA  NUMBER,
                                 K_DATOS_CLIENTE OPERACION.MIGRT_DET_TEMP_SOT%rowtype) is
/*****************************************************************
'* Nombre SP : MIGRSI_REGISTRA_SOTDET
'* Propósito : Registrar Detalle de Sot de Baja Administrativa
'* Input : K_CODSOLOTBAJA Sot de Baja Administrativa generada, K_DATOS_CLIENTE Datos del Cliente
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
      V_SOLOTPTO     solotpto%rowtype;
      V_PUNTO        NUMBER;
      V_CANTIDAD     PLS_INTEGER;

  begin
         begin
           select count(1)
             into V_CANTIDAD
             from solotpto
            where codsolot = K_CODSOLOTBAJA
              and codsrvnue = K_DATOS_CLIENTE.DATAC_CODSRV
              and codinssrv = K_DATOS_CLIENTE.DATAN_CODINSSRV
              and Pid = K_DATOS_CLIENTE.DATAN_PID
              and codubi = K_DATOS_CLIENTE.DATAC_CODUBI;

           exception
             when others then
                V_CANTIDAD := 0;
        end;

        if V_CANTIDAD = 0 then
            V_SOLOTPTO.codsolot    := K_CODSOLOTBAJA;
            V_SOLOTPTO.punto       := null;
            V_SOLOTPTO.tiptrs      := null;
            V_SOLOTPTO.codsrvnue   := K_DATOS_CLIENTE.DATAC_CODSRV;
            V_SOLOTPTO.bwnue       := K_DATOS_CLIENTE.DATAN_BW;
            V_SOLOTPTO.codinssrv   := K_DATOS_CLIENTE.DATAN_CODINSSRV;
            V_SOLOTPTO.cid         := K_DATOS_CLIENTE.DATAN_CID;
            V_SOLOTPTO.descripcion := K_DATOS_CLIENTE.DATAV_DESCVENTA;
            V_SOLOTPTO.direccion   := K_DATOS_CLIENTE.DATAV_DIRVENTA;
            V_SOLOTPTO.tipo        := 2;
            V_SOLOTPTO.estado      := 1;
            V_SOLOTPTO.visible     := 1;
            V_SOLOTPTO.codubi      := K_DATOS_CLIENTE.DATAC_CODUBI;
            V_SOLOTPTO.cantidad    := 1;
            V_SOLOTPTO.codpostal   := K_DATOS_CLIENTE.DATAV_CODPOSTAL;
            V_SOLOTPTO.flgmt       := 1;
            V_SOLOTPTO.idplano     := K_DATOS_CLIENTE.DATAV_IDPLANO;
            V_SOLOTPTO.Pid         := K_DATOS_CLIENTE.DATAN_PID;

            pq_solot.p_insert_solotpto(V_SOLOTPTO, V_PUNTO);
        end if;
  end;
-------------------------------------------------------------------

procedure MIGRSI_REG_SOTEMPCAB(K_DATOS_CLIENTE T_DATOSXCLIENTE,
                               K_FECHA         DATE,
                               K_IDTEMPSOTBAJA OUT NUMBER,
                               K_NERROR        OUT INTEGER,
                               K_VERROR        OUT VARCHAR2 ) is
/*****************************************************************
'* Nombre SP : MIGRSI_REG_SOTEMPCAB
'* Propósito : Registrar Cabecera de Temporal Sot de Baja Administrativa
'* Input : K_DATOS_CLIENTE Datos del Cliente, K_FECHA Fecha de Proceso
'* Output : K_IDTEMPSOTBAJA Sot Temporal de Baja Administrativa generada, K_NERROR Codigo Error, K_VERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_APLICA_TOPE pls_integer := 0;
  V_AGENDA      CHAR(2);
  V_AGENDN      PLS_INTEGER;
  V_DATOS_CLIENTE T_DATOSXCLIENTE;

  begin
      K_NERROR := 0;
      K_VERROR := 'OK';
      V_DATOS_CLIENTE := K_DATOS_CLIENTE;

      begin
         select DATAN_ID
           into K_IDTEMPSOTBAJA
           from OPERACION.MIGRT_CAB_TEMP_SOT
          where DATAC_CODCLI  = V_DATOS_CLIENTE.DATAC_CODCLI
            and DATAC_CODUBI  = V_DATOS_CLIENTE.DATAC_CODUBIGEO
            and DATAC_TIPSRV  = V_DATOS_CLIENTE.DATAC_TIPSRV
            and DATAC_IDPROYECTO = V_DATOS_CLIENTE.DATAC_IDPROYECTO
            and DATAC_CODSUCURSAL = V_DATOS_CLIENTE.DATAC_CODSUCURSAL;

         exception
           when others then
              K_IDTEMPSOTBAJA := 0;
      end;

      if K_IDTEMPSOTBAJA = 0 then
          begin

            if V_DATOS_CLIENTE.DATAC_UBISUCF is null then
                   V_DATOS_CLIENTE.DATAV_IDDEPF := V_DATOS_CLIENTE.DATAV_IDDEPI ;
                   V_DATOS_CLIENTE.DATAC_IDPROVF := V_DATOS_CLIENTE.DATAC_IDPROVI ;
                   V_DATOS_CLIENTE.DATAC_IDDISTF := V_DATOS_CLIENTE.DATAC_IDDISTI ;
                   V_DATOS_CLIENTE.DATAV_DEPARTAMENTOF := V_DATOS_CLIENTE.DATAV_DEPARTAMENTOI ;
                   V_DATOS_CLIENTE.DATAV_PROVINCIAF := V_DATOS_CLIENTE.DATAV_PROVINCIAI;
                   V_DATOS_CLIENTE.DATAV_DISTRITOF := V_DATOS_CLIENTE.DATAV_DISTRITOI ;
                   V_DATOS_CLIENTE.DATAV_DIRSUCF := V_DATOS_CLIENTE.DATAV_DIRSUCI ;
                   V_DATOS_CLIENTE.DATAV_NOMSUCF := V_DATOS_CLIENTE.DATAV_NOMSUCI ;
                   V_DATOS_CLIENTE.DATAC_UBISUCF := V_DATOS_CLIENTE.DATAC_UBISUCI ;
                   V_DATOS_CLIENTE.DATAC_UBIGEOF := V_DATOS_CLIENTE.DATAC_UBIGEOI ;
                   V_DATOS_CLIENTE.DATAC_IDTIPOVIAF := V_DATOS_CLIENTE.DATAC_IDTIPOVIAI ;
                   V_DATOS_CLIENTE.DATAV_TIPOVIAF := V_DATOS_CLIENTE.DATAV_TIPOVIAI;
                   V_DATOS_CLIENTE.DATAV_NOMVIAF := V_DATOS_CLIENTE.DATAV_NOMVIAI ;
                   V_DATOS_CLIENTE.DATAV_NUMVIAF := V_DATOS_CLIENTE.DATAV_NUMVIAI ;
                   V_DATOS_CLIENTE.DATAN_IDTIPODOMIF := V_DATOS_CLIENTE.DATAN_IDTIPODOMII ;
                   V_DATOS_CLIENTE.DATAV_TIPODOMIF := V_DATOS_CLIENTE.DATAV_TIPODOMII ;
                   V_DATOS_CLIENTE.DATAN_IDTIPURBF := V_DATOS_CLIENTE.DATAN_IDTIPURBI ;
                   V_DATOS_CLIENTE.DATAV_NOMURBF := V_DATOS_CLIENTE.DATAV_NOMURBI ;
                   V_DATOS_CLIENTE.DATAN_IDZONAF := V_DATOS_CLIENTE.DATAN_IDZONAI ;
                   V_DATOS_CLIENTE.DATAV_ZONAF := V_DATOS_CLIENTE.DATAV_ZONAI;
                   V_DATOS_CLIENTE.DATAV_REFERENCIAF := V_DATOS_CLIENTE.DATAV_REFERENCIAI ;
                   V_DATOS_CLIENTE.DATAV_TELF1F := V_DATOS_CLIENTE.DATAV_TELF1I ;
                   V_DATOS_CLIENTE.DATAV_TELF2F := V_DATOS_CLIENTE.DATAV_TELF2I ;
                   V_DATOS_CLIENTE.DATAV_CODPOSF := V_DATOS_CLIENTE.DATAV_CODPOSI ;
                   V_DATOS_CLIENTE.DATAV_MANZANAF := V_DATOS_CLIENTE.DATAV_MANZANAI ;
                   V_DATOS_CLIENTE.DATAV_LOTEF := V_DATOS_CLIENTE.DATAV_LOTEI ;
                   V_DATOS_CLIENTE.DATAV_SECTORF := V_DATOS_CLIENTE.DATAV_SECTORI ;
                   V_DATOS_CLIENTE.DATAN_CODEDIFF := V_DATOS_CLIENTE.DATAN_CODEDIFI ;
                   V_DATOS_CLIENTE.DATAV_EDIFICIOF := V_DATOS_CLIENTE.DATAV_EDIFICIOI ;
                   V_DATOS_CLIENTE.DATAN_PISOF := V_DATOS_CLIENTE.DATAN_PISOI ;
                   V_DATOS_CLIENTE.DATAV_INTERIORF := V_DATOS_CLIENTE.DATAV_INTERIORI ;
                   V_DATOS_CLIENTE.DATAV_NUM_INTERIORF := V_DATOS_CLIENTE.DATAV_NUM_INTERIORI ;
                   V_DATOS_CLIENTE.DATAV_IDPLANOF := V_DATOS_CLIENTE.DATAV_IDPLANOI ;
                   V_DATOS_CLIENTE.DATAV_PLANOF := V_DATOS_CLIENTE.DATAV_PLANOI ;
            end if;

            if MIGRFUN_VERIF_TOPE(V_DATOS_CLIENTE) then
              V_APLICA_TOPE := 1;
            end if;

            begin
              select DATAC_TIPOAGENDA
                into V_AGENDA
                from OPERACION.MIGRT_CLIENTES_A_MIGRAR
               where DATAC_CODCLI = V_DATOS_CLIENTE.DATAC_CODCLI;

            exception
              when others then
                 V_AGENDA := '';
            end;

            if V_AGENDA is not null then
               if UPPER(V_AGENDA) = 'SI' then
                  V_AGENDN := 1;
               else
                  V_AGENDN := 2;
               end if;
            end if;

            INSERT INTO OPERACION.MIGRT_CAB_TEMP_SOT
            (DATAC_TIPO_PERSONA,DATAC_CODCLI,DATAV_NOMABR,DATAV_NOMCLI,DATAV_APEPAT,DATAV_APEMAT,DATAC_TIPDOC,
             DATAV_DESCDOC,DATAV_NUMDOC,DATAD_FECNAC, DATAD_FECHAINI,DATAD_FECHAFIN,DATAV_EMAILPRINC,DATAV_EMAIL1,
             DATAV_EMAIL2,DATAC_TIPSRV ,DATAV_DESCTIPSRV,DATAN_CODCAMP,DATAV_DESCAMP, DATAN_CODPLAZO,DATAV_DESCPLAZO,
             DATAN_IDSOLUCION,DATAV_SOLUCION,DATAC_IDPROYECTO,DATAV_PLAY,DATAC_CODUBI,DATAC_CODSUCURSAL,DATAV_DIRECCION,
             DATAN_IDCICLO,DATAV_DESCICLO,DATAC_COD_EV,DATAC_IDTIPDOC_EV,DATAV_TIPDOC_EV,DATAV_NUMDOC_EV,DATAV_NOM_EV,
             DATAC_IDTIPVEN,DATAV_TIPVEN,DATAV_IDCONT,DATAN_NROCART, DATAC_CODOPE,DATAV_OPERADOR,DATAN_PRESUS,DATAN_PUBLI,
             DATAN_IDTIPENVIO,DATAV_TIPENVIO,DATAV_CORELEC ,DATAV_IDDEP_DIRCLI,DATAC_IDPROV_DIRCLI, DATAC_IDDIST_DIRCLI,
             DATAV_DEPA_DIRCLI,DATAV_PROV_DIRCLI,DATAV_DIST_DIRCLI,DATAV_DIRCLI,DATAC_CODUBIDIR,DATAC_UBIGEODIR,DATAC_IDTIPOVIADIR,
             DATAV_TIPOVIADIR,DATAV_NOMVIADIR,DATAV_NUMVIADIR,DATAN_IDTIPODOMIDIR,DATAV_TIPODOMIDIR,DATAV_NOMURBDIR,
             DATAN_IDZONADIR,DATAV_ZONADIR, DATAV_REFERENCIADIR,DATAV_TELF1DIR,DATAV_TELF2DIR,DATAV_CODPOSDIR,
             DATAV_MANZANADIR,DATAV_LOTEDIR,DATAV_SECTORDIR,DATAN_CODEDIFDIR, DATAV_EDIFICDIR,DATAN_PISODIR,
             DATAV_INTERIORDIR,DATAV_NUM_INTERIORDIR,DATAV_IDPLANODIR,DATAV_PLANODIR,DATAV_IDDEPI,DATAC_IDPROVI,
             DATAC_IDDISTI,DATAV_DEPARTAMENTOI,DATAV_PROVINCIAI,DATAV_DISTRITOI,DATAV_DIRSUCI,DATAV_NOMSUCI,DATAC_UBISUCI,
             DATAC_UBIGEOI,DATAC_IDTIPOVIAI,DATAV_TIPOVIAI,DATAV_NOMVIAI,DATAV_NUMVIAI,DATAN_IDTIPODOMII,DATAV_TIPODOMII,
             DATAN_IDTIPURBI,DATAV_NOMURBI,DATAN_IDZONAI,DATAV_ZONAI,DATAV_REFERENCIAI,DATAV_TELF1I,DATAV_TELF2I,
             DATAV_CODPOSI,DATAV_MANZANAI,DATAV_LOTEI,DATAV_SECTORI,DATAN_CODEDIFI,DATAV_EDIFICIOI,DATAN_PISOI,
             DATAV_INTERIORI,DATAV_NUM_INTERIORI,DATAV_IDPLANOI,DATAV_PLANOI,DATAV_IDDEPF,DATAC_IDPROVF,DATAC_IDDISTF,
             DATAV_DEPARTAMENTOF,DATAV_PROVINCIAF,DATAV_DISTRITOF,DATAV_DIRSUCF,DATAV_NOMSUCF,DATAC_UBISUCF,DATAC_UBIGEOF,
             DATAC_IDTIPOVIAF,DATAV_TIPOVIAF,DATAV_NOMVIAF,DATAV_NUMVIAF,DATAN_IDTIPODOMIF,DATAV_TIPODOMIF,DATAN_IDTIPURBF,
             DATAV_NOMURBF,DATAN_IDZONAF,DATAV_ZONAF,DATAV_REFERENCIAF,DATAV_TELF1F,DATAV_TELF2F,DATAV_CODPOSF,
             DATAV_MANZANAF,DATAV_LOTEF,DATAV_SECTORF,DATAN_CODEDIFF,DATAV_EDIFICIOF,DATAN_PISOF,DATAV_INTERIORF,
             DATAV_NUM_INTERIORF,DATAV_IDPLANOF,DATAV_PLANOF,DATAN_SOLOTACTV,DATAI_TIPOAGENDA,DATAI_PROCESADO, DATAI_TOPE, DATAD_FECPROC)
             VALUES
            (V_DATOS_CLIENTE.DATAC_TIPO_PERSONA,V_DATOS_CLIENTE.DATAC_CODCLI,V_DATOS_CLIENTE.DATAV_NOMABR,V_DATOS_CLIENTE.DATAV_NOMCLI,V_DATOS_CLIENTE.DATAV_APEPAT,V_DATOS_CLIENTE.DATAV_APEMAT,V_DATOS_CLIENTE.DATAC_TIPDOC,
             V_DATOS_CLIENTE.DATAV_DESCDOC,V_DATOS_CLIENTE.DATAV_NUMDOC,V_DATOS_CLIENTE.DATAD_FECNAC,V_DATOS_CLIENTE.DATAD_FECHAINI,V_DATOS_CLIENTE.DATAD_FECHAFIN,V_DATOS_CLIENTE.DATAV_EMAILPRINC,V_DATOS_CLIENTE.DATAV_EMAIL1,
             V_DATOS_CLIENTE.DATAV_EMAIL2,V_DATOS_CLIENTE.DATAC_TIPSRV,V_DATOS_CLIENTE.DATAV_DESCTIPSRV,V_DATOS_CLIENTE.DATAN_CODCAMP,V_DATOS_CLIENTE.DATAV_DESCAMP,V_DATOS_CLIENTE.DATAN_CODPLAZO,V_DATOS_CLIENTE.DATAV_DESCPLAZO,
             V_DATOS_CLIENTE.DATAN_IDSOLUCION,V_DATOS_CLIENTE.DATAV_SOLUCION,V_DATOS_CLIENTE.DATAC_IDPROYECTO,V_DATOS_CLIENTE.DATAV_PLAY,V_DATOS_CLIENTE.DATAC_CODUBIGEO,V_DATOS_CLIENTE.DATAC_CODSUCURSAL,V_DATOS_CLIENTE.DATAV_DIRVENTA,
             V_DATOS_CLIENTE.DATAN_IDCICLO,V_DATOS_CLIENTE.DATAV_DESCICLO,V_DATOS_CLIENTE.DATAC_COD_EV,V_DATOS_CLIENTE.DATAC_IDTIPDOC_EV,V_DATOS_CLIENTE.DATAV_TIPDOC_EV,V_DATOS_CLIENTE.DATAV_NUMDOC_EV,V_DATOS_CLIENTE.DATAV_NOM_EV,
             V_DATOS_CLIENTE.DATAC_IDTIPVEN,V_DATOS_CLIENTE.DATAV_TIPVEN,V_DATOS_CLIENTE.DATAV_IDCONT,V_DATOS_CLIENTE.DATAN_NROCART,V_DATOS_CLIENTE.DATAC_CODOPE,V_DATOS_CLIENTE.DATAV_OPERADOR,V_DATOS_CLIENTE.DATAN_PRESUS,V_DATOS_CLIENTE.DATAN_PUBLI,
             V_DATOS_CLIENTE.DATAN_IDTIPENVIO,V_DATOS_CLIENTE.DATAV_TIPENVIO,V_DATOS_CLIENTE.DATAV_CORELEC,V_DATOS_CLIENTE.DATAV_IDDEP_DIRCLI,V_DATOS_CLIENTE.DATAC_IDPROV_DIRCLI,V_DATOS_CLIENTE.DATAC_IDDIST_DIRCLI,
             V_DATOS_CLIENTE.DATAV_DEPA_DIRCLI,V_DATOS_CLIENTE.DATAV_PROV_DIRCLI,V_DATOS_CLIENTE.DATAV_DIST_DIRCLI,V_DATOS_CLIENTE.DATAV_DIRCLI,V_DATOS_CLIENTE.DATAC_CODUBIDIR,V_DATOS_CLIENTE.DATAC_UBIGEODIR,V_DATOS_CLIENTE.DATAC_IDTIPOVIADIR,
             V_DATOS_CLIENTE.DATAV_TIPOVIADIR,V_DATOS_CLIENTE.DATAV_NOMVIADIR,V_DATOS_CLIENTE.DATAV_NUMVIADIR,V_DATOS_CLIENTE.DATAN_IDTIPODOMIDIR,V_DATOS_CLIENTE.DATAV_TIPODOMIDIR,V_DATOS_CLIENTE.DATAV_NOMURBDIR,
             V_DATOS_CLIENTE.DATAN_IDZONADIR,V_DATOS_CLIENTE.DATAV_ZONADIR,V_DATOS_CLIENTE.DATAV_REFERENCIADIR,V_DATOS_CLIENTE.DATAV_TELF1DIR,V_DATOS_CLIENTE.DATAV_TELF2DIR,V_DATOS_CLIENTE.DATAV_CODPOSDIR,
             V_DATOS_CLIENTE.DATAV_MANZANADIR,V_DATOS_CLIENTE.DATAV_LOTEDIR,V_DATOS_CLIENTE.DATAV_SECTORDIR,V_DATOS_CLIENTE.DATAN_CODEDIFDIR,V_DATOS_CLIENTE.DATAV_EDIFICDIR,V_DATOS_CLIENTE.DATAN_PISODIR,
             V_DATOS_CLIENTE.DATAV_INTERIORDIR,V_DATOS_CLIENTE.DATAV_NUM_INTERIORDIR,V_DATOS_CLIENTE.DATAV_IDPLANODIR,V_DATOS_CLIENTE.DATAV_PLANODIR,V_DATOS_CLIENTE.DATAV_IDDEPI,V_DATOS_CLIENTE.DATAC_IDPROVI,
             V_DATOS_CLIENTE.DATAC_IDDISTI,V_DATOS_CLIENTE.DATAV_DEPARTAMENTOI,V_DATOS_CLIENTE.DATAV_PROVINCIAI,V_DATOS_CLIENTE.DATAV_DISTRITOI,V_DATOS_CLIENTE.DATAV_DIRSUCI,V_DATOS_CLIENTE.DATAV_NOMSUCI,V_DATOS_CLIENTE.DATAC_UBISUCI,
             V_DATOS_CLIENTE.DATAC_UBIGEOI,V_DATOS_CLIENTE.DATAC_IDTIPOVIAI,V_DATOS_CLIENTE.DATAV_TIPOVIAI,V_DATOS_CLIENTE.DATAV_NOMVIAI,V_DATOS_CLIENTE.DATAV_NUMVIAI,V_DATOS_CLIENTE.DATAN_IDTIPODOMII,V_DATOS_CLIENTE.DATAV_TIPODOMII,
             V_DATOS_CLIENTE.DATAN_IDTIPURBI,V_DATOS_CLIENTE.DATAV_NOMURBI,V_DATOS_CLIENTE.DATAN_IDZONAI,V_DATOS_CLIENTE.DATAV_ZONAI,V_DATOS_CLIENTE.DATAV_REFERENCIAI,V_DATOS_CLIENTE.DATAV_TELF1I,V_DATOS_CLIENTE.DATAV_TELF2I,
             V_DATOS_CLIENTE.DATAV_CODPOSI,V_DATOS_CLIENTE.DATAV_MANZANAI,V_DATOS_CLIENTE.DATAV_LOTEI,V_DATOS_CLIENTE.DATAV_SECTORI,V_DATOS_CLIENTE.DATAN_CODEDIFI,V_DATOS_CLIENTE.DATAV_EDIFICIOI,V_DATOS_CLIENTE.DATAN_PISOI,
             V_DATOS_CLIENTE.DATAV_INTERIORI,V_DATOS_CLIENTE.DATAV_NUM_INTERIORI,V_DATOS_CLIENTE.DATAV_IDPLANOI,V_DATOS_CLIENTE.DATAV_PLANOI,V_DATOS_CLIENTE.DATAV_IDDEPF,V_DATOS_CLIENTE.DATAC_IDPROVF,V_DATOS_CLIENTE.DATAC_IDDISTF,
             V_DATOS_CLIENTE.DATAV_DEPARTAMENTOF,V_DATOS_CLIENTE.DATAV_PROVINCIAF,V_DATOS_CLIENTE.DATAV_DISTRITOF,V_DATOS_CLIENTE.DATAV_DIRSUCF,V_DATOS_CLIENTE.DATAV_NOMSUCF,V_DATOS_CLIENTE.DATAC_UBISUCF,V_DATOS_CLIENTE.DATAC_UBIGEOF,
             V_DATOS_CLIENTE.DATAC_IDTIPOVIAF,V_DATOS_CLIENTE.DATAV_TIPOVIAF,V_DATOS_CLIENTE.DATAV_NOMVIAF,V_DATOS_CLIENTE.DATAV_NUMVIAF,V_DATOS_CLIENTE.DATAN_IDTIPODOMIF,V_DATOS_CLIENTE.DATAV_TIPODOMIF,V_DATOS_CLIENTE.DATAN_IDTIPURBF,
             V_DATOS_CLIENTE.DATAV_NOMURBF,V_DATOS_CLIENTE.DATAN_IDZONAF,V_DATOS_CLIENTE.DATAV_ZONAF,V_DATOS_CLIENTE.DATAV_REFERENCIAF,V_DATOS_CLIENTE.DATAV_TELF1F,V_DATOS_CLIENTE.DATAV_TELF2F,V_DATOS_CLIENTE.DATAV_CODPOSF,
             V_DATOS_CLIENTE.DATAV_MANZANAF,V_DATOS_CLIENTE.DATAV_LOTEF,V_DATOS_CLIENTE.DATAV_SECTORF,V_DATOS_CLIENTE.DATAN_CODEDIFF,V_DATOS_CLIENTE.DATAV_EDIFICIOF,V_DATOS_CLIENTE.DATAN_PISOF,V_DATOS_CLIENTE.DATAV_INTERIORF,
             V_DATOS_CLIENTE.DATAV_NUM_INTERIORF,V_DATOS_CLIENTE.DATAV_IDPLANOF,V_DATOS_CLIENTE.DATAV_PLANOF,V_DATOS_CLIENTE.DATAN_SOLOTACTV,V_AGENDN, 0, V_APLICA_TOPE, K_FECHA)
             RETURNING DATAN_ID INTO K_IDTEMPSOTBAJA;

            EXCEPTION
              WHEN OTHERS THEN
                  K_NERROR := -1;
                  K_VERROR := 'ERRORES AL INSERTAR EN CABECERA: '||sqlcode||'-'||sqlerrm;
          end;
      end if;
  end;
-------------------------------------------------------------------

procedure MIGRSI_REG_SOTEMPDET(K_IDTEMPSOTBAJA  NUMBER,
                               K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                               K_NERROR         OUT INTEGER,
                               K_VERROR         OUT VARCHAR2) is
/*****************************************************************
'* Nombre SP : MIGRSI_REG_SOTEMPDET
'* Propósito : Registrar Detalle de Sot Temporal de Baja Administrativa
'* Input : K_IDTEMPSOTBAJA Sot Temporal de Baja Administrativa generada, K_DATOS_CLIENTE Datos del Cliente
'* Output : K_NERROR Codigo Error, K_VERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
      V_CANTIDAD    PLS_INTEGER;

  begin
        K_NERROR := 0;
        K_VERROR := 'OK';

        begin
           select count(1)
             into V_CANTIDAD
             from OPERACION.MIGRT_DET_TEMP_SOT
            where DATAN_IDCAB = K_IDTEMPSOTBAJA
              and DATAC_CODSRV = K_DATOS_CLIENTE.DATAC_CODSRV
              and DATAN_CODINSSRV = K_DATOS_CLIENTE.DATAN_CODINSSRV
              and DATAN_PID = K_DATOS_CLIENTE.DATAN_PID
              and DATAC_CODSUCURSAL = K_DATOS_CLIENTE.DATAC_CODSUCURSAL
              and DATAC_CODUBI = K_DATOS_CLIENTE.DATAC_CODUBIGEO;

           exception
             when others then
                V_CANTIDAD := 0;
        end;

        if V_CANTIDAD = 0 then
            begin

                INSERT INTO OPERACION.MIGRT_DET_TEMP_SOT
                (DATAN_IDCAB,DATAN_IDPAQ,DATAV_PAQUETE,DATAC_TIPPROD,DATAV_DESCTIPPROD,DATAN_IDPROD,
                 DATAV_PROD,DATAC_CODSRV,DATAV_SERVICIO,
                 DATAV_DESCPLAN,DATAV_TIPOSERVICIO,DATAN_IDESTSERV,DATAV_DESCESTSERV,DATAN_IDTIPINSS,
                 DATAV_TIPINSS,DATAN_CODINSSRV,DATAN_PID,DATAN_IDMARCAEQUIPO,DATAV_MARCAEQUIPO,
                 DATAC_CODTIPEQU,DATAN_TIPEQU,DATAV_TIPO_EQUIPO,DATAV_EQU_TIPO,DATAC_COD_EQUIPO,
                 DATAV_MODELO_EQUIPO,DATAV_TIPO,DATAV_NUMERO,DATAN_CONTROL,DATAN_CARGOFIJO,
                 DATAN_CANTIDAD,DATAC_PUBLICAR,DATAN_BW,DATAN_CID,DATAC_CODSUCURSAL,
                 DATAV_DESCVENTA,DATAV_DIRVENTA,DATAC_CODUBI,DATAV_CODPOSTAL,DATAV_IDPLANO)
                VALUES
                (K_IDTEMPSOTBAJA,K_DATOS_CLIENTE.DATAN_IDPAQ,K_DATOS_CLIENTE.DATAV_PAQUETE,K_DATOS_CLIENTE.DATAC_TIPPROD,K_DATOS_CLIENTE.DATAV_DESCTIPPROD,K_DATOS_CLIENTE.DATAN_IDPROD,
                 K_DATOS_CLIENTE.DATAV_PROD,K_DATOS_CLIENTE.DATAC_CODSRV,K_DATOS_CLIENTE.DATAV_SERVICIO,
                 K_DATOS_CLIENTE.DATAV_DESCPLAN,K_DATOS_CLIENTE.DATAV_TIPOSERVICIO,K_DATOS_CLIENTE.DATAN_IDESTSERV,K_DATOS_CLIENTE.DATAV_DESCESTSERV,K_DATOS_CLIENTE.DATAN_IDTIPINSS,
                 K_DATOS_CLIENTE.DATAV_TIPINSS,K_DATOS_CLIENTE.DATAN_CODINSSRV,K_DATOS_CLIENTE.DATAN_PID,K_DATOS_CLIENTE.DATAN_IDMARCAEQUIPO,K_DATOS_CLIENTE.DATAV_MARCAEQUIPO,
                 K_DATOS_CLIENTE.DATAC_CODTIPEQU,K_DATOS_CLIENTE.DATAN_TIPEQU,K_DATOS_CLIENTE.DATAV_TIPO_EQUIPO,K_DATOS_CLIENTE.DATAV_EQU_TIPO,K_DATOS_CLIENTE.DATAC_COD_EQUIPO,
                 K_DATOS_CLIENTE.DATAV_MODELO_EQUIPO,K_DATOS_CLIENTE.DATAV_TIPO,K_DATOS_CLIENTE.DATAV_NUMERO,K_DATOS_CLIENTE.DATAN_CONTROL,K_DATOS_CLIENTE.DATAN_CARGOFIJO,
                 K_DATOS_CLIENTE.DATAN_CANTIDAD,K_DATOS_CLIENTE.DATAC_PUBLICAR,K_DATOS_CLIENTE.DATAN_BW,K_DATOS_CLIENTE.DATAN_CIDVENTA,K_DATOS_CLIENTE.DATAC_CODSUCURSAL,
                 K_DATOS_CLIENTE.DATAV_DESCVENTA,K_DATOS_CLIENTE.DATAV_DIRVENTA,K_DATOS_CLIENTE.DATAC_CODUBIGEO,K_DATOS_CLIENTE.DATAV_CODPOSVENTA,K_DATOS_CLIENTE.DATAV_IDPLANOI);

                EXCEPTION
                  WHEN OTHERS THEN
                      K_NERROR := -1;
                      K_VERROR := 'ERRORES AL INSERTAR EN DETALLE: '||sqlcode||'-'||sqlerrm;
            end;
        end if;
  end;
-------------------------------------------------------------------

 PROCEDURE MIGRSD_DEPURA_BAJA(K_SOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                              K_NERROR OUT INTEGER,
                              K_VERROR OUT VARCHAR2) IS
/*****************************************************************
'* Nombre SP : MIGRSD_DEPURA_BAJA
'* Propósito : Eliminar CODINSSRV repetidos y poner PIDs en nulo
'* Input : K_SOT Sot Baja Administrativa
'* Output : KN_ERROR Codigo Error , KV_ERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
 BEGIN
       K_NERROR := 0;
       K_VERROR := 'OK';

       delete from SOLOTPTO A
        where rowid > (select min(rowid)
                         from SOLOTPTO B
                        where B.CODSOLOT = A.CODSOLOT
                          and B.CODINSSRV = A.CODINSSRV)
          and A.CODSOLOT = K_SOT
          and A.CODINSSRV in (select C.CODINSSRV
                                from SOLOTPTO C
                               where C.CODSOLOT = A.CODSOLOT
                               group by C.CODINSSRV
                              having count(*) > 1);

      update operacion.solotpto
         set pid = null
       where codsolot = K_SOT;

      EXCEPTION
        WHEN OTHERS THEN
         K_NERROR := -1;
         K_VERROR := $$plsql_unit || '.MIGRSD_DEPURA_BAJA: Ocurrio un error al eliminar registros duplicados en la SOT de Baja: ' || sqlerrm;

 END;
-------------------------------------------------------------------

PROCEDURE MIGRSI_REGULA_BAJA(K_SOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                             K_NERROR OUT INTEGER,
                             K_VERROR OUT VARCHAR2) IS
/*****************************************************************
'* Nombre SP : MIGRSI_REGULA_BAJA
'* Propósito : Eliminar CODINSSRV repetidos, poner PIDs en nulo e insertar detalles faltantes
'* Input : K_SOT Sot Baja Administrativa
'* Output : KN_ERROR Codigo Error , KV_ERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  V_PUNTO           NUMBER;
  V_CODCLI          OPERACION.SOLOT.CODCLI%TYPE;
  V_REGULARIZACION  EXCEPTION;
  V_NOEXISTEALTA    EXCEPTION;
  V_SOT_ALTA        OPERACION.SOLOT.CODSOLOT%TYPE;
  V_ERRORDEPURACION EXCEPTION;

  -- Identificar los codinssrv no incluidos en la SOT de Baja
  CURSOR C_1(K_SOT_ALTA VARCHAR2, K_SOT_BAJA VARCHAR2) IS
  SELECT DISTINCT i.codinssrv
        FROM solot a,
             solotpto b,
             inssrv i
     WHERE a.codsolot = b.codsolot
       AND b.codinssrv = i.codinssrv
       AND a.codsolot = K_SOT_ALTA
       and exists (select 1
                          from opedd o, tipopedd t
                         where o.tipopedd = t.tipopedd
                           and t.abrev = 'MIGR_SGA_BSCS'
                           and o.ABREVIACION = 'ESTADO_INSSRV'
                           and o.codigoc = i.estinssrv)--Con estado 1 Activo o 2 Suspendido
       AND i.codinssrv NOT IN (SELECT i.codinssrv
                                FROM solot a,
                                     solotpto b,
                                     inssrv i
                                WHERE a.codsolot = b.codsolot
                                AND b.codinssrv = i.codinssrv
                                AND a.codsolot = K_SOT_BAJA
                                GROUP BY i.codinssrv );

   -- Identificar el registro en la SOLOTPTO
  CURSOR C_2(K_SOT_ALTA VARCHAR2, K_CODINSSRV NUMBER) IS
    SELECT b.codsolot, b.tiptrs, b.codsrvant, b.bwant, b.codsrvnue, b.bwnue, b.codusu, b.codinssrv, b.cid,
                    b.descripcion, b.direccion, b.tipo, b.estado, b.visible, b.puerta, b.pop, b.codubi, b.fecini, b.fecfin,
                    b.fecinisrv, b.feccom, b.tiptraef, b.tipotpto, b.efpto, b.pid, b.pid_old, b.cantidad, b.codpostal,
                    b.flgmt, b.codinssrv_tra, b.mediotx, b.provenlace, b.flg_agenda, b.cintillo, b.ncos_old, b.ncos_new,
                    b.idplataforma, b.idplano, b.codincidence, b.cell_id, b.segment_name
             FROM solot a,
                  solotpto b,
                  inssrv i
             WHERE a.codsolot = b.codsolot
             AND b.codinssrv = i.codinssrv
             AND a.codsolot = K_SOT_ALTA
             AND i.codinssrv = K_CODINSSRV
             and exists (select 1
                          from opedd o, tipopedd t
                         where o.tipopedd = t.tipopedd
                           and t.abrev = 'MIGR_SGA_BSCS'
                           and o.ABREVIACION = 'ESTADO_INSSRV'
                           and o.codigoc = i.estinssrv)--Con estado 1 Activo o 2 Suspendido
             AND rownum = 1;

  BEGIN
     -- Eliminar los CODINSSRV repetivos y poner los PID en null
     MIGRSD_DEPURA_BAJA (K_SOT, K_NERROR, K_VERROR );

     IF K_NERROR = -1 THEN
       RAISE V_ERRORDEPURACION;
     END IF;

     K_NERROR := 0;
     K_VERROR := 'OK';

     V_CODCLI := MIGRFUN_CODCLIENTE(K_SOT);-- Obtener el cliente
     V_SOT_ALTA := OPERACION.PQ_SGA_BSCS.F_OBTENER_SOT_ALTA(V_CODCLI, K_SOT );

     IF V_SOT_ALTA IS NULL THEN
       RAISE V_NOEXISTEALTA;
     END IF;

     V_PUNTO := MIGRFUN_PTO_SOT(K_SOT);-- Identificar el correlativo PUNTO

     FOR A IN C_1(V_SOT_ALTA, K_SOT) LOOP
          FOR S IN C_2(V_SOT_ALTA, a.codinssrv) LOOP
              s.codsolot := K_SOT;
              V_PUNTO := V_PUNTO + 1;

              INSERT INTO operacion.solotpto
               ( codsolot, punto, tiptrs, codsrvant, bwant, codsrvnue, bwnue, codusu, codinssrv, cid,
                 descripcion, direccion, tipo, estado, visible, puerta, pop, codubi, fecini, fecfin,
                 fecinisrv, feccom, tiptraef, tipotpto, efpto, pid, pid_old, cantidad, codpostal,
                 flgmt, codinssrv_tra, mediotx, provenlace, flg_agenda, cintillo, ncos_old, ncos_new,
                 idplataforma, idplano, codincidence, cell_id, segment_name)
              VALUES
               ( s.codsolot, V_PUNTO, s.tiptrs, s.codsrvant, s.bwant, s.codsrvnue, s.bwnue, s.codusu, s.codinssrv, s.cid,
                 s.descripcion, s.direccion, s.tipo, s.estado, s.visible, s.puerta, s.pop, s.codubi, s.fecini, s.fecfin,
                 s.fecinisrv, s.feccom, s.tiptraef, s.tipotpto, s.efpto, null, s.pid_old, s.cantidad, s.codpostal,
                 s.flgmt, s.codinssrv_tra, s.mediotx, s.provenlace, s.flg_agenda, s.cintillo, s.ncos_old, s.ncos_new,
                 s.idplataforma, s.idplano, s.codincidence, s.cell_id, s.segment_name );

              IF SQL%ROWCOUNT = 0 THEN
                 RAISE V_REGULARIZACION;
              END IF;
           END LOOP;
     END LOOP;

  EXCEPTION
    WHEN V_ERRORDEPURACION THEN
      null;

    WHEN V_NOEXISTEALTA THEN
       K_NERROR := -1;
       K_VERROR := $$plsql_unit || '.MIGRSI_REGULA_BAJA: No se encontró la SOT de Alta' ;

    WHEN V_REGULARIZACION THEN
       K_NERROR := -1;
       K_VERROR := $$plsql_unit || '.MIGRSI_REGULA_BAJA: Ocurrio un error al regularizar registros en la SOT de Baja: ' || sqlerrm;

    WHEN OTHERS THEN
       K_NERROR := sqlcode;
       K_VERROR := $$plsql_unit || '.MIGRSI_REGULA_BAJA: ' || sqlerrm|| ' - Linea (' ||dbms_utility.format_error_backtrace || ')';

 end;
-------------------------------------------------------------------

PROCEDURE MIGRSU_CIERRE_BAJADM(K_SOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                               K_NERROR OUT INTEGER,
                               K_VERROR OUT VARCHAR2) is
/*****************************************************************
'* Nombre SP : MIGRSU_CIERRE_BAJADM
'* Propósito : Realiza cierre de tareas y de la Sot de Baja Administrativa
'* Input : K_SOT Sot Baja Administrativa
'* Output : KN_ERROR Codigo Error , KV_ERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
  CN_ESTCERRADO    CONSTANT NUMBER := 4;
  V_TAREADEF       NUMBER;
  V_REGULARIZACION EXCEPTION;
  V_SOLOTALTA      NUMBER(8);
  V_NUMCLI         VARCHAR2(15);
  V_IDCAB          NUMBER(10);

  CURSOR C_TAREAS IS
    select o.codigon, o.codigoc
      from opedd o, tipopedd t
     where o.tipopedd = t.tipopedd
       and t.abrev = 'MIGR_SGA_BSCS'
       and o.abreviacion = 'TAREAS_WF'
     order by o.codigon_aux;

  CURSOR C_SOLOT(K_TAREADEF NUMBER) IS
    select c.idtareawf, c.mottarchg, c.idwf, c.tarea, c.tareadef
      from solot a, wf b, tareawf c
     where a.codsolot = b.codsolot
       and b.idwf = c.idwf
       and c.tareadef = K_TAREADEF
       and b.valido = 1
       and a.estsol = (select codigon
                         from opedd o, tipopedd t
                        where o.tipopedd = t.tipopedd
                          and t.abrev = 'MIGR_SGA_BSCS'
                          and o.abreviacion = 'ESTADO_SOT_EJEC') --17 Estado en ejecucion
       and c.esttarea = 1
       and a.codsolot = K_SOT;

begin

  select DATAN_ID, DATAN_CODSOLOT, DATAV_NUMDOC
    into V_IDCAB, V_SOLOTALTA, V_NUMCLI
    from OPERACION.MIGRT_CAB_TEMP_SOT
   where DATAN_CODSOTBAJAADM = K_SOT;

  FOR CTAREAS IN C_TAREAS loop
      --Ejecuta tareas en ese orden:
      --448  Liberar recursos asignados
      --1012 Liberar Números Telefónicos
      --299  Activación/Desactivación del servicio
      V_TAREADEF := CTAREAS.CODIGON;
      FOR CTAREA IN C_SOLOT(V_TAREADEF) LOOP
          if CTAREAS.CODIGOC = '1' then--si tarea es 299 Activación/Desactivación del servicio
              operacion.pq_solot.p_activacion_automatica(CTAREA.idtareawf,
                                                         CTAREA.idwf,
                                                         CTAREA.tarea,
                                                         CTAREA.tareadef);
          end if;

          --Cerramos la baja administrativa si tarea es 299 Activación/Desactivación del servicio
          PQ_WF.P_CHG_STATUS_TAREAWF(CTAREA.idtareawf,
                                     CN_ESTCERRADO,
                                     CN_ESTCERRADO,
                                     CTAREA.mottarchg,
                                     sysdate,
                                     sysdate);

      end loop;
  end loop;

  K_NERROR := 1;
  K_VERROR := 'OK';

exception
  when V_REGULARIZACION then
    MIGRSI_REGISTRA_ERROR(V_IDCAB,V_NUMCLI,V_SOLOTALTA,'ALTA',K_VERROR);

  when others then
    K_NERROR := sqlcode;
    K_VERROR := 'Error en SP '||$$plsql_unit || '.MIGRSU_CIERRE_BAJADM: '||sqlerrm|| ' - Linea (' ||dbms_utility.format_error_backtrace || ')';

    MIGRSI_REGISTRA_ERROR(V_IDCAB,V_NUMCLI,V_SOLOTALTA,'ALTA',K_VERROR);

end;
-------------------------------------------------------------------

procedure MIGRSU_ACT_EQUISERV_SOT (K_DATOS_CLIENTE T_DATOSXCLIENTE)
  is
/*****************************************************************
'* Nombre SP : MIGRSU_EQU_SERV_SOT
'* Propósito : Actualizar Equipos y Servicios equivalentes para SISACT en Detalle de Sot de Baja Administrativa
'* Input : K_CODSOLOTBAJA Sot Baja Adm
'* Output : N/A
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

begin
    update OPERACION.MIGRT_DET_TEMP_SOT
       set DATAV_EQ_IDSRV_SISACT = K_DATOS_CLIENTE.DATAV_EQ_IDSRV_SISACT,
           DATAN_MONTO_SISACT    = K_DATOS_CLIENTE.DATAN_MONTO_SISACT,
           DATAN_MONTO_SGA       = K_DATOS_CLIENTE.DATAN_MONTO_SGA,
           DATAN_EQ_PLAN_SISACT  = K_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT,
           DATAV_EQ_IDEQU_SISACT = K_DATOS_CLIENTE.DATAV_EQ_IDEQU_SISACT
     where DATAN_IDCAB = K_DATOS_CLIENTE.DATAN_ID
       and DATAN_IDPROD = K_DATOS_CLIENTE.DATAN_IDPROD
       and DATAC_CODSRV = K_DATOS_CLIENTE.DATAC_CODSRV
       and DATAN_CODINSSRV = K_DATOS_CLIENTE.DATAN_CODINSSRV
       and DATAN_PID = K_DATOS_CLIENTE.DATAN_PID;

   exception
     when others then
       null;
end;
-------------------------------------------------------------------

PROCEDURE MIGRSU_ACT_EQU_SISACT(K_FECHA  DATE,
                                K_NERROR OUT INTEGER,
                                K_VERROR OUT VARCHAR2) is
/*****************************************************************
'* Nombre SP : MIGRSU_ACT_EQU_SISACT
'* Propósito : Realiza la actualizacion de los servicios y equipos equivalentes en SISACT
'* Input : K_FECHA Fecha de Proceso
'* Output : KN_ERROR Codigo Error , KV_ERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   cursor lista_SotsAProcesar(P_FECHA DATE) is
       select DATAN_ID,
              DATAV_NUMDOC,
              DATAN_CODSOTBAJAADM,
              DATAC_CODCLI,
              DATAC_TIPSRV,
              DATAC_IDPROYECTO
         from OPERACION.MIGRT_CAB_TEMP_SOT
        where trunc(DATAD_FECPROC) = trunc(P_FECHA)
          order by DATAC_CODCLI;

   cursor lista_SotsDetAProcesar(P_IDCAB NUMBER) is
       select DATAC_CODUBI,
              DATAN_CODINSSRV,
              DATAC_CODSUCURSAL,
              DATAN_IDPROD,
              DATAN_PID,
              DATAV_TIPO_EQUIPO,
              DATAC_COD_EQUIPO,
              DATAN_TIPEQU,
              DATAC_CODSRV,
              DATAV_MODELO_EQUIPO,
              DATAV_SERVICIO,
              DATAN_CARGOFIJO,
              DATAV_TIPOSERVICIO,
              DATAC_TIPPROD,
              DATAV_TIPO
         from OPERACION.MIGRT_DET_TEMP_SOT
        where DATAN_IDCAB = P_IDCAB
        order by DATAV_TIPOSERVICIO desc;

      V_DATOS_CLIENTE T_DATOSXCLIENTE;
      V_EQUIV_SISACT  T_EQUIV_SISACT;
      V_FECHA         DATE;
      V_CODRESULTADO  PLS_INTEGER;
      V_RESULTADO     VARCHAR2(1000);
      V_MIGRAR        PLS_INTEGER := 0;
      V_CANTIDAD      PLS_INTEGER := 0;
      V_FLAG          PLS_INTEGER;/**/

begin
      V_FECHA := TRUNC(K_FECHA);
      if V_FECHA is null then
       V_FECHA := TRUNC(SYSDATE);
      end if;

      for listaCabSots in lista_SotsAProcesar(V_FECHA) loop
          V_DATOS_CLIENTE.DATAC_CODCLI      := listaCabSots.Datac_Codcli;
          V_DATOS_CLIENTE.DATAC_TIPSRV      := listaCabSots.Datac_Tipsrv;
          V_DATOS_CLIENTE.DATAC_IDPROYECTO  := listaCabSots.Datac_Idproyecto;
          V_DATOS_CLIENTE.DATAN_ID          := listaCabSots.Datan_id;

          for listaDetSots in lista_SotsDetAProcesar(listaCabSots.Datan_Id) loop
                V_DATOS_CLIENTE.DATAN_IDPROD      := listaDetSots.Datan_Idprod;
                V_DATOS_CLIENTE.DATAC_CODSRV      := listaDetSots.Datac_Codsrv;
                V_DATOS_CLIENTE.DATAN_CODINSSRV   := listaDetSots.Datan_Codinssrv;
                V_DATOS_CLIENTE.DATAN_PID         := listaDetSots.Datan_Pid;
                V_DATOS_CLIENTE.DATAC_CODSUCURSAL := listaDetSots.Datac_Codsucursal;
                V_DATOS_CLIENTE.DATAC_CODUBIGEO   := listaDetSots.Datac_Codubi;
                V_DATOS_CLIENTE.DATAC_TIPPROD     := listaDetSots.DATAC_TIPPROD;
                V_DATOS_CLIENTE.DATAV_TIPOSERVICIO := listaDetSots.DATAV_TIPOSERVICIO;

                V_DATOS_CLIENTE.DATAV_TIPO_EQUIPO := listaDetSots.DATAV_TIPO_EQUIPO;
                V_DATOS_CLIENTE.DATAC_COD_EQUIPO  := listaDetSots.Datac_cod_equipo;
                V_DATOS_CLIENTE.DATAN_TIPEQU      := listaDetSots.DATAN_TIPEQU;
                V_DATOS_CLIENTE.DATAV_TIPO        := listaDetSots.DATAV_TIPO;
                V_DATOS_CLIENTE.DATAV_MODELO_EQUIPO := listaDetSots.DATAV_MODELO_EQUIPO;

                V_DATOS_CLIENTE.DATAV_SERVICIO    := listaDetSots.Datav_servicio;
                V_DATOS_CLIENTE.DATAN_CARGOFIJO   := listaDetSots.Datan_cargofijo;

                V_CANTIDAD := 0;

               select count(*)
                 into V_CANTIDAD
                 from opedd o, tipopedd t
                where o.tipopedd = t.tipopedd
                  and t.abrev = 'MIGR_SGA_BSCS'
                  and o.ABREVIACION = 'TIPOS_SERV'
                  and o.codigoc = V_DATOS_CLIENTE.DATAC_TIPPROD
                  and o.codigon_aux is null;

               select codigon
                 into V_FLAG
                 from OPEDD
                where TIPOPEDD = (select TIPOPEDD
                                    from TIPOPEDD
                                   where ABREV = 'MIGR_SGA_BSCS')
                  and ABREVIACION = 'ADIC_TELFIJA'; /**/

               if (V_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Principal' and V_CANTIDAD > 0) or--si es servicio principal solo de telefonia fija, internet o cable
                  (
                   ((V_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Adicionales' or V_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Equipos') and V_DATOS_CLIENTE.DATAC_TIPPROD = '0062') or --o servicio adicional o Equipo de cable
                   ((V_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Adicionales' ) and V_DATOS_CLIENTE.DATAC_TIPPROD = '0004' and V_FLAG = 1)/**/--o servicio adicional de Telefonia, si esta configurado
                   ) then

                  V_DATOS_CLIENTE.DATAN_MONTO_SGA   := MIGRFUN_MONTO_CIGV(V_DATOS_CLIENTE.DATAN_CARGOFIJO);

                  if V_DATOS_CLIENTE.DATAV_TIPOSERVICIO != 'Principal' then--Si es Adicional o Equipo obtener Plan de Servicio Principal
                      begin
                        select DATAN_EQ_PLAN_SISACT
                          into V_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT
                          from OPERACION.MIGRT_DET_TEMP_SOT
                         where DATAN_IDCAB = V_DATOS_CLIENTE.DATAN_ID
                           and DATAN_EQ_PLAN_SISACT is not null
                           and DATAV_TIPOSERVICIO = 'Principal'
                           and DATAC_TIPPROD = V_DATOS_CLIENTE.DATAC_TIPPROD
                           and rownum = 1;

                        exception
                          when others then
                            V_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT := null;
                      end;
                  end if;

                  MIGRSS_EQUIVALENCIAS (V_DATOS_CLIENTE, V_EQUIV_SISACT, V_CODRESULTADO, V_RESULTADO);

                  if V_CODRESULTADO = 0 then
                     V_DATOS_CLIENTE.DATAV_EQ_IDSRV_SISACT := V_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT;
                     V_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT  := V_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT;

                     V_DATOS_CLIENTE.DATAN_TIPEQU          := V_EQUIV_SISACT.DATAN_TIPEQU;
                     V_DATOS_CLIENTE.DATAV_EQ_IDEQU_SISACT := V_EQUIV_SISACT.DATAV_EQ_IDEQU_SISACT;

                     V_DATOS_CLIENTE.DATAN_MONTO_SISACT    := V_EQUIV_SISACT.DATAN_MONTO_SISACT;

                     MIGRSU_ACT_EQUISERV_SOT (V_DATOS_CLIENTE);--Actualizar equipos y servicios equivalentes para SISACT en Detalle de Tabla Temporal

                  end if;
                end if;

                --actualizar flag migrar
                if MIGRFUN_VERIF_MIGRAR(V_DATOS_CLIENTE) then
                  V_MIGRAR := 1;
                else
                  V_MIGRAR := 0;
                end if;

                begin
                  update OPERACION.MIGRT_DET_TEMP_SOT
                     set DATAN_MIGRAR = V_MIGRAR
                   where DATAN_IDCAB = V_DATOS_CLIENTE.DATAN_ID
                     and DATAN_IDPROD = V_DATOS_CLIENTE.DATAN_IDPROD
                     and DATAC_CODSRV = V_DATOS_CLIENTE.DATAC_CODSRV
                     and DATAN_CODINSSRV = V_DATOS_CLIENTE.DATAN_CODINSSRV
                     and DATAN_PID = V_DATOS_CLIENTE.DATAN_PID;

                exception
                  when others then
                    null;
                end;

                 if V_CODRESULTADO = 0 then
                   MIGRSU_ACT_SOT(V_DATOS_CLIENTE, null, V_FECHA, 2);--registrar proceso Exitoso en Tabla Final--modif
                   K_NERROR := 0;
                   K_VERROR := 'OK';
                 end if;
          end loop;

      end loop;
end;
-------------------------------------------------------------------

procedure MIGRSS_EQUIVALENCIAS (K_DATOS_CLIENTE T_DATOSXCLIENTE,
                                K_EQUIV_SISACT  OUT T_EQUIV_SISACT,
                                K_NERROR        OUT INTEGER,
                                K_VERROR        OUT VARCHAR2) is
/*****************************************************************
'* Nombre SP : MIGRSS_EQUIVALENCIAS
'* Propósito : Obtener las Equivalencias de los Servicios y Equipos para SISACT
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_EQUIV_SISACT Servicios y Equipos Equivalentes para SISACT, K_NERROR Codigo Error, K_VERROR Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
    V_ERR_EQUIPO    EXCEPTION;
    V_ERR_SERVICIO  EXCEPTION;
    V_ERR_SERV_ADIC EXCEPTION;
    V_CANTIDAD      PLS_INTEGER;

begin
    if K_DATOS_CLIENTE.DATAV_TIPO = 'Equipo' then
        select count(1)
          into V_CANTIDAD
          from opedd
         where tipopedd =
               (select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS')
           and ABREVIACION = 'SERV_EQUI_MIGRA'
           and CODIGOC = K_DATOS_CLIENTE.DATAC_CODSRV;

        if V_CANTIDAD > 0 then--Si es Servicio de Alquiler o Venta de Equipos entonces obtener equivalente de Servicio Adicional
            K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT := K_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT;

            begin
                select DATAV_EQ_IDSRV_SISACT
                  into K_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT
                  from OPERACION.MIGRT_SERV_ADICIONAL
                 where DATAC_IDSRV_SGA = K_DATOS_CLIENTE.DATAC_CODSRV
                   and DATAN_EQ_PLAN_SISACT = K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT
                   and rownum = 1;
                exception
                  when others then
                    RAISE V_ERR_SERV_ADIC;
            end;

            if trim(K_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT) is null or nvl(K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT,0) = 0 then
                RAISE V_ERR_SERV_ADIC;
            end if;
        else--sino obtener equivalente de equipo
              begin
                 select  DATAV_EQ_IDEQU_SISACT,
                         DATAN_TIPEQU
                    into K_EQUIV_SISACT.DATAV_EQ_IDEQU_SISACT,
                         K_EQUIV_SISACT.DATAN_TIPEQU
                    from OPERACION.MIGRT_EQUIPOS_SGA_SISACT
                   where DATAC_IDEQU_SGA = K_DATOS_CLIENTE.DATAC_COD_EQUIPO
                     and DATAN_TIPEQU = K_DATOS_CLIENTE.DATAN_TIPEQU
                     and rownum = 1;

                  exception
                    when others then
                      K_EQUIV_SISACT.DATAV_EQ_IDEQU_SISACT := '';
                      K_EQUIV_SISACT.DATAN_TIPEQU := null;
              end;
        end if;
    end if;

    if K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Adicionales' or K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Puerto 25' or K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'IP Público' then
        K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT := K_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT;

        begin
            select DATAV_EQ_IDSRV_SISACT
              into K_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT
              from OPERACION.MIGRT_SERV_ADICIONAL
             where DATAC_IDSRV_SGA = K_DATOS_CLIENTE.DATAC_CODSRV
               and DATAN_EQ_PLAN_SISACT = K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT
               and rownum = 1;
            exception
              when others then
                RAISE V_ERR_SERV_ADIC;
        end;

        if trim(K_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT) is null or nvl(K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT,0) = 0 then
            RAISE V_ERR_SERV_ADIC;
        end if;

    end if;

    if K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Principal' then
        begin
            select DATAV_EQ_IDSRV_SISACT,
                   DATAN_MONTO_SISACT,
                   DATAN_EQ_PLAN_SISACT
              into K_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT,
                   K_EQUIV_SISACT.DATAN_MONTO_SISACT,
                   K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT
              from OPERACION.MIGRT_EQU_SGA_SISACT
             where DATAC_IDSRV_SGA = K_DATOS_CLIENTE.DATAC_CODSRV
               and DATAN_MONTO_SGA = K_DATOS_CLIENTE.DATAN_MONTO_SGA
               and rownum = 1;

            exception
              when others then
                RAISE V_ERR_SERVICIO;
        end;

        if trim(K_EQUIV_SISACT.DATAV_EQ_IDSRV_SISACT) is null or nvl(K_EQUIV_SISACT.DATAN_EQ_PLAN_SISACT,0) = 0 or nvl(K_EQUIV_SISACT.DATAN_MONTO_SISACT,0) = 0 or nvl(K_DATOS_CLIENTE.DATAN_MONTO_SGA,0) = 0 then
            RAISE V_ERR_SERVICIO;
        end if;
    end if;

    K_NERROR := 0;
    K_VERROR := 'OK';

    exception
      when V_ERR_SERVICIO then
         K_NERROR := -1;
         K_VERROR := 'No existe Equivalencia de Monto, Plan y/o Servicio para SISACT del Servicio Principal de SGA '||K_DATOS_CLIENTE.DATAC_CODSRV||'-'||K_DATOS_CLIENTE.DATAV_SERVICIO|| ' con Monto sin IGV '||K_DATOS_CLIENTE.DATAN_CARGOFIJO||' PID '||K_DATOS_CLIENTE.DATAN_PID;

      when V_ERR_SERV_ADIC then
         K_NERROR := -1;
         K_VERROR := 'No existe Equivalencia de Plan y/o Servicio para SISACT del Servicio Adicional de SGA '||K_DATOS_CLIENTE.DATAC_CODSRV||'-'||K_DATOS_CLIENTE.DATAV_SERVICIO||' PID '||K_DATOS_CLIENTE.DATAN_PID;

end;

 procedure MIGRSS_PROCESO_SOT_SISACT is
    /*****************************************************************
    '* Nombre SP : MIGRSS_PROCESO_SOT_SISACT
    '* Propósito : listar las sot's de altas generadas por sisact en el proceso de migracion
    '* Input : N/A
    '* Output : N/A
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 19/05/2016
    '* Fec Actualización : 19/05/2016
    '*****************************************************************/
    V_ERROR        pls_integer;
    V_MENSAJE      varchar2(1000);
    V_TIPTRA_MIGRA SOLOT.TIPTRA%type;
    V_WF_MIGRA     WF.WFDEF%type;
    V_CONTINUA     pls_integer;

    cursor SOT_PROCESA_SISACT is
      select T.DATAN_CODSOLOT, T.DATAC_CODCLI, T.DATAV_NUMDOC, T.DATAN_ID, T.DATAI_TIPOAGENDA
        from OPERACION.MIGRT_CAB_TEMP_SOT T
       where NVL(T.DATAI_PROCSISACT, 0) = 1
         and NVL(T.DATAI_PROCAGENSGA, 0) = 0;
  begin

    for SOT_SISACT in SOT_PROCESA_SISACT loop
      V_CONTINUA := 1;

      if SOT_SISACT.DATAI_TIPOAGENDA = 1 then --visita
        V_CONTINUA := 0;
      end if;

      if V_CONTINUA = 1 then
        V_TIPTRA_MIGRA := MIGRFUN_GET_TIPTRA_MIGRA(SOT_SISACT.DATAI_TIPOAGENDA);
        V_WF_MIGRA     := MIGRFUN_GET_WF_MIGRA(SOT_SISACT.DATAI_TIPOAGENDA);

        MIGRSS_VALIDA_SOT_ALTA(SOT_SISACT.DATAN_CODSOLOT,
                               V_TIPTRA_MIGRA,
                               V_WF_MIGRA,
                               V_ERROR,
                               V_MENSAJE);
        if V_ERROR <> 0 then
          OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(SOT_SISACT.DATAN_ID,
                                                                 SOT_SISACT.DATAV_NUMDOC,
                                                                 SOT_SISACT.DATAN_CODSOLOT,
                                                                 'ALTA',
                                                                 V_MENSAJE);
          V_CONTINUA := 0;
        end if;
      end if;

      if V_CONTINUA = 1 then
        MIGRSS_EJECUTA_TAREAS_SOT(SOT_SISACT.DATAN_CODSOLOT,
                                  V_ERROR,
                                  V_MENSAJE);
        if V_ERROR <> 0 then
          OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(SOT_SISACT.DATAN_ID,
                                                                 SOT_SISACT.DATAV_NUMDOC,
                                                                 SOT_SISACT.DATAN_CODSOLOT,
                                                                 'ALTA',
                                                                 V_MENSAJE);
          V_CONTINUA := 0;
        end if;
      end if;

      if V_CONTINUA = 1 then
        MIGRSS_ACTUALIZA_TEMP_SOT(SOT_SISACT.DATAN_CODSOLOT,
                                  V_ERROR,
                                  V_MENSAJE);

        if V_ERROR <> 0 then
          OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(SOT_SISACT.DATAN_ID,
                                                                 SOT_SISACT.DATAV_NUMDOC,
                                                                 SOT_SISACT.DATAN_CODSOLOT,
                                                                 'ALTA',
                                                                 V_MENSAJE);
        end if;
      end if;
      COMMIT;
    end loop;

    commit;

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.MIGRSS_PROCESO_SOT_SISACT()' || sqlerrm);
  end;
  -----------------------------------------------------------------------------------
  function MIGRFUN_GET_DATOS_CLIENTE(K_CODSOLOT SOLOT.CODSOLOT%type)
    return OPERACION.MIGRT_CAB_TEMP_SOT%rowtype is
    V_DATOS_MIGRA OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;
  begin

    select T.*
      into V_DATOS_MIGRA
      from OPERACION.MIGRT_CAB_TEMP_SOT T
     where T.DATAN_CODSOLOT = K_CODSOLOT;

    return V_DATOS_MIGRA;

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.MIGRFUN_GET_DATOS_CLIENTE(K_CODSOLOT => ' ||
                              K_CODSOLOT || sqlerrm);
  end;
  -----------------------------------------------------------------------------------
  procedure MIGRSS_GEN_RESERVA_IWAY(K_IDTAREAWF in number,
                                    K_IDWF      in number,
                                    K_TAREA     in number,
                                    K_TAREADEF  in number) is
    /*****************************************************************
    '* Nombre SP : MIGRSS_GEN_RESERVA_IWAY
    '* Propósito : ejecuta sp para intraway
    '* Input : N/A
    '* Output : N/A
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 19/05/2016
    '* Fec Actualización : 19/05/2016
    '*****************************************************************/
    V_CODSOLOT  SOLOT.CODSOLOT%type;
    V_RESULTADO varchar2(10);
    V_MENSAJE   varchar(1000);
    V_ERROR     number;

  begin

    select CODSOLOT into V_CODSOLOT from WF where IDWF = K_IDWF;

    OPERACION.PQ_OPE_INS_EQUIPO.P_GEN_CARGA_INICIAL(V_CODSOLOT,
                                                    V_MENSAJE,
                                                    V_ERROR);

    update INTRAWAY.AGENDAMIENTO_INT
       set EST_ENVIO = 5, MENSAJE = 'Envio a P_INTRAWAYEXE'
     where CODSOLOT = V_CODSOLOT;
    commit;

  exception
    when others then
      rollback;
      V_RESULTADO := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      V_MENSAJE   := sqlerrm;
  end;
  -----------------------------------------------------------------------------------
  procedure MIGRSS_EJECUTA_TAREAS_SOT(K_CODSOLOT SOLOT.CODSOLOT%type,
                                      K_ERROR    out number,
                                      K_MENSAJE  out varchar2) is
    /*****************************************************************
    '* Nombre SP : MIGRSS_EJECUTA_TAREAS_SOT
    '* Propósito : ejecuta las tareas de la sot
    '* Input : N/A
    '* Output : N/A
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 19/05/2016
    '* Fec Actualización : 19/05/2016
    '*****************************************************************/
    V_IDWF        WF.IDWF%type;
    V_ERROR       pls_integer;
    V_MENSAJE     varchar2(1000);
    V_DATOS_MIGRA OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;

    cursor TAREAS_FALTANTES(P_IDWF number) is
      select A.ORDEN, T.IDTAREAWF, T.TIPO, T.TAREA, T.PRE_TAREAS, T.POS_TAREAS, T.DESCRIPCION
        from TAREAWFCPY T, TAREAWFDEF A
       where A.TAREA = T.TAREA
         and T.IDWF = P_IDWF
         and not exists (select 1
                from TAREAWF TW
               where TW.IDWF = T.IDWF
                 and TW.ESTTAREA = 4 --no ejecutar las que estan cerradas
                 and T.IDTAREAWF = TW.IDTAREAWF)
       order by A.ORDEN;

  begin

    V_DATOS_MIGRA := MIGRFUN_GET_DATOS_CLIENTE(K_CODSOLOT);
    V_IDWF        := MIGRFUN_GET_IDWF_SOT(K_CODSOLOT);

    for TAREAS in TAREAS_FALTANTES(V_IDWF) loop


      if MIGRFUN_VALIDA_TAREAS_ANT(V_IDWF, TAREAS.IDTAREAWF) then
        K_ERROR   := -1;
        K_MENSAJE := 'Error: SOT de alta de migración ' || K_CODSOLOT ||
                     ', las Pre_Tareas ' || TAREAS.IDTAREAWF ||'> ' ||TAREAS.Descripcion || '> ' ||
                     TAREAS.PRE_TAREAS || ' No se encuentra cerradas.';

        OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(V_DATOS_MIGRA.DATAN_ID,
                                                               V_DATOS_MIGRA.DATAV_NUMDOC,
                                                               V_DATOS_MIGRA.DATAN_CODSOLOT,
                                                               'ALTA',
                                                               K_MENSAJE);
        return;
      end if;

      if MIGRFUN_VALIDA_TAREA_ACT(V_IDWF, TAREAS.IDTAREAWF) then
        MIGRSS_EVALUA_TAREA_WF(V_IDWF,
                               TAREAS.IDTAREAWF,
                               V_ERROR,
                               V_MENSAJE);
        if V_ERROR <> 0 then
          K_ERROR   := -1;
          K_MENSAJE := V_MENSAJE;
          OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(V_DATOS_MIGRA.DATAN_ID,
                                                                 V_DATOS_MIGRA.DATAV_NUMDOC,
                                                                 V_DATOS_MIGRA.DATAN_CODSOLOT,
                                                                 'ALTA',
                                                                 K_MENSAJE);
          return;
        end if;

        MIGRSS_CERRAR_TAREA_WF(TAREAS.IDTAREAWF, V_ERROR, V_MENSAJE);
        if V_ERROR <> 0 then
          K_ERROR   := -1;
          K_MENSAJE := V_MENSAJE;
          OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(V_DATOS_MIGRA.DATAN_ID,
                                                                 V_DATOS_MIGRA.DATAV_NUMDOC,
                                                                 V_DATOS_MIGRA.DATAN_CODSOLOT,
                                                                 'ALTA',
                                                                 V_MENSAJE);
          return;
        end if;
      end if;
    end loop;

    K_ERROR   := 0;
    K_MENSAJE := 'Ok';

  end;
  -----------------------------------------------------------------------------------
  procedure MIGRSS_VALIDA_SOT_ALTA(K_CODSOLOT     SOLOT.CODSOLOT%type,
                                   K_TIPTRA_MIGRA SOLOT.TIPTRA%type,
                                   K_WF_MIGRA     WF.WFDEF%type,
                                   K_ERROR        out number,
                                   K_MENSAJE      out varchar2) is
    /*****************************************************************
    '* Nombre SP : MIGRSS_VALIDA_SOT_ALTA
    '* Propósito : valida que la SOT es de migracion y si cumple condiciones
    '* Input : N/A
    '* Output : N/A
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 19/05/2016
    '* Fec Actualización : 19/05/2016
    '*****************************************************************/
    V_COUNT pls_integer;

    V_TIPTRA SOLOT.TIPTRA%type;
    V_WF     WF.WFDEF%type;

    V_COD_ID      SOLOT.COD_ID%type;
    V_CUSTOMER_ID SOLOT.CUSTOMER_ID%type;
    V_ERROR       number;
    V_MENSAJE     varchar2(500);

  begin

    select count(S.CODSOLOT)
      into V_COUNT
      from SOLOT S
     where S.CODSOLOT = K_CODSOLOT;

    if V_COUNT = 0 then
      K_ERROR   := -1;
      K_MENSAJE := 'La SOT de alta migración ' || K_CODSOLOT ||
                     ' , no se encuentra registrada.';
      return;
    end if;

    V_COUNT := 0;

    select count(*) into V_COUNT from WF W where W.CODSOLOT = K_CODSOLOT;

    if V_COUNT > 0 then

      select S.TIPTRA
        into V_TIPTRA
        from SOLOT S
       where CODSOLOT = K_CODSOLOT;

      if V_TIPTRA <> K_TIPTRA_MIGRA then
        K_ERROR   := -1;
        K_MENSAJE := 'La SOT de alta migración ' || K_CODSOLOT ||
                     ' , tiene un Tipo de Trabajo que no corresponde al proceso de migración.';
        return;
      end if;

      select W.WFDEF into V_WF from WF W where W.CODSOLOT = K_CODSOLOT;

      if V_WF <> K_WF_MIGRA then
        K_ERROR   := -1;
        K_MENSAJE := 'La SOT de alta migración ' || K_CODSOLOT ||
                     ' , tiene un WF que no corresponde al proceso de migración.';
        return;
      end if;
    else
      K_ERROR   := -1;
      K_MENSAJE := 'La SOT de alta migración ' || K_CODSOLOT ||
                   ' , No tiene asignado WF para el proceso de migración.';
      return;
    end if;

    begin
      select S.COD_ID, S.CUSTOMER_ID
        into V_COD_ID, V_CUSTOMER_ID
        from SOLOT S
       where S.CODSOLOT = K_CODSOLOT;
    exception
      when others then
        V_COD_ID := null;
    end;

    if V_COD_ID is not null then
      MIGRSS_VALIDAR_COD_ID(V_COD_ID, V_ERROR, V_MENSAJE);
      if V_ERROR = -1 then
        K_ERROR   := -1;
        K_MENSAJE := 'La SOT de alta migración ' || K_CODSOLOT || ', ' ||
                     V_MENSAJE;
        return;
      end if;
    else
      K_ERROR   := -1;
      V_MENSAJE := 'No fue actualizado Cod_id y Customer_id por el servicio de BSCS.';
      K_MENSAJE := 'La SOT de alta migración ' || K_CODSOLOT || ', ' ||
                   V_MENSAJE;
      return;
    end if;

    K_ERROR   := 0;
    K_MENSAJE := 'Ok';

  end;
  -----------------------------------------------------------------------------------
function MIGRFUN_GET_IDWF_SOT(K_CODSOLOT SOLOT.CODSOLOT%type)
  return WF.IDWF%type is
  /*****************************************************************
  '* Nombre FUN : MIGRFUN_GET_IDWF_SOT
  '* Propósito : Obtiene el idwf de la sot para las tareas
  '* Output : idwf de la sot
  '* Creado por : Jimmy Calle - Edwin Vasquez
  '* Fec Creación : 05/05/2016
  '* Fec Actualización : 05/05/2016
  '*****************************************************************/
  V_IDWF WF.IDWF%type;

begin

  begin
    select T.IDWF into V_IDWF from WF T where T.CODSOLOT = K_CODSOLOT;
  exception
    when NO_DATA_FOUND then
      V_IDWF := -1;
      return V_IDWF;
  end;

  return V_IDWF;

exception
  when others then
    RAISE_APPLICATION_ERROR(-20000,
                            $$plsql_unit ||
                            '.MIGRSS_GET_IDWF_SOT(K_CODSOLOT) => ' ||
                            K_CODSOLOT || sqlerrm);
end;
  -----------------------------------------------------------------------------------
function MIGRFUN_GET_TIPTRA_MIGRA(K_TIPOAGENDA OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_TIPOAGENDA%type)
  return TIPTRABAJO.TIPTRA%type is
  /*****************************************************************
  '* Nombre FUN : MIGRFUN_GET_IDWF_SOT
  '* Propósito : Obtiene el tipo de trabajo para la migracion
  '* Output : tiptra de la sot
  '* Creado por : Jimmy Calle - Edwin Vasquez
  '* Fec Creación : 05/05/2016
  '* Fec Actualización : 05/05/2016
  '*****************************************************************/

  V_TIPTRA TIPTRABAJO.TIPTRA%type;

begin
  select O.CODIGON
    into V_TIPTRA
    from OPEDD O, TIPOPEDD T
   where O.TIPOPEDD = T.TIPOPEDD
     and T.ABREV = 'MIGR_SGA_BSCS'
     and O.ABREVIACION = 'MIG_TIPTRA'
     and O.CODIGOC = K_TIPOAGENDA;

  return V_TIPTRA;

exception
  when others then
    RAISE_APPLICATION_ERROR(-20000,
                            $$plsql_unit || '.MIGRSS_GET_TIPTRA_MIGRA()' ||
                            sqlerrm);

end;
  -----------------------------------------------------------------------------------
function MIGRFUN_GET_WF_MIGRA(K_TIPOAGENDA OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_TIPOAGENDA%type)
  return WF.WFDEF%type is
  /*****************************************************************
  '* Nombre FUN : MIGRFUN_GET_WF_MIGRA
  '* Propósito : Obtiene el WF de migracion
  '* Output : wf para la migracion
  '* Creado por : Jimmy Calle - Edwin Vasquez
  '* Fec Creación : 05/05/2016
  '* Fec Actualización : 05/05/2016
  '*****************************************************************/
  V_WF WF.WFDEF%type;

begin
  select O.CODIGON
    into V_WF
    from OPEDD O, TIPOPEDD T
   where O.TIPOPEDD = T.TIPOPEDD
     and T.ABREV = 'MIGR_SGA_BSCS'
     and O.ABREVIACION = 'MIG_WF'
     and O.CODIGOC = K_TIPOAGENDA;

  return V_WF;

exception
  when others then
    RAISE_APPLICATION_ERROR(-20000,
                            $$plsql_unit || '.MIGRSS_GET_WF_MIGRA()' ||
                            sqlerrm);

end;
  -----------------------------------------------------------------------------------
 function MIGRFUN_GET_ESTTAREA_CERRADA return OPEDD.CODIGON%type is
 /*****************************************************************
'* Nombre FUN : MIGRFUN_GET_ESTTAREA_CERRADA
'* Propósito : Obtiene el codigo estado de las tareas cerrada
'* Output : estado de la tarea cerrada
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/
   V_ESTADO_TAREA_CERRADA OPEDD.CODIGON%type;

 begin
   select O.CODIGON
     into V_ESTADO_TAREA_CERRADA
     from OPEDD O
    where O.TIPOPEDD =
          (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
      and O.ABREVIACION = 'PAR_ESTTAREA';

   return V_ESTADO_TAREA_CERRADA;

 exception
   when others then
     RAISE_APPLICATION_ERROR(-20000,
                             $$plsql_unit ||
                             '.MIGRFUN_get_EST_TAREA_CERRADA()' ||
                             sqlerrm);
 end;
  -----------------------------------------------------------------------------------
  function MIGRFUN_VALIDA_TAREAS_ANT(K_IDWF      WF.IDWF%type,
                                     K_IDTAREAWF TAREAWF.IDTAREAWF%type)
    return boolean is
    /*****************************************************************
    '* Nombre FUN : MIGRFUN_VALIDA_TAREAS_ANT
    '* Propósito : valida si la tarea esta cerrada
    '* Output : boolean
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 05/05/2016
    '* Fec Actualización : 05/05/2016
    '*****************************************************************/
    V_TAREAWFCPY TAREAWFCPY%rowtype;
    V_PRE_TAREAS varchar2(200);

    V_ESTADO_TAREA_CERRADA OPEDD.CODIGON%type;
    V_TAREA                varchar2(20);
    V_TIPESTTAR            number(2);
    V_ERROR                boolean := false;
  begin

    V_TAREAWFCPY := MIGRFUN_GET_TAREA_TAREAWFCPY(K_IDWF, K_IDTAREAWF);
    V_PRE_TAREAS := V_TAREAWFCPY.PRE_TAREAS;

    V_ESTADO_TAREA_CERRADA := MIGRFUN_GET_ESTTAREA_CERRADA();

    if V_PRE_TAREAS is not null then

      while INSTR(V_PRE_TAREAS, ';') <> 0 loop
        V_TAREA      := SUBSTR(V_PRE_TAREAS,
                               1,
                               INSTR(V_PRE_TAREAS, ';') - 1);
        V_PRE_TAREAS := SUBSTR(V_PRE_TAREAS,
                               INSTR(V_PRE_TAREAS, ';') + 1,
                               LENGTH(V_PRE_TAREAS));

        V_TIPESTTAR := MIGRFUN_GET_TIPESTTAR_TAREAWF(K_IDWF, V_TAREA);
        if V_TIPESTTAR = -1 then
          V_ERROR := true;
          return V_ERROR;
        end if;

        if V_TIPESTTAR != V_ESTADO_TAREA_CERRADA then
          V_ERROR := true;
          return V_ERROR;
        end if;

        if V_ERROR then
          exit;
        end if;
      end loop;

      if not V_ERROR then
        V_TIPESTTAR := MIGRFUN_GET_TIPESTTAR_TAREAWF(K_IDWF, V_PRE_TAREAS);
        if V_TIPESTTAR = -1 then
          V_ERROR := true;
          return V_ERROR;
        end if;

        if V_TIPESTTAR != V_ESTADO_TAREA_CERRADA then
          V_ERROR := true;
          return V_ERROR;
        end if;
      end if;
    end if;

    return V_ERROR;

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.MIGRFUN_VALIDA_TAREAS_ANT(K_idwf => ' ||
                              K_IDWF || ', K_idtareawf => ' || K_IDTAREAWF ||
                              sqlerrm);
  end;
  -----------------------------------------------------------------------------------
  function MIGRFUN_GET_TAREA_TAREAWFCPY(K_IDWF      TAREAWFCPY.IDWF%type,
                                        K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type)
    return TAREAWFCPY%rowtype is
    /*****************************************************************
    '* Nombre FUN : MIGRSS_VALIDA_TAREA_TAREAWFCPY
    '* Propósito : Obtiene todos los parametros de la tarea
    '* Output : tarea parametros
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 05/05/2016
    '* Fec Actualización : 05/05/2016
    '*****************************************************************/
    V_TAREAWFCPY TAREAWFCPY%rowtype;
  begin
    select *
      into V_TAREAWFCPY
      from TAREAWFCPY
     where IDWF = K_IDWF
       and IDTAREAWF = K_IDTAREAWF;

    return V_TAREAWFCPY;
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.MIGRFUN_GET_TAREA_TAREAWFCPY(K_idwf => ' ||
                              K_IDWF || ' K_tareawfcpy => ' || K_IDTAREAWF ||
                              sqlerrm);
  end;
  -----------------------------------------------------------------------------------
  function MIGRFUN_GET_DESC_TAREA(K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type)
    return TAREAWFCPY.DESCRIPCION%type is
    /*****************************************************************
    '* Nombre FUN : MIGRFUN_GET_DESC_TAREA
    '* Propósito : Obtiene descripcion de la tarea
    '* Output : descripcion de la tarea
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 05/05/2016
    '* Fec Actualización : 05/05/2016
    '*****************************************************************/
    V_DES_TAREA TAREAWFCPY.DESCRIPCION%type;
  begin
    select DESCRIPCION
      into V_DES_TAREA
      from TAREAWFCPY
     where IDTAREAWF = K_IDTAREAWF;

    return V_DES_TAREA;
  exception
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.MIGRFUN_GET_DESC_TAREA( K_IDTAREAWF => ' ||
                              K_IDTAREAWF || sqlerrm);
  end;
  -----------------------------------------------------------------------------------
 function MIGRFUN_GET_TIPESTTAR_TAREAWF(K_IDWF  TAREAWF.IDWF%type,
                                        K_TAREA varchar2)
   return TAREAWF.ESTTAREA%type is
  /*****************************************************************
   '* Nombre FUN : MIGRFUN_GET_TIPESTTAR_TAREAWF
   '* Propósito : Devuelve el tipo de estado tarea
   '* Output : estado tarea
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   V_TIPESTTAR TAREAWF.ESTTAREA%type;

 begin

   select T.TIPESTTAR
     into V_TIPESTTAR
     from TAREAWF T
    where IDWF = K_IDWF
      and T.TAREA = TO_NUMBER(K_TAREA);

   return V_TIPESTTAR;

 exception
   when others then
     return - 1;
 end;
  -----------------------------------------------------------------------------------
 function MIGRFUN_VALIDA_TAREA_ACT(K_IDWF      WF.IDWF%type,
                                   K_IDTAREAWF TAREAWF.IDTAREAWF%type)
   return boolean is
   /*****************************************************************
   '* Nombre FUN : MIGRFUN_VALIDA_TAREA_ACT
   '* Propósito : valida si la tarea esta cerrada
   '* Output : boolean
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   V_TAREAWFCPY TAREAWFCPY%rowtype;

   V_ESTADO_TAREA_CERRADA OPEDD.CODIGON%type;
   V_TAREA                varchar2(20);
   V_TIPESTTAR            number(2);

   V_ERROR                boolean := false;
 begin

   V_TAREAWFCPY := MIGRFUN_GET_TAREA_TAREAWFCPY(K_IDWF, K_IDTAREAWF);
   V_TAREA      := V_TAREAWFCPY.TAREA;

   V_ESTADO_TAREA_CERRADA := MIGRFUN_GET_ESTTAREA_CERRADA();

   if V_TAREA is not null then
     V_TIPESTTAR := MIGRFUN_GET_TIPESTTAR_TAREAWF(K_IDWF, V_TAREA);
     if V_TIPESTTAR = -1 then
       V_ERROR := true;
       return V_ERROR;
     end if;

     if V_TIPESTTAR != V_ESTADO_TAREA_CERRADA then
       V_ERROR := true;
       return V_ERROR;
     end if;
   end if;

   return V_ERROR;

 exception
   when others then
     RAISE_APPLICATION_ERROR(-20000,
                             $$plsql_unit ||
                             '.MIGRFUN_VALIDA_TAREA_ACT(K_IDWF => ' ||
                             K_IDWF || ', K_IDTAREAWF => ' || K_IDTAREAWF ||
                             sqlerrm);
 end;
 -----------------------------------------------------------------------------------
  procedure MIGRSS_GENERA_TAREA_WF(K_IDWF      WF.IDWF%type,
                                   K_TAREA     TAREAWF.TAREA%type,
                                   K_IDTAREAWF TAREAWF.IDTAREAWF%type,
                                   K_ERROR     out number,
                                   K_MENSAJE   out varchar2) is
    /*****************************************************************
    '* Nombre SP : MIGRSS_GENERA_TAREA_WF
    '* Propósito : Genera la tarea
    '* Output : error en ejecucion
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 05/05/2016
    '* Fec Actualización : 05/05/2016
    '*****************************************************************/
    V_DESC_TAREA TAREAWFCPY.DESCRIPCION%type;

  begin

    PQ_WF.P_GENERA_TAREA(K_IDWF, K_TAREA, K_IDTAREAWF);

    K_ERROR   := 0;
    K_MENSAJE := 'Ok';

  exception
    when others then
      V_DESC_TAREA := MIGRFUN_GET_DESC_TAREA(K_IDTAREAWF);
      K_ERROR      := -1;
      K_MENSAJE    := $$plsql_unit || ' >  MIGRSS_GENERA_TAREA_WF > TAREA ' ||
                      K_TAREA || ' > ' || V_DESC_TAREA || ' > ' || sqlerrm;
  end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_CERRAR_TAREA_WF(K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                  K_ERROR     out number,
                                  K_MENSAJE   out varchar2) is
   /*****************************************************************
   '* Nombre SP : MIGRSS_CERRAR_TAREA_WF
   '* Propósito : Cierra la tarea
   '* Output : error en ejecucion
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   V_DESC_TAREA TAREAWFCPY.DESCRIPCION%type;

 begin

   PQ_WF.P_CHG_STATUS_TAREAWF(K_IDTAREAWF,
                              4, --Cerrada
                              4, --Cerrada
                              null,
                              sysdate,
                              sysdate);
   K_ERROR   := 0;
   K_MENSAJE := 'Ok';
 exception
   when others then
     V_DESC_TAREA := MIGRFUN_GET_DESC_TAREA(K_IDTAREAWF);
     K_ERROR      := -1;
     K_MENSAJE    := $$plsql_unit ||
                     ' > MIGRSS_CERRAR_TAREA_WF > IDTAREAWF ' ||
                     K_IDTAREAWF || ' > ' || V_DESC_TAREA || '> ' ||
                     sqlerrm;
 end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_EVALUA_TAREA_WF(K_IDWF      TAREAWF.IDWF%type,
                                  K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                  K_ERROR     out number,
                                  K_MENSAJE   out varchar2) is
   /*****************************************************************
   '* Nombre SP : MIGRSS_EVALUA_TAREA_WF
   '* Propósito : Evalua la tarea
   '* Output : error en ejecucion
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   V_CONT       pls_integer;
   V_TAREAWFCPY TAREAWFCPY%rowtype;
   V_ERROR      pls_integer;
   V_MENSAJE    varchar2(1000);

 begin
   select count(*)
     into V_CONT
     from TAREAWF
    where IDWF = K_IDWF
      and IDTAREAWF = K_IDTAREAWF;

   V_TAREAWFCPY := MIGRFUN_GET_TAREA_TAREAWFCPY(K_IDWF, K_IDTAREAWF);

   if V_CONT > 0 then
     if V_TAREAWFCPY.PRE_PROC is not null then
       --Ejecutar procedimiento pre_proc
       MIGRSS_EJECUTA_PROC_TAREA(V_TAREAWFCPY.PRE_PROC,
                                 V_TAREAWFCPY.IDTAREAWF,
                                 V_TAREAWFCPY.IDWF,
                                 V_TAREAWFCPY.TAREA,
                                 V_TAREAWFCPY.TAREADEF,
                                 V_ERROR,
                                 V_MENSAJE);
       if V_ERROR = -1 then
         K_ERROR   := -1;
         K_MENSAJE := V_MENSAJE;
         return;
       end if;
     end if;

     if (NVL(V_TAREAWFCPY.OPCIONAL, 0) = 1 and V_TAREAWFCPY.TIPO = 1) or
        (V_TAREAWFCPY.TIPO = 2) then
       --Ejecutar procedimiento Cur_proc
       if V_TAREAWFCPY.CUR_PROC is not null then
         MIGRSS_EJECUTA_PROC_TAREA(V_TAREAWFCPY.CUR_PROC,
                                   V_TAREAWFCPY.IDTAREAWF,
                                   V_TAREAWFCPY.IDWF,
                                   V_TAREAWFCPY.TAREA,
                                   V_TAREAWFCPY.TAREADEF,
                                   V_ERROR,
                                   V_MENSAJE);
         if V_ERROR = -1 then
           K_ERROR   := -1;
           K_MENSAJE := V_MENSAJE;
           return;
         end if;
       end if;
       --Ejecutar P_chg_status_tarea
       MIGRSS_CERRAR_TAREA_WF(V_TAREAWFCPY.IDTAREAWF, V_ERROR, V_MENSAJE);
       if V_ERROR = -1 then
         K_ERROR   := -1;
         K_MENSAJE := V_MENSAJE;
         return;
       end if;
     end if;
   else
     MIGRSS_GENERA_TAREA_WF(V_TAREAWFCPY.IDWF,
                            V_TAREAWFCPY.TAREA,
                            V_TAREAWFCPY.IDTAREAWF,
                            V_ERROR,
                            V_MENSAJE);
     if V_ERROR = -1 then
       K_ERROR   := -1;
       K_MENSAJE := V_MENSAJE;
       return;
     end if;
   end if;

 end;
 -----------------------------------------------------------------------------------
  procedure MIGRSS_EJECUTA_PROC_TAREA(K_NOMPROC   varchar2,
                                      K_IDTAREAWF TAREAWF.IDTAREAWF%type,
                                      K_IDWF      TAREAWF.IDWF%type,
                                      K_TAREA     TAREAWF.TAREA%type,
                                      K_TAREADEF  TAREAWF.TAREADEF%type,
                                      K_ERROR     out number,
                                      K_MENSAJE   out varchar2) is
    /*****************************************************************
    '* Nombre SP : MIGRSS_EJECUTA_PROC_TAREA
    '* Propósito : Ejecuta el proceso de la tarea requerida.
    '* Output : error en ejecucion
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 05/05/2016
    '* Fec Actualización : 05/05/2016
    '*****************************************************************/
    V_DESC_TAREA TAREAWFCPY.DESCRIPCION%type;

  begin

    OPEWF.PQ_WF.P_EJECUTA_PROC(K_NOMPROC,
                               K_IDTAREAWF,
                               K_IDWF,
                               K_TAREA,
                               K_TAREADEF);

    K_ERROR   := 0;
    K_MENSAJE := 'Ok';

  exception
    when others then
      V_DESC_TAREA := MIGRFUN_GET_DESC_TAREA(K_IDTAREAWF);
      K_ERROR      := -1;
      K_MENSAJE    := $$plsql_unit ||
                      ' >  MIGRSS_EJECUTA_PROC_TAREA > K_NOMPROC => ' ||
                      K_NOMPROC || ' ,K_IDTAREAWF => ' || K_IDTAREAWF ||
                      ' ,K_IDWF => ' || K_IDWF || ' ,K_TAREA => ' ||
                      K_TAREA || ' ,K_TAREADEF => ' || K_TAREADEF || ' > ' ||
                      V_DESC_TAREA || ' > ' || sqlerrm;
  end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_ASIGNAR_NUMERO(K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                 K_IDWF      TAREAWFCPY.IDWF%type,
                                 K_TAREA     TAREAWFCPY.TAREA%type,
                                 K_TAREADEF  TAREAWFCPY.TAREADEF%type) is
   /*****************************************************************
   '* Nombre SP : MIGRSS_ASIGNAR_NUMERO
   '* Propósito : Ejecuta el proceso de asignacion de numeros para la alta
   '* Output : asignacion de numero
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/

   V_CODSOLOT    SOLOT.CODSOLOT%type;
   V_TIPTRA      SOLOT.TIPTRA%type;
   V_NUMSLC      INSSRV.NUMSLC%type;
   V_CONT_TIPTRA pls_integer;
   V_DATOS_MIGRA OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;
   V_MENSAJE     varchar2(1000);

 begin

   begin
     select W.CODSOLOT into V_CODSOLOT from WF W where W.IDWF = K_IDWF;
   exception
     when others then
       V_DATOS_MIGRA := MIGRFUN_GET_DATOS_CLIENTE(V_CODSOLOT);
       V_MENSAJE     := 'Error, no se ubico codigo SOT para asignacion de numero';
       OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(V_DATOS_MIGRA.DATAN_ID,
                                                              V_DATOS_MIGRA.DATAV_NUMDOC,
                                                              V_CODSOLOT,
                                                              'ALTA',
                                                              V_MENSAJE);
       RAISE_APPLICATION_ERROR(-20000,
                               $$plsql_unit || V_MENSAJE || sqlerrm);
   end;

   select S.TIPTRA, S.NUMSLC
     into V_TIPTRA, V_NUMSLC
     from SOLOT S
    where S.CODSOLOT = V_CODSOLOT;

   select count(1)
     into V_CONT_TIPTRA
     from OPEDD A, TIPOPEDD B
    where A.TIPOPEDD = B.TIPOPEDD
      and B.ABREV = 'OPE_ASIG_NUM'
      and CODIGON = V_TIPTRA;

   if V_CONT_TIPTRA = 0 then
     MIGRSS_VALIDAR_INSSRV(V_CODSOLOT,
                           K_IDTAREAWF,
                           K_IDWF,
                           K_TAREA,
                           K_TAREADEF);
   end if;

 exception
   when others then
     RAISE_APPLICATION_ERROR(-20000,
                             $$plsql_unit ||
                             '.MIGRSS_P_ASIGNAR_NUMERO(K_IDTAREAWF => ' ||
                             K_IDTAREAWF || ' , K_IDWF => ' || K_IDWF ||
                             ' , K_TAREA => ' || K_TAREA ||
                             ' ,K_TAREADEF => ' || K_TAREADEF || sqlerrm);
 end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_VALIDAR_INSSRV(K_CODSOLOT  number default null,
                                 K_IDTAREAWF TAREAWFCPY.IDTAREAWF%type,
                                 K_IDWF      TAREAWFCPY.IDWF%type,
                                 K_TAREA     TAREAWFCPY.TAREA%type,
                                 K_TAREADEF  TAREAWFCPY.TAREADEF%type) is
   /*****************************************************************
   '* Nombre SP : MIGRSS_VALIDAR_INSSRV
   '* Propósito : Ejecuta el proceso de validacion de las inssrv
   '* Output : asignacion de numero
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   V_CODSOLOT     OPERACION.SOLOT.CODSOLOT%type;
   V_CODSOLOT1    OPERACION.SOLOT.CODSOLOT%type;
   V_FLG_VERIFICA pls_integer;
   V_CODSOLOT_VAL OPERACION.SOLOT.CODSOLOT%type;

   cursor C1 is
     select distinct I.CODINSSRV, IT.CODSOLOT, I.CID, I.TIPINSSRV
       from INSSRV I, SOLOTPTO S, SOLOT O, INTRAWAY.AGENDAMIENTO_INT IT
      where I.CODINSSRV = S.CODINSSRV
        and S.CODSOLOT = IT.CODSOLOT
        and S.CODSOLOT = O.CODSOLOT
        and IT.EST_ENVIO = 0
        and (O.CODSOLOT = K_CODSOLOT);

   cursor C2 is
     select distinct S.CODSOLOT
       from INSSRV I, SOLOTPTO S
      where I.CODINSSRV = S.CODINSSRV
        and S.CODSOLOT = V_CODSOLOT
        and I.CID is null;

   cursor C3 is -- Parametros para asignar CIDs
     select W.CODSOLOT, T.IDTAREAWF, T.IDWF, T.TAREA, T.TAREADEF
       from WF W, TAREAWF T
      where W.IDWF = T.IDWF
        and T.TAREADEF in (select A.CODIGON
                             from OPEDD A, TIPOPEDD B
                            where A.TIPOPEDD = B.TIPOPEDD
                              and B.ABREV = 'TAREADEF')
        and W.CODSOLOT = V_CODSOLOT1
        and W.VALIDO = 1;

   cursor C4 is
     select T.IDTAREAWF, T.TAREADEF, T.FECINI
       from WF W, TAREAWF T, SOLOT A
      where W.IDWF = T.IDWF
        and T.TAREADEF in (760, 779)
        and W.VALIDO = 1
        and W.CODSOLOT = A.CODSOLOT
        and A.ESTSOL = 17
        and T.ESTTAREA = 15
        and A.CODSOLOT = K_CODSOLOT;

 begin
   V_FLG_VERIFICA := 0;
   for S2 in C1 loop

     V_CODSOLOT_VAL := S2.CODSOLOT;
     if S2.CID is null then
       if S2.TIPINSSRV = 3 then

         update INSSRV I set NUMERO = null where CODINSSRV = S2.CODINSSRV;
         commit;

       end if;

       V_CODSOLOT := S2.CODSOLOT;

       for AB in C2 loop
         V_CODSOLOT1 := AB.CODSOLOT;
       end loop;

       for CB in C3 loop
         ---- Procedimiento que actualiza los CIDs
         OPERACION.PQ_CUSPE_OPE.P_WORKFLOWAUTOMATICOCABLE(CB.IDTAREAWF,
                                                          CB.IDWF,
                                                          CB.TAREA,
                                                          CB.TAREADEF);

         update INTRAWAY.AGENDAMIENTO_INT
            set MENSAJE = 'Actualizado CIDs'
          where CODSOLOT = CB.CODSOLOT;
         commit;

         V_FLG_VERIFICA := V_FLG_VERIFICA + 1;

       end loop;

     else

       update INTRAWAY.AGENDAMIENTO_INT
          set MENSAJE = 'Validacion Inssrv OK'
        where CODSOLOT = S2.CODSOLOT;
       commit;

       V_FLG_VERIFICA := V_FLG_VERIFICA + 1;

     end if;

   end loop;

   if V_FLG_VERIFICA > 0 then
     MIGRSS_ACTUALIZA_NUMERO(K_CODSOLOT,
                             K_IDTAREAWF,
                             K_IDWF,
                             K_TAREA,
                             K_TAREADEF);
   end if;

   for S4 in C4 loop
     begin
       PQ_WF.P_CHG_STATUS_TAREAWF(S4.IDTAREAWF,
                                  1,
                                  1,
                                  0,
                                  S4.FECINI,
                                  S4.FECINI);
     exception
       when others then
         null;
     end;

   end loop;

 exception
   when others then
     RAISE_APPLICATION_ERROR(-20000,
                             $$plsql_unit ||
                             '.MIGRSS_VALIDAR_INSSRV(K_CODSOLOT => ' ||
                             K_CODSOLOT || ', K_IDTAREAWF => ' ||
                             K_IDTAREAWF || ' , K_IDWF => ' || K_IDWF ||
                             ' , K_TAREA => ' || K_TAREA ||
                             ' , K_TAREADEF => ' || K_TAREADEF || sqlerrm);
 end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_ACTUALIZA_NUMERO(K_CODSOLOT_ALTA SOLOT.CODSOLOT%type,
                                   K_IDTAREAWF     TAREAWF.IDTAREAWF%type,
                                   K_IDWF          TAREAWF.IDWF%type,
                                   K_TAREA         TAREAWF.TAREA%type,
                                   K_TAREADEF      TAREAWF.TAREADEF%type) is

    /*****************************************************************
   '* Nombre SP : MIGRSS_ACTUALIZA_NUMERO
   '* Propósito : Ejecuta el proceso de validacion para actualizacion de numero
   '* Output : actualizacion de numero
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   V_SOLOTACTV        SOLOT.CODSOLOT%type;
   V_FLG_VERIFICA     number(1);
   V_DATOS_MIGRA      OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;
   V_CODNUMTEL_ULTIMA NUMTEL.CODNUMTEL%type;
   V_CODSOLOT         SOLOT.CODSOLOT%type;
   V_MENSAJE          varchar2(1000);

   cursor LINEA_ANTERIOR(V_CODSOLOT_ULTIMA SOLOT.CODSOLOT%type) is
     select O.NUMSLC, I.NUMERO
       from SOLOT O, INSSRV I, SOLOTPTO S
      where O.CODSOLOT = S.CODSOLOT
        and I.CODINSSRV = S.CODINSSRV
        and S.CODSOLOT = V_CODSOLOT_ULTIMA
        and I.TIPINSSRV = 3
      group by O.NUMSLC, I.NUMERO
      order by I.NUMERO;

   cursor LINEA_ACTUAL is
     select O.NUMSLC, I.NUMERO, I.CODINSSRV
       from SOLOT O, INSSRV I, SOLOTPTO S
      where O.CODSOLOT = S.CODSOLOT
        and I.CODINSSRV = S.CODINSSRV
        and S.CODSOLOT = K_CODSOLOT_ALTA
        and I.TIPINSSRV = 3
      group by O.NUMSLC, I.NUMERO, I.CODINSSRV
      order by I.NUMERO;

   cursor P1 is
     select distinct P.CODSOLOT, S.CODIGO_EXT
       from INSSRV I, SOLOTPTO P, TYSTABSRV S, PRODUCTO D
      where I.CODINSSRV = P.CODINSSRV
        and I.CODSRV = S.CODSRV
        and S.IDPRODUCTO = D.IDPRODUCTO
        and D.TIPSRV in ('0006', '0004', '0062', '0043', '0059')
        and P.CODSOLOT = K_CODSOLOT_ALTA;
 begin

   begin
     select O.DATAN_SOLOTACTV
       into V_SOLOTACTV
       from OPERACION.MIGRT_CAB_TEMP_SOT O
      where O.DATAN_CODSOLOT = K_CODSOLOT_ALTA;
   exception
     when others then
       V_DATOS_MIGRA := MIGRFUN_GET_DATOS_CLIENTE(K_CODSOLOT_ALTA);
       V_MENSAJE     := 'Error, no se ubico codigo SOT para actualizar numero';
       OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(V_DATOS_MIGRA.DATAN_ID,
                                                              V_DATOS_MIGRA.DATAV_NUMDOC,
                                                              V_CODSOLOT,
                                                              'ALTA',
                                                              V_MENSAJE);
       RAISE_APPLICATION_ERROR(-20000,
                               $$plsql_unit || V_MENSAJE || sqlerrm);

   end;

   for A in LINEA_ANTERIOR(V_SOLOTACTV) loop
     for B in LINEA_ACTUAL loop

       select T.CODNUMTEL
         into V_CODNUMTEL_ULTIMA
         from NUMTEL T
        where T.NUMERO = A.NUMERO;

       update NUMTEL N
          set N.CODINSSRV = B.CODINSSRV
        where N.NUMERO = A.NUMERO;

       update RESERVATEL R
          set R.NUMSLC = B.NUMSLC
        where R.CODNUMTEL = V_CODNUMTEL_ULTIMA;

       update INSSRV I
          set I.NUMERO = A.NUMERO
        where I.CODINSSRV = B.CODINSSRV;

       commit;

     end loop;

     V_CODSOLOT     := K_CODSOLOT_ALTA;
     V_FLG_VERIFICA := 1;

     for N in P1 loop
       if N.CODIGO_EXT is null then
         update INTRAWAY.AGENDAMIENTO_INT
            set MENSAJE = 'COD_EXTERNO NULO'
          where CODSOLOT = N.CODSOLOT;

         V_FLG_VERIFICA := 0;

         commit;
       else
         V_FLG_VERIFICA := 1;
       end if;

     end loop;

     if V_FLG_VERIFICA = 1 then

       INTRAWAY.PQ_SOTS_AGENDADAS.P_ASIG_HUBCMTS(K_CODSOLOT_ALTA);

     else
       update INTRAWAY.AGENDAMIENTO_INT
          set MENSAJE = 'COD_EXTERNO NULO'
        where CODSOLOT = K_CODSOLOT_ALTA;

     end if;

   end loop;

 exception
   when others then
     begin
       update INTRAWAY.AGENDAMIENTO_INT
          set MENSAJE = 'Asig_Número migrss_actualiza_numero'
        where CODSOLOT = V_CODSOLOT;
       commit;
     end;
 end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_CERRAR_SOT_BAJA(K_CODSOLOT_ALTA SOLOT.CODSOLOT%type) is
    /*****************************************************************
   '* Nombre SP : MIGRSS_CERRAR_SOT_BAJA
   '* Propósito : Ejecuta el proceso de cierre de sot de baja
   '* Output : cierr la sot
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/

   V_SOLOTBAJA   OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CODSOTBAJAADM%type;
   V_DATOS_MIGRA OPERACION.MIGRT_CAB_TEMP_SOT%rowtype;
   V_ERROR       pls_integer;
   V_MENSAJE     varchar2(1000);

 begin
   begin
     select O.DATAN_CODSOTBAJAADM
       into V_SOLOTBAJA
       from OPERACION.MIGRT_CAB_TEMP_SOT O
      where O.DATAN_CODSOLOT = K_CODSOLOT_ALTA;
   exception
     when others then
       V_DATOS_MIGRA := MIGRFUN_GET_DATOS_CLIENTE(K_CODSOLOT_ALTA);
       V_MENSAJE     := 'Error, No se registro SOT DE BAJA ADMINISTRATIVA';
       OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSI_REGISTRA_ERROR(V_DATOS_MIGRA.DATAN_ID,
                                                              V_DATOS_MIGRA.DATAV_NUMDOC,
                                                              K_CODSOLOT_ALTA,
                                                              'ALTA',
                                                              V_MENSAJE);

       RAISE_APPLICATION_ERROR(-20000,
                               $$plsql_unit || V_MENSAJE || sqlerrm);

   end;

   OPERACION.PKG_MIGRACION_SGA_BSCS.MIGRSU_CIERRE_BAJADM(V_SOLOTBAJA,
                                                         V_ERROR,
                                                         V_MENSAJE);

 exception
   when others then
     RAISE_APPLICATION_ERROR(-20000,
                             $$plsql_unit ||
                             '.MIGRSS_CERRAR_SOT_BAJA(K_CODSOLOT_ALTA => ' ||
                             K_CODSOLOT_ALTA || sqlerrm);
 end;

 -----------------------------------------------------------------------------------
  procedure MIGRSS_ACTUALIZA_TEMP_SOT(K_CODSOLOT_ALTA SOLOT.CODSOLOT%type,
                                      K_ERROR         out number,
                                      K_MENSAJE       out varchar2) is
    /*****************************************************************
    '* Nombre SP : MIGRSS_ACTUALIZA_TEMP_SOT
    '* Propósito : sp actualiza la tabla padre
    '* Output : -
    '* Creado por : Jimmy Calle - Edwin Vasquez
    '* Fec Creación : 05/05/2016
    '* Fec Actualización : 05/05/2016
    '*****************************************************************/
    V_COD_ID      SOLOT.COD_ID%type;
    V_CUSTOMER_ID SOLOT.CUSTOMER_ID%type;

    V_ERROR_SOT_ALTA exception;
  begin

    begin
      select T.COD_ID, T.CUSTOMER_ID
        into V_COD_ID, V_CUSTOMER_ID
        from SOLOT T
       where T.CODSOLOT = K_CODSOLOT_ALTA;
    exception
      when others then
        raise V_ERROR_SOT_ALTA;
    end;

    update OPERACION.MIGRT_CAB_TEMP_SOT T
       set T.DATAI_PROCAGENSGA    = 1,
           T.DATAD_FECPROCAGENSGA = sysdate,
           T.DATAN_COD_ID         = V_COD_ID,
           T.DATAN_CUSTOMER_ID    = V_CUSTOMER_ID
     where T.DATAN_CODSOLOT = K_CODSOLOT_ALTA;

    K_ERROR   := 0;
    K_MENSAJE := 'Ok';

  exception
    when V_ERROR_SOT_ALTA then
      K_ERROR   := -1;
      K_MENSAJE := 'Error, No se ha encontro informacion de la sot de alta Nº' ||
                   K_CODSOLOT_ALTA ||
                   ' para la actualizacion del contrato.';
    when others then
      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit ||
                              '.MIGRSS_ACTUALIZA_TEMP_SOT(K_CODSOLOT_ALTA => ' ||
                              K_CODSOLOT_ALTA || sqlerrm);
  end;
 -----------------------------------------------------------------------------------
 procedure MIGRSS_VALIDAR_COD_ID(K_COD_ID  SOLOT.COD_ID%type,
                                K_ERROR   out number,
                                K_MENSAJE out varchar2) is
   /*****************************************************************
   '* Nombre SP : MIGRSS_VALIDA_COD_ID
   '* Propósito : sp valida funcion del bscs
   '* Output : -
   '* Creado por : Jimmy Calle - Edwin Vasquez
   '* Fec Creación : 05/05/2016
   '* Fec Actualización : 05/05/2016
   '*****************************************************************/
   N_RESPUESTA varchar2(1);

 begin

   N_RESPUESTA := TIM.TFUN007_GET_STATUS_COID@DBL_BSCS_BF(K_COD_ID);

   if N_RESPUESTA = '-1' then
     K_ERROR   := -1;
     K_MENSAJE := 'Error, Contrato NO EXISTE';
     return;
   elsif N_RESPUESTA = '-2' then
     K_ERROR   := -1;
     K_MENSAJE := 'Error, Pendiente de Finalizar Provision';
     return;
   elsif N_RESPUESTA is null then
     K_ERROR   := -1;
     K_MENSAJE := 'Error, COD_ID con Estado Nulo';
     return;
   end if;

   K_ERROR   := 0;
   K_MENSAJE := 'Ok';

 exception
   when others then
     RAISE_APPLICATION_ERROR(-20000,
                             $$plsql_unit ||
                             '.MIGRSS_VALIDA_COD_ID(K_COD_ID => ' ||
                             K_COD_ID || sqlerrm);
 end;

----------

PROCEDURE SISACTSS_MIG_SISACT_CAB
  /*
    *****************************************************************************
    PROCEDIMIENTO:        SISACTSS_MIG_SISACT
    PROPOSITO:            CONSULTA REGISTROS PARA EL PROCESO DE MIGRACION EN SISACT
    INPUTS:               -
    OUTPUTS:              P_OUT_MIGSISACT
                          P_OUT_MSG
                          P_OUT_NRO
    CREADO POR:           PROY-23947 - EVERIS
    FECHA CREACIÓN:       07-JUNIO-2016
    MODIFICADO POR:       -
    FECHA MODIFICACION:   -
    *****************************************************************************
    */
  (P_DATAI_PROCIW IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAI_PROCIW%TYPE,--2.0
   P_OUT_MIGSISACT OUT SYS_REFCURSOR,
   P_OUT_MSG       OUT VARCHAR2,
   P_OUT_NRO       OUT VARCHAR2) AS

    V_COUNT INT;
    EX_NOTFOUND EXCEPTION;

  BEGIN

    OPEN P_OUT_MIGSISACT FOR
      SELECT NULL DATAN_ID,
             NULL DATAC_TIPO_PERSONA,
             NULL DATAC_CODCLI,
             NULL DATAV_NOMABR,
             NULL DATAV_NOMCLI,
             NULL DATAV_APEPAT,
             NULL DATAV_APEMAT,
             NULL DATAC_TIPDOC,
             NULL DATAV_DESCDOC,
             NULL DATAV_NUMDOC,
             NULL DATAD_FECNAC,
             NULL DATAD_FECHAINI,
             NULL DATAD_FECHAFIN,
             NULL DATAV_EMAILPRINC,
             NULL DATAV_EMAIL1,
             NULL DATAV_EMAIL2,
             NULL DATAC_TIPSRV,
             NULL DATAV_DESCTIPSRV,
             NULL DATAN_CODCAMP,
             NULL DATAV_DESCAMP,
             NULL DATAN_CODPLAZO,
             NULL DATAV_DESCPLAZO,
             NULL DATAN_IDSOLUCION,
             NULL DATAV_SOLUCION,
             NULL DATAC_IDPROYECTO,
             NULL DATAV_PLAY,
             NULL DATAC_CODUBI,
             NULL DATAC_CODSUCURSAL,
             NULL DATAV_DIRECCION,
             NULL DATAC_COD_EV,
             NULL DATAC_IDTIPDOC_EV,
             NULL DATAV_TIPDOC_EV,
             NULL DATAV_NUMDOC_EV,
             NULL DATAV_NOM_EV,
             NULL DATAC_IDTIPVEN,
             NULL DATAV_TIPVEN,
             NULL DATAV_IDCONT,
             NULL DATAN_NROCART,
             NULL DATAC_CODOPE,
             NULL DATAV_OPERADOR,
             NULL DATAN_PRESUS,
             NULL DATAN_PUBLI,
             NULL DATAN_IDTIPENVIO,
             NULL DATAV_TIPENVIO,
             NULL DATAV_CORELEC,
             NULL DATAV_IDDEP_DIRCLI,
             NULL DATAC_IDPROV_DIRCLI,
             NULL DATAC_IDDIST_DIRCLI,
             NULL DATAV_DEPA_DIRCLI,
             NULL DATAV_PROV_DIRCLI,
             NULL DATAV_DIST_DIRCLI,
             NULL DATAV_DIRCLI,
             NULL DATAC_CODUBIDIR,
             NULL DATAC_UBIGEODIR,
             NULL DATAC_IDTIPOVIADIR,
             NULL DATAV_TIPOVIADIR,
             NULL DATAV_NOMVIADIR,
             NULL DATAV_NUMVIADIR,
             NULL DATAN_IDTIPODOMIDIR,
             NULL DATAV_TIPODOMIDIR,
             NULL DATAV_NOMURBDIR,
             NULL DATAN_IDZONADIR,
             NULL DATAV_ZONADIR,
             NULL DATAV_REFERENCIADIR,
             NULL DATAV_TELF1DIR,
             NULL DATAV_TELF2DIR,
             NULL DATAV_CODPOSDIR,
             NULL DATAV_MANZANADIR,
             NULL DATAV_LOTEDIR,
             NULL DATAV_SECTORDIR,
             NULL DATAN_CODEDIFDIR,
             NULL DATAV_EDIFICDIR,
             NULL DATAN_PISODIR,
             NULL DATAV_INTERIORDIR,
             NULL DATAV_NUM_INTERIORDIR,
             NULL DATAV_IDPLANODIR,
             NULL DATAV_PLANODIR,
             NULL DATAV_IDDEPI,
             NULL DATAC_IDPROVI,
             NULL DATAC_IDDISTI,
             NULL DATAV_DEPARTAMENTOI,
             NULL DATAV_PROVINCIAI,
             NULL DATAV_DISTRITOI,
             NULL DATAV_DIRSUCI,
             NULL DATAV_NOMSUCI,
             NULL DATAC_UBISUCI,
             NULL DATAC_UBIGEOI,
             NULL DATAC_IDTIPOVIAI,
             NULL DATAV_TIPOVIAI,
             NULL DATAV_NOMVIAI,
             NULL DATAV_NUMVIAI,
             NULL DATAN_IDTIPODOMII,
             NULL DATAV_TIPODOMII,
             NULL DATAN_IDTIPURBI,
             NULL DATAV_NOMURBI,
             NULL DATAN_IDZONAI,
             NULL DATAV_ZONAI,
             NULL DATAV_REFERENCIAI,
             NULL DATAV_TELF1I,
             NULL DATAV_TELF2I,
             NULL DATAV_CODPOSI,
             NULL DATAV_MANZANAI,
             NULL DATAV_LOTEI,
             NULL DATAV_SECTORI,
             NULL DATAN_CODEDIFI,
             NULL DATAV_EDIFICIOI,
             NULL DATAN_PISOI,
             NULL DATAV_INTERIORI,
             NULL DATAV_NUM_INTERIORI,
             NULL DATAV_IDPLANOI,
             NULL DATAV_PLANOI,
             NULL DATAV_IDDEPF,
             NULL DATAC_IDPROVF,
             NULL DATAC_IDDISTF,
             NULL DATAV_DEPARTAMENTOF,
             NULL DATAV_PROVINCIAF,
             NULL DATAV_DISTRITOF,
             NULL DATAV_DIRSUCF,
             NULL DATAV_NOMSUCF,
             NULL DATAC_UBISUCF,
             NULL DATAC_UBIGEOF,
             NULL DATAC_IDTIPOVIAF,
             NULL DATAV_TIPOVIAF,
             NULL DATAV_NOMVIAF,
             NULL DATAV_NUMVIAF,
             NULL DATAN_IDTIPODOMIF,
             NULL DATAV_TIPODOMIF,
             NULL DATAN_IDTIPURBF,
             NULL DATAV_NOMURBF,
             NULL DATAN_IDZONAF,
             NULL DATAV_ZONAF,
             NULL DATAV_REFERENCIAF,
             NULL DATAV_TELF1F,
             NULL DATAV_TELF2F,
             NULL DATAV_CODPOSF,
             NULL DATAV_MANZANAF,
             NULL DATAV_LOTEF,
             NULL DATAV_SECTORF,
             NULL DATAN_CODEDIFF,
             NULL DATAV_EDIFICIOF,
             NULL DATAN_PISOF,
             NULL DATAV_INTERIORF,
             NULL DATAV_NUM_INTERIORF,
             NULL DATAV_IDPLANOF,
             NULL DATAV_PLANOF,
             NULL DATAN_SOLOTACTV,
             NULL DATAI_TIPOAGENDA,
             NULL DATAN_CODSOTBAJAADM,
             NULL DATAN_ESTSOTBAJA,
             NULL DATAN_IDCICLO,
             NULL DATAV_DESCICLO,
             NULL DATAI_TOPE
        FROM DUAL
       WHERE 1 = 2;

    SELECT COUNT(*)
      INTO V_COUNT
      FROM OPERACION.MIGRT_CAB_TEMP_SOT SOT
     WHERE SOT.DATAI_PROCESADO = 1
       AND SOT.DATAI_PROCSISACT = 0
       AND SOT.DATAN_CODSOTBAJAADM IS NOT NULL;

    IF V_COUNT = 0 THEN
      RAISE EX_NOTFOUND;
    END IF;

    OPEN P_OUT_MIGSISACT FOR
      SELECT SOT.DATAN_ID,
             SOT.DATAC_TIPO_PERSONA,
             SOT.DATAC_CODCLI,
             SOT.DATAV_NOMABR,
             SOT.DATAV_NOMCLI,
             SOT.DATAV_APEPAT,
             SOT.DATAV_APEMAT,
             SOT.DATAC_TIPDOC,
             SOT.DATAV_DESCDOC,
             SOT.DATAV_NUMDOC,
             SOT.DATAD_FECNAC,
             SOT.DATAD_FECHAINI,
             SOT.DATAD_FECHAFIN,
             SOT.DATAV_EMAILPRINC,
             SOT.DATAV_EMAIL1,
             SOT.DATAV_EMAIL2,
             SOT.DATAC_TIPSRV,
             SOT.DATAV_DESCTIPSRV,
             SOT.DATAN_CODCAMP,
             SOT.DATAV_DESCAMP,
             SOT.DATAN_CODPLAZO,
             SOT.DATAV_DESCPLAZO,
             SOT.DATAN_IDSOLUCION,
             SOT.DATAV_SOLUCION,
             SOT.DATAC_IDPROYECTO,
             SOT.DATAV_PLAY,
             SOT.DATAC_CODUBI,
             SOT.DATAC_CODSUCURSAL,
             SOT.DATAV_DIRECCION,
             SOT.DATAC_COD_EV,
             SOT.DATAC_IDTIPDOC_EV,
             SOT.DATAV_TIPDOC_EV,
             SOT.DATAV_NUMDOC_EV,
             SOT.DATAV_NOM_EV,
             SOT.DATAC_IDTIPVEN,
             SOT.DATAV_TIPVEN,
             SOT.DATAV_IDCONT,
             SOT.DATAN_NROCART,
             SOT.DATAC_CODOPE,
             SOT.DATAV_OPERADOR,
             SOT.DATAN_PRESUS,
             SOT.DATAN_PUBLI,
             SOT.DATAN_IDTIPENVIO,
             SOT.DATAV_TIPENVIO,
             SOT.DATAV_CORELEC,
             SOT.DATAV_IDDEP_DIRCLI,
             SOT.DATAC_IDPROV_DIRCLI,
             SOT.DATAC_IDDIST_DIRCLI,
             SOT.DATAV_DEPA_DIRCLI,
             SOT.DATAV_PROV_DIRCLI,
             SOT.DATAV_DIST_DIRCLI,
             SOT.DATAV_DIRCLI,
             SOT.DATAC_CODUBIDIR,
             SOT.DATAC_UBIGEODIR,
             SOT.DATAC_IDTIPOVIADIR,
             SOT.DATAV_TIPOVIADIR,
             SOT.DATAV_NOMVIADIR,
             SOT.DATAV_NUMVIADIR,
             SOT.DATAN_IDTIPODOMIDIR,
             SOT.DATAV_TIPODOMIDIR,
             SOT.DATAV_NOMURBDIR,
             SOT.DATAN_IDZONADIR,
             SOT.DATAV_ZONADIR,
             SOT.DATAV_REFERENCIADIR,
             SOT.DATAV_TELF1DIR,
             SOT.DATAV_TELF2DIR,
             SOT.DATAV_CODPOSDIR,
             SOT.DATAV_MANZANADIR,
             SOT.DATAV_LOTEDIR,
             SOT.DATAV_SECTORDIR,
             SOT.DATAN_CODEDIFDIR,
             SOT.DATAV_EDIFICDIR,
             SOT.DATAN_PISODIR,
             SOT.DATAV_INTERIORDIR,
             SOT.DATAV_NUM_INTERIORDIR,
             SOT.DATAV_IDPLANODIR,
             SOT.DATAV_PLANODIR,
             SOT.DATAV_IDDEPI,
             SOT.DATAC_IDPROVI,
             SOT.DATAC_IDDISTI,
             SOT.DATAV_DEPARTAMENTOI,
             SOT.DATAV_PROVINCIAI,
             SOT.DATAV_DISTRITOI,
             SOT.DATAV_DIRSUCI,
             SOT.DATAV_NOMSUCI,
             SOT.DATAC_UBISUCI,
             SOT.DATAC_UBIGEOI,
             SOT.DATAC_IDTIPOVIAI,
             SOT.DATAV_TIPOVIAI,
             SOT.DATAV_NOMVIAI,
             SOT.DATAV_NUMVIAI,
             SOT.DATAN_IDTIPODOMII,
             SOT.DATAV_TIPODOMII,
             SOT.DATAN_IDTIPURBI,
             SOT.DATAV_NOMURBI,
             SOT.DATAN_IDZONAI,
             SOT.DATAV_ZONAI,
             SOT.DATAV_REFERENCIAI,
             SOT.DATAV_TELF1I,
             SOT.DATAV_TELF2I,
             SOT.DATAV_CODPOSI,
             SOT.DATAV_MANZANAI,
             SOT.DATAV_LOTEI,
             SOT.DATAV_SECTORI,
             SOT.DATAN_CODEDIFI,
             SOT.DATAV_EDIFICIOI,
             SOT.DATAN_PISOI,
             SOT.DATAV_INTERIORI,
             SOT.DATAV_NUM_INTERIORI,
             SOT.DATAV_IDPLANOI,
             SOT.DATAV_PLANOI,
             SOT.DATAV_IDDEPF,
             SOT.DATAC_IDPROVF,
             SOT.DATAC_IDDISTF,
             SOT.DATAV_DEPARTAMENTOF,
             SOT.DATAV_PROVINCIAF,
             SOT.DATAV_DISTRITOF,
             SOT.DATAV_DIRSUCF,
             SOT.DATAV_NOMSUCF,
             SOT.DATAC_UBISUCF,
             SOT.DATAC_UBIGEOF,
             SOT.DATAC_IDTIPOVIAF,
             SOT.DATAV_TIPOVIAF,
             SOT.DATAV_NOMVIAF,
             SOT.DATAV_NUMVIAF,
             SOT.DATAN_IDTIPODOMIF,
             SOT.DATAV_TIPODOMIF,
             SOT.DATAN_IDTIPURBF,
             SOT.DATAV_NOMURBF,
             SOT.DATAN_IDZONAF,
             SOT.DATAV_ZONAF,
             SOT.DATAV_REFERENCIAF,
             SOT.DATAV_TELF1F,
             SOT.DATAV_TELF2F,
             SOT.DATAV_CODPOSF,
             SOT.DATAV_MANZANAF,
             SOT.DATAV_LOTEF,
             SOT.DATAV_SECTORF,
             SOT.DATAN_CODEDIFF,
             SOT.DATAV_EDIFICIOF,
             SOT.DATAN_PISOF,
             SOT.DATAV_INTERIORF,
             SOT.DATAV_NUM_INTERIORF,
             SOT.DATAV_IDPLANOF,
             SOT.DATAV_PLANOF,
             SOT.DATAN_SOLOTACTV,
             SOT.DATAI_TIPOAGENDA,
             SOT.DATAN_CODSOTBAJAADM,
             SOT.DATAN_ESTSOTBAJA,
             SOT.DATAN_IDCICLO,
             SOT.DATAV_DESCICLO,
             SOT.DATAI_TOPE
        FROM OPERACION.MIGRT_CAB_TEMP_SOT SOT
       WHERE SOT.DATAI_PROCESADO = 1
         AND SOT.DATAI_PROCSISACT = 0
         AND SOT.DATAI_PROCIW = P_DATAI_PROCIW --2.0
         AND SOT.DATAN_CODSOTBAJAADM IS NOT NULL;

    P_OUT_NRO := '0';
    P_OUT_MSG := 'OK';

  EXCEPTION
    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'NO SE ENCONTRARON RESGISTROS PARA MIGRAR';

    WHEN OTHERS THEN
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSS_MIG_SISACT_CAB;

  PROCEDURE SISACTSS_MIG_SISACT_DET
  /*
      *****************************************************************************
      PROCEDIMIENTO:        SISACTSS_MIG_SISACT_DET
      PROPOSITO:            CONSULTA EL DETALLE DE LOS REGISTROS PARA EL PROCESO DE
                            MIGRACION EN SISACT
      INPUTS:               P_IN_IDMIGRA
      OUTPUTS:              P_OUT_MIGSISACT
                            P_OUT_MSG
                            P_OUT_NRO
      CREADO POR:           PROY-23947 - EVERIS
      FECHA CREACIÓN:       08-JUNIO-2016
      MODIFICADO POR:       -
      FECHA MODIFICACION:   -
      *****************************************************************************
    */
  (P_IN_IDMIGRA    IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
   P_OUT_MIGSISACT OUT SYS_REFCURSOR,
   P_OUT_MSG       OUT VARCHAR2,
   P_OUT_NRO       OUT VARCHAR2) AS

    V_COUNT INT;
    EX_NOTFOUND EXCEPTION;

  BEGIN
    SELECT COUNT(*)
      INTO V_COUNT
      FROM OPERACION.MIGRT_DET_TEMP_SOT DET
     INNER JOIN OPERACION.MIGRT_CAB_TEMP_SOT CAB
        ON CAB.DATAN_ID = DET.DATAN_IDCAB
     WHERE DET.DATAN_IDCAB = P_IN_IDMIGRA
       AND CAB.DATAI_PROCESADO = 1
       AND CAB.DATAI_PROCSISACT = 0
       AND CAB.DATAN_CODSOTBAJAADM IS NOT NULL;

    IF V_COUNT = 0 THEN
      RAISE EX_NOTFOUND;
    END IF;

    OPEN P_OUT_MIGSISACT FOR
      SELECT DET.DATAN_ID,
             DET.DATAN_IDCAB,
             DET.DATAN_IDPAQ,
             DET.DATAV_PAQUETE,
             DET.DATAC_TIPPROD,
             DET.DATAV_DESCTIPPROD,
             DET.DATAN_IDPROD,
             DET.DATAV_PROD,
             DET.DATAC_CODSRV,
             DET.DATAV_SERVICIO,
             DET.DATAV_DESCPLAN,
             DET.DATAV_TIPOSERVICIO,
             DET.DATAN_IDESTSERV,
             DET.DATAV_DESCESTSERV,
             DET.DATAN_IDTIPINSS,
             DET.DATAV_TIPINSS,
             DET.DATAN_CODINSSRV,
             DET.DATAN_PID,
             DET.DATAN_IDMARCAEQUIPO,
             DET.DATAV_MARCAEQUIPO,
             DET.DATAC_CODTIPEQU,
             DET.DATAN_TIPEQU,
             DET.DATAV_TIPO_EQUIPO,
             DET.DATAV_EQU_TIPO,
             DET.DATAC_COD_EQUIPO,
             DET.DATAV_MODELO_EQUIPO,
             DET.DATAV_TIPO,
             DET.DATAV_NUMERO,
             DET.DATAN_CONTROL,
             DET.DATAN_CARGOFIJO,
             DET.DATAN_CANTIDAD,
             DET.DATAC_PUBLICAR,
             DET.DATAN_BW,
             DET.DATAN_CID,
             DET.DATAC_CODSUCURSAL,
             DET.DATAV_DESCVENTA,
             DET.DATAV_DIRVENTA,
             DET.DATAC_CODUBI,
             DET.DATAV_CODPOSTAL,
             DET.DATAV_IDPLANO,
             DET.DATAV_EQ_IDSRV_SISACT,
             DET.DATAN_MONTO_SISACT,
             DET.DATAN_EQ_PLAN_SISACT,
             DET.DATAN_MONTO_SGA,
             DET.DATAC_EQ_IDSRV_SGA,
             DET.DATAV_EQ_IDEQU_SISACT
        FROM OPERACION.MIGRT_DET_TEMP_SOT DET
       INNER JOIN OPERACION.MIGRT_CAB_TEMP_SOT CAB
          ON CAB.DATAN_ID = DET.DATAN_IDCAB
       WHERE DET.DATAN_IDCAB = P_IN_IDMIGRA
         AND CAB.DATAI_PROCESADO = 1
         AND CAB.DATAI_PROCSISACT = 0
         AND CAB.DATAN_CODSOTBAJAADM IS NOT NULL
         AND DET.DATAN_MIGRAR=1
         ;

    P_OUT_NRO := '0';
    P_OUT_MSG := 'OK';

  EXCEPTION
    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'NO SE ENCONTRARON RESGISTROS PARA MIGRAR';

    WHEN OTHERS THEN
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSS_MIG_SISACT_DET;

  PROCEDURE SISACTSI_MIG_ERROR
  /*
    *****************************************************************************
    PROCEDIMIENTO:        SISACTSI_MIG_ERROR
    PROPOSITO:            REGISTRA LOS DATOS DE UN ERROR
    INPUTS:               P_IN_IDCAB
                          P_IN_NUMDOC
                          P_IN_SOLOT
                          P_IN_PROCE
                          P_IN_DESTI
                          P_IN_ASUNTO
                          P_IN_MENSAJE
                          P_IN_USUREG
    OUTPUTS:              P_OUT_MSG
                          P_OUT_NRO
    CREADO POR:           PROY-23947 - EVERIS
    FECHA CREACIÓN:       08-JUNIO-2016
    MODIFICADO POR:       -
    FECHA MODIFICACION:   -
    *****************************************************************************
    */
  (P_IN_IDCAB   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAN_IDCAB%TYPE,
   P_IN_NUMDOC  IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_NUMDOC%TYPE,
   P_IN_SOLOT   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAN_SOLOT%TYPE,
   P_IN_PROCE   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_PROCESO%TYPE,
   P_IN_DESTI   IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_DESTINO%TYPE,
   P_IN_ASUNTO  IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_ASUNTO%TYPE,
   P_IN_MENSAJE IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_MENSAJE%TYPE,
   P_IN_USUREG  IN OPERACION.MIGRT_ERROR_MIGRACION.DATAV_USUREG%TYPE,
   P_OUT_MSG    OUT VARCHAR2,
   P_OUT_NRO    OUT VARCHAR2) AS

    EX_NOTFOUND EXCEPTION;

  BEGIN
    IF P_IN_IDCAB IS NOT NULL AND P_IN_NUMDOC IS NOT NULL AND
       P_IN_SOLOT IS NOT NULL AND P_IN_PROCE IS NOT NULL AND
       P_IN_MENSAJE IS NOT NULL AND P_IN_USUREG IS NOT NULL THEN

      INSERT INTO OPERACION.MIGRT_ERROR_MIGRACION
        (DATAN_IDCAB,
         DATAV_NUMDOC,
         DATAN_SOLOT,
         DATAV_PROCESO,
         DATAV_DESTINO,
         DATAV_ASUNTO,
         DATAV_MENSAJE,
         DATAV_USUREG,
         DATAD_FECREG)
      VALUES
        (P_IN_IDCAB,
         P_IN_NUMDOC,
         P_IN_SOLOT,
         P_IN_PROCE,
         P_IN_DESTI,
         P_IN_ASUNTO,
         P_IN_MENSAJE,
         P_IN_USUREG,
         SYSDATE);

      UPDATE OPERACION.MIGRT_CAB_TEMP_SOT OM
         SET OM.DATAI_PROCSISACT = -1
       WHERE OM.DATAN_ID = P_IN_IDCAB;
      COMMIT;

      P_OUT_NRO := '0';
      P_OUT_MSG := 'OK';

    ELSE
      RAISE EX_NOTFOUND;
    END IF;

  EXCEPTION
    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'LOS CAMPOS NO PUEDEN SER NULOS';

    WHEN OTHERS THEN
      ROLLBACK;
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSI_MIG_ERROR;

  PROCEDURE SISACTSU_MIG_SEC
  /*
    *****************************************************************************
    PROCEDIMIENTO:        SISACTSI_MIG_SEC
    PROPOSITO:            REGISTRA LA SEC EN LA TABLA: OPERACION.MIGRT_CAB_TEMP_SOT
    INPUTS:               P_IN_IDCAB
                          P_IN_NROSEC
                          P_IN_ESTSEC
    OUTPUTS:              P_OUT_MSG
                          P_OUT_NRO
    CREADO POR:           PROY-23947 - EVERIS
    FECHA CREACIÓN:       09-JUNIO-2016
    MODIFICADO POR:       -
    FECHA MODIFICACION:   -
    *****************************************************************************
    */
  (P_IN_IDCAB  IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
   P_IN_NROSEC IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CODSOTBAJAADM%TYPE,
   P_IN_ESTSEC IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAC_ESTSEC%TYPE,
   P_OUT_MSG   OUT VARCHAR2,
   P_OUT_NRO   OUT VARCHAR2) AS

    V_COUNT NUMBER;
    EX_NOTDATA  EXCEPTION;
    EX_NOTFOUND EXCEPTION;

  BEGIN
    IF P_IN_IDCAB IS NULL OR P_IN_NROSEC IS NULL OR P_IN_ESTSEC IS NULL THEN
      RAISE EX_NOTDATA;
    END IF;

    SELECT COUNT(*)
      INTO V_COUNT
      FROM OPERACION.MIGRT_CAB_TEMP_SOT SOT
     WHERE SOT.DATAN_ID = P_IN_IDCAB;

    IF V_COUNT > 0 THEN
      UPDATE OPERACION.MIGRT_CAB_TEMP_SOT SOT
         SET SOT.DATAN_NUMSEC = P_IN_NROSEC, SOT.DATAC_ESTSEC = P_IN_ESTSEC
       WHERE SOT.DATAN_ID = P_IN_IDCAB;

      COMMIT;

      P_OUT_NRO := '0';
      P_OUT_MSG := 'OK';

    ELSE
      RAISE EX_NOTFOUND;
    END IF;

  EXCEPTION
    WHEN EX_NOTDATA THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'LOS CAMPOS NO PUEDEN SER NULOS';

    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'NO SE ENCONTRO EL REGISTRO';

    WHEN OTHERS THEN
      ROLLBACK;
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSU_MIG_SEC;

  PROCEDURE SISACTSS_MIG_SEC
  /*
    *****************************************************************************
    PROCEDIMIENTO:        SISACTSS_MIG_SEC
    PROPOSITO:            RETORNA DATOS DE LA SEC Y EL ESTADO
    INPUTS:               P_IN_IDCAB
    OUTPUTS:              P_OUT_MIGSEC
                          P_OUT_MSG
                          P_OUT_NRO
    CREADO POR:           PROY-23947 - EVERIS
    FECHA CREACIÓN:       09-JUNIO-2016
    MODIFICADO POR:       -
    FECHA MODIFICACION:   -
    *****************************************************************************
    */
  (P_IN_IDCAB   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
   P_OUT_MIGSEC OUT SYS_REFCURSOR,
   P_OUT_MSG    OUT VARCHAR2,
   P_OUT_NRO    OUT VARCHAR2) AS

    V_COUNT NUMBER;
    EX_NOTDATA  EXCEPTION;
    EX_NOTFOUND EXCEPTION;

  BEGIN

    OPEN P_OUT_MIGSEC FOR
      SELECT NULL DATAN_NUMSEC, NULL DATAC_ESTSEC FROM DUAL WHERE 1 = 2;

    IF P_IN_IDCAB IS NULL THEN
      RAISE EX_NOTDATA;
    END IF;

    SELECT COUNT(*)
      INTO V_COUNT
      FROM OPERACION.MIGRT_CAB_TEMP_SOT SOT
     WHERE SOT.DATAN_ID = P_IN_IDCAB;

    IF V_COUNT > 0 THEN

      OPEN P_OUT_MIGSEC FOR
        SELECT CAB.DATAN_NUMSEC, CAB.DATAC_ESTSEC
          FROM OPERACION.MIGRT_CAB_TEMP_SOT CAB
         WHERE CAB.DATAN_ID = P_IN_IDCAB;

      P_OUT_NRO := '0';
      P_OUT_MSG := 'OK';

    ELSE
      RAISE EX_NOTFOUND;
    END IF;

  EXCEPTION
    WHEN EX_NOTDATA THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'LOS CAMPOS NO PUEDEN SER NULOS';

    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'NO SE ENCONTRO EL REGISTRO';

    WHEN OTHERS THEN
      ROLLBACK;
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSS_MIG_SEC;

  PROCEDURE SISACTSU_MIG_SOTALTA
  /*
    *****************************************************************************
    PROCEDIMIENTO:        SISACTSU_MIG_SOTALTA
    PROPOSITO:            REGISTRA LOS DATOS DE SOT DE ALTA Y EL ESTADO EN LA TABLA
                          OPERACION.MIGRT_CAB_TEMP_SOT
    INPUTS:               P_IN_IDCAB
                          P_IN_SOTALTA
                          P_IN_ESTSOT
    OUTPUTS:              P_OUT_MSG
                          P_OUT_NRO
    CREADO POR:           PROY-23947 - EVERIS
    FECHA CREACIÓN:       10-JUNIO-2016
    MODIFICADO POR:       -
    FECHA MODIFICACION:   -
    *****************************************************************************
    */
  (P_IN_IDCAB   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
   P_IN_SOTALTA IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CODSOLOT%TYPE,
   P_IN_ESTSOT  IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ESTSOTALTA%TYPE,
   P_OUT_MSG    OUT VARCHAR2,
   P_OUT_NRO    OUT VARCHAR2) AS

    V_COUNT NUMBER;
    EX_NOTDATA  EXCEPTION;
    EX_NOTFOUND EXCEPTION;

  BEGIN

    IF P_IN_IDCAB IS NULL OR P_IN_SOTALTA IS NULL OR P_IN_ESTSOT IS NULL THEN
      RAISE EX_NOTDATA;
    END IF;

    SELECT COUNT(*)
      INTO V_COUNT
      FROM OPERACION.MIGRT_CAB_TEMP_SOT SOT
     WHERE SOT.DATAN_ID = P_IN_IDCAB;

    IF V_COUNT > 0 THEN
      UPDATE OPERACION.MIGRT_CAB_TEMP_SOT SOT
         SET SOT.DATAN_CODSOLOT   = P_IN_SOTALTA,
             SOT.DATAN_ESTSOTALTA = P_IN_ESTSOT
       WHERE SOT.DATAN_ID = P_IN_IDCAB;

      COMMIT;

      P_OUT_NRO := '0';
      P_OUT_MSG := 'OK';

    ELSE
      RAISE EX_NOTFOUND;
    END IF;

  EXCEPTION
    WHEN EX_NOTDATA THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'LOS CAMPOS NO PUEDEN SER NULOS';

    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'NO SE ENCONTRO EL REGISTRO';

    WHEN OTHERS THEN
      ROLLBACK;
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSU_MIG_SOTALTA;

  PROCEDURE SISACTSU_MIG_EXITO
  /*
    *****************************************************************************
    PROCEDIMIENTO:        SISACTSU_MIG_EXITO
    PROPOSITO:            MARCA CON ESTADO DE EXITO EL PROCESO DE MIGRACION - SISACT
                          OPERACION.MIGRT_CAB_TEMP_SOT
    INPUTS:               P_IN_IDCAB
                          P_IN_CO_ID
                          P_IN_CUST_ID
    OUTPUTS:              P_OUT_MSG
                          P_OUT_NRO
    CREADO POR:           PROY-23947 - EVERIS
    FECHA CREACIÓN:       10-JUNIO-2016
    MODIFICADO POR:       -
    FECHA MODIFICACION:   -
    *****************************************************************************
    */
  (P_IN_IDCAB   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_ID%TYPE,
   P_IN_CO_ID   IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_COD_ID%TYPE,
   P_IN_CUST_ID IN OPERACION.MIGRT_CAB_TEMP_SOT.DATAN_CUSTOMER_ID%TYPE,
   P_OUT_MSG    OUT VARCHAR2,
   P_OUT_NRO    OUT VARCHAR2) AS

    V_COUNT NUMBER;
    EX_NOTDATA  EXCEPTION;
    EX_NOTFOUND EXCEPTION;

  BEGIN

    IF P_IN_IDCAB IS NULL OR P_IN_CO_ID IS NULL OR P_IN_CUST_ID IS NULL THEN
      RAISE EX_NOTDATA;
    END IF;

    SELECT COUNT(*)
      INTO V_COUNT
      FROM OPERACION.MIGRT_CAB_TEMP_SOT SOT
     WHERE SOT.DATAN_ID = P_IN_IDCAB;

    IF V_COUNT > 0 THEN
      UPDATE OPERACION.MIGRT_CAB_TEMP_SOT SOT
         SET SOT.DATAI_PROCSISACT    = 1,
             SOT.DATAN_COD_ID        = P_IN_CO_ID,
             SOT.DATAN_CUSTOMER_ID   = P_IN_CUST_ID,
             SOT.datad_fecprocsisact = SYSDATE
       WHERE SOT.DATAN_ID = P_IN_IDCAB;

      COMMIT;

      P_OUT_NRO := '0';
      P_OUT_MSG := 'OK';

    ELSE
      RAISE EX_NOTFOUND;
    END IF;

  EXCEPTION
    WHEN EX_NOTDATA THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'LOS CAMPOS NO PUEDEN SER NULOS';

    WHEN EX_NOTFOUND THEN
      P_OUT_NRO := '-1';
      P_OUT_MSG := 'NO SE ENCONTRO EL REGISTRO';

    WHEN OTHERS THEN
      ROLLBACK;
      P_OUT_NRO := SQLCODE;
      P_OUT_MSG := SQLERRM;

  END SISACTSU_MIG_EXITO;

procedure MIGRSS_VALIDA_CLIENTES(K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                                 K_IDRESULTADO    out PLS_INTEGER,
                                 K_RESULTADO      out VARCHAR2 ) is

/*****************************************************************
'* Nombre SP : MIGRSS_PRE_REQUISTOS
'* Propósito : Verificar consistencia de datos enviados y validaciones
'* Input : K_DATOS_CLIENTE Datos del Cliente
'* Output : K_IDRESULTADO Codigo de Error, K_RESULTADO Mensaje de Error
'* Creado por : Jimmy Calle - Edwin Vasquez
'* Fec Creación : 05/05/2016
'* Fec Actualización : 05/05/2016
'*****************************************************************/

    V_TIPO_PERS   CHAR(1);
    V_NOMABR_CLIENTE VARCHAR2(150);
    V_CLIENTE     VARCHAR2(200);
    V_TIPO_DOC    VARCHAR2(10);
    V_NUM_DOC     VARCHAR2(15);
    V_IDPROYECTO  CHAR(10);
    V_CODSUCURSAL CHAR(10);
    V_CODUBIGEO   CHAR(10);
    V_NOM_EV      VARCHAR2(60);
    V_TIPVEN      VARCHAR2(50);
    V_IDCONT      VARCHAR2(15);
    V_DIRCLI      VARCHAR2(480);
    V_UBIGEODIR   CHAR(6);
    V_TIPOVIADIR  VARCHAR2(30);
    V_NOMVIADIR   VARCHAR2(60);
    V_NUMVIADIR   VARCHAR2(50);
    V_DIRSUCI     VARCHAR2(1000);
    V_UBIGEOI     CHAR(6);
    V_TIPOVIAI    VARCHAR2(30);
    V_NOMVIAI     VARCHAR2(60);
    V_NUMVIAI     VARCHAR2(50);
    V_CODSOLOTACT NUMBER(8);
    V_EVAL        PLS_INTEGER;
    V_DATOS_SOT   T_DATOSXSOT;

begin
    K_IDRESULTADO := 1;

    V_NOMABR_CLIENTE := trim(K_DATOS_CLIENTE.DATAV_NOMABR);
    if V_NOMABR_CLIENTE is null then--Nombre Abreviado de Cliente Nulo
       K_IDRESULTADO := -1;
       K_RESULTADO   := K_RESULTADO||'El Nombre Abreviado del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||' es nulo |';
    end if;

     if K_DATOS_CLIENTE.DATAC_TIPSRV = '0061' then
        V_CLIENTE := trim(K_DATOS_CLIENTE.DATAV_NOMCLI);
        if V_CLIENTE is null then--Nombre de Cliente Nula
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Nombre del Cliente NOMCLI con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||' es nulo |';
        end if;
     end if;

    if K_IDRESULTADO != -1 then
        V_TIPO_PERS := trim(K_DATOS_CLIENTE.DATAC_TIPO_PERSONA);
        if V_TIPO_PERS is null then--Tipo de Persona Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Tipo de Persona es nulo del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_TIPO_DOC := trim(K_DATOS_CLIENTE.DATAV_DESCDOC);
        if V_TIPO_DOC is null then--Tipo de Documento Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Tipo de Documento es nulo del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_NUM_DOC := trim(K_DATOS_CLIENTE.DATAV_NUMDOC);
        if V_NUM_DOC is null then--Numero de Documento del Cliente Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Numero de Documento es nulo del Cliente con Codigo '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_IDPROYECTO := trim(K_DATOS_CLIENTE.DATAC_IDPROYECTO);
        if V_IDPROYECTO is null then--Proyecto Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Proyecto anterior activo enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_CODSUCURSAL := trim(K_DATOS_CLIENTE.DATAC_CODSUCURSAL);
        if V_CODSUCURSAL is null then--Sucursal Nula
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'La Sucursal CODSUCURSAL asociado a la Venta enviada es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_CODUBIGEO := trim(K_DATOS_CLIENTE.DATAC_CODUBIGEO);
        if V_CODUBIGEO is null then--Ubigeo Nula
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'La Ubicacion CODUBIGEO asociado a la Venta enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        if K_DATOS_CLIENTE.DATAC_TIPSRV='0061' then
          V_NOM_EV := trim(K_DATOS_CLIENTE.DATAV_NOM_EV);
          if V_NOM_EV is null then--Vendedor Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Vendedor enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_TIPVEN := trim(K_DATOS_CLIENTE.DATAV_TIPVEN);
          if V_TIPVEN is null then--Tipo Venta Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Tipo de Venta es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_IDCONT := trim(K_DATOS_CLIENTE.DATAV_IDCONT);
          if V_IDCONT is null then--Numero de Venta Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Numero de Venta IDCONT es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;
        end if;

        V_DIRCLI := trim(K_DATOS_CLIENTE.DATAV_DIRCLI);
        if V_DIRCLI is null then--Direccion de Cliente Nula
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'La Direccion es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_UBIGEODIR := trim(K_DATOS_CLIENTE.DATAC_UBIGEODIR);
        if V_UBIGEODIR is null then--Ubigeo de la Direccion del Cliente Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Ubigeo de la Direccion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_TIPOVIADIR := trim(K_DATOS_CLIENTE.DATAV_TIPOVIADIR);
        if V_TIPOVIADIR is null then--Tipo de Via de la Direccion del Cliente  Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Tipo de Via de la Direccion del Cliente es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_NOMVIADIR := trim(K_DATOS_CLIENTE.DATAV_NOMVIADIR);
        if V_NOMVIADIR is null then--Nombre de Via de la Direccion del Cliente Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Nombre de Via de la Direccion del Cliente es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_NUMVIADIR := trim(K_DATOS_CLIENTE.DATAV_NUMVIADIR);
        if V_NUMVIADIR is null then--Numero de Via de la Direccion del Cliente Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Numero de Via de la Direccion del Cliente es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_DIRSUCI := trim(K_DATOS_CLIENTE.DATAV_DIRSUCI);
        if V_DIRSUCI is null then--Sucursal de Instalacion Nula
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'La Sucursal de Instalacion es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_UBIGEOI := trim(K_DATOS_CLIENTE.DATAC_UBIGEOI);
        if V_UBIGEOI is null then--Ubigeo de la Sucursal de Instalacion Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Ubigeo de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_TIPOVIAI := trim(K_DATOS_CLIENTE.DATAV_TIPOVIAI);
        if V_TIPOVIAI is null then--Tipo de Via de la Sucursal de Instalacion Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Tipo de Via de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_NOMVIAI := trim(K_DATOS_CLIENTE.DATAV_NOMVIAI);
        if V_NOMVIAI is null then--Nombre de Via de la Sucursal de Instalacion Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Nombre de Via de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_NUMVIAI := trim(K_DATOS_CLIENTE.DATAV_NUMVIAI);
        if V_NUMVIAI is null then--Numero de Via de la Sucursal de Instalacion Nulo
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'El Numero de Via de la Sucursal de Instalacion es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

        V_CODSOLOTACT := trim(K_DATOS_CLIENTE.DATAN_SOLOTACTV);--Verificar
        if V_CODSOLOTACT is null then--Ultima Sot Activa Nula
          K_IDRESULTADO := -1;
          K_RESULTADO   := K_RESULTADO||'La Ultima Sot Activa enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        end if;

    end if;

    if K_IDRESULTADO != -1 then
        if MIGRFUN_PROCESADO(K_DATOS_CLIENTE, 1) then--Si ya esta procesado el Cliente con su Plan--modif
           K_IDRESULTADO := -1;
           K_RESULTADO   := K_RESULTADO||'El Cliente ya fue procesado: ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
        else

            /*V_CANTIDAD := MIGRFUN_TIENE_PLAY(V_IDPROYECTO,V_CODSUCURSAL,K_DATOS_CLIENTE.DATAC_CODCLI);
            if V_CANTIDAD = 0 then--Verificar Play con solo Telefonia Fija, Internet o Cable
               K_IDRESULTADO := -1;
               K_RESULTADO   := K_RESULTADO||'No tiene Servicio Principal Activo de 1, 2 o 3Play, el Cliente: ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
            end if;*/--Verificar

            /*if K_DATOS_CLIENTE.DATAC_TIPSRV='0061' then
                if not MIGRFUN_ES_CLIENTE_SGA(K_DATOS_CLIENTE.DATAN_SOLOTACTV) then--Si Cliente no es Masivo SGA
                   K_IDRESULTADO := -1;
                   K_RESULTADO   := K_RESULTADO||'El Cliente no es Masivo SGA: ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
                end if;
            end if;*/

            MIGRSS_VALIDA_SOT(K_DATOS_CLIENTE.DATAC_CODCLI,K_DATOS_CLIENTE.DATAC_TIPSRV, V_EVAL, V_DATOS_SOT);
            if V_EVAL = -1 then--Si ultima Sot de Cliente fuera de Suspension, Corte, Baja Total, Mantenimiento en cualquier estado o Reconexion (sin cerrar)
               K_IDRESULTADO := -1;
               K_RESULTADO   := K_RESULTADO||'Existe una ultima Sot del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' que no esta aceptada para continuar el proceso: Sot->'||V_DATOS_SOT.DATAN_SOT||'-Tipo->'||V_DATOS_SOT.DATAV_TIPOSOT||' |';
            end if;

            if V_EVAL = -2 then--Si hubo problemas al obtener ultima Sot de Cliente
               K_IDRESULTADO := -1;
               K_RESULTADO   := K_RESULTADO||'Hubo problemas al quererse obtener ultima Sot del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
            end if;

            if MIGRFUN_VARIAS_SUC(K_DATOS_CLIENTE) then--Si tiene mas de una Sucursal
               K_IDRESULTADO := -1;
               K_RESULTADO   := K_RESULTADO||'El Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' tiene varias Sucursales'||' |';
            end if;
       end if;
  end if;

end ;

procedure MIGRSS_VALIDA_SERVICIOS(K_DATOS_CLIENTE  T_DATOSXCLIENTE,
                                  K_IDRESULTADO    out PLS_INTEGER,
                                  K_RESULTADO      out VARCHAR2 ) is

    V_TIPSRV      CHAR(4);
    V_CODCAMP     NUMBER(6);
    V_DESCAMP     VARCHAR2(200);
    V_CODPLAZO    NUMBER(4);
    V_DESCPLAZO   VARCHAR2(80);
    V_IDSOLUCION  NUMBER(10);
    V_IDPAQ       NUMBER(10);
    V_PRODUCTO    VARCHAR2(50);
    V_CODSRV      CHAR(4);
    V_SERVICIO    VARCHAR2(50);
    V_CODINSSRV   NUMBER(10);
    V_PID         NUMBER(10);
    V_SOLOTACT    NUMBER(8);
    V_CANTIDAD    PLS_INTEGER;
    V_EVAL        PLS_INTEGER;
    V_SERPRINC    CHAR(4);
    V_MONTO       NUMBER;
    V_FLAG        PLS_INTEGER;/**/
    V_EQUIV_SISACT T_EQUIV_SISACT;
    V_RESULTADO   VARCHAR2(1000);
    V_DATOS_CLIENTE T_DATOSXCLIENTE;

begin
     K_IDRESULTADO := 1; V_CANTIDAD := 0;

     select count(*)
       into V_CANTIDAD
       from opedd o, tipopedd t
      where o.tipopedd = t.tipopedd
        and t.abrev = 'MIGR_SGA_BSCS'
        and o.ABREVIACION = 'TIPOS_SERV'
        and o.codigoc = K_DATOS_CLIENTE.DATAC_TIPPROD
        and o.codigon_aux is null;

     select codigon
       into V_FLAG
       from OPEDD
      where TIPOPEDD =
            (select TIPOPEDD from TIPOPEDD where ABREV = 'MIGR_SGA_BSCS')
        and ABREVIACION = 'ADIC_TELFIJA';/**/

     if (K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Principal' and V_CANTIDAD > 0) or--si es servicio principal solo de telefonia fija, internet o cable
        (
         ((K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Adicionales' or K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Equipos') and K_DATOS_CLIENTE.DATAC_TIPPROD = '0062') or --o servicio adicional o Equipo de cable
         ((K_DATOS_CLIENTE.DATAV_TIPOSERVICIO = 'Adicionales' ) and K_DATOS_CLIENTE.DATAC_TIPPROD = '0004' and V_FLAG = 1)/**/--o servicio adicional de Telefonia, si esta configurado
         ) then

          V_TIPSRV := trim(K_DATOS_CLIENTE.DATAC_TIPSRV);
          if V_TIPSRV is null then--Familia de Servicio Nula
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'La Familia de Servicio TIPSRV enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_CODCAMP := K_DATOS_CLIENTE.DATAN_CODCAMP;
          if V_CODCAMP is null then--Codigo de Campaña Nula
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Codigo de Campaña enviado es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_DESCAMP := trim(K_DATOS_CLIENTE.DATAV_DESCAMP);
          if V_DESCAMP is null then--Campaña Nula
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'La Campaña enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_CODPLAZO := K_DATOS_CLIENTE.DATAN_CODPLAZO;
          if V_CODPLAZO is null then--Codigo de Plazo Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Codigo de Plazo enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_DESCPLAZO := trim(K_DATOS_CLIENTE.DATAV_DESCPLAZO);
          if V_DESCPLAZO is null then--Plazo Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Plazo enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_IDSOLUCION := K_DATOS_CLIENTE.DATAN_IDSOLUCION;
          if V_IDSOLUCION is null then--Codigo de Solucion Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'La Solucion enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_IDPAQ := K_DATOS_CLIENTE.DATAN_IDPAQ;
          if V_IDPAQ is null then--Codigo de Paquete Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Paquete enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_PRODUCTO := trim(K_DATOS_CLIENTE.DATAV_PROD);
          if V_PRODUCTO is null then--Producto Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Producto enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_CODSRV := trim(K_DATOS_CLIENTE.DATAC_CODSRV);
          if V_CODSRV is null then--Codigo de Servicio Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Codigo de Servicio/Plan CODSRV enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_SERVICIO := trim(K_DATOS_CLIENTE.DATAV_SERVICIO);
          if V_SERVICIO is null then--Servicio Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Servicio/Plan enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_CODINSSRV := K_DATOS_CLIENTE.DATAN_CODINSSRV;
          if V_CODINSSRV is null then--Codigo de Instancia de Servicio Nula
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'La Instancia de Servicio CODINSSRV enviada es nula del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_PID := K_DATOS_CLIENTE.DATAN_PID;
          if V_PID is null then--Codigo de Instancia de Producto Nulo
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'El Codigo de Instancia de Producto PID enviado es nulo del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
          end if;

          V_SOLOTACT := MIGRFUN_ULTIMA_SOT_ACTV(V_CODINSSRV);
          if V_SOLOTACT = 0 then
            K_IDRESULTADO := -1;
            K_RESULTADO   := K_RESULTADO||'La Ultima Sot Activa del Cliente '|| K_DATOS_CLIENTE.DATAC_CODCLI ||'-'||K_DATOS_CLIENTE.DATAV_NOMABR||' no tiene Detalle, verificar. |';
          end if;

          if K_DATOS_CLIENTE.DATAN_SOLOTACTV != V_SOLOTACT then--Sot no es la Ultima Activa
                K_IDRESULTADO := -1;
                K_RESULTADO   := K_RESULTADO||'La Sot enviada no es la ultima Sot Activa del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||'(Enviada: '||K_DATOS_CLIENTE.DATAN_SOLOTACTV||' - Deberia enviar: '||V_SOLOTACT||') |';
         end if;

         if K_IDRESULTADO != -1 then

              if not atccorp.PQ_ORDEN_VIS_VALID.esta_activo_servicio_sga(K_DATOS_CLIENTE.DATAC_CODCLI, V_CODINSSRV) then--Si no esta activo el Servicio
                 K_IDRESULTADO := -1;
                 K_RESULTADO   := K_RESULTADO||'El Servicio '||V_CODINSSRV||' No esta Activo del Cliente ' || K_DATOS_CLIENTE.DATAC_CODCLI || '-' ||K_DATOS_CLIENTE.DATAV_NOMABR||' |';
              end if;

              V_DATOS_CLIENTE.DATAC_TIPPROD     := K_DATOS_CLIENTE.DATAC_TIPPROD;
              V_DATOS_CLIENTE.DATAC_CODSRV    := K_DATOS_CLIENTE.DATAC_CODSRV;
              V_DATOS_CLIENTE.DATAN_CARGOFIJO := K_DATOS_CLIENTE.DATAN_CARGOFIJO;
              V_DATOS_CLIENTE.DATAV_SERVICIO  := K_DATOS_CLIENTE.DATAV_SERVICIO;
              V_DATOS_CLIENTE.DATAN_MONTO_SGA := MIGRFUN_MONTO_CIGV(K_DATOS_CLIENTE.DATAN_CARGOFIJO);
              V_DATOS_CLIENTE.DATAC_COD_EQUIPO := K_DATOS_CLIENTE.DATAC_COD_EQUIPO;
              V_DATOS_CLIENTE.DATAN_TIPEQU := K_DATOS_CLIENTE.DATAN_TIPEQU;
              V_DATOS_CLIENTE.DATAV_MODELO_EQUIPO  := K_DATOS_CLIENTE.DATAV_MODELO_EQUIPO;
              V_DATOS_CLIENTE.DATAV_TIPO        := K_DATOS_CLIENTE.DATAV_TIPO;
              V_DATOS_CLIENTE.DATAN_PID         := K_DATOS_CLIENTE.DATAN_PID;
              V_DATOS_CLIENTE.DATAV_TIPOSERVICIO := K_DATOS_CLIENTE.DATAV_TIPOSERVICIO;
              V_DATOS_CLIENTE.DATAV_TIPO_EQUIPO := K_DATOS_CLIENTE.DATAV_TIPO_EQUIPO;

              V_DATOS_CLIENTE.DATAN_IDPROD      := K_DATOS_CLIENTE.DATAN_IDPROD;/**/
              V_DATOS_CLIENTE.DATAN_CODINSSRV   := K_DATOS_CLIENTE.DATAN_CODINSSRV;/**/
              V_DATOS_CLIENTE.DATAC_CODSUCURSAL := K_DATOS_CLIENTE.DATAC_CODSUCURSAL;/**/
              V_DATOS_CLIENTE.DATAC_CODUBIGEO   := K_DATOS_CLIENTE.DATAC_CODUBIGEO;/**/

             if V_DATOS_CLIENTE.DATAV_TIPOSERVICIO != 'Principal' then--Si es Adicional o Equipo obtener Plan de Servicio Principal
                  begin
                     select datac_codsrv, nvl(datan_cargofijo,0)
                       into V_SERPRINC, V_MONTO
                       from operacion.migrt_dataprinc
                      where datac_codcli = K_DATOS_CLIENTE.DATAC_CODCLI
                        and datac_tipsrv = K_DATOS_CLIENTE.DATAC_TIPSRV
                        and DATAV_TIPOSERVICIO = 'Principal'
                        and DATAC_TIPPROD = V_DATOS_CLIENTE.DATAC_TIPPROD
                        and rownum = 1;

                      V_MONTO := MIGRFUN_MONTO_CIGV(V_MONTO);

                      select datan_eq_plan_sisact
                        into V_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT
                        from operacion.migrt_equ_sga_sisact
                       where datac_idsrv_sga = V_SERPRINC
                         and datan_monto_sga = V_MONTO
                         and rownum = 1;/**/

                    exception
                      when others then
                        V_DATOS_CLIENTE.DATAN_EQ_PLAN_SISACT := null;
                  end;
              end if;

              MIGRSS_EQUIVALENCIAS (V_DATOS_CLIENTE, V_EQUIV_SISACT, V_EVAL, V_RESULTADO);
              if V_EVAL = -1 then
                 K_IDRESULTADO := V_EVAL;
                 K_RESULTADO   := K_RESULTADO||V_RESULTADO||' |';
              end if;

         end if;
     end if;
 end;
-----------------------------------------------------------------------------------------
procedure MIGRSS_CERRAR_BAJAADM(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number,
                                a_tipesttar in number,
                                a_esttarea  in number,
                                a_mottarchg in number,
                                a_fecini    in date,
                                a_fecfin    in date) is

  cons_altbaj constant varchar2(10) := 'ALTABAJA';

  ln_resp         numeric;
  lv_mensaje      varchar2(3000);
  ln_codsolot     number;
  ln_codsolotbaja number;
  ln_id           number;
  lc_codcli       char(8);
  lv_numdoc       varchar2(15);
  ln_count           number;

begin

  select w.codsolot into ln_codsolot from wf w where w.idwf = a_idwf;
  select count(*)
    into ln_count
    from operacion.migrt_cab_temp_sot mc
   where mc.datan_codsolot = ln_codsolot;

  if ln_count = 1 then

    select mc.datan_codsotbajaadm,
           mc.datav_numdoc,
           mc.datac_codcli,
           mc.datan_id
      into ln_codsolotbaja, lv_numdoc, lc_codcli, ln_id
      from operacion.migrt_cab_temp_sot mc
     where mc.datan_codsolot = ln_codsolot;

    if ln_codsolotbaja is not null then
      operacion.sp_procesa_sot_baja_adm(ln_codsolotbaja,
                                        ln_resp,
                                        lv_mensaje);

      if ln_resp <> 1 then
        migrsi_registra_error(ln_id,
                              lv_numdoc,
                              null,
                              cons_altbaj,
                              lv_mensaje);
        raise_application_error(-20500, lv_mensaje);
      end if;
    else
      lv_mensaje := 'No se registro SOT DE BAJA ADMINISTRATIVA';
      migrsi_registra_error(ln_id,
                            lv_numdoc,
                            null,
                            cons_altbaj,
                            lv_mensaje);
      raise_application_error(-20500, lv_mensaje);
    end if;
  end if;

exception
  when others then
    lv_mensaje := 'Error al actualizar Sot de Baja Administrativa : ' ||
                  sqlerrm;
    migrsi_registra_error(ln_id, lv_numdoc, null, cons_altbaj, lv_mensaje);

    raise_application_error(-20001, lv_mensaje);
end;
-----------------------------------------------------------------------------------------


end;
/