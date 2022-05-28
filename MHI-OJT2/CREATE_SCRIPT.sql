USE [master]
GO
/****** Object:  Database [OJT]    Script Date: 03/May/2022 15:53:54 ******/
CREATE DATABASE [OJT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OJT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\OJT.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'OJT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\OJT_log.ldf' , SIZE = 1536KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [OJT] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OJT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OJT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OJT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OJT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OJT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OJT] SET ARITHABORT OFF 
GO
ALTER DATABASE [OJT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OJT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OJT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OJT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OJT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OJT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OJT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OJT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OJT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OJT] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OJT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OJT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OJT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OJT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OJT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OJT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OJT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OJT] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OJT] SET  MULTI_USER 
GO
ALTER DATABASE [OJT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OJT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OJT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OJT] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [OJT] SET DELAYED_DURABILITY = DISABLED 
GO
USE [OJT]
GO
/****** Object:  User [project1]    Script Date: 03/May/2022 15:53:55 ******/
CREATE USER [project1] FOR LOGIN [project1] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[ADJUST_COURSE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ADJUST_COURSE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[COURSE_NUMBER] [varchar](100) NOT NULL,
	[TIMES] [int] NOT NULL,
	[COURSE_NAME] [varchar](250) NOT NULL,
	[START_DATE] [date] NOT NULL,
	[END_DATE] [date] NOT NULL,
	[START_TIME] [varchar](50) NOT NULL,
	[END_TIME] [varchar](50) NOT NULL,
	[TOTAL_HOURS] [int] NOT NULL,
	[DEPARTMENT_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NOT NULL,
	[TEACHER_ID] [int] NOT NULL,
	[DETAIL] [varchar](250) NULL,
	[OBJECTIVE] [varchar](250) NULL,
	[ASSESSOR1_ID] [int] NULL,
	[ASSESSOR2_ID] [int] NULL,
	[ASSESSOR3_ID] [int] NULL,
	[ASSESSOR4_ID] [int] NULL,
	[ASSESSOR5_ID] [int] NULL,
	[ASSESSOR6_ID] [int] NULL,
	[STATUS] [int] NULL,
	[EVALUATED_DATE] [date] NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL,
	[FILE_UPLOAD] [varbinary](max) NULL,
	[IS_EXAM_EVALUATE] [bit] NULL,
	[IS_REAL_WORK_EVALUATE] [bit] NULL,
	[IS_OTHER_EVALUATE] [bit] NULL,
	[OTHER_EVALUATE_REMARK] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[APPROVAL]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APPROVAL](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[COURSE_ID] [int] NOT NULL,
	[PERSON_ID] [int] NOT NULL,
	[IS_APPROVED] [bit] NULL,
	[APPROVAL_RESULT] [bit] NULL,
	[APPROVAL_SEQUENCE] [int] NULL,
	[ACTION_DATE] [datetime] NULL,
	[REMARK] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CLERK_NOTIFICATION]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLERK_NOTIFICATION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CREATED_AT] [datetime] NULL,
	[READ] [bit] NULL,
	[COURSE_ID] [int] NOT NULL,
	[APPROVE_RESULT] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DEPARTMENT]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEPARTMENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SECTION_ID] [int] NOT NULL,
	[DEPARTMENT_NAME] [varchar](100) NOT NULL,
	[IS_ACTIVE] [bit] NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EVALUATE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVALUATE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[COURSE_ID] [int] NOT NULL,
	[PERSON_ID] [int] NOT NULL,
	[SCORE_1] [float] NOT NULL,
	[SCORE_2] [float] NOT NULL,
	[SCORE_3] [float] NOT NULL,
	[SCORE_4] [float] NOT NULL,
	[SCORE_5] [float] NOT NULL,
	[TOTAL_SCORE] [float] NOT NULL,
	[IS_EVALUATED] [bit] NULL,
	[CREATED_AT] [datetime] NULL,
	[EXAM_SCORE] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOCATION]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOCATION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LOCATION_NAME] [varchar](200) NULL,
	[IS_ACTIVE] [bit] NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PLAN_AND_COURSE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLAN_AND_COURSE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PLAN_ID] [int] NOT NULL,
	[COURSE_ID] [int] NOT NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SECTION]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SECTION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SECTION_NAME] [varchar](100) NULL,
	[IS_ACTIVE] [bit] NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SYSTEM_LOG]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTEM_LOG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ACTION_TYPE] [nvarchar](100) NULL,
	[TITLE] [nvarchar](200) NULL,
	[OLD_VALUE] [varchar](100) NULL,
	[NEW_VALUE] [nvarchar](100) NULL,
	[REMARK] [nvarchar](200) NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_AT] [datetime] NULL,
	[IS_USER] [bit] NOT NULL,
	[TABLE_NAME] [varchar](50) NULL,
	[FK_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SYSTEM_USERS]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTEM_USERS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[USERNAME] [varchar](200) NOT NULL,
	[PASSWORD] [varchar](200) NOT NULL,
	[INITIAL_NAME] [varchar](50) NOT NULL,
	[FIRST_NAME] [varchar](100) NOT NULL,
	[LAST_NAME] [varchar](100) NOT NULL,
	[POSITION_NAME] [varchar](100) NOT NULL,
	[ROLES] [varchar](100) NOT NULL,
	[IS_ACTIVE] [bit] NULL,
	[CREATED_AT] [datetime] NULL,
	[IS_EDIT_MASTER] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TEACHER]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEACHER](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[INITIAL_NAME] [varchar](50) NULL,
	[FIRST_NAME] [varchar](200) NOT NULL,
	[LAST_NAME] [varchar](200) NULL,
	[IS_ACTIVE] [bit] NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRAINING_PLAN]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAINING_PLAN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DEPARTMENT_ID] [int] NOT NULL,
	[PLAN_NAME] [varchar](250) NULL,
	[REF_DOCUMENT] [varchar](100) NULL,
	[HOURS] [int] NULL,
	[FREQUENCY] [varchar](100) NULL,
	[SM_MG] [bit] NULL,
	[SAM_AM] [bit] NULL,
	[SEG_SV] [bit] NULL,
	[EG_ST] [bit] NULL,
	[FM] [bit] NULL,
	[LD_SEP_EP] [bit] NULL,
	[OP] [bit] NULL,
	[PLAN_DATE] [date] NOT NULL,
	[ACTUAL_DATE] [date] NULL,
	[TRAINER] [varchar](50) NULL,
	[CREATED_AT] [datetime] NULL,
	[CREATED_BY] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VIEW_PLAN_AND_COURSE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[VIEW_PLAN_AND_COURSE] AS
