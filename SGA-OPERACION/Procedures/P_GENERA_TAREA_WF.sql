CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_TAREA_WF(l_tareadef    tareawfcpy.tareadef%type,
                                              l_idwf        tareawfcpy.idwf%type,
                                              l_wfdef       tareawfcpy.wfdef%type,
                                              l_tipo        tareawfcpy.tipo%type,
                                              l_plazo       tareawfcpy.plazo%type,
                                              l_area        tareawfcpy.area%type,
                                              l_responsable tareawfcpy.responsable%type,
                                              l_pre_tareas  tareawfcpy.pre_tareas%type,
                                              l_pos_tareas  tareawfcpy.pos_tareas%type,
                                              a_tarea in number default null) IS

 /******************************************************************************
   Ver        Date        Author           Description
   --------- ----------  ---------------  ------------------------------------
   1.0       25/11/2007  Hector Huaman   Agrega una Tarea adicional a un Worflow.
   2.0       25/05/2013  Edilberto Astulle      PROY-8520 Proyectos Internos de RED en SGA
   3.0       15/07/2013  Edilberto Astulle      
******************************************************************************/

  l_idtareawf   tareawfcpy.idtareawf%type;
  ls_pos_tareas varchar2(200);
  lr_tareadef   tareadef%rowtype;
  v_pre_tareas  varchar2(200);
  d_feccom      date;
  v_tarea       varchar2(20);
  n_esttarea    number(4);
  n_tipesttar   number(2);
  error         boolean;
  uname         varchar2(30);
  t_tareawfcpy  tareawfcpy%rowtype;
  l_cont        number;
  l_feccom      tareawf.feccom%type;
  l_tarea       tareawfcpy.tarea%type;
BEGIN

 SELECT legal.f_add_dias_utiles_contract(sysdate,l_plazo) INTO l_feccom FROM DUAL;

  l_tarea:=l_tareadef;
  select * into lr_tareadef from tareadef where tareadef = l_tareadef;

  BEGIN
  select tarea into  l_tarea from tareawfdef 
  where tareadef=l_tareadef and wfdef=l_wfdef and rownum=1;--2.0
  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_tarea := 73;
    END;
  error := false;
  select OPEWF.SQ_ID_TAREAWFCPY.nextval into l_idtareawf from dual;--2.0
  insert into tareawfcpy
    (IDTAREAWF,TAREA,--2.0
     IDWF,
     DESCRIPCION,
     TIPO,
     AREA,
     WFDEF,
     TAREADEF,
     RESPONSABLE,
     PRE_MAIL,
     POS_MAIL,
     PLAZO,
     PRE_PROC,
     CUR_PROC,
     CHG_PROC,
     POS_PROC,
     PRE_TAREAS,
     POS_TAREAS)
  values
    (l_idtareawf,nvl(a_tarea,l_tarea),--3.0
     l_idwf,
     lr_tareadef.descripcion,
     l_tipo,
     l_area,
     l_wfdef,
     l_tareadef,
     l_responsable,
     lr_tareadef.pre_mail,
     lr_tareadef.pos_mail,
     l_plazo,
     lr_tareadef.pre_proc,
     lr_tareadef.cur_proc,
     lr_tareadef.chg_proc,
     lr_tareadef.pos_proc,
     l_pos_tareas,
     l_pre_tareas);

