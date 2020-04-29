-- DELETE TABLA OPEDD
DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD T WHERE T.ABREV = 'TIPTRA_ACTIVACION');

-- DELETE TABLA TIPOPEDD
DELETE FROM OPERACION.TIPOPEDD WHERE DESCRIPCION = 'Tipo Trabajo - Activaciones' AND ABREV = 'TIPTRA_ACTIVACION';

-- RESTAURACIÓN TABLA CFG_ENV_CORREO_CONTRATA
UPDATE operacion.cfg_env_correo_contrata T SET T.QUERY = 
'SELECT S.CODSOLOT, '''' pepequ,
vtatabdst.nomdst,
vtatabdst.nomprov,
vtatabdst.nomdepa,
E.DESCRIPCION ESTADO_SOT,
T.DESCRIPCION TIPO_TRABAJO,
SG.FECHA fechaatencion,
(SELECT MAX(I.FECINI) FROM SOLOTPTO SP, INSSRV I, VTASUCCLI VS WHERE S.CODSOLOT=SP.CODSOLOT AND I.CODINSSRV=SP.CODINSSRV AND VS.CODSUC=I.CODSUC)FECINISSRV,
S.CODCLI,
V.NOMCLI,
(SELECT TT.CODTIPEQU FROM TIPEQU TT WHERE TT.TIPEQU=SQ.TIPEQU)COD_MATERIAL_SGA,
(SELECT I.COD_SAP FROM TIPEQU TT, ALMTABMAT I WHERE TT.TIPEQU=SQ.TIPEQU AND I.CODMAT=TT.CODTIPEQU) COD_MATERIAL_SAP,       
(SELECT I.DESMAT FROM TIPEQU TT, ALMTABMAT I WHERE TT.TIPEQU=SQ.TIPEQU AND I.CODMAT=TT.CODTIPEQU) DESCRIPCION_MATERIAL,
SQ.CANTIDAD,
SQ.NUMSERIE SERIAL_NUMBER, SQ.Enacta Flg_retiro,
DECODE(SQ.IDAGENDA,NULL,(SELECT MAX(A.IDAGENDA) FROM AGENDAMIENTO A WHERE A.CODSOLOT=S.CODSOLOT),SQ.IDAGENDA)IDAGENDA,
(SELECT AA.fecha_instalacion FROM AGENDAMIENTO AA WHERE AA.IDAGENDA=DECODE(SQ.IDAGENDA,NULL,(SELECT MAX(A.IDAGENDA) 
FROM AGENDAMIENTO A WHERE A.CODSOLOT=S.CODSOLOT),SQ.IDAGENDA) 
AND ROWNUM=1)fecha_instalacion ,
(select min(fecha) from solotchgest a1 where estado=29 and a1.codsolot=s.codsolot) fecha_atendido,
DECODE((SELECT C.NOMBRE FROM AGENDAMIENTO A, CONTRATA C WHERE A.IDAGENDA=SQ.IDAGENDA AND C.CODCON=A.CODCON),NULL,
(SELECT MAX(C.NOMBRE) FROM AGENDAMIENTO A, CONTRATA C WHERE A.CODSOLOT=S.CODSOLOT AND C.CODCON=A.CODCON),
(SELECT C.NOMBRE FROM AGENDAMIENTO A, CONTRATA C WHERE A.IDAGENDA=SQ.IDAGENDA AND C.CODCON=A.CODCON))CONTRATA,
(SELECT MAX(VS.IDPLANO) FROM SOLOTPTO SP, INSSRV I, VTASUCCLI VS WHERE S.CODSOLOT=SP.CODSOLOT AND I.CODINSSRV=SP.CODINSSRV AND VS.CODSUC=I.CODSUC)PLANO,
(SELECT A.IDPLANO FROM AGENDAMIENTO A, CONTRATA C WHERE A.IDAGENDA=SQ.IDAGENDA AND C.CODCON=A.CODCON)PLANO,
mot.descripcion,
decode(s.customer_id,null,S.CODCLI,s.customer_id) customer_id ,
      (SELECT  substr(to_char(substr(wm_concat(A.DESCRIPCION||''~~''),1,4000)),1,4000)                      
FROM SOLOTPTOETA  ST,
     SOLOTPTOETAACT AC,
     ACTIVIDAD A
WHERE ST.CODSOLOT=S.CODSOLOT
      AND ST.CODSOLOT=AC.CODSOLOT
      AND ST.PUNTO=AC.PUNTO AND ST.ORDEN=AC.ORDEN 
      AND A.CODACT=AC.CODACT) ACTIVIDADES
 
FROM   SOLOT S,
SOLOTCHGEST SG,
ESTSOL E,
TIPTRABAJO T,
VTATABCLI V,
SOLOTPTOEQU SQ,agendamiento age, operacion.Mot_Solucion mot ,vtatabdst
WHERE  
S.CODSOLOT=SG.CODSOLOT and s.codsolot=age.codsolot and age.motsol_cab=mot.codmot_solucion(+) and
age.codubi=vtatabdst.codubi
AND E.ESTSOL=SG.ESTADO
AND SG.ESTADO IN (29)
AND E.ESTSOL IN (29,12)
AND T.TIPTRA=S.TIPTRA
AND S.CODCLI=V.CODCLI 
AND SQ.CODSOLOT(+)=S.CODSOLOT
and (SG.FECHA) between to_date(''01/01/2015'', ''dd/mm/yyyy'') and to_date(''31/12/2015'' || '' 23:59:59'', ''dd/mm/yyyy hh24:mi:ss'')
and s.tiptra in (724,620  ,626  , 494  ,606  , 770  ,672  ,430  ,413  , 613  ,427  ,780  ,611  ,
630  ,414  ,409  ,442  ,627  ,431  ,787  ,671  , 720  ,690  ,614  ,615  ,628  ,404  ,424  ,779  ,480  ,670  ,730  ,610  ,
417  ,691  ,496  ,719  ,439  ,669  ,629  ,679  ,676  ,763  ,6  ,725  ,407,410  ,674  ,452  ,
443  ,445  , 605  ,489  ,415  ,462  ,658  ,444  ,411  ,451  ,441  ,621  ,412  ,418  ,625  ,675  ,
632  ,717  ,416  ,695  ,733  ,689  ,692  ,745  ,766  ,700  ,732  ,721  ,773  ,731  ,693  ,694  ,796  ,785  ,784  ,678  ,775  ,654  ,
722  ,716)  
and age.codcon=131' 
WHERE T.IDCFG = 1;
COMMIT;

-- RESTAURACIÓN TABLA CFG_ENV_CORREO_CONTRATA
DECLARE
STR LONG;
BEGIN
STR :=
'release 8;
datawindow(units=0 timer_interval=0 color=1073741824 processing=1 print.orientation=0 print.margin.left=110 print.margin.right=110 print.margin.top=96 print.margin.bottom=96 print.paper.size=0 print.paper.source=0 grid.lines=0 selected.mouse=yes)
header(height=120)
summary(height=0)
footer(height=0)
detail(height=80)
table(column=(type=decimal(0) updatewhereclause=yes name=codsolot dbname="codsolot" )
column=(type=char(0) updatewhereclause=yes name=pepequ dbname="pepequ" )
column=(type=char(40) updatewhereclause=yes name=nomdst dbname="nomdst" )
column=(type=char(100) updatewhereclause=yes name=nomprov dbname="nomprov" )
column=(type=char(100) updatewhereclause=yes name=nomdepa dbname="nomdepa" )
column=(type=char(100) updatewhereclause=yes name=estado_sot dbname="estado_sot" )
column=(type=char(200) updatewhereclause=yes name=tipo_trabajo dbname="tipo_trabajo" )
column=(type=datetime updatewhereclause=yes name=fechaatencion dbname="fechaatencion" )
column=(type=datetime updatewhereclause=yes name=fecinissrv dbname="fecinissrv" )
column=(type=char(8) updatewhereclause=yes name=codcli dbname="codcli" )
column=(type=char(200) updatewhereclause=yes name=nomcli dbname="nomcli" )
column=(type=char(15) updatewhereclause=yes name=cod_material_sga dbname="cod_material_sga" )
column=(type=char(18) updatewhereclause=yes name=cod_material_sap dbname="cod_material_sap" )
column=(type=char(150) updatewhereclause=yes name=descripcion_material dbname="descripcion_material" )
column=(type=decimal(2) updatewhereclause=yes name=cantidad dbname="cantidad" )
column=(type=char(2000) updatewhereclause=yes name=serial_number dbname="serial_number" )
column=(type=decimal(0) updatewhereclause=yes name=flg_retiro dbname="flg_retiro" )
column=(type=number updatewhereclause=yes name=idagenda dbname="idagenda" )
column=(type=datetime updatewhereclause=yes name=fecha_instalacion dbname="fecha_instalacion" )
column=(type=datetime updatewhereclause=yes name=fecha_atendido dbname="fecha_atendido" )
column=(type=char(100) updatewhereclause=yes name=contrata dbname="contrata" )
column=(type=char(10) updatewhereclause=yes name=plano dbname="plano" )
column=(type=char(10) updatewhereclause=yes name=plano_1 dbname="plano" )
column=(type=char(200) updatewhereclause=yes name=descripcion dbname="descripcion" )
column=(type=char(40) updatewhereclause=yes name=customer_id dbname="customer_id" )
column=(type=char(4000) updatewhereclause=yes name=actividades dbname="actividades" )
 retrieve="SELECT S.CODSOLOT, '''' pepequ,