SELECT 
	(SELECT ID FROM SECTION WHERE ID = (SELECT SECTION_ID FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID)) AS PLAN_SECTION_ID
    ,(SELECT SECTION_NAME FROM SECTION WHERE ID = (SELECT SECTION_ID FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID)) AS PLAN_SECTION_NAME
    ,(SELECT DEPARTMENT_NAME FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID) AS PLAN_DEPARTMENT_NAME
    ,[plan].PLAN_NAME
    ,[plan].[REF_DOCUMENT] AS PLAN_REF_DOCUMENT
    ,[plan].[HOURS] AS PLAN_HOURS
    ,[plan].[FREQUENCY] AS PLAN_FREQUENCY
    ,[plan].[SM_MG]
    ,[plan].SAM_AM
    ,[plan].[SEG_SV]
    ,[plan].EG_ST
    ,[plan].[FM]
    ,[plan].[LD_SEP_EP]
    ,[plan].[OP]
    ,[plan].PLAN_DATE
    ,[plan].[ACTUAL_DATE] AS PLAN_ACTUAL_DATE
    ,[plan].TRAINER

	,course.ID COURSE_ID
	,course.COURSE_NUMBER
	,course.TIMES AS COURSE_TIMES
	,course.COURSE_NAME
	,course.[START_DATE] AS COURSE_START_DATE
	,course.[END_DATE] AS COURSE_END_DATE
	,course.START_TIME AS COURSE_START_TIME
	,course.END_TIME AS COURSE_END_TIME
	,course.TOTAL_HOURS AS COURSE_TOTAL_HOURS
	,dep.DEPARTMENT_NAME
    ,sec.SECTION_NAME
	,loc.LOCATION_NAME
	,CONCAT(tea.INITIAL_NAME, ' ', tea.FIRST_NAME, ' ', tea.LAST_NAME) AS TEACHER_NAME
	,course.DETAIL AS COURSE_DETAIL
	,course.OBJECTIVE AS COURSE_OBJECTIVE
	,course.EVALUATED_DATE

    ,course.[STATUS] AS STATUS_CODE

    ,CASE 
		WHEN course.[STATUS] = 1 THEN  'รอเลือกพนักงาน'
		WHEN course.[STATUS] = 2 THEN  'รอประเมินผล'
		WHEN course.[STATUS] = 3 THEN  'รอผู้อนุมัติคนที่ 1'
		WHEN course.[STATUS] = 4 THEN  'รอผู้อนุมัติคนที่ 2'
		WHEN course.[STATUS] = 5 THEN  'รอผู้อนุมัติคนที่ 3'
		WHEN course.[STATUS] = 6 THEN  'รอผู้อนุมัติคนที่ 4'
		WHEN course.[STATUS] = 7 THEN  'รอผู้อนุมัติคนที่ 5'
		WHEN course.[STATUS] = 8 THEN  'รอผู้อนุมัติคนที่ 6'
		WHEN course.[STATUS] = 9 THEN  'อนุมัติ'
		WHEN course.[STATUS] = 10 THEN  'ไม่อนุมัติ'
		ELSE NULL 
	 END AS STATUS_TEXT

    ,[user].[ID] CREATED_ID
	,CONCAT([user].INITIAL_NAME, ' ', [user].FIRST_NAME, ' ', [user].LAST_NAME) AS CREATED_NAME

