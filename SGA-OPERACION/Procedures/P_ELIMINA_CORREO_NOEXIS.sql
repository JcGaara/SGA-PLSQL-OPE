CREATE OR REPLACE PROCEDURE OPERACION.p_Elimina_correo_noexis(p_pre_mail in varchar,p_pos_mail in varchar)is
vc_pemtotal  tareawfdef.pre_mail%type;
vc_postotal  tareawfdef.pos_mail%type;
vc_premail   tareawfdef.pre_mail%type;
vc_posmail   tareawfdef.pos_mail%type;
vn_cant number;
vn_cantpos number;
vc_pre varchar2(100);
vc_pro varchar2(100);
vc_pem varchar2(100);
vc_pos varchar2(100);
vc_char char(1);
vc_charpos char(1);
i number;
j number;
cursor c1 is
  select tarea,pre_mail,pos_mail from tareawfdef
  where upper(pre_mail) like upper(vc_pre)
     or upper(pos_mail) like upper(vc_pro);

begin
  vc_pre := '%' || p_pre_mail || '%';
  vc_pro := '%' || p_pos_mail || '%';
  vc_pem := '';
  vc_pos := '';

  for lc1 in c1 loop

     vc_premail := trim(lc1.pre_mail);
     if vc_premail is not null then
         select length(vc_premail) into vn_cant from dual;
         for i in 1..vn_cant loop
             select substr(vc_premail,i,1) into vc_char from dual;
             if vc_char <> ',' then
                vc_pem := vc_pem || vc_char;
                if (trim(vc_pem) = trim(p_pre_mail)) then
                   vc_pem:='';
                end if;
             else
                if (trim(vc_pem) <> trim(p_pre_mail)) then
                   if /*vc_char = ',' and */vc_pemtotal is null then
                       vc_pemtotal := vc_pem ;
                       vc_pem := '';
                   else
                       vc_pemtotal := vc_pemtotal || ',' || vc_pem ;
                       vc_pem := '';
                   end if;
                end if;
             end if;
             if i = vn_cant and (trim(vc_pem) <> trim(p_pre_mail)) then
                    vc_pemtotal :=  vc_pemtotal || ',' || vc_pem ;
                    vc_pem := '';
             end if;
         end loop;
         update tareawfdef set pre_mail = vc_pemtotal
         where  tarea = lc1.tarea;
         vc_pemtotal := '';
     end if;

     vc_posmail := trim(lc1.pos_mail);
     if vc_posmail is not null then
       select length(vc_posmail) into vn_cantpos from dual;
       for j in 1..vn_cantpos loop
           select substr(vc_posmail,j,1) into vc_charpos from dual;
           if vc_charpos <> ',' then
              vc_pos := vc_pos || vc_charpos;
              if (trim(vc_pos) = trim(p_pos_mail)) then
                   vc_pos:='';
              end if;
           else
              if (trim(vc_pos) <> trim(p_pos_mail)) then
                 if /*vc_char = ',' and */vc_postotal is null then
                       vc_postotal := vc_pos ;
                       vc_pos := '';
                   else
                       vc_postotal := vc_postotal || ',' || vc_pos ;
                       vc_pos := '';
                   end if;
              end if;
           end if;
           if j = vn_cantpos and (trim(vc_pos) <> trim(p_pos_mail)) then
                  vc_postotal :=  vc_postotal || ',' || vc_pos;
                  vc_pos := '';
           end if;
       end loop;
       update tareawfdef set pos_mail = vc_postotal
       where  tarea = lc1.tarea;
       vc_postotal := '';
     end if;

  end loop;

  commit;
end;
/


