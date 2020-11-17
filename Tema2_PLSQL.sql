set serverouput on
set verify off

--2
create or replace type tip_orase_sch is table of varchar2(100);
/

create table excursie_sch(
cod_excursie number(4),
denumire varchar2(20),
status varchar2(20));


alter table excursie_sch
add (orase tip_orase_sch)
nested table  orase store as table_orase_sch;


insert into excursie_sch
values (0, 'Ex_0', 'disponibila', tip_orase_sch('oras1', 'oras2') );
select * from excursie_sch;


declare
 v_orase tip_orase_sch := tip_orase_sch('oras1', 'oras2' , 'oras3');
begin 
    for i in 1..5 loop
      insert into excursie_sch
      values (i, 'Excursie_' || i, 'disponibila', v_orase);
    end loop;
    end;
    /
    
    rollback;
--0	Ex_0	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2')
--1	Excursie_1	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--2	Excursie_2	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--3	Excursie_3	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--4	Excursie_4	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
    
      
      
      
 --Actualiza?i coloana orase pentru o excursie specificat?:
 --ad?uga?i un ora? nou în list?, ce va fi ultimul vizitat în excursia respectiv?;
declare
  cod_exc excursie_sch.cod_excursie%type := &c_ex;
  v_orase tip_orase_sch;
  oras_t varchar2(20) :='oras_nou';
begin
    select orase
    into v_orase
    from excursie_sch
    where cod_excursie= cod_exc;
    
    dbms_output.put_line(v_orase.last);
    v_orase.extend;
    dbms_output.put_line(v_orase.last);
    v_orase(v_orase.last) :=oras_t;
    update excursie_sch
    set orase = v_orase
    where cod_excursie= cod_exc;
     for i in v_orase.first..v_orase.last loop
        dbms_output.put_line( v_orase(i));
    end loop;
    
end;

/
select * from excursie_sch;
-- Am facut modificarile la Excursie_2:

--0	Ex_0	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2')
--1	Excursie_1	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--2	Excursie_2	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3','oras_nou')
--3	Excursie_3	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--4	Excursie_4	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')



--- ad?uga?i un ora? nou în list?, ce va fi al doilea ora? vizitat în excursia respectiv?;
declare
  cod_exc excursie_sch.cod_excursie%type := &c_ex;
  v_orase tip_orase_sch;
  oras_t varchar2(20) :='oras_nou2';
  i integer;
begin
    select orase
    into v_orase
    from excursie_sch
    where cod_excursie= cod_exc;
    
    dbms_output.put_line(v_orase.last);
    
    
    v_orase.extend;
    i := v_orase.last;
    while i > 2 loop
      dbms_output.put_line(i);
      v_orase(i) := v_orase(i-1);
      i := v_orase.prior(i);
    end loop;
    v_orase(2) := oras_t;
    update excursie_sch
    set orase = v_orase
    where cod_excursie= cod_exc;
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line( v_orase(i));
    end loop;
    
end;
/
-- Am facut modificarile la Excursie_2
--0	Ex_0	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2')
--1	Excursie_1	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--2	Excursie_2	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras_nou2','oras2','oras3','oras_nou')
--3	Excursie_3	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--4	Excursie_4	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--5	Excursie_5	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')


--- inversa?i ordinea de vizitare a dou? dintre ora?e al c?ror nume este specificat;
declare
  cod_exc excursie_sch.cod_excursie%type := &c_ex;
  v_orase tip_orase_sch;
  oras1 varchar(20) := 'oras1';
  oras2 varchar2(20) := 'oras3';
  oras3 varchar2(20);
  i integer;
  j integer;
begin
    select orase
    into v_orase
    from excursie_sch
    where cod_excursie= cod_exc;
    for k in v_orase.first..v_orase.last loop
      if v_orase(k) = oras1
      then i := k;
      elsif v_orase(k) = oras2
      then j := k;
      end if;
    end loop;
    oras3 := v_orase(j);
    v_orase(j) := v_orase(i);
    v_orase(i) := oras3;
  
    update excursie_sch
    set orase = v_orase
    where cod_excursie= cod_exc;
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line( v_orase(i));
    end loop;
    
end;
/
-- Am facut modificarile la Excursie_3. Am interschimbat orasele date direct in program pentru ca nu mi-a functionat citirea de la tastatura
--0	Ex_0	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2')
--1	Excursie_1	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--2	Excursie_2	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras_nou2','oras2','oras3','oras_nou')
--3	Excursie_3	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras3','oras2','oras1')
--4	Excursie_4	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')
--5	Excursie_5	disponibila	IOANASCHIPOR.TIP_ORASE_SCH('oras1','oras2','oras3')



--- elimina?i din list? un ora? al c?rui nume este specificat.

--???Nu a functionat :(
declare
  cod_exc excursie_sch.cod_excursie%type := &c_ex;
  v_orase tip_orase_sch;
  oras varchar(20);
  j integer;
begin
    select orase
    into v_orase
    from excursie_sch
    where cod_excursie= cod_exc;
    for i in v_orase.first..v_orase.last loop
    --retin indexul orasului 
      if v_orase(i) = &oras
      then j := i;
      end if;
    end loop;
    --stergere oras din lista:
    for i in (j+1)..v_orase.count loop
      v_orase(i-1) := v_orase(i);
    end loop;
    --micsoram lungimea vectorului deoarece am sters un element
    v_orase.trim;
  
    update excursie_sch
    set orase = v_orase
    where cod_excursie= cod_exc;
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line( v_orase(i));
    end loop;
    
end;
/

--c. Pentru o excursie al c?rui cod este dat, afi?a?i num?rul de ora?e vizitate, respectiv numele ora?elor.
declare
  cod_exc excursie_sch.cod_excursie%type := &c_ex;
  v_orase tip_orase_sch;
begin
    select orase
    into v_orase
    from excursie_sch
    where cod_excursie= cod_exc;
    dbms_output.put_line(v_orase.count);
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line( v_orase(i));
    end loop;
    
end;
/
-- 3
-- oras1
-- oras2
-- oras3


-- d. Pentru fiecare excursie afi?a?i lista ora?elor vizitate.
declare
  v_orase tip_orase_sch;
  --vector in care retin codurile excursiilor:
  type tip_coduri_excursii is table of excursie_sch.cod_excursie%type; 
  v_coduri_excursii tip_coduri_excursii;

begin
    for exc in (select cod_excursie, orase from excursie_sch) loop -- select-ul returneaza codurile excursiilor SI listele oraselor
    dbms_output.put_line('Ex ' || exc.cod_excursie);
        --pentru fiecare excursie ii afisez si orasele:
       for ors in 1..exc.orase.count loop
       dbms_output.put_line( ors || ': ' || exc.orase(j));
        end loop;
    end loop;
end;
/
--Excursia 0
--1: oras1
--2: oras2
-- ... etc.