vtatabdst.nomdst,
vtatabdst.nomprov,
vtatabdst.nomdepa,
E.DESCRIPCION ESTADO_SOT,
T.DESCRIPCION TIPO_TRABAJO,
SG.FECHA fechaatencion,
(SELECT MAX(I.FECINI) FROM SOLOTPTO SP, INSSRV I, VTASUCCLI VS WHERE S.CODSOLOT=SP.CODSOLOT AND I.CODINSSRV=SP.CODINSSRV AND VS.CODSUC=I.CODSUC)FECINISSRV,
S.CODCLI,
V.NOMCLI,
(SELECT TT.CODTIPEQU FROM TIPEQU TT WHERE TT.TIPEQU=SQ.TIPEQU)COD_MATERIAL_SGA,
(SELECT I.COD_SAP FROM TIPEQU TT, ALMTABMAT I WHERE TT.TIPEQU=SQ.TIPEQU AND I.CODMAT=TT.CODTIPEQU) COD_MATERIAL_SAP,       
(SELECT I.DESMAT FROM TIPEQU TT, ALMTABMAT I WHERE TT.TIPEQU=SQ.TIPEQU AND I.CODMAT=TT.CODTIPEQU) DESCRIPCION_MATERIAL,
SQ.CANTIDAD,
SQ.NUMSERIE SERIAL_NUMBER, SQ.Enacta Flg_retiro,
DECODE(SQ.IDAGENDA,NULL,(SELECT MAX(A.IDAGENDA) FROM AGENDAMIENTO A WHERE A.CODSOLOT=S.CODSOLOT),SQ.IDAGENDA)IDAGENDA,
(SELECT AA.fecha_instalacion FROM AGENDAMIENTO AA WHERE AA.IDAGENDA=DECODE(SQ.IDAGENDA,NULL,(SELECT MAX(A.IDAGENDA) 
FROM AGENDAMIENTO A WHERE A.CODSOLOT=S.CODSOLOT),SQ.IDAGENDA) 
AND ROWNUM=1)fecha_instalacion ,
(select min(fecha) from solotchgest a1 where estado=29 and a1.codsolot=s.codsolot) fecha_atendido,
DECODE((SELECT C.NOMBRE FROM AGENDAMIENTO A, CONTRATA C WHERE A.IDAGENDA=SQ.IDAGENDA AND C.CODCON=A.CODCON),NULL,
(SELECT MAX(C.NOMBRE) FROM AGENDAMIENTO A, CONTRATA C WHERE A.CODSOLOT=S.CODSOLOT AND C.CODCON=A.CODCON),
(SELECT C.NOMBRE FROM AGENDAMIENTO A, CONTRATA C WHERE A.IDAGENDA=SQ.IDAGENDA AND C.CODCON=A.CODCON))CONTRATA,
(SELECT MAX(VS.IDPLANO) FROM SOLOTPTO SP, INSSRV I, VTASUCCLI VS WHERE S.CODSOLOT=SP.CODSOLOT AND I.CODINSSRV=SP.CODINSSRV AND VS.CODSUC=I.CODSUC)PLANO,
(SELECT A.IDPLANO FROM AGENDAMIENTO A, CONTRATA C WHERE A.IDAGENDA=SQ.IDAGENDA AND C.CODCON=A.CODCON)PLANO,
mot.descripcion,
decode(s.customer_id,null,S.CODCLI,s.customer_id) customer_id ,
      (SELECT  substr(to_char(substr(wm_concat(A.DESCRIPCION||''~~''),1,4000)),1,4000)                      
FROM SOLOTPTOETA  ST,
     SOLOTPTOETAACT AC,
     ACTIVIDAD A
WHERE ST.CODSOLOT=S.CODSOLOT
      AND ST.CODSOLOT=AC.CODSOLOT
      AND ST.PUNTO=AC.PUNTO AND ST.ORDEN=AC.ORDEN 
      AND A.CODACT=AC.CODACT) ACTIVIDADES
 
