CREATE OR REPLACE TRIGGER OPERACION.T_OT_BI
BEFORE INSERT
ON OPERACION.OT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
tmpVar NUMBER;
l_origen char(1);
l_derivado number;
BEGIN
   select count(*) into tmpvar from ot where codsolot = :new.codsolot and
           tiptra = :new.tiptra and coddpt = :new.coddpt and estot <> 5;
   if tmpvar > 0 then
       RAISE_APPLICATION_ERROR (-20500, 'No se puede derivar la misma OT a la misma area 2 veces.');
   end if;

   -- se revisa el origen de la OT
   if :new.origen is null then
      select origen into l_origen from solot where codsolot = :new.codsolot;
      if l_origen = 'R' then
        :new.origen := 'R';
      elsif l_origen = 'A' then
         :new.origen := 'A';
      elsif l_origen = 'P' or l_origen is null then
         :new.origen := 'D';
      end if;
   end if;

   -- Marca la Ot como derivada

   select derivado into l_derivado from solot where codsolot = :new.codsolot;

   if l_derivado = 0 then
      update solot set derivado = '1',
          origen = decode(origen, null, decode(l_origen, null, 'P', 'D', 'P', 'R', 'R', 'A', 'A', 'P' ) ,
            origen ),
          estsolope = 2 -- solot como en ejecucion
         where solot.codsolot = :new.codsolot;
   end if;
   -- Se obtiene el numero de la llave
   if :new.CODOT is null then
      select F_GET_CLAVE_OT() into :new.codot from DUAL;
   end if;
   :new.fecultest := :new.fecusu;
   if :new.feccli is null then
      :new.feccli := :new.feccom;
   end if;

	-- se actualiza temporalmente el campo area para las OT
   if :new.area is null then
   	select area into :new.area from areaope where coddpt = :new.coddpt;
   end if;

   -- se actualiza temporalmente el campo coddpt para las OT
   if :new.coddpt is null then
      select coddpt into :new.coddpt from areaope where area = :new.area;
   end if;

   -- SE actualiza la informaciopn del presupuesto
   if :new.area >= 10 and :new.area <= 14 then
   	update presupuesto set feccom = :new.feccom, tiptra = :new.tiptra
      where codsolot = :new.codsolot;
   end if;

   -- Se crea la OT como un Documento
   begin
     tmpVar := 0;
     Select DOCID.NextVal into tmpVar from dual;
     insert into DOC (docid,doctipid) values (tmpVar,2);  -- inserta en la tabla documentos como tipo solicitud de OT
     :NEW.docid := tmpVar;
     insert into DOCESTHIS (docid,docest,docestold,fecha) values (:NEW.docid,:NEW.ESTOT,null,:new.fecusu);
   EXCEPTION
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR (-20500, 'No se pudo insertar el correspondiente documento - '||sqlerrm);
   end;
END;
/