FROM PLAN_AND_COURSE pnc
JOIN ADJUST_COURSE course ON course.ID = pnc.COURSE_ID
JOIN TRAINING_PLAN [plan] ON [plan].ID = pnc.PLAN_ID
JOIN DEPARTMENT dep ON dep.ID = course.DEPARTMENT_ID
JOIN [LOCATION] loc ON loc.ID = course.LOCATION_ID
JOIN TEACHER tea ON tea.ID = course.TEACHER_ID
JOIN [SECTION] sec ON sec.ID = dep.SECTION_ID

JOIN SYSTEM_USERS [user] ON [user].ID = course.CREATED_BY 
GO
/****** Object:  View [dbo].[VIEW_ADJUST_COURSE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[VIEW_ADJUST_COURSE] AS
SELECT
	a.*
	,a.ID COURSE_ID
	,(SELECT TOP 1 CONCAT(INITIAL_NAME,FIRST_NAME, ' ', LAST_NAME) FROM SYSTEM_USERS WHERE ID=a.CREATED_BY) CREATED_NAME
	,[STATUS] AS STATUS_CODE
	,CASE 
		WHEN [STATUS] = 1 THEN  'รอเลือกพนักงาน'
		WHEN [STATUS] = 2 THEN  'รอประเมินผล'
		WHEN [STATUS] = 3 THEN  'รอผู้อนุมัติคนที่ 1'
		WHEN [STATUS] = 4 THEN  'รอผู้อนุมัติคนที่ 2'
		WHEN [STATUS] = 5 THEN  'รอผู้อนุมัติคนที่ 3'
		WHEN [STATUS] = 6 THEN  'รอผู้อนุมัติคนที่ 4'
		WHEN [STATUS] = 7 THEN  'รอผู้อนุมัติคนที่ 5'
		WHEN [STATUS] = 8 THEN  'รอผู้อนุมัติคนที่ 6'
        WHEN [STATUS] = 9 THEN  'อนุมัติ'
		WHEN [STATUS] = 10 THEN  'ไม่อนุมัติ'
		ELSE NULL 
	 END AS STATUS_TEXT
    ,(CASE WHEN (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE p.COURSE_ID = a.ID) > 0 THEN 1 ELSE 0 END) AS PLANNED
	,d.DEPARTMENT_NAME
	,(SELECT PLAN_DATE FROM VIEW_PLAN_AND_COURSE WHERE COURSE_ID = a.ID) AS PLAN_DATE

FROM ADJUST_COURSE a
INNER JOIN DEPARTMENT d ON d.ID = a.DEPARTMENT_ID

GO
/****** Object:  View [dbo].[TIGER_EMPLOYEE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TIGER_EMPLOYEE] AS
SELECT 
	person.PersonID
    ,person.PersonCode
    ,CONCAT(person.PersonCode, ' ', person.FnameT, ' ', person.LnameT) FULLNAME_TH
    ,CONCAT(person.PersonCode, ' ', person.FnameE, ' ', person.LnameE) FULLNAME_EN
    ,Cmb1NameT CMB1_NAME_TH
    ,Cmb1NameE CMB1_NAME_EN

    ,Cmb2NameT CMB2_NAME_TH
    ,Cmb2NameE CMB2_NAME_EN

    ,Cmb3NameT CMB3_NAME_TH
    ,Cmb3NameE CMB3_NAME_EN

    ,Cmb4NameT CMB4_NAME_TH
    ,Cmb4NameE CMB4_NAME_EN

    ,Cmb5NameT CMB5_NAME_TH
    ,Cmb5NameE CMB5_NAME_EN

    ,Cmb6NameT CMB6_NAME_TH
    ,Cmb6NameE CMB6_NAME_EN

    ,position.PositionNameT POSITION_NAME_TH
    ,position.PositionNameE POSITION_NAME_EN

FROM Cyberhrm.dbo.PNT_Person person
JOIN Cyberhrm.dbo.PNM_Cmb1 cmb1 ON cmb1.Cmb1ID = person.Cmb1ID
JOIN Cyberhrm.dbo.PNM_Cmb2 cmb2 ON cmb2.Cmb2ID = person.Cmb2ID
JOIN Cyberhrm.dbo.PNM_Cmb3 cmb3 ON cmb3.Cmb3ID = person.Cmb3ID
JOIN Cyberhrm.dbo.PNM_Cmb4 cmb4 ON cmb4.Cmb4ID = person.Cmb4ID
JOIN Cyberhrm.dbo.PNM_Cmb5 cmb5 ON cmb5.Cmb5ID = person.Cmb5ID
JOIN Cyberhrm.dbo.PNM_Cmb6 cmb6 ON cmb6.Cmb6ID = person.Cmb6ID
JOIN Cyberhrm.dbo.PNM_Position position ON position.PositionID = person.PositionID
WHERE ResignStatus = 1 AND ChkDeletePerson = 1
GO
/****** Object:  View [dbo].[VIEW_SYSTEM_LOG]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_SYSTEM_LOG] AS 
SELECT 
    l.*
    ,IIF(l.IS_USER = 1, t.FULLNAME_TH collate Thai_CI_AS, CONCAT(u.USERNAME, ' ', u.FIRST_NAME, ' ', u.LAST_NAME)) as username
FROM SYSTEM_LOG l
LEFT JOIN SYSTEM_USERS u ON u.ID = l.CREATED_BY
LEFT JOIN TIGER_EMPLOYEE t ON t.PersonID = l.CREATED_BY
GO
/****** Object:  View [dbo].[APPROVAL_LIST]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[APPROVAL_LIST] AS
SELECT 
	apr.APPROVAL_SEQUENCE
    
    -- employee id
    ,person.PersonID
    ,person.PersonCode

    -- name TH
    ,ini.InitialT
    ,person.FnameT
    ,person.LnameT
    
    -- name EN
    ,InitialE
    ,person.FnameE
    ,person.LnameE

    ,apr.APPROVAL_RESULT
    ,IS_APPROVED
    ,apr.COURSE_ID
    ,apr.ACTION_DATE
    ,apr.REMARK

    ,COURSE_NUMBER
    ,COURSE_NAME
    ,dep.DEPARTMENT_NAME

FROM OJT.dbo.APPROVAL apr

JOIN Cyberhrm.dbo.PNT_Person AS person ON  person.PersonID = apr.PERSON_ID
JOIN Cyberhrm.dbo.PNM_Initial AS ini ON person.InitialID = ini.InitialID
JOIN Cyberhrm.dbo.PNM_Position AS position ON position.PositionID = person.PositionID 
JOIN OJT.dbo.ADJUST_COURSE AS adj ON adj.ID = apr.COURSE_ID
JOIN OJT.dbo.DEPARTMENT AS dep on dep.ID = adj.DEPARTMENT_ID

GO
/****** Object:  View [dbo].[COURSE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[COURSE] AS
SELECT
	adj.ID AS COURSE_ID
	,adj.COURSE_NUMBER
	,adj.TIMES
	,adj.COURSE_NAME
	,adj.[START_DATE]
	,adj.[END_DATE]
	,adj.START_TIME
	,adj.END_TIME
	,adj.TOTAL_HOURS
	,dep.DEPARTMENT_NAME
    ,sec.ID SECTION_ID
    ,sec.SECTION_NAME
	,loc.LOCATION_NAME
	,CONCAT(tea.INITIAL_NAME, ' ', tea.FIRST_NAME, ' ', tea.LAST_NAME) AS TEACHER_NAME
	,adj.DETAIL
	,adj.OBJECTIVE
	,adj.EVALUATED_DATE

	,adj.[STATUS] AS STATUS_CODE
	,CASE 
		WHEN adj.[STATUS] = 1 THEN  'รอเลือกพนักงาน'
		WHEN adj.[STATUS] = 2 THEN  'รอประเมินผล'
		WHEN adj.[STATUS] = 3 THEN  'รอผู้อนุมัติคนที่ 1'
		WHEN adj.[STATUS] = 4 THEN  'รอผู้อนุมัติคนที่ 2'
		WHEN adj.[STATUS] = 5 THEN  'รอผู้อนุมัติคนที่ 3'
		WHEN adj.[STATUS] = 6 THEN  'รอผู้อนุมัติคนที่ 4'
		WHEN adj.[STATUS] = 7 THEN  'รอผู้อนุมัติคนที่ 5'
		WHEN adj.[STATUS] = 8 THEN  'รอผู้อนุมัติคนที่ 6'
        WHEN adj.[STATUS] = 9 THEN  'อนุมัติ'
		WHEN adj.[STATUS] = 10 THEN  'ไม่อนุมัติ'
		ELSE NULL 
	 END AS STATUS_TEXT

    ,adj.CREATED_BY
	,CONCAT([user].INITIAL_NAME, ' ', [user].FIRST_NAME, ' ', [user].LAST_NAME) AS CREATED_NAME

FROM OJT.dbo.ADJUST_COURSE AS adj
JOIN OJT.dbo.DEPARTMENT AS dep ON adj.DEPARTMENT_ID = dep.ID
JOIN OJT.dbo.SECTION AS sec ON sec.ID = dep.SECTION_ID
JOIN OJT.dbo.[LOCATION] AS loc ON adj.LOCATION_ID = loc.ID
JOIN OJT.dbo.TEACHER AS tea ON adj.TEACHER_ID = tea.ID
JOIN OJT.dbo.SYSTEM_USERS as [user] on [user].ID = adj.CREATED_BY
GO
/****** Object:  View [dbo].[COURSE_AND_EMPLOYEE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[COURSE_AND_EMPLOYEE] AS
SELECT 
	adj.ID AS COURSE_ID
	,adj.COURSE_NUMBER
	,adj.TIMES
	,adj.COURSE_NAME
	,adj.[START_DATE]
	,adj.[END_DATE]
	,adj.START_TIME
	,adj.END_TIME
	,adj.TOTAL_HOURS
	,dep.DEPARTMENT_NAME
    ,sec.ID SECTION_ID
    ,sec.SECTION_NAME
	,loc.LOCATION_NAME
	,CONCAT(tea.INITIAL_NAME, ' ', tea.FIRST_NAME, ' ', tea.LAST_NAME) AS TEACHER_NAME
	,adj.DETAIL
	,adj.OBJECTIVE
	,adj.EVALUATED_DATE

	,person.PersonCode
	,ini.InitialT
	,person.FnameT
	,person.LnameT
	,CONCAT(ini.InitialT,' ',person.FnameT, ' ',person.LnameT) AS EMPLOYEE_NAME_TH
    ,position.PositionNameT AS POSITION_NAME_TH

    ,person.PersonID
	,ini.InitialE
	,person.FnameE
	,person.LnameE
	,CONCAT(ini.InitialE,' ',person.FnameE, ' ',person.LnameE) as EMPLOYEE_NAME_EN
    ,position.PositionNameE AS POSITION_NAME_EN
    ,CONVERT(varchar,person.StartDate,23) AS EMPLOYEE_START_DATE
	,person.PersonPic

    ,eval.ID AS EVALUATE_ID
	,eval.IS_EVALUATED
	,eval.SCORE_1
	,eval.SCORE_2
	,eval.SCORE_3
	,eval.SCORE_4
	,eval.SCORE_5
	,ROUND(eval.TOTAL_SCORE,2) TOTAL_SCORE
    ,ROUND(eval.EXAM_SCORE,2) EXAM_SCORE

    ,[user].[ID] CREATED_ID
	,CONCAT([user].INITIAL_NAME, ' ', [user].FIRST_NAME, ' ', [user].LAST_NAME) AS CREATED_NAME

    ,adj.[STATUS] AS STATUS_CODE
	,CASE 
		WHEN adj.[STATUS] = 1 THEN  'Choose employees'
		WHEN adj.[STATUS] = 2 THEN  'Waiting for evaluation'
		WHEN adj.[STATUS] = 3 THEN  'Waiting for the 1st approver'
		WHEN adj.[STATUS] = 4 THEN  'Waiting for the 2nd approver'
		WHEN adj.[STATUS] = 5 THEN  'Waiting for the 3rd approver'
		WHEN adj.[STATUS] = 6 THEN  'Waiting for the 4th approver'
		WHEN adj.[STATUS] = 7 THEN  'Waiting for the 5th approver'
		WHEN adj.[STATUS] = 8 THEN  'Waiting for the 6th approver'
        WHEN adj.[STATUS] = 9 THEN  'Approved'
		WHEN adj.[STATUS] = 10 THEN  'Rejected'
		ELSE NULL 
	 END AS STATUS_TEXT

	 ,adj.IS_EXAM_EVALUATE
	 ,adj.IS_REAL_WORK_EVALUATE
	 ,adj.[IS_OTHER_EVALUATE]
     ,adj.[OTHER_EVALUATE_REMARK]

FROM Cyberhrm.dbo.PNT_Person AS person

JOIN Cyberhrm.dbo.PNM_Initial AS ini ON person.InitialID = ini.InitialID
JOIN Cyberhrm.dbo.PNM_Position AS position ON position.PositionID = person.PositionID 

JOIN OJT.dbo.EVALUATE AS eval ON person.PersonID = eval.PERSON_ID
JOIN OJT.dbo.ADJUST_COURSE AS adj ON eval.COURSE_ID = adj.ID
JOIN OJT.dbo.DEPARTMENT AS dep ON adj.DEPARTMENT_ID = dep.ID
JOIN OJT.dbo.SECTION AS sec ON dep.SECTION_ID = sec.ID
JOIN OJT.dbo.[LOCATION] AS loc ON adj.LOCATION_ID = loc.ID
JOIN OJT.dbo.TEACHER AS tea ON adj.TEACHER_ID = tea.ID
JOIN OJT.dbo.SYSTEM_USERS as [user] on [user].ID = adj.CREATED_BY
GO
/****** Object:  View [dbo].[VIEW_CLERK_NOTIFICATION]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_CLERK_NOTIFICATION] AS
SELECT 
    notify.ID
    ,notify.CREATED_AT
    ,notify.[READ]
    ,notify.APPROVE_RESULT
    
    ,adj.COURSE_NUMBER
    ,adj.COURSE_NAME
    
    ,usr.ID USER_ID
    ,usr.FIRST_NAME
    ,usr.LAST_NAME

FROM CLERK_NOTIFICATION notify
JOIN ADJUST_COURSE adj ON adj.ID = notify.COURSE_ID
JOIN SYSTEM_USERS usr ON usr.ID = adj.CREATED_BY
GO
/****** Object:  View [dbo].[VIEW_PLAN]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_PLAN] AS
SELECT
    p.ID
    ,d.DEPARTMENT_NAME
    ,p.PLAN_NAME
    ,p.REF_DOCUMENT
    ,p.[HOURS]
    ,p.FREQUENCY
    ,p.SM_MG
    ,p.SAM_AM
    ,p.SEG_SV
    ,p.EG_ST
    ,p.FM
    ,p.LD_SEP_EP
    ,p.OP
    ,p.PLAN_DATE
    ,p.ACTUAL_DATE
    ,p.TRAINER
    ,u.ID UPDATED_ID
    ,u.USERNAME UPDATED_USERNAME
    ,CONCAT(u.FIRST_NAME, ' ', u.LAST_NAME) UPDATED_FULLNAME
FROM TRAINING_PLAN p
JOIN DEPARTMENT d ON d.ID = p.DEPARTMENT_ID
JOIN SYSTEM_USERS u ON u.ID = p.CREATED_BY

GO
ALTER TABLE [dbo].[ADJUST_COURSE] ADD  CONSTRAINT [DF_ADJUST_COURSE_IS_EVALUATED]  DEFAULT ((0)) FOR [STATUS]
GO
ALTER TABLE [dbo].[ADJUST_COURSE] ADD  CONSTRAINT [DF_ADJUST_COURSE_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[APPROVAL] ADD  DEFAULT ((0)) FOR [IS_APPROVED]
GO
ALTER TABLE [dbo].[APPROVAL] ADD  DEFAULT ((0)) FOR [APPROVAL_SEQUENCE]
GO
ALTER TABLE [dbo].[CLERK_NOTIFICATION] ADD  CONSTRAINT [DF_CLERK_NOTIFICATION_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[CLERK_NOTIFICATION] ADD  CONSTRAINT [DF_CLERK_NOTIFICATION_READ]  DEFAULT ((0)) FOR [READ]
GO
ALTER TABLE [dbo].[DEPARTMENT] ADD  CONSTRAINT [DF_DEPARTMENT_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[EVALUATE] ADD  CONSTRAINT [DF_EVALUATED_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[EVALUATE] ADD  CONSTRAINT [DF_EVALUATE_EXAM_SCORE]  DEFAULT ((0)) FOR [EXAM_SCORE]
GO
ALTER TABLE [dbo].[LOCATION] ADD  CONSTRAINT [DF_LOCATION_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[PLAN_AND_COURSE] ADD  CONSTRAINT [DF_PLAN_AND_COURSE_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[SECTION] ADD  CONSTRAINT [DF_SECTION_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[SYSTEM_LOG] ADD  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[SYSTEM_USERS] ADD  CONSTRAINT [DF_SYSTEM_USERS_IS_ACTIVE]  DEFAULT ((1)) FOR [IS_ACTIVE]
GO
ALTER TABLE [dbo].[SYSTEM_USERS] ADD  CONSTRAINT [DF_SYSTEM_USERS_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[TEACHER] ADD  CONSTRAINT [DF_TEACHER_CREATED_AT]  DEFAULT (getdate()) FOR [CREATED_AT]
GO
ALTER TABLE [dbo].[TRAINING_PLAN] ADD  DEFAULT (getdate()) FOR [CREATED_AT]
GO
/****** Object:  StoredProcedure [dbo].[GET_TIGER_EMPLOYEE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_TIGER_EMPLOYEE]
    @courseId int
AS
BEGIN
   SELECT TOP 1100 p.PersonID , 
        CONCAT(p.PersonCode, SPACE(8 - LEN(p.PersonCode)), ' ', p.FnameT, ' ', p.LnameT, '  (', Cmb2NameT ,')') fullName,  
        IIF(e.PERSON_ID = p.PersonID, 1, 0) as selected  
    FROM Cyberhrm.dbo.PNT_Person p  
    INNER JOIN Cyberhrm.dbo.PNM_Cmb2 c ON c.Cmb2ID = p.Cmb2ID  
    LEFT JOIN OJT.dbo.EVALUATE e ON e.PERSON_ID = p.PersonID AND e.COURSE_ID = @courseId 
    WHERE p.ResignStatus = 1 AND p.ChkDeletePerson = 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_APPROVAL_LIST]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[SP_APPROVAL_LIST]
    @USER_ID /*parameter name*/ int,
    @LIMIT INT = 100
