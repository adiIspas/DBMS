select * from user_constraints order by 4;

select category from title;

-- 4. C�te filme (titluri, respectiv copii) au fost �mprumutate din cea mai cerut� categorie?
select title, count(*)
from rental r join title_copy tc on(r.title_id = tc.title_id and r.copy_id = tc.copy_id)
              join title t on (tc.title_id = t.title_id)
group by title, category
having count(*) = (select max(count(*))
                  from rental r join title_copy tc on(r.title_id = tc.title_id and r.copy_id = tc.copy_id)
                                join title t on (tc.title_id = t.title_id)
                  group by title, category);
                  
                  
-- 5. C�te copii din fiecare film sunt disponibile �n prezent (considera?i c� statusul unei copii nu este setat, deci nu poate fi utilizat)?
select t.title, count(tc.copy_id)
from title t join title_copy tc on (t.title_id = tc.title_id)
join rental r on (tc.copy_id = r.copy_id and r.act_ret_date is not null)
group by t.title
order by 2;


-- 6. Afi?a?i urm�toarele informa?ii: titlul filmului, num�rul copiei, statusul setat ?i statusul corect.
select t.title, r.copy_id,
case
  when r.act_ret_date is not null and tc.status like 'AVAILABLE' then 'Available'
  else 'Unavailable'
end
from title t join title_copy tc on (t.title_id = tc.title_id)
join rental r on (tc.copy_id = r.copy_id);

select act_ret_date from rental;