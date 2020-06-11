/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select  distinct(Mb.firstname + ' ' +Mb.surname) As MemberName,Fac.membercost As MemberCost from dbo.Members Mb
left join Bookings Bk on Mb.memid = Bk.memid
left join Facilities Fac on Bk.facid = Fac.facid
where Fac.membercost > 0


/* Q2: How many facilities do not charge a fee to members? */

select  count(distinct(Mb.firstname +' '+ Mb.surname) ) As Membercount 
from dbo.Members Mb
left join Bookings Bk on Mb.memid = Bk.memid
left join Facilities Fac on Bk.facid = Fac.facid
where Fac.membercost = 0

/* List of facilities do not charge a fee to members */ 

select  distinct(Mb.firstname + ' ' +Mb.surname) As MemberName,Fac.membercost As MemberCost from dbo.Members Mb
left join Bookings Bk on Mb.memid = Bk.memid
left join Facilities Fac on Bk.facid = Fac.facid
where Fac.membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select  facid, Name , membercost,monthlymaintenance  
from dbo.Facilities where membercost < (monthlymaintenance/100)*20

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
select * from dbo.Facilities where facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
select *,'cheap' from dbo.Facilities where monthlymaintenance <= 100
union all
select *,'expensive' from dbo.Facilities where monthlymaintenance > 100
order by facid

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
select  firstname +' '+ surname from dbo.Members where  joindate = (select max(joindate) from Members)

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select  distinct(Mb.firstname +' '+ Mb.surname), Fac.name As FacilityName
from dbo.Members Mb
left join Bookings Bk on Mb.memid = Bk.memid
left join Facilities Fac on Bk.facid = Fac.facid
where Fac.name like 'tennis court%'
order by Mb.firstname +' '+ Mb.surname

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select  distinct(Mb.firstname +' '+ Mb.surname) As MemberName, Fac.name As FacilityName,Fac.membercost+Fac.guestcost As TotCost
from dbo.Members Mb
left join Bookings Bk on Mb.memid = Bk.memid
left join Facilities Fac on Bk.facid = Fac.facid
where Bk.starttime like '2012-09-14%' and Fac.membercost+Fac.guestcost >30
order by Mb.firstname +' '+ Mb.surname

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

select  distinct(Mb.firstname +' '+ Mb.surname) As MemberName, Fac.name As FacilityName,Fac.membercost+Fac.guestcost As TotCost
from dbo.Members Mb,Bookings Bk,Facilities Fac
where Mb.memid = Bk.memid
and Bk.facid = Fac.facid
and Bk.starttime between '2012-08-01 08:00:00' and '2012-08-31 08:00:00'
and Fac.membercost+Fac.guestcost >30
order by Mb.firstname +' '+ Mb.surname

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

select (membercost+guestcost+initialoutlay+monthlymaintenance) TotRev,name 
from Facilities 
where (membercost+guestcost+initialoutlay+monthlymaintenance) >1000