-- add more stored procedure parameters here
AS
BEGIN
    -- body of the stored procedure
   SELECT TOP (@LIMIT) * FROM ( 
        SELECT
        ADJ.ID COURSE_ID
        ,COURSE_NUMBER 
        ,COURSE_NAME 
        ,DEPARTMENT_NAME 
        ,[STATUS] 
        ,(SELECT SUM(CAST(ISNULL(APPROVAL_RESULT,0) AS INT)) FROM APPROVAL WHERE COURSE_ID = ADJ.ID) COUNT_APPROVED_RESULT 
        ,(SELECT APPROVAL_SEQUENCE FROM APPROVAL WHERE COURSE_ID = ADJ.ID AND PERSON_ID = @USER_ID) APPROVAL_SEQUENCE 
        ,(SELECT ID FROM APPROVAL WHERE COURSE_ID = ADJ.ID AND PERSON_ID = @USER_ID) APPROVAL_ID 
        ,iif(ADJ.IS_EXAM_EVALUATE = 0 AND ADJ.IS_REAL_WORK_EVALUATE = 0 AND ADJ.IS_OTHER_EVALUATE = 1,1,0) IS_OTHER_ONLY
		FROM ADJUST_COURSE ADJ 
        JOIN DEPARTMENT DEP ON DEP.ID = ADJ.DEPARTMENT_ID 
        WHERE [STATUS] >= 3 AND [STATUS] < 9
        AND (ASSESSOR1_ID = @USER_ID 
        OR ASSESSOR2_ID = @USER_ID 
        OR ASSESSOR3_ID = @USER_ID 
        OR ASSESSOR4_ID = @USER_ID 
        OR ASSESSOR5_ID = @USER_ID 
        OR ASSESSOR6_ID = @USER_ID) 
        ) DATA 
        WHERE COUNT_APPROVED_RESULT+1 = APPROVAL_SEQUENCE
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DASHBOARD_CARD_CLERK]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[SP_DASHBOARD_CARD_CLERK]
    @personId /*parameter name*/ int
