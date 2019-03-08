//sudo -u postgres psql postgres


CREATE or REPLACE FUNCTION somefunc(int valor) RETURNS int AS $$
BEGIN
	valor = valor + 1;

END; $$
LANGUAGE plpgsql;


//select somefunc();




create table dados (name varchar(50), salary float, id int);
INSERT INTO dados values ('XXX', 100,1);

CREATE FUNCTION selecionar(p_itemno int)
RETURNS TABLE(name varchar(50), salary float) AS $$
begin
	RETURN QUERY SELECT s.name, s.salary from dados AS s
		WHERE s.id = p_itemno;
end;
$$ LANGUAGE plpgsql;




create table dado ( id int , name varchar(50), age int ,
address varchar(50), salary float );
insert into dado values (1,'paulo',32, 'são miguel', 2000);
insert into dado values (2,'joao',22, 'chapeco', 2300);
insert into dado values (3,'maria',62, 'chapeco', 5300);
insert into dado values (4,'pedro',42, 'chapeco', 1300);



//NUMERO1

create or replace function numero1()
returns boolean as $$
declare
	linha record;
begin
	for linha IN select dado.id from dado where dado.id >= 0 
	loop
		update dado set salary = salary * 1.1 where dado.id = linha.id;

	end loop;

	return FOUND;
end;
$$ language plpgsql;


//NUMERO2

create or replace function numero2(aumento float, usuario int)
returns boolean as $$

begin
		update dado set salary = salary * (1 + aumento/100) where usuario = id;

	return FOUND;
end;
$$ language plpgsql;


//NUMERO3

create or replace function numero3()
returns boolean as $$

declare
	linha record;
begin
	for linha IN select * from dado where dado.id >= 0 
	loop
		update dado set usuario = current_user where dado.id = linha.id;
		update dado set data = current_date where dado.id = linha.id;
	end loop;

return FOUND;
end;
$$ language plpgsql;





select * from dado;
