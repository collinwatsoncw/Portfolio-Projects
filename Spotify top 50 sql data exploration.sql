Select * from [dbo].[top50_Energy]
order by 1, 2


Select Artist_name, Genre, Energy, Danceability, Ranking
From [dbo].[top50_Energy]
order by energy


--Shows how music translates to physical Expression
Select Artist_name, Genre, (Energy+Danceability) as Excitement_grade, Ranking
From [dbo].[top50_Energy]
order by Excitement_grade

--Shows Excitement for pop genres
Select Artist_name, Genre, (Energy+Danceability) as Excitement_grade, Ranking
From [dbo].[top50_Energy]
where Genre like '%pop%'
order by Excitement_grade


--Shows AVG BPM for Genres outside of POP
Select AVG(Beats_Per_Minute) as AverageBPM 
From [dbo].[top50_Energy]
Where Genre not like '%pop%'


-- Shows Average Energy per genre and reorders genres according to Energy

Select AVG(Energy) as AVEnergy, Genre
From [dbo].[top50_Energy]
Group by Genre
Order by AVEnergy Desc



--Shows Average Excitement grade per Genre in order
Select Genre, AVG(Energy+Danceability) as Excitement_grade
From [dbo].[top50_Energy]
Group by Genre
order by Excitement_grade Desc

--Shows Average Energy per artist in order
Select AVG(Energy) as AVEnergy, Artist_name
From [dbo].[top50_Energy]
Group by Artist_name
Order by AVEnergy Desc

--Shows Max Danceability per artist in order
Select Max(Danceability) as Mdance, Artist_name
From [dbo].[top50_Energy]
Group by Artist_name
Order by Mdance Desc



-- Shows Popularity ranking compared to energy levels of songs
Select  top50_Energy.genre, top50_Energy.Artist_name, top50_Popularity.Popularity, top50_Energy.Energy
From [dbo].[top50_Energy] Full Join [dbo].[top50_Popularity]
on top50_Energy.genre = top50_popularity.genre
Order by Popularity Desc


-- Shows the sum of the averages of popularity and energy as a reference to artists listenability 
Select  top50_Energy.Artist_name, AVG(top50_Energy.Energy + top50_Energy.Danceability + top50_Popularity.Popularity) as Total_grade
 From [dbo].[top50_Energy] Full Join [dbo].[top50_Popularity]
on top50_Energy.Artist_name = top50_popularity.Artist_name
Group by top50_Energy.Artist_name
Order by Total_grade Desc;

-- Shows the sum of the averages of popularity and energy as a reference to Genres outside of pop and their listenability 
Select  top50_Energy.genre, AVG(top50_Energy.Energy + top50_Energy.Danceability + top50_Popularity.Popularity) as Total_grade
From [dbo].[top50_Energy] Full Join [dbo].[top50_Popularity]
on top50_Energy.genre = top50_popularity.genre
Where top50_Energy.genre not like '%pop%'
Group by top50_Energy.genre
Order by Total_grade Desc

-- Create View for later Visualizations

Create View Total_Grade_of_Artists as
Select  top50_Energy.Artist_name, AVG(top50_Energy.Energy + top50_Energy.Danceability + top50_Popularity.Popularity) as Total_grade
 From [dbo].[top50_Energy] Full Join [dbo].[top50_Popularity]
on top50_Energy.Artist_name = top50_popularity.Artist_name
Group by top50_Energy.Artist_name
