set serverouput on
set verify off
--2. Se d? urm?torul enun?: Pentru fiecare zi a lunii octombrie (se vor lua în considerare ?i zilele din
--lun? în care nu au fost realizate împrumuturi) ob?ine?i num?rul de împrumuturi efectuate.
--a. Încerca?i s? rezolva?i problema în SQL f?r? a folosi structuri ajut?toare.
--b. Defini?i tabelul octombrie_*** (id, data). Folosind PL/SQL popula?i cu date acest tabel.
--Rezolva?i în SQL problema dat?.

--a)
-- am facut fara zilele in care nu au fost realizate imprumuturi
select count(book_date), book_date
from rental
group by book_date

--b)
create table octombrie_cpy(id number, data date);
declare 
  v_data date;
  maxim number(2) := 31;

begin 
  for contor in 1..maxim loop
    v_data := (last_day(sysdate) - maxim) + contor;
    insert into octombrie_cpy values(contor, v_data);
  end loop;
end;
/

select * from octombrie_cpy
rollback;


--4. Modifica?i problema anterioar? astfel încât s? afi?a?i ?i urm?torul text:
-- - Categoria 1 (a împrumutat mai mult de 75% din titlurile existente)
-- - Categoria 2 (a împrumutat mai mult de 50% din titlurile existente)
-- - Categoria 3 (a împrumutat mai mult de 25% din titlurile existente)
-- - Categoria 4 (altfel)

declare 
  name varchar(20) := '&input';
  rental_count number(2) := 0;
  total_number_of_titles number(2);
  
begin
  --numarul total de titluri distincte:
  select count(distinct title_id)
  into total_number_of_titles
  from rental;
  --numarul de titluri distincte imprumutate de membrul introdus de la tastatura:
  select count(distinct title_id)
  into rental_count
  from rental r, member m
  where r.member_id = m.member_id
  and lower(m.last_name) = lower(name);
 
  
  if rental_count = 0 
  then dbms_output.put_line('Nu exista in baza de date/nu a facut imprumuturi');
  elsif rental_count >= 75/100*total_number_of_titles then
      dbms_output.put_line('Categoria 1');
  elsif rental_count >= 50/100*total_number_of_titles then
      dbms_output.put_line('Categoria 2');
  elsif rental_count >= 25/100*total_number_of_titles then
      dbms_output.put_line('Categoria 3');
  else 
      dbms_output.put_line('Categoria 4');
  end if;
  dbms_output.put_line(rental_count || ' filme imprumutate');

  exception
    when no_data_found then dbms_output.put_line('no data found');
    when too_many_rows then dbms_output.put_line('too many rows');
 
end;
/

--5. Crea?i tabelul member_*** (o copie a tabelului member). Ad?uga?i în acest tabel coloana
--discount, care va reprezenta procentul de reducere aplicat pentru membrii, în func?ie de categoria
--din care fac parte ace?tia:
-- - 10% pentru membrii din Categoria 1
-- - 5% pentru membrii din Categoria 2
-- - 3% pentru membrii din Categoria 3
-- - nimic
--Actualiza?i coloana discount pentru un membru al c?rui cod este dat de la tastatur?. Afi?a?i un
--mesaj din care s? reias? dac? actualizarea s-a produs sau nu.

create table member_cpy as select * from member;
select * from member_cpy
commit;

alter table member_cpy;
add discount number default null;--nu merge inserarea coloanei

--mai departe am presupus ca am inserat coloana cu valori nule
declare
  name varchar(2) := '&input';
  rental_count number(2) := 0;
  total_number_of_titles number(2);
  new_discount number(2);
  first_discount number(2);
  
begin
  --numarul total de titluri distincte
  select count(distinct title_id)
  into total_number_of_titles
  from rental;
  --numarul de titluri distincte imprumutate de membrul introdus de la tastatura
  select count(distinct title_id)
  into rental_count
  from rental r, member m
  where r.member_id = m.member_id
  and lower(m.last_name) = lower(name);
 
  --discount-ul de la inceput al membrului introdus de la tastatura
  select discount into first_discount
  from member_cpy
  where last_name = name;
    
  if rental_count >= 75/100*total_number_of_titles then
      discount_n := 1/10
  elsif rental_count >= 50/100*total_number_of_titles then
      discount_n := 1/20
  elsif rental_count >= 25/100*total_number_of_titles then
      discount_n := 3/100
  else 
      discount_n := 0
  end if;
  dbms_output.put_line(rental_count || ' filme imprumutate');
  
  --modific discount-ul doar daca e diferit fata de valoarea initiala + afisez
 if nvl(first_discount, 0) != nvl(new_discount, 0) then
        update member_cpy
        set discount = new_discount
        where last_name = name;

        dbms_output.putline('Updated discount to be ' || new_discount);
    else
        dbms_output.putline('Discount is unchanged');
    end if;

  exception
    when no_data_found then dbms_output.put_line('no data found');
    when too_many_rows then dbms_output.put_line('too many rows');
 
end;
/

rollback;