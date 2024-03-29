USE [master]
GO
/****** Object:  Database [hospital]    Script Date: 3/11/2024 8:31:14 PM ******/
CREATE DATABASE [hospital]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hospital', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\hospital.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'hospital_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\hospital_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [hospital] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hospital].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hospital] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hospital] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hospital] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hospital] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hospital] SET ARITHABORT OFF 
GO
ALTER DATABASE [hospital] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hospital] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hospital] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hospital] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hospital] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hospital] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hospital] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hospital] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hospital] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hospital] SET  ENABLE_BROKER 
GO
ALTER DATABASE [hospital] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hospital] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hospital] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hospital] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hospital] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hospital] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hospital] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hospital] SET RECOVERY FULL 
GO
ALTER DATABASE [hospital] SET  MULTI_USER 
GO
ALTER DATABASE [hospital] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hospital] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hospital] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hospital] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [hospital] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'hospital', N'ON'
GO
ALTER DATABASE [hospital] SET QUERY_STORE = OFF
GO
USE [hospital]
GO
/****** Object:  UserDefinedFunction [dbo].[raise]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[raise](@number int)
returns int
as
begin
declare @a int
select @a= sum(r.payment_per_day*b.number_day_bastari )from bastari b inner join release r on b.code_reception=r.reception_code
inner join visite v on v.reception_code=b.code_reception
group by v.code
having v.code=@number
return @a
end
GO
/****** Object:  Table [dbo].[reception]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reception](
	[reception_code] [int] NOT NULL,
	[patient_code] [int] NULL,
	[operator_code] [int] NULL,
	[entry_date] [date] NULL,
	[entry_time] [time](7) NULL,
	[code_prereception] [int] NULL,
	[code_terazh] [int] NULL,
 CONSTRAINT [pk_reception_code] PRIMARY KEY CLUSTERED 
(
	[reception_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bastari]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bastari](
	[code_bastari] [int] NOT NULL,
	[code_reception] [int] NULL,
	[code_bed] [int] NULL,
	[code_prebastari] [int] NULL,
	[number_day_bastari] [int] NULL,
	[code_nurse] [int] NULL,
	[date_bastari] [date] NULL,
 CONSTRAINT [pk_bastari] PRIMARY KEY CLUSTERED 
(
	[code_bastari] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[patient]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[patient](
	[code_patient] [int] NOT NULL,
	[name] [nvarchar](30) NULL,
	[lastname] [nvarchar](30) NULL,
	[age] [tinyint] NOT NULL,
	[adress] [nvarchar](max) NULL,
	[tell] [int] NULL,
	[birthday] [date] NULL,
	[underlying_disease] [int] NULL,
	[disease_background] [int] NULL,
 CONSTRAINT [pk_patient_code] PRIMARY KEY CLUSTERED 
(
	[code_patient] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[report_patients_notbastrai]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[report_patients_notbastrai]
as
(
select r.reception_code ,p.name+' '+p.lastname as fullname,p.age,r.entry_time from reception  r  inner join patient p on r.patient_code=p.code_patient
where  not exists(select * from bastari b where r.reception_code=b.code_reception )

)
GO
/****** Object:  Table [dbo].[visite]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[visite](
	[code] [int] NOT NULL,
	[doctor_code] [int] NULL,
	[visite_date] [date] NULL,
	[visit_time] [time](7) NULL,
	[visite_illness_recojnition] [nvarchar](max) NULL,
	[visite_place] [int] NULL,
	[payment_visite] [int] NULL,
	[reception_code] [int] NULL,
 CONSTRAINT [pk_visite_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[speci_patients]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[speci_patients]
as
(
select p.name+' '+p.lastname as fullname, r.reception_code ,r.entry_date as date_receptin,
v.visite_illness_recojnition,v.doctor_code as code_doctor_visite
from patient p inner join reception r on p.code_patient=r.patient_code
inner join visite v on v.reception_code=r.reception_code
)
GO
/****** Object:  Table [dbo].[teryazh]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[teryazh](
	[code_teryazh] [int] NOT NULL,
	[reason_reception] [nvarchar](max) NULL,
	[illness_recojnition] [nvarchar](max) NULL,
	[code_patient] [int] NULL,
 CONSTRAINT [pk_teryazh_code] PRIMARY KEY CLUSTERED 
(
	[code_teryazh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[patient_teryazh]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[patient_teryazh]
as
(
select * from teryazh t inner join reception r on t.code_patient=r.patient_code
)
GO
/****** Object:  Table [dbo].[accompany_patient]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[accompany_patient](
	[code] [int] NOT NULL,
	[patient_code] [int] NULL,
	[fname] [nvarchar](30) NULL,
	[lname] [nvarchar](30) NULL,
	[adress] [nvarchar](max) NULL,
	[tell] [int] NULL,
 CONSTRAINT [pk_accompany_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[all_illness]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[all_illness](
	[name_illnesse] [nvarchar](30) NOT NULL,
	[symptoms] [nvarchar](max) NULL,
	[code_allillness] [int] NOT NULL,
 CONSTRAINT [pk_all_code] PRIMARY KEY CLUSTERED 
(
	[code_allillness] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[allillness_teryazh]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[allillness_teryazh](
	[code_teryazh] [int] NULL,
	[code_allillness] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bed]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bed](
	[code] [int] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[code_room] [int] NULL,
 CONSTRAINT [pk_bed_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[building]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[building](
	[name] [nvarchar](30) NOT NULL,
	[code_hospital] [int] NULL,
	[code_building] [int] NOT NULL,
 CONSTRAINT [pk_buil_code] PRIMARY KEY CLUSTERED 
(
	[code_building] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[disease_background]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[disease_background](
	[code] [int] NOT NULL,
	[name_pation] [nvarchar](30) NULL,
	[hospitalization_tim] [date] NULL,
	[hospitalization_name] [nvarchar](50) NULL,
 CONSTRAINT [pk_disease_background] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[doctor]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[doctor](
	[code_doctor] [int] NOT NULL,
	[firstname] [nvarchar](30) NOT NULL,
	[lastname] [nvarchar](30) NOT NULL,
	[tell] [int] NOT NULL,
	[adress] [nvarchar](max) NULL,
	[speciality_kind] [nvarchar](50) NULL,
	[employment_cod] [int] IDENTITY(100,1) NOT NULL,
 CONSTRAINT [pk_doctor_code] PRIMARY KEY CLUSTERED 
(
	[code_doctor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employments]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employments](
	[code_employee] [int] NULL,
	[kind_imploye] [nvarchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hospital]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hospital](
	[code] [int] NOT NULL,
	[hospital_name] [nvarchar](30) NULL,
	[management] [int] NULL,
 CONSTRAINT [pk_hospital_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[insurance]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[insurance](
	[code] [int] IDENTITY(1,1) NOT NULL,
	[insurance_name] [nvarchar](30) NULL,
	[franchise] [int] NULL,
	[code_main_insured] [int] NULL,
 CONSTRAINT [pk_p_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[insurances_patient]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[insurances_patient](
	[patient_code] [int] NULL,
	[insurance_code] [int] NULL,
	[validity_duration] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mangement]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mangement](
	[code] [int] NOT NULL,
	[manag_name] [nvarchar](30) NULL,
	[lastname] [nvarchar](30) NULL,
	[tell] [tinyint] NULL,
	[adress] [nvarchar](max) NULL,
 CONSTRAINT [pk_manag_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[medicine]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[medicine](
	[code] [int] NOT NULL,
	[name_medicine] [nvarchar](30) NULL,
	[expiration_date] [date] NULL,
	[manufacture_date] [date] NULL,
	[price_medicine] [int] NULL,
	[code_visite] [int] NULL,
 CONSTRAINT [pk_medicine_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nurse]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nurse](
	[firstname] [nvarchar](30) NOT NULL,
	[lastname] [nvarchar](30) NOT NULL,
	[tell] [int] NOT NULL,
	[adress] [nvarchar](max) NULL,
	[speciality_kind] [nvarchar](30) NULL,
	[employment_cod] [int] IDENTITY(300,1) NOT NULL,
 CONSTRAINT [pk_nurse_code] PRIMARY KEY CLUSTERED 
(
	[employment_cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[office_prsonnel]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[office_prsonnel](
	[firstname] [nvarchar](30) NOT NULL,
	[lastname] [nvarchar](30) NOT NULL,
	[tell] [int] NOT NULL,
	[adress] [nvarchar](max) NULL,
	[code_employment] [int] NOT NULL,
	[speciality_kind] [nvarchar](30) NULL,
 CONSTRAINT [pk_office_code] PRIMARY KEY CLUSTERED 
(
	[code_employment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[part]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[part](
	[code] [int] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[code_buil] [int] NULL,
 CONSTRAINT [pk_part_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pishbastari]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pishbastari](
	[code_prebastari] [int] NOT NULL,
	[code_visite] [int] NULL,
	[reason_bastar] [nvarchar](max) NULL,
 CONSTRAINT [pk_code_pish] PRIMARY KEY CLUSTERED 
(
	[code_prebastari] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prereception]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prereception](
	[code] [int] NOT NULL,
	[code_patient] [int] NULL,
	[date_tim] [datetime] NULL,
	[date_time_rejister] [datetime] NULL,
	[kind_prereception] [nvarchar](30) NULL,
 CONSTRAINT [pk_pre_reception] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[release]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[release](
	[code] [int] NOT NULL,
	[patient_code] [int] NULL,
	[reception_code] [int] NULL,
	[code_doctor_release] [int] NULL,
	[release_time] [time](7) NULL,
	[release_date] [date] NULL,
	[code_visite] [int] NULL,
	[payment_per_day] [int] NULL,
 CONSTRAINT [pk_release_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[room]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[room](
	[code] [int] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[code_section] [int] NULL,
 CONSTRAINT [pk_room_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[saled]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[saled](
	[code_saled] [int] IDENTITY(1,1) NOT NULL,
	[code_reception] [int] NULL,
	[saled_date] [date] NULL,
	[payment_visite] [int] NULL,
	[number_day_bastari] [int] NULL,
	[payment_per_day] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[section]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[section](
	[code] [int] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[code_part] [int] NULL,
 CONSTRAINT [pk_section_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sevices_prsonnel]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sevices_prsonnel](
	[firstname] [nvarchar](30) NOT NULL,
	[lastname] [nvarchar](30) NOT NULL,
	[tell] [int] NOT NULL,
	[adress] [nvarchar](max) NULL,
	[employment_cod] [int] IDENTITY(500,1) NOT NULL,
	[speciality_kind] [nvarchar](30) NULL,
 CONSTRAINT [pk_services_code] PRIMARY KEY CLUSTERED 
(
	[employment_cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[underlying_disease]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[underlying_disease](
	[code] [int] NOT NULL,
	[kind] [nvarchar](30) NULL,
 CONSTRAINT [pk_underlying_disease_code] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[reception] ADD  CONSTRAINT [d_reception_entry]  DEFAULT ('gggg/mm/dd') FOR [entry_date]
GO
ALTER TABLE [dbo].[visite] ADD  CONSTRAINT [d_visit_date]  DEFAULT ('gggg/mm/dd') FOR [visite_date]
GO
ALTER TABLE [dbo].[accompany_patient]  WITH CHECK ADD  CONSTRAINT [fk_accompany_patient_code] FOREIGN KEY([patient_code])
REFERENCES [dbo].[patient] ([code_patient])
GO
ALTER TABLE [dbo].[accompany_patient] CHECK CONSTRAINT [fk_accompany_patient_code]
GO
ALTER TABLE [dbo].[allillness_teryazh]  WITH CHECK ADD  CONSTRAINT [code_all_allillnes] FOREIGN KEY([code_allillness])
REFERENCES [dbo].[all_illness] ([code_allillness])
GO
ALTER TABLE [dbo].[allillness_teryazh] CHECK CONSTRAINT [code_all_allillnes]
GO
ALTER TABLE [dbo].[allillness_teryazh]  WITH CHECK ADD  CONSTRAINT [code_allill_teryazh] FOREIGN KEY([code_teryazh])
REFERENCES [dbo].[teryazh] ([code_teryazh])
GO
ALTER TABLE [dbo].[allillness_teryazh] CHECK CONSTRAINT [code_allill_teryazh]
GO
ALTER TABLE [dbo].[bastari]  WITH CHECK ADD  CONSTRAINT [fk_bastar_pish] FOREIGN KEY([code_prebastari])
REFERENCES [dbo].[pishbastari] ([code_prebastari])
GO
ALTER TABLE [dbo].[bastari] CHECK CONSTRAINT [fk_bastar_pish]
GO
ALTER TABLE [dbo].[bastari]  WITH CHECK ADD  CONSTRAINT [fk_bastari_bed] FOREIGN KEY([code_bed])
REFERENCES [dbo].[bed] ([code])
GO
ALTER TABLE [dbo].[bastari] CHECK CONSTRAINT [fk_bastari_bed]
GO
ALTER TABLE [dbo].[bastari]  WITH CHECK ADD  CONSTRAINT [fk_bastari_nurse] FOREIGN KEY([code_nurse])
REFERENCES [dbo].[nurse] ([employment_cod])
GO
ALTER TABLE [dbo].[bastari] CHECK CONSTRAINT [fk_bastari_nurse]
GO
ALTER TABLE [dbo].[bastari]  WITH CHECK ADD  CONSTRAINT [fk_bastari_reception] FOREIGN KEY([code_reception])
REFERENCES [dbo].[reception] ([reception_code])
GO
ALTER TABLE [dbo].[bastari] CHECK CONSTRAINT [fk_bastari_reception]
GO
ALTER TABLE [dbo].[bed]  WITH CHECK ADD  CONSTRAINT [fk_bed_room] FOREIGN KEY([code_room])
REFERENCES [dbo].[room] ([code])
GO
ALTER TABLE [dbo].[bed] CHECK CONSTRAINT [fk_bed_room]
GO
ALTER TABLE [dbo].[building]  WITH CHECK ADD  CONSTRAINT [fk_buil_hus] FOREIGN KEY([code_hospital])
REFERENCES [dbo].[hospital] ([code])
GO
ALTER TABLE [dbo].[building] CHECK CONSTRAINT [fk_buil_hus]
GO
ALTER TABLE [dbo].[hospital]  WITH CHECK ADD  CONSTRAINT [fk_hospital_buil] FOREIGN KEY([management])
REFERENCES [dbo].[mangement] ([code])
GO
ALTER TABLE [dbo].[hospital] CHECK CONSTRAINT [fk_hospital_buil]
GO
ALTER TABLE [dbo].[insurances_patient]  WITH CHECK ADD  CONSTRAINT [fk_insurances_insurance_code] FOREIGN KEY([insurance_code])
REFERENCES [dbo].[insurance] ([code])
GO
ALTER TABLE [dbo].[insurances_patient] CHECK CONSTRAINT [fk_insurances_insurance_code]
GO
ALTER TABLE [dbo].[insurances_patient]  WITH CHECK ADD  CONSTRAINT [fk_insurances_patient_code] FOREIGN KEY([patient_code])
REFERENCES [dbo].[patient] ([code_patient])
GO
ALTER TABLE [dbo].[insurances_patient] CHECK CONSTRAINT [fk_insurances_patient_code]
GO
ALTER TABLE [dbo].[medicine]  WITH CHECK ADD  CONSTRAINT [fk_medicine_visit] FOREIGN KEY([code_visite])
REFERENCES [dbo].[visite] ([code])
GO
ALTER TABLE [dbo].[medicine] CHECK CONSTRAINT [fk_medicine_visit]
GO
ALTER TABLE [dbo].[part]  WITH CHECK ADD  CONSTRAINT [fk_part_buil] FOREIGN KEY([code_buil])
REFERENCES [dbo].[building] ([code_building])
GO
ALTER TABLE [dbo].[part] CHECK CONSTRAINT [fk_part_buil]
GO
ALTER TABLE [dbo].[patient]  WITH CHECK ADD  CONSTRAINT [fk_patient_disease_background] FOREIGN KEY([disease_background])
REFERENCES [dbo].[disease_background] ([code])
GO
ALTER TABLE [dbo].[patient] CHECK CONSTRAINT [fk_patient_disease_background]
GO
ALTER TABLE [dbo].[patient]  WITH CHECK ADD  CONSTRAINT [fk_patient_underlying_disease] FOREIGN KEY([underlying_disease])
REFERENCES [dbo].[underlying_disease] ([code])
GO
ALTER TABLE [dbo].[patient] CHECK CONSTRAINT [fk_patient_underlying_disease]
GO
ALTER TABLE [dbo].[pishbastari]  WITH CHECK ADD  CONSTRAINT [fk_pish_visit] FOREIGN KEY([code_visite])
REFERENCES [dbo].[visite] ([code])
GO
ALTER TABLE [dbo].[pishbastari] CHECK CONSTRAINT [fk_pish_visit]
GO
ALTER TABLE [dbo].[prereception]  WITH CHECK ADD  CONSTRAINT [fk_pre_patient] FOREIGN KEY([code_patient])
REFERENCES [dbo].[patient] ([code_patient])
GO
ALTER TABLE [dbo].[prereception] CHECK CONSTRAINT [fk_pre_patient]
GO
ALTER TABLE [dbo].[reception]  WITH CHECK ADD  CONSTRAINT [fk_reception_office] FOREIGN KEY([operator_code])
REFERENCES [dbo].[office_prsonnel] ([code_employment])
GO
ALTER TABLE [dbo].[reception] CHECK CONSTRAINT [fk_reception_office]
GO
ALTER TABLE [dbo].[reception]  WITH CHECK ADD  CONSTRAINT [fk_reception_pation] FOREIGN KEY([patient_code])
REFERENCES [dbo].[patient] ([code_patient])
GO
ALTER TABLE [dbo].[reception] CHECK CONSTRAINT [fk_reception_pation]
GO
ALTER TABLE [dbo].[reception]  WITH CHECK ADD  CONSTRAINT [fk_reception_pre] FOREIGN KEY([code_prereception])
REFERENCES [dbo].[prereception] ([code])
GO
ALTER TABLE [dbo].[reception] CHECK CONSTRAINT [fk_reception_pre]
GO
ALTER TABLE [dbo].[reception]  WITH CHECK ADD  CONSTRAINT [reception_teryazh_code] FOREIGN KEY([code_terazh])
REFERENCES [dbo].[teryazh] ([code_teryazh])
GO
ALTER TABLE [dbo].[reception] CHECK CONSTRAINT [reception_teryazh_code]
GO
ALTER TABLE [dbo].[release]  WITH CHECK ADD  CONSTRAINT [fk_release_doctor] FOREIGN KEY([code_doctor_release])
REFERENCES [dbo].[doctor] ([code_doctor])
GO
ALTER TABLE [dbo].[release] CHECK CONSTRAINT [fk_release_doctor]
GO
ALTER TABLE [dbo].[release]  WITH CHECK ADD  CONSTRAINT [fk_release_patient] FOREIGN KEY([patient_code])
REFERENCES [dbo].[patient] ([code_patient])
GO
ALTER TABLE [dbo].[release] CHECK CONSTRAINT [fk_release_patient]
GO
ALTER TABLE [dbo].[release]  WITH CHECK ADD  CONSTRAINT [fk_release_reception] FOREIGN KEY([reception_code])
REFERENCES [dbo].[reception] ([reception_code])
GO
ALTER TABLE [dbo].[release] CHECK CONSTRAINT [fk_release_reception]
GO
ALTER TABLE [dbo].[release]  WITH CHECK ADD  CONSTRAINT [fk_release_visit] FOREIGN KEY([code_visite])
REFERENCES [dbo].[visite] ([code])
GO
ALTER TABLE [dbo].[release] CHECK CONSTRAINT [fk_release_visit]
GO
ALTER TABLE [dbo].[room]  WITH CHECK ADD  CONSTRAINT [fk_room_section] FOREIGN KEY([code_section])
REFERENCES [dbo].[section] ([code])
GO
ALTER TABLE [dbo].[room] CHECK CONSTRAINT [fk_room_section]
GO
ALTER TABLE [dbo].[saled]  WITH CHECK ADD  CONSTRAINT [fk_saled_reception] FOREIGN KEY([code_reception])
REFERENCES [dbo].[reception] ([reception_code])
GO
ALTER TABLE [dbo].[saled] CHECK CONSTRAINT [fk_saled_reception]
GO
ALTER TABLE [dbo].[section]  WITH CHECK ADD  CONSTRAINT [fk_section_part] FOREIGN KEY([code_part])
REFERENCES [dbo].[part] ([code])
GO
ALTER TABLE [dbo].[section] CHECK CONSTRAINT [fk_section_part]
GO
ALTER TABLE [dbo].[teryazh]  WITH CHECK ADD  CONSTRAINT [fk_teryazh_patient] FOREIGN KEY([code_patient])
REFERENCES [dbo].[patient] ([code_patient])
GO
ALTER TABLE [dbo].[teryazh] CHECK CONSTRAINT [fk_teryazh_patient]
GO
ALTER TABLE [dbo].[visite]  WITH CHECK ADD  CONSTRAINT [fk_visite_doctor] FOREIGN KEY([doctor_code])
REFERENCES [dbo].[doctor] ([code_doctor])
GO
ALTER TABLE [dbo].[visite] CHECK CONSTRAINT [fk_visite_doctor]
GO
ALTER TABLE [dbo].[visite]  WITH CHECK ADD  CONSTRAINT [fk_visite_part] FOREIGN KEY([visite_place])
REFERENCES [dbo].[part] ([code])
GO
ALTER TABLE [dbo].[visite] CHECK CONSTRAINT [fk_visite_part]
GO
ALTER TABLE [dbo].[visite]  WITH CHECK ADD  CONSTRAINT [fk_visite_receptin] FOREIGN KEY([reception_code])
REFERENCES [dbo].[reception] ([reception_code])
GO
ALTER TABLE [dbo].[visite] CHECK CONSTRAINT [fk_visite_receptin]
GO
/****** Object:  StoredProcedure [dbo].[code_bastari2]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[code_bastari2]
@c int 
as
select b.code_bastari, b.code_reception,b.code_bed,b.date_bastari,b.code_nurse from bastari b inner join reception r on b.code_reception=r.reception_code where patient_code=@c
GO
/****** Object:  StoredProcedure [dbo].[doctor_visit_patient_paramter_value]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[doctor_visit_patient_paramter_value]
@doctor_code int ,@parametr nvarchar(3),@value int
as
select code_doctor,patient_code from doctor d inner join visite v on d.code_doctor=v.doctor_code
inner join reception r on v.reception_code=r.reception_code where code_doctor=@doctor_code and 
(case @parametr
when 'y'then datediff(YY,dateadd(YEAR,-@value,GETDATE()),visite_date)
when 'm' then datediff(mm,dateadd(MONTH,-@value,GETDATE()),visite_date)
when 'd' then datediff(dd,dateadd(DAY,-@value,GETDATE()),visite_date)
end) =@value
GO
/****** Object:  StoredProcedure [dbo].[illness_bastari]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[illness_bastari]
@c int
as
with bastari_illnesse ( code_allillness,patient_code)
as
(
select code_allillness,patient_code from allillness_teryazh a inner join reception r on a.code_teryazh=r.code_terazh
inner join bastari on r.code=bastari.code_reception where code_allillness=@c
)
select * from bastari_illnesse  where code_allillness=@c
GO
/****** Object:  StoredProcedure [dbo].[illness_bastari1]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[illness_bastari1]
@c int
as
with bastari_illnesse ( code_allillness,patient_code)
as
(
select code_allillness,patient_code from allillness_teryazh a inner join reception r on a.code_teryazh=r.code_terazh
inner join bastari on r.reception_code=bastari.code_reception where code_allillness=@c
)
select * from bastari_illnesse  where code_allillness=@c
GO
/****** Object:  StoredProcedure [dbo].[patient_nurse]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[patient_nurse]
@code_patient int
as
select  p.code_patient,b.code_nurse from patient p inner join reception r on p.code_patient=r.patient_code
inner join bastari b on  b.code_reception=r.reception_code
GO
/****** Object:  StoredProcedure [dbo].[patient_time_reception]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[patient_time_reception]
@parametr nvarchar(30) , @value int
as
select  p.code_patient ,r.entry_time from patient p inner join reception r on p.code_patient=r.patient_code
where   (case @parametr

when 'y' then  DATEDIFF(YY,DATEADD(yy,-@value,GETDATE()) ,entry_date)
when 'm' then DATEDIFF(MONTH,DATEADD(month,-@value,getdate()),entry_date)
end

)=@value
GO
/****** Object:  StoredProcedure [dbo].[time_bastari]    Script Date: 3/11/2024 8:31:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[time_bastari]
@year int,@month int,
@day int 
as
select p.code_patient,b.code_bastari,b.date_bastari,p.name,p.lastname from patient p inner join reception r on p.code_patient=r.patient_code
inner join visite v on r.reception_code=v.reception_code
inner join bastari b on b.code_reception=v.reception_code
where b.date_bastari between  DATEFROMPARTS(@year,@month,@day) and  getdate()
GO
USE [master]
GO
ALTER DATABASE [hospital] SET  READ_WRITE 
GO