/*  select idtareawf
    into l_idtareawf
    from tareawfcpy
   where idwf = l_idwf
     and tareadef = l_tareadef
     and tarea =l_tarea
     and area =l_area ;*/ --2.0

  ls_pos_tareas := l_pos_tareas;


  if ls_pos_tareas is not null then
    select count(*)
      into l_cont
      from tareawfcpy
     where idwf = l_idwf
       and tarea = ls_pos_tareas
       and pos_tareas is not null;

      if l_cont > 0 then
        update tareawfcpy
           set pos_tareas = pos_tareas || ';' ||to_char(l_tarea)
         where idwf = l_idwf
           and tarea = ls_pos_tareas;
      else
        update tareawfcpy
           set pos_tareas =to_char(l_tarea)
         where idwf = l_idwf
           and tarea = ls_pos_tareas;
      end if;
  end if;
  uname := user;

  select count(*)
    into l_cont
    from tareawf
   where idwf = l_idwf
     and idtareawf = l_idtareawf;
  if l_cont > 0 then
    return;
  end if;
  select *
    into t_tareawfcpy
    from tareawfcpy
   where idwf = l_idwf
     and idtareawf = l_idtareawf;
  v_pre_tareas := t_tareawfcpy.pre_tareas;
  if v_pre_tareas is not null then
    while INSTR(v_pre_tareas, ';') <> 0 loop
      v_tarea      := SUBSTR(v_pre_tareas, 1, INSTR(v_pre_tareas, ';') - 1);
      v_pre_tareas := SUBSTR(v_pre_tareas,
                             INSTR(v_pre_tareas, ';') + 1,
                             LENGTH(v_pre_tareas));
      begin
        select esttarea, tipesttar
          into n_esttarea, n_tipesttar
          from tareawf
         where idwf = l_idwf
           and tarea = to_number(v_tarea);
      exception
        when no_data_found then
          error := True;
      end;

      if n_tipesttar not in (4, 5) then
        error := True;
      end if;
    end loop;
    begin
      select esttarea, tipesttar
        into n_esttarea, n_tipesttar
        from tareawf
       where idwf = l_idwf
         and tarea = to_number(v_pre_tareas);
    exception
      when no_data_found then
        error := True;
    end;
    if n_tipesttar not in (4, 5) then
      error := True;
    end if;
  end if;
  if not error then
    select PQ_WF.F_GET_FECCOM_TAREAWF(t_tareawfcpy.idtareawf,
                                      t_tareawfcpy.idwf,
                                      t_tareawfcpy.tarea,
                                      t_tareawfcpy.tareadef,
                                      t_tareawfcpy.plazo)
      into d_feccom
      from dual;

    --Insercion de regitro en "tareawf"
    insert into tareawf
      (idtareawf,
       tarea,
       idwf,
       tipesttar,
       esttarea,
       tareadef,
       area,
       responsable,
       tipo,
       feccom,
       fecini,
       fecinisys,
       fecusumod,
       codusumod,
       opcional)
    values
      (t_tareawfcpy.idtareawf,
       t_tareawfcpy.tarea,
       t_tareawfcpy.idwf,
       1,
       1,
       t_tareawfcpy.tareadef,
       t_tareawfcpy.area,
       t_tareawfcpy.responsable,
       t_tareawfcpy.tipo,
       d_feccom,
       sysdate,
       sysdate,
       sysdate,
       uname,
       t_tareawfcpy.opcional);

    --Ejecutar procedimiento Pre_proc
    if t_tareawfcpy.pre_proc is not null then
      PQ_WF.P_EJECUTA_PROC(t_tareawfcpy.pre_proc,
                           t_tareawfcpy.idtareawf,
                           t_tareawfcpy.idwf,
                           t_tareawfcpy.tarea,
                           t_tareawfcpy.tareadef);
    end if;
    --Ejecuta Send_mail
    PQ_WF.P_SEND_MAIL_TAREAWF(t_tareawfcpy, 1, 0);

    if (nvl(t_tareawfcpy.opcional, 0) = 1 and t_tareawfcpy.tipo = 1) or
       (t_tareawfcpy.tipo = 2) then
      --Ejecutar procedimiento Cur_proc
      if t_tareawfcpy.cur_proc is not null then
        PQ_WF.P_EJECUTA_PROC(t_tareawfcpy.cur_proc,
                             t_tareawfcpy.idtareawf,
                             t_tareawfcpy.idwf,
                             t_tareawfcpy.tarea,
                             t_tareawfcpy.tareadef);
      end if;
      --Ejecutar P_chg_status_tarea
      PQ_WF.P_CHG_STATUS_TAREAWF(l_idtareawf, 4, 4, null, sysdate, sysdate);
    end if;
  end if;

  update tareawf set feccom = l_feccom where idtareawf = l_idtareawf;

END;
/