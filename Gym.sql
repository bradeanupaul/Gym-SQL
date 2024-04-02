use salaFitness

create table Proprietar
(
id_proprietar int primary key,
nume varchar(50),
varsta int
)

insert into Proprietar (id_proprietar, nume, varsta)
values (1, 'Paul', '20')

drop table Proprietar

create table SalaFitness
(
id_sala int primary key,
adresa_sala varchar(50),
program_sala varchar(50),
pret_abonament int,
id_p int foreign key references Proprietar(id_proprietar)
on delete cascade
on update cascade
)

insert into SalaFitness (id_sala, adresa_sala, program_sala, pret_abonament, id_p)
values ('100', 'Cojocnei 8', '8:00 - 20:00', 150, 1)
insert into SalaFitness (id_sala, adresa_sala, program_sala, pret_abonament, id_p)
values ('101', 'Mihai Viteazu 3', '8:00 - 16:00', 130, 1)
insert into SalaFitness (id_sala, adresa_sala, program_sala, pret_abonament, id_p)
values ('102', 'Bucuresti 12', '8:00 - 20:00', 150, 1)
insert into SalaFitness (id_sala, adresa_sala, program_sala, pret_abonament, id_p)
values ('103', 'Dambovitei 5', '8:00 - 16:00', 130, 1)
insert into SalaFitness (id_sala, adresa_sala, program_sala, pret_abonament, id_p)
values ('104', 'Prieteniei 3', '8:00 - 16:00', 130, 1)
insert into SalaFitness (id_sala, adresa_sala, program_sala, pret_abonament, id_p)
values ('105', 'Viteazului 7', '8:00 - 20:00', 150, 1)

drop table SalaFitness

create table Website
(
id_website int identity(1,1) primary key,
adresa varchar(50),
descriere varchar(50),
id_s int foreign key references SalaFitness(id_sala)
on delete cascade
on update cascade
)

drop table Website

insert into Website (adresa, descriere, id_s)
values ('www.sala.ro', 'Sport si Sanatate', 100)

delete from Website
where adresa = 'www.sala.ro' or descriere is null

drop table Website

create table Client
(
id_client int identity(1, 1) primary key,
nume_client varchar(50),
)

drop table Client

insert into Client (nume_client)
values ('Iulian')
insert into Client (nume_client)
values ('Andrei')
insert into Client (nume_client)
values ('Tudor')
insert into Client (nume_client)
values ('Paul')
insert into Client (nume_client)
values ('George')
insert into Client (nume_client)
values ('Tudor')
insert into Client (nume_client)
values ('Andrei')

create table Abonament
(
nume_client varchar(50),
adresa_sala varchar(50),
pret int,
id_c int foreign key references Client(id_client)
on delete cascade
on update cascade,
id_s int foreign key references SalaFitness(id_sala)
on delete cascade
on update cascade,
constraint id_abonament primary key (id_c, id_s)
)

insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('Mihai', 'Croitorului 8', '130', 1, 101)
insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('Andrei', 'Croitorului 8', '130', 2, 103)
insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('Tudor', 'Croitorului 8', '150', 3, 100)
insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('Paul', 'Croitorului 8', '150', 4, 102)
insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('George', 'Croitorului 8', '150', 5, 100)
insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('Tudor', 'Croitorului 8', '90', 6, 102)
insert into Abonament (nume_client, adresa_sala, pret, id_c, id_s)
values ('Andrei', 'Croitorului 8', '110', 7, 103)

update Abonament
set adresa_sala = 'Zorilor 3'
where pret > 120 and nume_client is not null

update Abonament
set adresa_sala = 'Dambovitei 4'
where pret = 150 and nume_client is not null

update Abonament
set pret = 90
where id_c = 6 and id_s = 102

update Abonament
set pret = 110
where id_c = 7 and id_s = 103

delete from Abonament
where nume_client = 'Mihai'

drop table Abonament

select * from Proprietar
select * from SalaFitness
select * from Website
select * from Client
select * from Abonament

---union

select nume_client from Client
union
select adresa_sala from SalaFitness

---clientii si salile la care au abonament

select c.id_client, c.nume_client,s.adresa_sala from Client c
inner join Abonament a on a.id_c = c.id_client
inner join SalaFitness s on s.id_sala  = a.id_s

---clientii care au abonament care costa 150 ron si sunt pe strada dambovitei

