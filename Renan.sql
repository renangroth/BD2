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




CREATE TABLE emp (
 empname text,
 salary integer,
 last_date timestamp,
 last_user text
);


CREATE or REPLACE FUNCTION emp_time() RETURNS trigger AS $$
 BEGIN
 NEW.last_date := current_timestamp;
 NEW.last_user := current_user;
 NEW.salary := NEW.salary * 1.1;
 RETURN NEW;
 END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER emp_time BEFORE INSERT OR UPDATE ON emp
 FOR EACH ROW EXECUTE PROCEDURE emp_time();



CREATE TABLE emp (
 empname text,
 salary integer
);
CREATE TABLE emp_audit(
 operation varchar(1) ,
 stamp timestamp,
 username text ,
 empname text ,
 salary integer
);

insert into emp(empname, salary) values ('joao',1000);



*****ATIVIDADE 1******************************************************

CREATE TABLE EMPREGADO(
id integer primary key,
nome varchar(50), 
cpf varchar(15),
Num_Departamento integer, 
Salario DECIMAL(10,2 ), 
Supervisor varchar(50)
);

CREATE TABLE Auditoria(
empregado_ID int,
nome varchar(50), 
cpf CHAR(12), 
Num_Departamento integer,
Salario DECIMAL(10,2 ), 
Supervisor varchar(50) , 
evento int, 
usuario varchar,
date date);

CREATE or REPLACE FUNCTION Auditoria() RETURNS trigger AS $$
 BEGIN
 	IF (TG_OP = 'INSERT') THEN
 		INSERT INTO Auditoria values (NEW.*, 1, current_user, current_date);
 		RETURN NEW;
 	ELSEIF (TG_OP = 'UPDATE') THEN
 		INSERT INTO Auditoria values (NEW.*, 2, current_user, current_date);
 		RETURN NEW;
 	ELSEIF (TG_OP = 'DELETE') THEN
 		INSERT INTO Auditoria values (NEW.*, 3, current_user, current_date);
 		RETURN OLD;
 	END IF;
 	RETURN NULL;
 END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER Auditoria BEFORE INSERT OR DELETE OR UPDATE
 ON EMPREGADO FOR EACH ROW EXECUTE PROCEDURE Auditoria();



insert into EMPREGADO(id, nome, cpf, Num_Departamento, Salario, Supervisor)
 values (1, 'Joao', 0000000000, 10, 10000, 'Pedro');

select *from Auditoria;

**************************************************************************


