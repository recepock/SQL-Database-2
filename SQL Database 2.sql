--Tablo Oluşturma
CREATE TABLE StokTakibi
(
	StokTakibiID int identity(1,1) primary key,
	Türü int,
	StokUrunAdı varchar(50),
	StokUrunMiktar int,
	UrunKod int,
	UrunID int,
	KategoriID int
)
CREATE TABLE Ürünler
(
	UrunID int identity(1,1) primary key,
	UrunAdı varchar(50),
	UrunKodu int,
	UrunMiktarı int,
	UrunFiyatı int,
	KategoriID int,
	SiparişID int,
	StokTakibiID int
)

--Veri Ekleme
İnstert into StokTakibi values (‘1’,’İphone13’,5,102,1,1),
				(‘1’,’Kitaplık’,10,105,3,3),
				(‘1’,’Cüzdan’,40,121,9,4),
				(‘8’,’AkıllıSaat’,50,104,5,1),
				(‘8’,’Kalem’,100,122,10,4),
				(‘8’,’Simyacı’,20,110,6,2)

İnstert into Ulke values (‘İtalya’),
			   (‘Türkiye’),
			   (‘Kore’)

--Müşterilerin isimlerinde i harfi geçen isimleri listeleme (Where-like)
Select *From Müşteriler where Ad like '%i%'

--En yüksek Fiyatlı Ürünü Listele (iç-içe select)
Select *from Ürünler where UrunFiyatı= (select max(UrunFiyatı) from Ürünler)

--Kategoriye göre ürünlerin ortalama fiyatını bulma (Group by - avg)
Select Kategori.KategoriAdı, avg(UrunFiyatı) as [Ortalama Ürün Fiyatı] from Ürünler join Kategori
on Ürünler.KategoriID=Kategori.KategoriID
group by Kategori.KategoriID,Kategori.KategoriAdı

--Ürünlerin en çok miktara sahip ilk 3 tanesini sıralayalım (Top – order by)
Select Top 3 *from Ürünler order by UrunMiktarı desc

--Ürünleri kategorilere göre toplam ürün fiyatını ve hangi kategoride kaç ürün olduğunu bulma (Group by – sum – count)
Select Kategori.KategoriAdı, sum(UrunFiyatı) as [Toplam Ürün Fiyatı], count(*) as [Ürün Sayısı]
from Ürünler join Kategori
on Ürünler.KategoriID=Kategori.KategoriID
group by Kategori.KategoriID,Kategori.KategoriAdı 

--Kategorilere göre Stoktaki Ortalama Ürün Miktarları (Join – group by - avg)
Select Kategori.KategoriAdı, avg(StokUrunMİktar) as [Ortalama Ürün Miktarı] from StokTakibi join Kategori
on StokTakibi.KategoriID=Kategori.KategoriID
group by Kategori.KategoriID,Kategori.KategoriAdı

--“Diğer” kategorisinin Ortalama Stok Ürün Miktarını Bulma (Join – group by – avg - where)
Select Kategori.KategoriAdı, avg(StokUrunMİktar) as [Ortalama Ürün Miktarı] from StokTakibi join Kategori
on StokTakibi.KategoriID=Kategori.KategoriID
where KategoriAdı='Diğer'
group by Kategori.KategoriID,Kategori.KategoriAdı

--Maksimum ve Minimum ürün fiyatları (Max-Min)
Select Max(UrunFiyatı) as [Maksimum Ürün Fiyatı], Min (UrunFiyatı)  as [Minimum Ürün Fiyatı]
from Ürünler

--Elektronik kategorisinden alışveriş yapan müşterilerin adını, ülkesini ve aldığı ürünün adını ve fiyatını listeleme (İN)
Select Müşteriler.Ad, Ürünler.UrunAdı, Ürünler.UrunFiyatı, Ulke.UlkeAdı,Kategori.KategoriAdı
From GelenSiparişler
inner join Müşteriler on Müşteriler.MusteriID=GelenSiparişler.MusteriID
inner join Ürünler on Ürünler.UrunID=GelenSiparişler.UrunID
inner join Kategori
on Ürünler.KategoriID=Kategori.KategoriID
inner join Ulke
on Müşteriler.UlkeID=Ulke.UlkeID
where Kategori.KategoriID IN(1)

--Kategorilere göre ürünlerin toplam fiyatını bulup toplam fiyatı 2000’den fazla olanları listeleme (Group by - having)
Select Kategori.KategoriAdı, sum(UrunFiyatı) as [Toplam Ürün Fiyatı]
from Ürünler join Kategori
on Ürünler.KategoriID=Kategori.KategoriID
group by Kategori.KategoriID,Kategori.KategoriAdı
having sum(UrunFiyatı)>2000

--Müşterilerin isminde a harfi olan isimleri listeleyen procedure oluşturma (like)
create Proc LikeProcedure
@MüsteriAdı varchar(50)
as
select*from Müşteriler where Ad like '%'+@MüsteriAdı+'%'
exec LikeProcedure 'a'

--Veri ekleyen procedure oluşturma (insert)
Create Proc MusteriEkle
@MusteriAd varchar(50),
@MusteriSoyad varchar(50),
@MusteriEmail varchar(50),
@MusteriDogumTarihi date,
@MusteriUlkeID int,
@MusteriSiparisID int,
@MusteriFirmaID int,
@MusteriTeslimatID int
as
insert into Müşteriler values (@MusteriAd, @MusteriSoyad, @MusteriEmail, @MusteriDogumTarihi, @MusteriUlkeID, @MusteriSiparisID, @MusteriFirmaID, @MusteriTeslimatID
)
exec MusteriEkle'Mehet','Camcı','mhmtcmc@gmail.com','2000-7-8',3,5,2,5

--Silme işlemi yapınca başka bir tabloya eklenen verinin ID ve ekleme tarihini kaydeden Trigger yapma
create table SilinenÜlkeler
(
	Id int identity(1,1)Primary key,
	SilinenÜlkeID int,
	SilinenTarih date,
)
Go

create trigger ÜlkeyiSil
on Ulke
after delete
as
begin
declare @UlkeID int
select @UlkeID = UlkeID
from deleted
insert into SilinenÜlkeler values (@UlkeID, GETDATE())
end

delete from Ulke where UlkeID=4
select*from Ulke
select*from SilinenÜlkeler

--İnsert işlemini yapınca başka bir tabloya eklenen verinin ID ve ekleme tarihini kaydeden Trigger yapma
	create Table UlkeEkle
(
		ID int identity(1,1) primary key,
		EklenenUlkeID int,
		EklenmeTarihi date
)
Go

Create trigger UlkeEkleme
on Ulke
after insert
as
begin
declare @EklenenUlkeID int
select @EklenenUlkeID = UlkeID
from inserted
insert into UlkeEkle values (@EklenenUlkeID,GETDATE())
end

insert into Ulke values ('Yunanistan')