select c.nume_client, a.pret, a.adresa_sala from Client c
inner join Abonament a on  c.id_client = a.id_c
inner join SalaFitness s on a.id_s = s.id_sala
where a.pret = 150 and a.adresa_sala = 'Dambovitei 4'

---adresa salilor la care merg clientii, fara a se repeta

select distinct s.adresa_sala from SalaFitness s
left outer join Abonament a on s.id_sala = a.id_s
left outer join Client c on a.id_c = c.id_client

---cel mai mic pret de abonament pentru fiecare nume intalnit

select nume_client, 
min(pret) as PretMinim
from Abonament
group by nume_client

---media preturilor de abonament pentru fiecare nume intalnit, mai mica decat 130

select nume_client,
avg(pret) as MediaPretului
from Abonament
group by nume_client
having avg(pret) < 130

---numarul de abonamente pentru fiecare sala

select id_s,
(select adresa_sala from SalaFitness
where id_sala = id_s) as AdresaSala,
count(id_c) as NumarClienti
from Abonament
group by id_s

---adauga un nou website

exec InsertWebsite @adresa = 'shop.fitness.com', @descriere = 'cele mai mici preturi', @id_s = 1000
exec InsertWebsite @adresa = 'shop.fitness.com', @descriere = 'cele mai mici preturi', @id_s = 103
exec InsertWebsite @adresa = 'sh', @descriere = 'cele mai mici preturi', @id_s = 103

create procedure InsertWebsite @adresa varchar(50), @descriere varchar(50), @id_s int
as 
if exists (select * from salaFitness where @id_s = id_sala) and dbo.ValidareAdresaWebsite(@adresa) = 1
begin
insert into Website values (@adresa, @descriere, @id_s)
end
else
begin
raiserror('Nu exista o salaFitness cu acest id sau adresa e prea scurta', 1, 1)
end
go

create function ValidareAdresaWebsite(@adresa varchar(50))
	returns bit
as
begin
	return case when len(@adresa)>3 then 1 else 0 end
end

select * from Website

exec InsertAbonament @nume_client = 'Iulian', @adresa_Sala = 'Cojocnei 8', @pret = 170, @id_c = 1, @id_s = 10 
exec InsertAbonament @nume_client = 'Iulian', @adresa_Sala = 'Cojocnei 8', @pret = 1, @id_c = 1, @id_s = 103

create procedure InsertAbonament @nume_client varchar(50), @adresa_sala varchar(50), @pret int, @id_c int, @id_s int
as
if exists (select * from Client where @id_c = id_client)
begin
if exists (select * from SalaFitness where @id_s = id_sala) and dbo.ValidarePretAbonament(@pret) = 1
begin
insert into Abonament values (@nume_client, @adresa_sala, @pret, @id_c, @id_s)
end
else
raiserror('Nu exista o sala cu acest id sau pretul este prea mic', 1, 1)
end
else
begin
raiserror('Nu exista un client cu acest id', 1, 1)
end
go

create function ValidarePretAbonament(@pret int)
	returns bit
as
begin
	return case when @pret > 10 then 1 else 0 end
end

select * from Abonament

exec InsertClient @nume_client = 'Raul'
exec InsertClient @nume_client = 'Ra'
exec InsertClient @nume_client = 'interzis'

create procedure InsertClient @nume_client varchar(50)
as
if (@nume_client != 'interzis') and dbo.ValidareNumeClient(@nume_client) = 1
begin
insert into Client values (@nume_client)
end
else
begin
raiserror('Numele nu este acceptat', 1, 1)
end
go

create function ValidareNumeClient(@nume_client varchar(50))
	returns bit
as
begin
	return case when len(@nume_client) > 2 then 1 else 0 end
end

select * from Client

---creare view

create view ProgramAbonament as
select c.nume_client as NumeClient, a.pret as PretAbonament, s.program_sala as ProgramSala
from Client as c
inner join Abonament as a on a.id_c = c.id_client
inner join SalaFitness as s on s.id_sala = a.id_s

select * from ProgramAbonament

--- trigger pentru clienti

create trigger addClient
on Client
for insert
as
begin
print 'Client'
print 'Insert'
print getdate()
end

create trigger delClient
on Client
for delete
as
begin
print 'Client'
print 'Delete'
print getdate()
end


insert into Client (nume_client)
values ('Mihnea')

delete from Client where nume_client = 'Mihnea'