--Registra tipo de trabajo
insert into operacion.tiptrabajo
  select (select max(a.tiptra) + 1 from operacion.tiptrabajo a),
         tiptrs,
         'HFC/SIAC - BAJA TOTAL POR CAMBIO DE PLAN',
         sysdate,
         user,
         cuenta,
         coddpt,
         flgcom,
         flgpryint,
         codmotinssrv,
         sotfacturable,
         bloqueo_desbloqueo,
         horas,
         agenda,
         hora_ini,
         hora_fin,
         agendable,
         num_reagenda,
         horas_antes,
         corporativo,
         selpuntossot,
         id_tipo_orden,
         id_tipo_orden_ce
    from operacion.tiptrabajo
   where tiptra = 423;


DECLARE

  N_WFDEF                    OPEWF.WFDEF.WFDEF%TYPE;
  N_TIPTRA                   OPERACION.TIPTRABAJO.TIPTRA%TYPE;

BEGIN


	INSERT INTO OPERACION.TIPTRABAJO
	  (TIPTRA,
	   TIPTRS,
	   DESCRIPCION,
	   FECUSU,
	   CODUSU,
	   CUENTA,
	   CODDPT,
	   FLGCOM,
	   FLGPRYINT,
	   CODMOTINSSRV,
	   SOTFACTURABLE,	
	   BLOQUEO_DESBLOQUEO,
	   HORAS,
	   AGENDA,
	   HORA_INI,
	   HORA_FIN,
	   AGENDABLE,
	   NUM_REAGENDA,
	   HORAS_ANTES,
	   CORPORATIVO,
	   SELPUNTOSSOT,
	   ID_TIPO_ORDEN,
	   ID_TIPO_ORDEN_CE)
	  select (SELECT MAX(T.TIPTRA) + 1 FROM OPERACION.TIPTRABAJO T),
			 tiptrs,
			 'HFC/SIAC DESACTIVACIÓN POR SUSTITUCIÓN',
			  sysdate,
			  substr(user,1, 30) ,
			 cuenta,
			 coddpt,
			 flgcom,
			 flgpryint,
			 codmotinssrv,
			 sotfacturable,
			 bloqueo_desbloqueo,
			 horas,
			 agenda,
			 hora_ini,
			 hora_fin,
			 agendable,
			 num_reagenda,
			 horas_antes,
			 corporativo,
			 selpuntossot,
			 id_tipo_orden,
			 id_tipo_orden_ce
		from operacion.tiptrabajo
	   where tiptra = 7;

insert into tipopedd
  (TIPOPEDD, DESCRIPCION, ABREV)
values
  ((select max(t.tipopedd) + 1 from tipopedd t),
   'Tiptrabajo Baja Sustitucion',
   'TIPTRA_BAJA_SUST');
   
insert into opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(o.IDOPEDD) + 1 from opedd o),
   null,
   7,
   null,
   'TIPTRA',
   (select tipopedd from tipopedd where abrev = 'TIPTRA_BAJA_SUST'),
   1);

INSERT INTO WFDEF
  (WFDEF,
   ESTADO,
   CLASEWF,
   DESCRIPCION,
   VERSION,
   TIPOPLAZO,
   FLAG_GRAFO)
VALUES
  ((SELECT MAX(T.WFDEF) + 1 FROM OPEWF.WFDEF T),
   1,
   0,
   'Desactivacion por Sustitucion - HFC/SIAC',
   1,
   0,
   0);
   
select W.WFDEF
    INTO N_WFDEF
    from OPEWF.WFDEF W
   where W.DESCRIPCION = 'Desactivacion por Sustitucion - HFC/SIAC';

  INSERT INTO OPEWF.TAREAWFDEF
    (TAREA,
     DESCRIPCION,
     ORDEN,
     TIPO,
     AREA,
     RESPONSABLE,
     WFDEF,
     TAREADEF,
     PRE_MAIL,
     POS_MAIL,
     PRE_TAREAS,
     POS_TAREAS,
     PLAZO,
     ESTADO,
     AREA_FACTIBILIDAD,
     AGRUPA,
     FRECUENCIA,
     FLGANULAR,
     FLGCONDICION,
     CONDICION,
     REGLA_ASIG_CONTRATA,
     REGLA_ASIG_FECPROG,
     AREA_DERIVA_CORREO,
     TIPO_AGENDA,
     FLG_ASIGNAAREA,
     F_ASIGNAAREA,
     FLG_OPC,
     SQL_CONDICION_TAREA)
  VALUES
    ((SELECT MAX(T.TAREA) + 1 FROM OPEWF.TAREAWFDEF T),
     'ACTIVACIÓN/DESACTIVACIÓN DE FACTURACIÓN - HFC/SIAC',
     0,
     2,
     200,
     null,
     N_WFDEF,
     833,
     null,
     null,
     null,
     null,
     1.00,
     1,
     null,
     null,
     null,
     0,
     0,
     null,
     null,
     null,
     null,
     null,
     0,
     null,
     0,
     null);

	 
insert into opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(o.IDOPEDD) + 1 from opedd o),
   null,
   N_WFDEF,
   'WF - Desactivación',
   null,
   260,
   null);	 

	 
  SELECT T.TIPTRA
    INTO N_TIPTRA
    FROM OPERACION.TIPTRABAJO T
   WHERE T.DESCRIPCION = 'HFC/SIAC DESACTIVACIÓN POR SUSTITUCIÓN';
   
 INSERT INTO CUSBRA.BR_SEL_WF
    (IDSEQ,
     IDPRODUCTO,
     TIPTRA,
     FLGMT,
     WFDEF,
     CODUSU,
     FECUSU,
     TIPSRV,
     PRE_PROC,
     VALOR,
     IDCAMPANHA,
     TIPMOTOT,
     FLG_SELECT)
  VALUES
    ((SELECT MAX(C.IDSEQ) + 1 FROM CUSBRA.BR_SEL_WF C),
     NULL,
     N_TIPTRA,
     NULL,
     N_WFDEF,
     SUBSTR(USER, 1, 30),
     SYSDATE,
     '0061',
     NULL,
     NULL,
     NULL,
     NULL,
     0);
	 
COMMIT;	 
END;
/
   