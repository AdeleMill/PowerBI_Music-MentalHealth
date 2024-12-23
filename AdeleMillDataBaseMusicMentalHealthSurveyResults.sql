
/*

Music & Mental Health Survey Results
https://www.kaggle.com/datasets/catherinerasgaitis/mxmh-survey-results

tables
Basis -- id PK , Timestamp,Age, Music effects, Permissions
Statistic - id pk, Primary streaming service,Hours per day nn, While working
SelfMusic - id pk, Instrumentalist,Composer
Preferences -id pk, Fav genre,Exploratory,Foreign languages,BPM
Genre - id PK, Classical, Country etc
Diagnose -  id PK, Anxiety, Depression, Insomnia, OCD

Discription of columns and tables:
Timestamp - Date and time when form was submitted,
Age - Respondent's age,
Primary streaming service - Respondent's primary streaming service,
Hours per day - Number of hours the respondent listens to music per day,
While working - Does the respondent listen to music while studying/working?,
Instrumentalist -Does the respondent play an instrument regularly?,
Composer - Does the respondent compose music?,
Fav genre - Respondent's favorite or top genre,
Exploratory - Does the respondent actively explore new artists/genres?,
Foreign languages - Does the respondent regularly listen to music with lyrics in a language they are not fluent in?,
BPM - Beats per minute of favorite genre,
Genre Frequency - How frequently the respondent listens to music of this genre?,
Diagnose - Self-reported diagnose, on a scale of 0-10, 
Music effects - Does music improve/worsen respondent's mental health conditions?, 
Permissions - Permissions to publicize data

*/

Use master
GO
Create database MusicMentalHealthSurveyResults
GO
Use MusicMentalHealthSurveyResults
GO

Begin tran
Alter table dbo.mxmh_survey_results
ADD ID int Identity(1,1) Constraint mxmh_survey_results_ID_Identity_PK Primary Key
;
select *
from dbo.mxmh_survey_results
;
Commit
GO

Create table Statistic
					(
					ID int Constraint Statistic_ID_PK Primary key,
					PrimaryStreamingService varchar(50), 
					HoursPerDay float NOT NULL,
					WhileWorking varchar(10)
					)
GO

Insert into Statistic(ID, PrimaryStreamingService, HoursPerDay, WhileWorking)
select a.ID, a.Primary_streaming_service, a.Hours_per_day, a.While_working
from dbo.mxmh_survey_results as a
GO

Create table Basis 
			( 
			ID int Constraint Basis_ID_pk  Primary key 
			Constraint Statistic_ID_fk foreign key references Statistic(ID),
			Timestamp datetime DEFAULT Getdate(),
			Age int,
			MusicEffects varchar(20) Default 'No value', 
			Permission varchar(20)
			)
GO

Insert into Basis (ID, Timestamp, Age, MusicEffects, Permission)
select a.ID, a.Timestamp, a.Age, a.Music_effects, a.Permissions
from dbo.mxmh_survey_results as a
GO

Create table SelfMusic
					( ID int Constraint SelfMusic_ID_PK Primary key,
					Instrumentalist varchar(10) ,
					Composer varchar(10)
					)
GO

Insert into SelfMusic(ID, Instrumentalist, Composer)
select a.ID, a.Instrumentalist, a.Composer
from dbo.mxmh_survey_results as a
GO

Create table Preferences
					( ID int Constraint Preferences_ID_PK Primary key,
					FavGenre varchar(50),
					Exploratory varchar(10),
					ForeignLanguages varchar(10),
					BPM int
					)
GO

Insert into Preferences(ID, FavGenre, Exploratory, ForeignLanguages, BPM)
select a.ID, a.Fav_genre, a.Exploratory, a.Foreign_languages, a.BPM
from dbo.mxmh_survey_results as a
GO