-- add more stored procedure parameters here
AS
BEGIN
    -- body of the stored procedure
    SELECT 
        CREATED_ID
        ,COUNT(CASE WHEN CREATED_ID = @personId THEN 1 END) AS ALL_COURSE_COUNT
        ,COUNT(CASE WHEN CREATED_ID = @personId AND YEAR(START_DATE) = YEAR(GETDATE()) THEN 1 END) AS TRAINED_THIS_YEAR
        ,COUNT(CASE WHEN CREATED_ID = @personId AND STATUS_CODE = 2 THEN 1 END) AS WAITING_FOR_EVALUATION
        ,COUNT(CASE WHEN CREATED_ID = @personId AND (STATUS_CODE > 2 AND STATUS_CODE <= 8 ) THEN 1 END) AS WAITING_FOR_APPROVAL

    FROM COURSE_AND_EMPLOYEE
    WHERE CREATED_ID = @personId
    GROUP BY CREATED_ID
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DASHBOARD_CARD_USER]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[SP_DASHBOARD_CARD_USER]
    @personId /*parameter name*/ int
-- add more stored procedure parameters here
AS
BEGIN
    -- body of the stored procedure
    SELECT 
        PersonID
        ,COUNT(CASE WHEN PersonID = @personId THEN 1 END) AS ALL_COURSE_COUNT
        ,COUNT(CASE WHEN PersonID = @personId AND YEAR(START_DATE) = YEAR(GETDATE()) THEN 1 END) AS TRAINED_THIS_YEAR
        ,COUNT(CASE WHEN PersonID = @personId AND STATUS_CODE = 2 THEN 1 END) AS WAITING_FOR_EVALUATION
        ,COUNT(CASE WHEN PersonID = @personId AND (STATUS_CODE > 2 AND STATUS_CODE <= 8 ) THEN 1 END) AS WAITING_FOR_APPROVAL

    FROM COURSE_AND_EMPLOYEE
    WHERE PersonID = @personId
    GROUP BY PersonID
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_COURSE]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[SP_DELETE_COURSE]
    @COURSE_ID INT