FROM   SOLOT S,
SOLOTCHGEST SG,
ESTSOL E,
TIPTRABAJO T,
VTATABCLI V,
SOLOTPTOEQU SQ,agendamiento age, operacion.Mot_Solucion mot ,vtatabdst
WHERE  
S.CODSOLOT=SG.CODSOLOT and s.codsolot=age.codsolot and age.motsol_cab=mot.codmot_solucion(+) and
age.codubi=vtatabdst.codubi
AND E.ESTSOL=SG.ESTADO
AND SG.ESTADO IN (29)
AND E.ESTSOL IN (29,12)
AND T.TIPTRA=S.TIPTRA
AND S.CODCLI=V.CODCLI 
AND SQ.CODSOLOT(+)=S.CODSOLOT
and (SG.FECHA) between to_date(''01/01/2015'',''dd/mm/yyyy'') and to_date(''31/12/2015'' || '' 23:59:59'',''dd/mm/yyyy hh24:mi:ss'')
and s.tiptra in (724,620,626,494,606,770,672,430,413,613,427,780,611,
630,414,409,442,627,431,787,671,720,670,730,610,
417,691,496,719,439,669,629,679,676,763,6,725,407,410,674,452,
722,716)  
and age.codcon=131 "
)
text(name=codsolot_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="9" y="8" height="52" width="274" text="Codsolot")
text(name=pepequ_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="293" y="8" height="52" width="169" text="Pepequ")
text(name=nomdst_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="471" y="8" height="52" width="937" text="Nomdst")
text(name=nomprov_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="1417" y="8" height="52" width="2309" text="Nomprov")
text(name=nomdepa_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="3735" y="8" height="52" width="2309" text="Nomdepa")
text(name=estado_sot_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="6053" y="8" height="52" width="2309" text="Estado Sot")
text(name=tipo_trabajo_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="8370" y="8" height="52" width="4594" text="Tipo Trabajo")
text(name=fechaatencion_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="12974" y="8" height="52" width="503" text="Fechaatencion")
text(name=fecinissrv_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="13486" y="8" height="52" width="503" text="Fecinissrv")
text(name=codcli_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="13998" y="8" height="52" width="206" text="Codcli")
text(name=nomcli_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="14213" y="8" height="52" width="4594" text="Nomcli")
text(name=cod_material_sga_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="18816" y="8" height="52" width="370" text="Cod Material Sga")
text(name=cod_material_sap_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="19195" y="8" height="52" width="434" text="Cod Material Sap")
text(name=descripcion_material_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="19639" y="8" height="52" width="3451" text="Descripcion Material")
text(name=cantidad_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="23099" y="8" height="52" width="274" text="Cantidad")
text(name=serial_number_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="23383" y="8" height="52" width="4681" text="Serial Number")
text(name=flg_retiro_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="28073" y="8" height="52" width="274" text="Flg Retiro")
text(name=idagenda_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="28357" y="8" height="52" width="274" text="Idagenda")
text(name=fecha_instalacion_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="28640" y="8" height="52" width="503" text="Fecha Instalacion")
text(name=fecha_atendido_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="29152" y="8" height="52" width="503" text="Fecha Atendido")
text(name=contrata_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="29664" y="8" height="52" width="2309" text="Contrata")
text(name=plano_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="31982" y="8" height="52" width="251" text="Plano")
text(name=plano_t_1_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="1" background.color="0" color="0" alignment="2" border="0" x="32242" y="8" height="52" width="251" text="Plano")
text(name=descripcion_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="32503" y="8" height="52" width="4594" text="Descripcion")
text(name=customer_id_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="37106" y="8" height="52" width="937" text="Customer Id")
text(name=actividades_t band=header font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" background.mode="2" background.color="134217750" color="0" alignment="2" border="6" x="38053" y="8" height="52" width="4681" text="Actividades")
column(name=codsolot band=detail id=1 x="9" y="8" height="64" width="274" color="0" border="0" alignment="1" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=10)
column(name=pepequ band=detail id=2 x="293" y="8" height="64" width="169" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=20)
column(name=nomdst band=detail id=3 x="471" y="8" height="64" width="937" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=40 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=30)
column(name=nomprov band=detail id=4 x="1417" y="8" height="64" width="2309" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=100 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=40)
column(name=nomdepa band=detail id=5 x="3735" y="8" height="64" width="2309" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=100 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=50)
column(name=estado_sot band=detail id=6 x="6053" y="8" height="64" width="2309" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=100 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=60)
column(name=tipo_trabajo band=detail id=7 x="8370" y="8" height="64" width="4594" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=200 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=70)
column(name=fechaatencion band=detail id=8 x="12974" y="8" height="64" width="503" color="0" border="0" alignment="0" format="[shortdate] [time]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=80)
column(name=fecinissrv band=detail id=9 x="13486" y="8" height="64" width="503" color="0" border="0" alignment="0" format="[shortdate] [time]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=90)
column(name=codcli band=detail id=10 x="13998" y="8" height="64" width="206" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=8 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=100)
column(name=nomcli band=detail id=11 x="14213" y="8" height="64" width="4594" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=200 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=110)
column(name=cod_material_sga band=detail id=12 x="18816" y="8" height="64" width="370" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=15 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=120)
column(name=cod_material_sap band=detail id=13 x="19195" y="8" height="64" width="434" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=18 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=130)
column(name=descripcion_material band=detail id=14 x="19639" y="8" height="64" width="3451" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=150 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=140)
column(name=cantidad band=detail id=15 x="23099" y="8" height="64" width="274" color="0" border="0" alignment="1" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=150)
column(name=serial_number band=detail id=16 x="23383" y="8" height="64" width="4683" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=2000 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=160)
column(name=flg_retiro band=detail id=17 x="28073" y="8" height="64" width="274" color="0" border="0" alignment="1" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=170)
column(name=idagenda band=detail id=18 x="28357" y="8" height="64" width="274" color="0" border="0" alignment="1" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=180)
column(name=fecha_instalacion band=detail id=19 x="28640" y="8" height="64" width="503" color="0" border="0" alignment="0" format="[shortdate] [time]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=190)
column(name=fecha_atendido band=detail id=20 x="29152" y="8" height="64" width="503" color="0" border="0" alignment="0" format="[shortdate] [time]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=200)
column(name=contrata band=detail id=21 x="29664" y="8" height="64" width="2309" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=100 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=210)
column(name=plano band=detail id=22 x="31982" y="8" height="64" width="251" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=10 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=220)
column(name=plano_1 band=detail id=23 x="32242" y="8" height="64" width="251" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=10 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=230)
column(name=descripcion band=detail id=24 x="32503" y="8" height="64" width="4594" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=200 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=240)
column(name=customer_id band=detail id=25 x="37106" y="8" height="64" width="937" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=40 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=250)
column(name=actividades band=detail id=26 x="38053" y="8" height="64" width="4683" color="0" border="0" alignment="0" format="[general]" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=yes edit.hscrollbar=no edit.imemode=0 edit.limit=4000 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="0" font.charset="0" font.face="MS Sans Serif" font.family="2" font.height="-8" font.italic="0" font.pitch="2" font.strikethrough="0" font.weight="400" font.underline="0" tabsequence=260)
htmltable(border="0" cellPadding="1" cellSpacing="1" generateCSS="no" noWrap="no")
htmlgen()';

UPDATE operacion.cfg_env_correo_contrata T SET T.SYNTAXDW = STR WHERE T.IDCFG = 1;
END;
/

COMMIT;