Create table GenreFrequency
				(ID int Constraint GenreFrequency_ID_PK Primary key,
				Classical varchar(50),
				Country varchar(50),
				EDM varchar(50),
				Folk varchar(50),
				Gospel  varchar(50),
				HipHop varchar(50),
				Jazz varchar(50),
				KPop varchar(50),
				Latin varchar(50),
				Lofi varchar(50),
				Metal varchar(50),
				Pop varchar(50),
				RandB varchar(50),
				Rap varchar(50),
				Rock varchar(50),
				VideoGameMusic varchar(50)
				)
GO

Insert into GenreFrequency(ID, Classical, Country, EDM, Folk, 
							Gospel, HipHop, Jazz, KPop, 
							Latin, Lofi, Metal, Pop, 
							RandB, Rap, Rock, VideoGameMusic)
select a.ID, a.Frequency_Classical, a.Frequency_Country,  a.Frequency_EDM, a.Frequency_Folk,
		a.Frequency_Gospel, a.Frequency_Hip_hop, a.Frequency_Jazz, a.Frequency_K_pop, 
		a.Frequency_Latin, a.Frequency_Lofi, a.Frequency_Metal, a.Frequency_Pop, 
		a.Frequency_R_B, a.Frequency_Rap, a.Frequency_Rock, a.Frequency_Video_game_music
from dbo.mxmh_survey_results as a
GO

Create table Diagnose
					(ID int Constraint Diagnose_ID_PK Primary key,
					Anxiety float NOT NULL,
					Depression float NOT NULL,
					Insomnia float NOT NULL,
					OCD float NOT NULL
					)
GO

Insert into Diagnose(ID, Anxiety, Depression, Insomnia, OCD)
select a.ID, a.Anxiety, a.Depression, a.Insomnia, a.OCD
from dbo.mxmh_survey_results as a
GO
;

/*

tables
Basis -- id PK , Timestamp, Age, Music effects, Permissions
Statistic - id pk, Primary streaming service,Hours per day nn, While working
SelfMusic - id pk, Instrumentalist,Composer
Preferences -id pk, Fav genre,Exploratory,Foreign languages, BPM
Genre - id PK, Classical, Country etc
Diagnose -  id PK, Anxiety, Depression, Insomnia, OCD

*/

-- Frequence of Favorite Genre
Select count(p.FavGenre) as frequence, p.FavGenre
from Diagnose as d
join Preferences as p
on p.ID = d.ID
Group by p.FavGenre
order by frequence desc
;

-- Does music improve/worsen respondent's mental health conditions?
select count(MusicEffects) as Frequence, MusicEffects
from basis
Group by MusicEffects
;

--How many respondents with Depression
Select count(ID)
from Diagnose
where Depression > 6 
;

-- Music Effect improve for respondents with Depression
select count(b.MusicEffects) as  improve 
from Basis as b
join Diagnose as d
on b.ID = d.ID
join Statistic as s
on s.ID = b.ID
where b.MusicEffects = 'improve' and d.Depression > 6 and s.HoursPerDay > 1
;

-- No Music Effect for respondents with Depression
select count(b.MusicEffects) as  'No effect'
from Basis as b
join Diagnose as d
on b.ID = d.ID
join Statistic as s
on s.ID = b.ID
where b.MusicEffects = 'No effect' and d.Depression > 6 and s.HoursPerDay > 1
;

-- Music Effect worsen for respondents with Depression
select count(b.MusicEffects) as  'Worsen'
from Basis as b
join Diagnose as d
on b.ID = d.ID
join Statistic as s
on s.ID = b.ID
where b.MusicEffects = 'Worsen' and d.Depression > 6 and s.HoursPerDay > 1
;

-- How many respondents with Depression explore new artists/genres?
Select count(p.Exploratory)
from Preferences as p
join Diagnose as d
on d.Id = p.ID
where p.Exploratory = 'Yes' and d.Depression > 6
;

-- How many respondents with Depression doesn't explore new artists/genres?
Select count(p.Exploratory)
from Preferences as p
join Diagnose as d
on d.Id = p.ID
where p.Exploratory = 'No' and d.Depression > 6
;