-- add more stored procedure parameters here
AS
BEGIN
    -- body of the stored procedure
    DELETE FROM ADJUST_COURSE WHERE ID=@COURSE_ID
    DELETE FROM APPROVAL WHERE COURSE_ID=@COURSE_ID
    DELETE FROM EVALUATE WHERE COURSE_ID=@COURSE_ID
    DELETE FROM PLAN_AND_COURSE WHERE COURSE_ID=@COURSE_ID

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SKILL_MAP]    Script Date: 03/May/2022 15:53:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[SP_SKILL_MAP]
    @sectionName NVARCHAR(MAX),
    @startDate NVARCHAR(10),
    @endDate NVARCHAR(10)
-- add more stored procedure parameters here
AS
BEGIN
    DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX)

SELECT @cols = STUFF((SELECT ',' + QUOTENAME(COURSE_NAME) 
                    FROM COURSE_AND_EMPLOYEE
                    WHERE SECTION_NAME = @sectionName AND STATUS_CODE = 9
                    AND 1+0 = (CASE WHEN (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE p.COURSE_ID = COURSE_AND_EMPLOYEE.COURSE_ID) > 0 THEN 1 ELSE 0 END)
                    GROUP BY COURSE_NAME, DEPARTMENT_NAME
					ORDER BY DEPARTMENT_NAME
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

SET @query = 'SELECT 
                PersonCode [EMP. CODE]
                ,[NAME]
                ,EMPLOYEE_START_DATE [START_DATE]
                ,POSITION_NAME_TH [POSITION]
                ,' + @cols + ' 
                ,PLAN_A [PLAN (A)]
                ,PLAN_B [PLAN (B)]
                ,CAST(CAST(PLAN_B AS DECIMAL(7,2)) / CAST(PLAN_A AS DECIMAL(7,2)) * 100 AS DECIMAL(7,2)) AS [(B / A * 100)]
                ,PLAN_A-PLAN_B AS [ระบุจำนวนงาน(Specify job no.)]
            FROM 
             (
                SELECT 
                    PersonCode
                    ,CONCAT(FnameE, '' '',LnameE) [NAME]
                    ,EMPLOYEE_START_DATE
                    ,POSITION_NAME_TH
                    ,COURSE_NAME
                    ,(SELECT COUNT(*) FROM COURSE_AND_EMPLOYEE c WHERE c.PersonID = COURSE_AND_EMPLOYEE.PersonID) PLAN_A
                    ,(SELECT COUNT(CASE WHEN TOTAL_SCORE > 50 THEN 1 END) FROM COURSE_AND_EMPLOYEE c WHERE c.PersonID = COURSE_AND_EMPLOYEE.PersonID) PLAN_B
                    ,TOTAL_SCORE
                FROM COURSE_AND_EMPLOYEE
                WHERE SECTION_NAME = '''+@sectionName+'''
                    AND START_DATE BETWEEN '''+ @startDate +''' AND '''+ @endDate +'''
					AND STATUS_CODE = 9
                    AND 1+0 = (CASE WHEN (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE p.COURSE_ID = COURSE_AND_EMPLOYEE.COURSE_ID) > 0 THEN 1 ELSE 0 END)
            ) x
            pivot 
            (
                MAX(TOTAL_SCORE)
                FOR COURSE_NAME IN (' + @cols + ')
            ) p '

execute(@query);
END
GO
USE [master]
GO
ALTER DATABASE [OJT] SET  READ_WRITE 
GO