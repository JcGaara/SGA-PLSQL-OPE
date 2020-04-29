CREATE OR REPLACE PROCEDURE OPERACION.P_AgregarNumtel is
   i                   number;
   id_num              number;

begin
   i:=64600000;
   WHILE i<=64629999
    LOOP
      Select TELEFONIA.SQ_ID_NUMTEL.nextval into id_num from dual;
      insert into telefonia.numtel
            (codnumtel, estnumtel, tipnumtel, numero, publicar)
      values
            (id_num, 1, 1, to_char(i), 0);
      commit;
      i:=i+1;
   end loop;
   update telefonia.numtel set tipnumtel=2
          where substr(numero,1,2)='60'
            and substr(numero,3,6) in (select substr(numero,3,6) from telefonia.numtel where substr(numero,1,2)='74' and tipnumtel=2);
   commit;
end P_AgregarNumtel;
/


