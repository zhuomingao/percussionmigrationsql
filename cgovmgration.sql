drop table #folder
;with folders as (
					  select null as ParentID, f.ContentID as ID, cs.title as FolderName, 
					convert(varchar(512),'') as Path, 1 as level 
					  from PSX_folder f join contentstatus cs on f.contentid = cs.contentid
					  where cs.contentid = 305
					  UNION ALL
					  select r.owner_ID as ParentID, f.contentid as ID, cs.title as FolderName, 
					convert(varchar(512),folders.Path + '/' + cs.title) as Path , folders.level +1 
					  from PSX_folder f inner JOIN PSX_ObjectRelationship r  ON r.dependent_id = f.contentid
					  inner JOIN folders ON folders.ID = r.owner_id
					  inner join contentstatus cs on f.contentid = cs.contentid
				)
				
select * into #folder from folders

update #folder set FolderName = '' where ParentID is null


drop table #mini
select CONTENTID into #mini from contentstatus where CONTENTID  in
(916031,858227,859583,859634,14222,14304,1099430,909708,910917,910942,429220,1080199,14587,915971,883849,13054,911134,911505,14034,63867,1090830,1043595,941434,1026781,321607,1057088,866280,1074842,1117590,747150,828020,1038929,988378,1052650,1047566,1087420,1088972,768882,867853,810260,776914,1026249,1078650,936591,918974,912884,915080,1054479,105818,14879,956474,1091338,901508,1061048,1113026,951603,936686,936680,936681,936682,936685,951608,914801,916849,916766,1092431,915271,1011470,16360,1102955,1114852,951125,919000,922513,930168,915591,14257,1034951,866188,1061645,799546,1061727,799373,916695,1033175,916661,608324,1041143,917286,917517,941591,922315,941619,941622,941581,941598,176775,14272,102551,65156,905730,918912,65192,1104024,969702,970160,974319,1026805,425591,917733,917734)

drop table #d
select * into #d from
 (select 'updated' as date_display_mode union all select 'posted')a


drop table #summary 
select c.contentid as id, su.CDRID as field_pdq_cdr_id, c.title
into #summary
from CONTENTSTATUS c 
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
inner join #folder f on f.id = r.owner_id
inner join CT_PDQCANCERINFOSUMMARY su on c.CONTENTID = su.CONTENTID and c.CURRENTREVISION = su.REVISIONID
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
left outer join 
( PSX_OBJECTRELATIONSHIP rs inner join CONTENTSTATUS cs on cs.CONTENTID = rs.DEPENDENT_ID
inner join CT_PDQCANCERINFOSUMMARY sus on cs.CONTENTID = sus.CONTENTID and cs.CURRENTREVISION = sus.REVISIONID
) 
on rs.OWNER_ID = c.CONTENTID and rs.OWNER_REVISION = c.CURRENTREVISION and rs.CONFIG_ID = 6
where c.locale = 'en-us'
select * from #summary
for xml path , root ('rows')


drop table #summaryes 
select cs.contentid as id, c.CONTENTID as spanishid 
, su.cdrid as field_pdq_cdr_id 
, c.title, 'es' as langcode
into #summaryes
from CONTENTSTATUS c 
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
inner join #folder f on f.id = r.owner_id
inner join CT_PDQCANCERINFOSUMMARY su on c.CONTENTID = su.CONTENTID and c.CURRENTREVISION = su.REVISIONID
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
left outer join 
( PSX_OBJECTRELATIONSHIP rs inner join CONTENTSTATUS cs on cs.CONTENTID = rs.owner_id and cs.CURRENTREVISION = rs.OWNER_REVISION
inner join CT_PDQCANCERINFOSUMMARY sus on cs.CONTENTID = sus.CONTENTID and cs.CURRENTREVISION = sus.REVISIONID
) 
on rs.DEPENDENT_ID = c.contentid and rs.CONFIG_ID = 6
where c.locale = 'es-us'
and cs.TITLE is not null

select * from #summaryes
for xml path , root ('rows')



select c.contentid as id, su.CDRID as field_pdq_cdr_id, c.title
into #dis 
from CONTENTSTATUS c 
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
inner join #folder f on f.id = r.owner_id
inner join CT_PDQDRUGINFOSUMMARY su on c.CONTENTID = su.CONTENTID and c.CURRENTREVISION = su.REVISIONID
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID

select * from #dis 
for xml path , root ('rows')





--site section
drop table #en
select   
f.level
, rsubmenu.SORT_RANK
,case when f.Path = '' then '/' else f.Path end as computed_path,
coalesce(n.NAV_TITLE, landing.short_title, f.FolderName) as name 
,c.CONTENTID as term_id
, isnull(rp.DEPENDENT_ID, 0) as parent
, f.FolderName as field_pretty_url
, case when sectionNav.TITLE IS NOT null then 1 else 0 END AS field_section_nav_root
, case f.path when '' then 1 else 0 end as field_main_nav_root
, case  n.SHOW_IN_NAV when 1 then NULL else 'hide_in_section_nav' END as field_navigation_display_options
, landing.contentid as field_landing_page
, landing.SHORT_TITLE as description_value
, null as field_navigation_label	
, sectionNav.LEVELS_TO_SHOW as field_levels_to_display
,m.bodyfield as field_mega_menu_content
, case f.path when '' then 1 else 0 end as field_breadcrumb_root
, 'en' as langcode
into #en
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		left outer join (PSX_OBJECTRELATIONSHIP rsubmenu inner join RXSLOTTYPE slsub on rsubmenu.SLOT_ID  = slsub.SLOTID and SLOTNAME = 'rffNavSubmenu' inner join CONTENTSTATUS co on co.CONTENTID = rsubmenu.OWNER_ID and co.CURRENTREVISION = rsubmenu.OWNER_REVISION) 
			on rsubmenu.DEPENDENT_ID = c.CONTENTID 
		left outer join 
		(PSX_OBJECTRELATIONSHIP rp 
		inner join CONTENTSTATUS cpn on cpn.CONTENTID = rp.DEPENDENT_ID 
		inner join CONTENTTYPES tpn on tpn.CONTENTTYPEID = cpn.CONTENTTYPEID and tpn.CONTENTTYPENAME in ('rffNavon', 'rffNavtree') )
		 on rp.OWNER_ID = f.ParentID and rp.CONFIG_ID = 3
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVNAVMETADATA_CGVNAVMETADATA n on n.contentid = c.contentid and n.REVISIONID = c.CURRENTREVISION 
		 outer apply 
		 (select c1.contentid, p.SHORT_TITLE from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c1.CONTENTID and p.REVISIONID = c1.CURRENTREVISION
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'rffNavLandingPage' 
		) landing
		outer apply 
		 (select c1.contentid from PSX_OBJECTRELATIONSHIP r1 
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
		 where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and t1.contenttypename = 'cgvBreadcrumb' ) breadcrumb
			outer apply 
			(select c1.title, sn.LEVELS_TO_SHOW, sn.SECTION_NAV_TITLE 
			from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_NCISECTIONNAV sn on sn.CONTENTID = c1.CONTENTID and sn.REVISIONID = c1.CURRENTREVISION
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'nvcgSlSectionNav' ) sectionNav
			outer apply (select  h.BODYFIELD from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_GLORAWHTML h on h.CONTENTID = r1.DEPENDENT_ID and c1.CURRENTREVISION = h.REVISIONID 
		where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'nvcgSlMegamenuHtml' ) m
where t.CONTENTTYPENAME in ( 'rffNavon', 'rffNavtree')
and f.Path not like '/espanol%'
and f.Path not like '/bestbet%'
and f.Path not like '/configuration%'
and f.Path not like '/private%'
and f.Path not like '/shareditem%'
and f.Path not like '/image%'
and f.Path not like '/file%'
and f.Path not like '/sites/nano%'
and f.Path not like '/nci/rare-brain-spine-tumor%'
and f.Path not like 'nci/pediatric-adult-rare-tumor%'
order by 1,2





drop table #enpage
select 
t.CONTENTTYPENAME
, en.term_id 
, c.CONTENTID as id, p.LONG_TITLE as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),319) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL 
	then left(convert(nvarchar(max),p.LONG_DESCRIPTION),319) else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
, case  p.PUBLIC_USE when 1 then 1 else 0 end as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, case dd.DATE_DISPLAY_MODE when 1 then ( select 'posted' as date_display_mode for XML path('') , type, elements) when 4 then (select 'reviewed' as date_display_mode for XML path('') , type, elements) when 2 then 
	(select date_display_mode from #d for XML path('') , type, elements) END as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, p.BROWSER_TITLE as field_browser_title
,p.card_title as field_card_title
, o.INTRO_TEXT as field_intro_text
into #enpage
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		inner join CGVCONTENTDATES_CGVCONTENTDATES1 d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join CGVDATEDISPLAYMODE_CGVDATEDISPLAYMODE1 dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.CURRENTREVISION
		inner join #en en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME not in ('ncifile', 'nciLink',  'cgvDynamicList')
and CONTENTTYPENAME not like 'pdq%'
and CONTENTTYPENAME not like '%image%'
and CONTENTTYPENAME not like 'rffNav%'

insert into #enpage
select 
t.CONTENTTYPENAME
, en.term_id 
, c.CONTENTID as id, p.SHORT_TITLE as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),319) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL 
	then left(convert(nvarchar(max),p.LONG_DESCRIPTION),319) else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
,0 as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, case dd.DATE_DISPLAY_MODE when 1 then ( select 'posted' as date_display_mode for XML path('') , type, elements) when 4 then (select 'reviewed' as date_display_mode for XML path('') , type, elements) when 2 then 
	(select date_display_mode from #d for XML path('') , type, elements) END as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, p.BROWSER_TITLE as field_browser_title
,p.card_title as field_card_title
, o.INTRO_TEXT as field_intro_text
--into #enpage
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		inner join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join GLODATEDISPLAYMODE_GLODATEDISPLAYMODE dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.CURRENTREVISION
		inner join #en en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME = 'glovideo'




alter table #enpage alter column field_public_use bit null




--4 reviewed
--2 posted and updated
-- 1 posted

insert into #enpage 
select 
t.CONTENTTYPENAME
, en.term_id 
, c.CONTENTID as id
, left(c.title, charindex('[', c.title)-1) as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),319) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL 
	then left(convert(nvarchar(max),p.LONG_DESCRIPTION),319) else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
, 0
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, case dd.DATE_DISPLAY_MODE when 1 then ( select 'posted' as date_display_mode for XML path('') , type, elements) when 4 then (select 'reviewed' as date_display_mode for XML path('') , type, elements) when 2 then 
	(select date_display_mode from #d for XML path('') , type, elements) END as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, p.BROWSER_TITLE as field_browser_title
,p.card_title as field_card_title
, null
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		inner join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join GLODATEDISPLAYMODE_GLODATEDISPLAYMODE dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.CURRENTREVISION
		inner join #en en on en.computed_path = f.Path 
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME = 'gloinstitution'



-----------------------
drop table #folder
GO

;with folders as (
					  select null as ParentID, f.ContentID as ID, cs.title as FolderName, 
					convert(varchar(512),'') as Path, 1 as level
					  from PSX_folder f join contentstatus cs on f.contentid = cs.contentid
					  where cs.contentid = 6702
					  UNION ALL
					  select r.owner_ID as ParentID, f.contentid as ID, cs.title as FolderName, 
					convert(varchar(512),folders.Path + '/' + cs.title) as Path, folders.level + 1 
					  from PSX_folder f inner JOIN PSX_ObjectRelationship r  ON r.dependent_id = f.contentid
					  inner JOIN folders ON folders.ID = r.owner_id
					  inner join contentstatus cs on f.contentid = cs.contentid
				)
				
select * into #folder from folders


drop table #es
select   
f.level
, rsubmenu.sort_rank
 , case when f.Path = '' then '/' else f.Path end as computed_path,
coalesce(n.NAV_TITLE, landing.short_title, f.FolderName) as name 
,c.CONTENTID as term_id
, isnull(rp.DEPENDENT_ID, 0) as parent
, case when f.ID = 6702 then NULL else f.FolderName END as field_pretty_url
, case when sectionNav.TITLE IS NOT null then 1 else 0 END AS field_section_nav_root
, case f.path when '' then 1 else 0 end as field_main_nav_root
, case  n.SHOW_IN_NAV when 1 then NULL else 'hide_in_section_nav' END as field_navigation_display_options
, landing.contentid as field_landing_page
, landing.SHORT_TITLE as description_value
, null as field_navigation_label	
, sectionNav.LEVELS_TO_SHOW as field_levels_to_display
,m.bodyfield as field_mega_menu_content
, case f.path when '' then 1 else 0 end as field_breadcrumb_root
,'es' as langcode
into #es
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		left outer join (PSX_OBJECTRELATIONSHIP rsubmenu inner join RXSLOTTYPE slsub on rsubmenu.SLOT_ID  = slsub.SLOTID and SLOTNAME = 'rffNavSubmenu' inner join CONTENTSTATUS co on co.CONTENTID = rsubmenu.OWNER_ID and co.CURRENTREVISION = rsubmenu.OWNER_REVISION) 
			on rsubmenu.DEPENDENT_ID = c.CONTENTID 
		left outer join 
		(PSX_OBJECTRELATIONSHIP rp 
		inner join CONTENTSTATUS cpn on cpn.CONTENTID = rp.DEPENDENT_ID 
		inner join CONTENTTYPES tpn on tpn.CONTENTTYPEID = cpn.CONTENTTYPEID and tpn.CONTENTTYPENAME in ('rffNavon', 'rffNavtree') )
		 on rp.OWNER_ID = f.ParentID and rp.CONFIG_ID = 3
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVNAVMETADATA_CGVNAVMETADATA n on n.contentid = c.contentid and n.REVISIONID = c.CURRENTREVISION 
		 outer apply 
		 (select c1.contentid, p.SHORT_TITLE from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c1.CONTENTID and p.REVISIONID = c1.CURRENTREVISION
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'rffNavLandingPage' 
		) landing
		outer apply 
		 (select c1.contentid from PSX_OBJECTRELATIONSHIP r1 
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
		 where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and t1.contenttypename = 'cgvBreadcrumb' ) breadcrumb
			outer apply 
			(select c1.title, sn.LEVELS_TO_SHOW, sn.SECTION_NAV_TITLE 
			from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_NCISECTIONNAV sn on sn.CONTENTID = c1.CONTENTID and sn.REVISIONID = c1.CURRENTREVISION
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'nvcgSlSectionNav' ) sectionNav
			outer apply (select  h.BODYFIELD from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_GLORAWHTML h on h.CONTENTID = r1.DEPENDENT_ID and c1.CURRENTREVISION = h.REVISIONID 
		where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'nvcgSlMegamenuHtml' ) m
where t.CONTENTTYPENAME in ( 'rffNavon', 'rffNavtree')
order by 1



 
 update #es set name = 'espanol' where computed_path = '/'
 update #es set name = 'El cáncer' where computed_path = '/cancer'
 update #es set name = 'Tipos de cáncer' where computed_path = '/tipos'
 

drop table #espage1
select 
t.CONTENTTYPENAME
, en.term_id 
, c.CONTENTID as id
, p.LONG_TITLE as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),319) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL 
		then left(convert(nvarchar(max),p.LONG_DESCRIPTION),319) else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
, case p.PUBLIC_USE when 1 then 1 else 0 END as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, case dd.DATE_DISPLAY_MODE when 1 then ( select 'posted' as date_display_mode for XML path('') , type, elements) when 4 then (select 'reviewed' as date_display_mode for XML path('') , type, elements) when 2 then 
	(select date_display_mode from #d for XML path('') , type, elements) END as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, p.BROWSER_TITLE as field_browser_title
,p.card_title as field_card_title
, o.INTRO_TEXT as   field_intro_text
into #espage1
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		inner join CGVCONTENTDATES_CGVCONTENTDATES1 d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join CGVDATEDISPLAYMODE_CGVDATEDISPLAYMODE1 dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.CURRENTREVISION
		inner join #es en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION 
where c.LOCALE = 'es-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME not in ('ncifile', 'nciLink',  'cgvDynamicList')
and CONTENTTYPENAME not like 'pdq%'
and CONTENTTYPENAME not like '%image%'




insert into #espage1
select 
t.CONTENTTYPENAME
, en.term_id 
, c.CONTENTID as id, p.SHORT_TITLE as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),319) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL 
	then left(convert(nvarchar(max),p.LONG_DESCRIPTION),319) else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
,0 as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, case dd.DATE_DISPLAY_MODE when 1 then ( select 'posted' as date_display_mode for XML path('') , type, elements) when 4 then (select 'reviewed' as date_display_mode for XML path('') , type, elements) when 2 then 
	(select date_display_mode from #d for XML path('') , type, elements) END as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, p.BROWSER_TITLE as field_browser_title
,p.card_title as field_card_title
, o.INTRO_TEXT as field_intro_text
--into #enpage
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		inner join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join GLODATEDISPLAYMODE_GLODATEDISPLAYMODE dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.CURRENTREVISION
		inner join #es en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION
where c.LOCALE = 'es-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME = 'glovideo'




drop table #espage

select es.*
, (
 select distinct c1.contentid as englishid 
 from PSX_OBJECTRELATIONSHIP r inner join CONTENTSTATUS c1 on c1.CONTENTID = r.OWNER_ID and c1.CURRENTREVISION = r.OWNER_REVISION
	inner join #enpage en on en.id = c1.CONTENTID 
	where   r.DEPENDENT_ID = es.id and r.CONFIG_ID = 6
)  as englishid 
into #espage
from #espage1 es inner join CONTENTSTATUS c on es.id = c.CONTENTID 




---- Spanish pages which are not translation
insert into #enpage ( contenttypename,
term_id,
id,
title,
langcode,
field_short_title,
field_page_description,
field_feature_card_description,
field_list_description,
field_search_engine_restrictions,
field_public_use,
field_date_posted,
field_date_reviewed,
field_date_updated ,
field_pretty_url,
  field_browser_title
, field_card_title
,field_intro_text)
select  contenttypename,
term_id,
id,
title,
langcode,
field_short_title,
field_page_description,
field_feature_card_description,
field_list_description,
field_search_engine_restrictions,
field_public_use,
field_date_posted,
field_date_reviewed,
field_date_updated,
field_pretty_url,
  field_browser_title
, field_card_title
,field_intro_text
from #espage where englishid is null



------------------------------------------------------------------
------------------------------------------------------------------

drop table #para
select  p.id, 
p.id as para_id
, null as field_body_section_heading
, h.BODY  as content
, 'en' as langcode
, null as sortrank 
into #para
from #enpage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.CURRENTREVISION
where p.CONTENTTYPENAME not in ('cgvpressrelease', 'cgvblogpost', 'cgvfactsheet') 
and h.BODY is not null
and p.id not in (select contentid from #mini )
union all
select  p.id, 
h.SYSID
, left(q.s,254 ) 
,h.ANSWER, p.langcode
, h.SORTRANK
from #enpage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
left outer join CT_CGVFACTSHEET_Q_N_AS h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.CURRENTREVISION
cross apply dbo.gaotagsearch(convert(nvarchar(max),h.QUESTION), '<p>','</p>', null, 0) q
where p.CONTENTTYPENAME = 'cgvfactsheet' and h.ANSWER is not null
order by id, sortrank



drop table #espara
select  p.id, 
p.id as para_id
, null as field_body_section_heading
, h.BODY  as content
, 'es' as langcode
, null as sortrank 
into #espara
from #espage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.CURRENTREVISION
where p.CONTENTTYPENAME not in ('cgvpressrelease', 'cgvblogpost', 'cgvfactsheet') and h.BODY is not null
and p.id not in (select contentid from #mini )
union all
select  p.id, 
h.SYSID
, left(q.s,254 ) 
,h.ANSWER, p.langcode
, h.SORTRANK
from #espage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
left outer join CT_CGVFACTSHEET_Q_N_AS h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.CURRENTREVISION
cross apply dbo.gaotagsearch(convert(nvarchar(max),h.QUESTION), '<p>','</p>', null, 0) q
where p.CONTENTTYPENAME = 'cgvfactsheet' and h.ANSWER is not null
order by id, sortrank





--!! sitesection
drop table #s
select * into #s from
(
select 'hide_in_main_nav' as field_navigation_display_options
union all 
select 'hide_in_mobile_nav'
union all
select 'hide_in_section_nav'
)a


select
computed_path,
level,
sort_rank AS weight,
name,
term_id,
parent,
field_pretty_url,
field_section_nav_root,
field_main_nav_root,
case when field_navigation_display_options Is NOT null then (select field_navigation_display_options from #s for XML path('') , type, elements ) else null end ,
field_landing_page,
description_value,
field_navigation_label,
field_levels_to_display,
field_mega_menu_content,
field_breadcrumb_root,
langcode
from
(select * from #en union all select * from #es) a
order by 1
for xml path , root('rows')


--!! English para
SELECT
    1 AS Tag,
    NULL AS Parent,
    NULL AS 'rows!1!',
    NULL AS 'row!2!para_id',
    NULL AS 'row!2!langcode',
    NULL AS 'row!2!heading!CDATA',
    NULL AS 'row!2!content!CDATA'
UNION ALL
SELECT
    2 AS Tag,
    1 AS Parent,
    NULL, 
    para_id,
    langcode,
    field_body_section_heading,
    content
FROM #para 
where para_id is not null and content is not null
FOR XML EXPLICIT

-----------------
--!!Spanish para

SELECT
    1 AS Tag,
    NULL AS Parent,
    NULL AS 'rows!1!',
    NULL AS 'row!2!para_id',
    NULL AS 'row!2!langcode',
    NULL AS 'row!2!heading!CDATA',
    NULL AS 'row!2!content!CDATA'
UNION ALL
SELECT
    2 AS Tag,
    1 AS Parent,
    NULL, 
    para_id,
    langcode,
    field_body_section_heading,
    content
FROM #espara 
where para_id is not null and content is not null
FOR XML EXPLICIT

--------------------------------------------------------



-------------
---Homelanding
drop table #landing_content1
select 
p.id,  p.langcode 
, p.title 
, c1.CONTENTID as sublayoutid
, r.RID as sublayout_rid
, r.SORT_RANK as sublayout_rank
, sub.LAYOUT_TITLE  as sublayouttitle
, r.RID + 10000 * (case sl1.slotname when 'nvcgSlLayoutFeatureA' then 1 
when 'nvcgSlLayoutGuideB' then 2
when 'nvcgSlLayoutFeatureB' then 3
when 'nvcgSlLayoutGeneralA' then 4
when 'nvcgSlLayoutGeneralB' then 4
when 'nvcgSlLayoutThumbnailA' then 5
END)    as row_rid
, sl1.SLOTNAME 
, c2.CONTENTID as linkid 
, r1.RID as card_rid
, case when sl1.SLOTNAME = 'nvcgSlLayoutGeneralB' then 20+r1.SORT_RANK else r1.SORT_RANK END as card_rank
, t2.contenttypename 
into #landing_content1
from (select id, langcode, title  from #enpage union select id, langcode, title from #espage) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_CGVSUBLAYOUT sub on sub.CONTENTID = c1.CONTENTID and sub.REVISIONID = c1.CURRENTREVISION
left outer join (PSX_OBJECTRELATIONSHIP r1 
			inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
			 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
where sl.SLOTNAME  = 'nvcgSlBodyLayout'
and sl1.SLOTNAME in ('nvcgSlLayoutFeatureA','nvcgSlLayoutFeatureB', 'nvcgSlLayoutGuideB', 'nvcgSlLayoutGeneralB', 'nvcgSlLayoutGeneralA' , 'nvcgSlLayoutThumbnailA')
and c1.TITLE not like '%Multi%'




drop table #landing_contentMM
select 
 p.id,  p.langcode 
, p.title 
, c1.CONTENTID as sublayoutid
, r.RID as sublayout_rid
, r.SORT_RANK as sublayout_rank
, sub.LAYOUT_TITLE  as sublayouttitle
, r.RID + 10000 * (case sl1.slotname when 'nvcgSlLayoutMultimediaA' then 1
when 'nvcgSlLayoutFeatureB' then 1
when 'nvcgSlLayoutThumbnailA' then 5
END)    as row_rid
, sl1.SLOTNAME 
, c2.CONTENTID as linkid 
, r1.RID as card_rid
, case when sl1.SLOTNAME = 'nvcgSlLayoutGeneralB' then 20+r1.SORT_RANK else r1.SORT_RANK END as card_rank
, t2.contenttypename 
into #landing_contentMM
from (select id, langcode, title  from #enpage union select id, langcode, title from #espage) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_CGVSUBLAYOUT sub on sub.CONTENTID = c1.CONTENTID and sub.REVISIONID = c1.CURRENTREVISION
left outer join (PSX_OBJECTRELATIONSHIP r1 
			inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
			 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
where sl.SLOTNAME  = 'nvcgSlBodyLayout'
and c1.TITLE like '%multi%'
order by 1, sublayoutid , slotname, card_rank





-- raw html
insert into #landing_content1 (id, title, langcode, sublayoutid, sublayout_rid, sublayout_rank, row_rid )
select p.id, p.title
, p.langcode 
, c1.CONTENTID as sublayoutid
, r.RID as sublayout_rid
, r.SORT_RANK as sublayout_rank
, r.RID as row_rid
from (select id, langcode, title  from #enpage union select id, langcode , title from #espage) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where sl.SLOTNAME = 'nvcgSlBodyLayout'
and t1.CONTENTTYPENAME not like '%layout%'
order by id, r.SORT_RANK



drop table #landing_content
select * , ROW_NUMBER () over (partition by  id order by sublayout_rank, row_rid , card_rank ) as sort_rank
into #landing_content
from (select * from #landing_content1 union all select * from #landing_contentMM) a
order by id, sublayout_rank, row_rid  , card_rank




drop table #landinglistitem
select * into #landinglistitem from
(select   
lc.row_rid as parentid
,lc.card_rid as listitem_rid
, lc.langcode 
, lc.linkid 
, lc.contenttypename
, lc.card_rank as listitem_rank
from #landing_content lc 
where lc.SLOTNAME = 'nvcgSlLayoutThumbnailA'
union all
select 
c.CONTENTID 
, r.rid 
, LEFT( c.LOCALE,2) as landcode
, c1.contentid 
, t1.contenttypename 
, r.sort_rank
from CONTENTSTATUS c 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where c.CONTENTID in (select CONTENTID from #mini)
and sl.SLOTNAME = 'nvcgSlLayoutThumbnailA'
) a 


drop table #internallink1
select * into #internallink1 from
(
select 
r.rid  as internallink_id 
,  rc.DEPENDENT_ID as field_internal_link_target_id
, clink.OVERRIDE_TITLE as field_override_title
,en.langcode
from (select id, langcode from #enpage union all select id , langcode from #espage
) en inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CT_CGVCUSTOMLINK clink on clink.CONTENTID = c1.CONTENTID and clink.REVISIONID = c1.CURRENTREVISION
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join PSX_OBJECTRELATIONSHIP rc on rc.OWNER_ID = c1.CONTENTID and rc.OWNER_REVISION = c1.CURRENTREVISION
inner join rxslottype sc on sc.slotid = rc.SLOT_ID
where  sl.SLOTNAME in ( 'cgvRelatedPages' )
and t1.CONTENTTYPENAME = 'cgvcustomlink'
and sc.SLOTNAME = 'cgvCustomLink' and sc.slotid = 893
and t.CONTENTTYPENAME <> 'cgvCTHPGuideCard'
union all
select 
r.rid as internallink_id
,c1.contentid as field_internal_link_target_id
, NULL as field_override_title
,en.langcode
from 
(select id, langcode from #enpage 
	union all select id , langcode from #espage
	) en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
where  sl.SLOTNAME in ( 'cgvRelatedPages' )  and t1.CONTENTTYPENAME not like  '%link%'
union all
select listitem_rid, linkid, null, langcode
from #landinglistitem where contenttypename not like  '%link%'
union all
select ll.listitem_rid,  r.DEPENDENT_ID as field_internal_link_target_id
, clink.OVERRIDE_TITLE as field_override_title
,ll.langcode
from #landinglistitem ll inner join contentstatus c on c.contentid = ll.linkid 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join rxslottype sc on sc.slotid = r.SLOT_ID and sc.SLOTNAME = 'cgvCustomLink' and sc.slotid = 893
inner join CT_CGVCUSTOMLINK clink on clink.CONTENTID = c.CONTENTID and clink.REVISIONID = c.CURRENTREVISION
where contenttypename  like  '%link%'
) a 


drop table #internallink
select * into #internallink from 
(select i.*
from #internallink1 i inner join (select id from #enpage union all select ID from #summary union all select ID from #dis ) p on i.field_internal_link_target_id = p.id 
union all
select i.internallink_id, coalesce(p.englishid,p.id) as field_internal_link_target_id, field_override_title, i.langcode
from #internallink1 i inner join (select id, englishid from #espage union all select spanishid,ID from #summaryes ) p on i.field_internal_link_target_id = p.id 
) a


select internallink_id , field_internal_link_target_id, field_override_title, langcode 
from #internallink 
for xml path , root('rows')


----------------------
drop table #externallink1
select * into #externallink1 from
(
select r.dependent_id, r.RID as externallink_id
, l.URL as field_external_link_uri, l.SHORT_TITLE as field_override_title
, l.LONG_DESCRIPTION as field_override_list_description
, en.langcode
from (select id, langcode from #enpage union all select id, langcode from #espage
) en inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join CT_NCILINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.CURRENTREVISION
where sl.SLOTNAME in ( 'cgvRelatedPages' )
and t1.CONTENTTYPENAME = 'ncilink'
union all
select ll.linkid, ll.listitem_rid
, l.URL as field_external_link_uri, l.SHORT_TITLE as field_override_title
, l.LONG_DESCRIPTION as field_override_list_description
, ll.langcode
from #landinglistitem ll 
inner join CONTENTSTATUS c on c.CONTENTID = ll.linkid
inner join CT_NCILINK l on l.CONTENTID = c.CONTENTID and l.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME = 'ncilink'
) a

drop table #externallink

select e.*
, r.DEPENDENT_ID  as field_override_image_promotional
into #externallink 
from #externallink1 e inner join CONTENTSTATUS c on e.DEPENDENT_ID = c.CONTENTID 
left outer join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION and r.SLOT_ID = 953

select * from #externallink 
 for xml path , root('rows')




drop table #rawhtml
select * into #rawhtml from 
(
select   
lc.card_rid as rawcard_rid
, lc.langcode 
, df.BODYFIELD 
from #landing_content lc inner join CONTENTSTATUS c on c.contentid = lc.linkid 
inner join CT_NCIDOCFRAGMENT df on df.CONTENTID = c.contentid and df.REVISIONID = c.CURRENTREVISION
union all
select   
lc.card_rid as rawcard_rid
, lc.langcode 
, df.BODYFIELD 
from #landing_content lc inner join CONTENTSTATUS c on c.contentid = lc.linkid 
inner join CT_GLORAWHTML df on df.CONTENTID = c.contentid and df.REVISIONID = c.CURRENTREVISION
union all
select lc1.sublayout_rid, lc1.langcode , df.BODYFIELD
from #landing_content1 lc1 inner join CONTENTSTATUS c on c.CONTENTID = lc1.sublayoutid
inner join CT_GLORAWHTML df on df.CONTENTID = c.contentid and df.REVISIONID = c.CURRENTREVISION
where lc1.linkid is null 
)a




--rawhtml
select   
1 as tag
, 0 as parent
,rawcard_rid as [row!1!id]
, langcode as [row!1!langcode]
, BODYFIELD [row!1!body!CDATA]
from #rawhtml
for xml explicit , root('rows')
	


drop table #blogfeature
select c.contentid, r.RID, r.SORT_RANK, left(c.locale,2) as langcode into #blogfeature
from CT_CGVBLOGPOST b 
inner join CONTENTSTATUS c on c.CONTENTID = b.CONTENTID  and c.CURRENTREVISION = b.REVISIONID
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where s.STATENAME not like '%archive%' and sl.SLOTNAME= 'nvcgSlLayoutFeatureA'



drop table #twoitemfeaturecardrow
select c.CONTENTID, c.CONTENTID + 40000 as row_rid, r.RID as card_rid, left(c.locale,2) as langcode, r.SORT_RANK
 into #twoitemfeaturecardrow
from CONTENTSTATUS c inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where c.CONTENTID in (select CONTENTID from #mini) and sl.SLOTNAME = 'nvcgSlLayoutFeatureA'


-------

drop table #citation
select * into #citation from 
(
select p.id , r.RID 
from #enpage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.CURRENTREVISION
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
union 
select p.englishid , r.RID 
from #espage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.CURRENTREVISION
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
) a


----
--citation

select 
1 as Tag,  
0 as Parent
,p.langcode as [row!1!langcode]
,r.rid  as [row!1!citation_id]
,ct.CITATION_TEXT as [row!1!!CDATA] 
, ct.PUBMED_ID as [row!1!field_pubmed_id]
from #enpage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.CURRENTREVISION
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
union all
select 
1 as Tag,  
0 as Parent
,p.langcode as [row!1!langcode]
,r.rid  as [row!1!citation_id]
,ct.CITATION_TEXT as [row!1!!CDATA] 
, ct.PUBMED_ID as [row!1!field_pubmed_id]
from #espage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.CURRENTREVISION
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
for xml explicit , root ('rows')
-------------------------------
-------------------------------

-----------------------

---english page data



drop table #enpagedata 

select * into #enpagedata from 
(select 
1 as Tag,  
0 as Parent
,NULL AS 'rows!1!'
,NULL as [row!2!term_id],
null as [row!2!id],
NULL as [row!2!title],
NULL as [row!2!langcode],
NULL as [row!2!field_short_title],
NULL as [row!2!field_page_description],
NULL as [row!2!field_feature_card_description],
NULL as [row!2!field_list_description],
NULL as [row!2!field_search_engine_restrictions],
NULL as [row!2!field_public_use],
NULL as [row!2!field_date_posted],
NULL as [row!2!field_date_reviewed],
NULL as [row!2!field_date_updated],
NULL AS [row!2!date_display_mode],
NULL as [row!2!field_pretty_url],
NULL as [row!2!field_browser_title],
NULL as [row!2!field_card_title],
NULL as [row!2!intro!CDATA]
,NULL as [row!2!related_resource_id!Element]
,NULL as [row!2!related_resource_ids!Element]
,NULL as [row!2!para_id!Element]
,NULL as [row!2!para_ids!Element]
,NULL as [row!2!citation_id!Element]
,NULL as [row!2!citation_ids!Element]
union all 
select 
2 as Tag,  
1 as Parent
,NULL
,term_id
,p.id,
p.title,
p.langcode,
field_short_title,
field_page_description,
field_feature_card_description,
field_list_description,
field_search_engine_restrictions,
field_public_use,
field_date_posted,
field_date_reviewed,
field_date_updated,
date_display_mode,
field_pretty_url
,field_browser_title
, field_card_title
,field_intro_text
,(
		select distinct internallink_id as related_resource_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select distinct internallink_id as related_resource_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select para_id 
		from #para pa
		where p.id = pa.id 
		and p.id in (select id from #para group by id having COUNT(*) = 1)
		FOR XML path (''), TYPE, ELEMENTS
   )
,(
		select para_id as para_ids
		from #para pa
		where p.id = pa.id 
		and p.id in (select id from #para group by id having COUNT(*) > 1)
		order by sortrank
		FOR XML path (''), TYPE, ELEMENTS
   )  
,(
		select il.rid as citation_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select il.rid as citation_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  > 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
from  #enpage 	 p 
) a


--Spanish page data
drop table #espagedata 

select * into #espagedata from 
(select 
1 as Tag,  
0 as Parent
,NULL AS 'rows!1!'
,NULL as [row!2!term_id],
null as [row!2!id],
NULL as [row!2!title],
NULL as [row!2!langcode],
NULL as [row!2!field_short_title],
NULL as [row!2!field_page_description],
NULL as [row!2!field_feature_card_description],
NULL as [row!2!field_list_description],
NULL as [row!2!field_search_engine_restrictions],
NULL as [row!2!field_public_use],
NULL as [row!2!field_date_posted],
NULL as [row!2!field_date_reviewed],
NULL as [row!2!field_date_updated],
NULL as [row!2!date_display_mode],
NULL as [row!2!field_pretty_url],
NULL as [row!2!field_browser_title],
NULL as [row!2!field_card_title],
NULL as [row!2!intro!CDATA]
,NULL as [row!2!related_resource_id!Element]
,NULL as [row!2!related_resource_ids!Element]
,NULL as [row!2!para_id!Element]
,NULL as [row!2!para_ids!Element]
,NULL as [row!2!citation_id!Element]
,NULL as [row!2!citation_ids!Element]
union all 
select 
2 as Tag,  
1 as Parent
,NULL
,term_id
,p.englishid,
p.title,
p.langcode,
field_short_title,
field_page_description,
field_feature_card_description,
field_list_description,
field_search_engine_restrictions,
field_public_use,
field_date_posted,
field_date_reviewed,
field_date_updated,
date_display_mode,
field_pretty_url
,field_browser_title
, field_card_title
,field_intro_text
,(
		select internallink_id as related_resource_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select internallink_id as related_resource_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select para_id 
		from #espara pa
		where p.id = pa.id 
		and p.id in (select id from #espara group by id having COUNT(*) = 1)
		FOR XML path (''), TYPE, ELEMENTS
   )
,(
		select para_id as para_ids
		from #espara pa
		where p.id = pa.id 
		and p.id in (select id from #espara group by id having COUNT(*) > 1)
		order by sortrank
		FOR XML path (''), TYPE, ELEMENTS
   )  
,(
		select il.rid as citation_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select il.rid as citation_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  > 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
from  #espage 	 p 
) a


----------------------
drop table #promocard1
select * into #promocard1 from
(
select distinct 
r.rid  as promocard_id 
,  rc.DEPENDENT_ID as field_featured_item_target_id
, clink.OVERRIDE_TITLE  as field_override_card_title
,en.langcode
from (select card_rid as id, langcode from #landing_content 
		union all select card_rid, langcode from #twoitemfeaturecardrow 
		union all select rid, langcode from #blogfeature
		
) en 
inner join PSX_OBJECTRELATIONSHIP r on en.id = r.RID 
inner join CONTENTSTATUS c on c.CONTENTID = r.OWNER_ID
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CT_CGVCUSTOMLINK clink on clink.CONTENTID = c1.CONTENTID and clink.REVISIONID = c1.CURRENTREVISION
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join PSX_OBJECTRELATIONSHIP rc on rc.OWNER_ID = c1.CONTENTID and rc.OWNER_REVISION = c1.CURRENTREVISION
inner join rxslottype sc on sc.slotid = rc.SLOT_ID
where  sl.SLOTNAME in ('nvcgSlLayoutFeatureA','nvcgSlLayoutFeatureB' )
and t1.CONTENTTYPENAME = 'cgvcustomlink'
and sc.SLOTNAME = 'cgvCustomLink' and sc.slotid = 893
and t.CONTENTTYPENAME <> 'cgvCTHPGuideCard'
union all
select distinct
r.rid as promocard_id
,c1.contentid as field_featured_item_target_id
, NULL as field_override_title
,en.langcode
from 
(select card_rid as id, langcode from #landing_content union all select card_rid, langcode from #twoitemfeaturecardrow union all select rid, langcode from #blogfeature	) en 
inner join PSX_OBJECTRELATIONSHIP r on en.id = r.RID 
inner join CONTENTSTATUS c on c.CONTENTID = r.OWNER_ID
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where  sl.SLOTNAME in ('nvcgSlLayoutFeatureA','nvcgSlLayoutFeatureB' )  and t1.CONTENTTYPENAME not in ( 'cgvCustomLink', 'ncilink')
) a 


drop table #promocard
select * into #promocard from 
(select i.*
from #promocard1 i inner join (select id from #enpage union all select ID from #summary union all select ID from #dis) p on i.field_featured_item_target_id = p.id 
union all
select i.promocard_id, coalesce(p.englishid,p.id) as field_internal_link_target_id, field_override_card_title, i.langcode
from #promocard1 i inner join (select ID, englishid from  #espage union all select spanishid, ID from #summaryes) p on i.field_featured_item_target_id = p.id 
) a





select distinct promocard_id , field_featured_item_target_id, langcode , field_override_card_title
from #promocard 
for xml path , root ('rows')

drop table #externalpromocard1
select distinct r.DEPENDENT_ID, r.RID as externalpromocard_id
, convert(varchar(max),l.URL) as field_featured_url, convert(varchar(max),l.SHORT_TITLE) as field_override_card_title
, en.langcode
into #externalpromocard1
from (select card_rid as id, langcode from #landing_content  union all select card_rid, langcode from #twoitemfeaturecardrow union all select rid, langcode from #blogfeature
) en 
inner join PSX_OBJECTRELATIONSHIP r on en.id = r.RID 
inner join CONTENTSTATUS c on c.CONTENTID = r.OWNER_ID
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join CT_NCILINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.CURRENTREVISION
where sl.SLOTNAME in ('nvcgSlLayoutFeatureA','nvcgSlLayoutFeatureB' )
and t1.CONTENTTYPENAME = 'ncilink'

drop table #externalpromocard
select e.*
, r.DEPENDENT_ID  as field_override_image_promotional
into #externalpromocard
from #externalpromocard1 e inner join CONTENTSTATUS c on e.DEPENDENT_ID = c.CONTENTID 
left outer join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION and r.SLOT_ID = 953

select * from #externalpromocard
 for xml path , root('rows')




--image
drop table #cgov_image
select * into #cgov_image from (
select distinct c.CONTENTID as pageid, c1.CONTENTID as imageid 
, left(c1.TITLE,  case when CHARINDEX('[' , c1.TITLE) -1 <=  0 then 999 else CHARINDEX('[' , c1.TITLE) -1 END) as title 
, case when si.IMG1_FILENAME IS null then 'promotion' else 'lead' END as imagefield
, case when i.img3_filename IS NOT null then 1 else 0 END as field_display_enlarge
, p.langcode
, i.PHOTO_CREDIT as field_credit
, convert(nvarchar(max),si.IMG_ALT) as field_accessible_version
, convert(nvarchar(max),i.img_CAPTION) as field_caption
, i.IMG_SOURCE as field_original_source
from CONTENTSTATUS c 
inner join (select id, langcode from #enpage union all select ID, langcode  from #espage  union all select dependent_id, langcode  from #externallink union all select dependent_id, langcode  from #externalpromocard) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GENIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.CURRENTREVISION
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c1.CONTENTID and si.REVISIONID = c1.CURRENTREVISION
where sl.slotname = 'gloImageSl' and t1.CONTENTTYPENAME <> 'gloImageTranslation'
union all 
select distinct c.CONTENTID as pageid, c2.CONTENTID as imageid 
, left(c1.TITLE,  case when CHARINDEX('[' , c1.TITLE) -1 <=  0 then 999 else CHARINDEX('[' , c1.TITLE) -1 END) as title 
, case when si.IMG1_FILENAME IS null then 'promotion' else 'lead' END as imagefield
, case when gi.img3_filename IS NOT null then 1 else 0 END as field_display_enlarge
, p.langcode
, trans.PHOTO_CREDIT
, convert(nvarchar(max),si.IMG_ALT) as ALT
, convert(nvarchar(max),trans.IMG_CAPTION)
, convert(nvarchar(max),trans.IMG_SOURCE)
from CONTENTSTATUS c 
inner join (select id , langcode  from #enpage union all select ID, langcode  from #espage union all select dependent_id, langcode  from #externallink union all select dependent_id, langcode  from #externalpromocard) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.CURRENTREVISION
inner join CT_GENIMAGE i on i.CONTENTID = c2.CONTENTID and i.REVISIONID = c2.CURRENTREVISION
inner join CT_GLOIMAGETRANSLATION trans on trans.CONTENTID = c1.CONTENTID and trans.REVISIONID = c1.CURRENTREVISION
left outer join CT_genimage gi on gi.CONTENTID = c2.CONTENTID and gi.REVISIONID = c2.CURRENTREVISION
where sl.slotname = 'gloImageSl' and t1.CONTENTTYPENAME = 'gloImageTranslation'
)a



--contextual image
drop table #contextual_image
select * into #contextual_image from (
select distinct c.CONTENTID as pageid, c1.CONTENTID as imageid 
, left(c1.TITLE,  case when CHARINDEX('[' , c1.TITLE) -1 <=  0 then 999 else CHARINDEX('[' , c1.TITLE) -1 END) as title 
, case when si.IMG1_FILENAME IS null then 'promotion' else 'lead' END as imagefield
, case when i.img3_filename IS NOT null then 1 else 0 END as field_display_enlarge
, p.langcode
, i.PHOTO_CREDIT as field_credit
, convert(nvarchar(max),si.IMG_ALT) as field_accessible_version
, convert(nvarchar(max),i.img_CAPTION) as field_caption
, i.IMG_SOURCE as field_original_source
from CONTENTSTATUS c 
inner join (select id, langcode from #enpage union all select ID, langcode from #espage ) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GENIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.CURRENTREVISION
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c1.CONTENTID and si.REVISIONID = c1.CURRENTREVISION
where t1.CONTENTTYPENAME = 'gloimage' and  sl.slotname  like 'sys%' 
union all 
select distinct c.CONTENTID as pageid, c2.CONTENTID as imageid 
, left(c2.TITLE,  case when CHARINDEX('[' , c2.TITLE) -1 <=  0 then 999 else CHARINDEX('[' , c2.TITLE) -1 END) as title 
, case when si.IMG1_FILENAME IS null then 'promotion' else 'lead' END as imagefield
, case when i.img3_filename IS NOT null then 1 else 0 END as field_display_enlarge
, p.langcode
, trans.PHOTO_CREDIT
, convert(nvarchar(max),si.IMG_ALT) as ALT
, convert(nvarchar(max),trans.IMG_CAPTION)
, convert(nvarchar(max),trans.IMG_SOURCE)
from CONTENTSTATUS c 
inner join (select id, langcode from #enpage union all select ID, langcode from #espage ) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.CURRENTREVISION
inner join CT_GENIMAGE i on i.CONTENTID = c2.CONTENTID and i.REVISIONID = c2.CURRENTREVISION
inner join CT_GLOIMAGETRANSLATION trans on trans.CONTENTID = c1.CONTENTID and trans.REVISIONID = c1.CURRENTREVISION
where   sl.slotname  like 'sys%' and t1.CONTENTTYPENAME = 'gloImageTranslation'
union all
select distinct c.CONTENTID as pageid, c1.CONTENTID as imageid 
, left(c1.TITLE,  case when CHARINDEX('[' , c1.TITLE) -1 <=  0 then 999 else CHARINDEX('[' , c1.TITLE) -1 END) as title 
, NULL as imagefield
,NULL
, p.langcode
, NULL as field_credit
, null
, NUll as field_caption
, null 
 
from CONTENTSTATUS c 
inner join (select id, langcode from #enpage union all select ID, langcode from #espage ) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GLOUTILITYIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.CURRENTREVISION
where t1.CONTENTTYPENAME = 'gloutilityimage' and  sl.slotname  like 'sys%' 

)a





-----------------------------------------

drop table #i

select distinct i.imageid
, u.IMG_UTILITY_FILENAME
,si.IMG1_FILENAME, si.IMG2_FILENAME
,gi.IMG3_FILENAME, gi.IMG4_FILENAME
,gi.IMG5_FILENAME, gi.IMG6_FILENAME
, i.ctype 
, i.langcode 
into #i
from (select *, 0 as ctype from #cgov_image union all select *, 1 as ctype from #contextual_image) i inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.CURRENTREVISION
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.CURRENTREVISION



drop table #ifile 
select * into #ifile from (
select imageid, IMG1_FILENAME as img, 1 as itype, langcode from #i where IMG1_FILENAME is not null
union all
select imageid, IMG2_FILENAME, 2, langcode from #i where IMG2_FILENAME is not null
union all
select imageid, IMG3_FILENAME, 3, langcode from #i where IMG3_FILENAME is not null
union all 
select imageid,  IMG4_FILENAME, 4, langcode from #i where IMG4_FILENAME is not null
union all
select imageid,  IMG5_FILENAME, 5, langcode from #i where IMG5_FILENAME is not null
union all
select imageid,  IMG6_FILENAME, 6 , langcode from #i where IMG6_FILENAME is not null
union all
select imageid,  IMG_UTILITY_FILENAME, 0 , langcode from #i where IMG_UTILITY_FILENAME is not null 
) a 




drop table #idup 
select f.IMG, f.imageid,itype, 
case itype 
when 0 then (select si.IMG_UTILITY_SIZE from dbo.CT_GLOUTILITYIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
when 1 then (select IMG1_SIZE from dbo.RXS_CT_SHAREDIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
when 2 then (select IMG2_SIZE from dbo.RXS_CT_SHAREDIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
when 3 then (select IMG3_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
when 4 then (select IMG4_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
when 5 then (select IMG5_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
when 6 then (select IMG6_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION) 
end as imgsize
, c.title
, langcode
, dbo.gaogetitemFolderPath(c.contentid, '') as folder
, a.total
into #idup
from #ifile f inner join
(
select IMG, COUNT(*) as total from #ifile 
where IMG is not null
group by IMG
having COUNT(*) > 1
)a on f.IMG = a.IMG
inner join CONTENTSTATUS c on c.CONTENTID = f.imageid
order by f.IMG, f.imageid, itype, total 





drop table #idup1
select ROW_NUMBER () over (partition by img, imageid order by  itype) as seq, * into #idup1 from #idup

--same image
select i.* from #idup i inner join
(select img, imageid from #idup1 where seq > 1) a on i.img = a.img and i.imageid = a.imageid

drop table #idup2
select row_number () over (partition by i.img order by i.imageid ) as seq 
,i.* into #idup2
from #idup i left outer join (select img, imageid from #idup1 where seq > 1) a on i.img = a.img and i.imageid = a.imageid
where a.imageid is null




drop table #isamesize
select i.img, i.imageid,c.title, i.langcode, i.itype,  i.imgsize, i1.imageid as imageid1, c1.title as title1, i1.langcode as langcode1 , i1.itype as itype1
into #isamesize
from
(select * from #idup2  where seq =1 ) i left outer join (select * from #idup2  where seq =2 ) i1 on i.img = i1.img
inner join CONTENTSTATUS c on i.imageid = c.CONTENTID
inner join CONTENTSTATUS c1 on i1.imageid = c1.CONTENTID
where i.imgsize = i1.imgsize

--select * from #isamesize where langcode = langcode1

drop table #isizediff
select i.img, i.imageid,c.title,i.langcode, i.itype,  i.imgsize, i1.imageid as imageid1, c1.title as title1, i1.langcode as langcode1, i1.itype as itype1, i1.imgsize as imgsize1
into #isizediff
from
(select * from #idup2  where seq =1 ) i left outer join (select * from #idup2  where seq =2 ) i1 on i.img = i1.img
inner join CONTENTSTATUS c on i.imageid = c.CONTENTID
inner join CONTENTSTATUS c1 on i1.imageid = c1.CONTENTID
where i.imgsize <> i1.imgsize


--diff size
select distinct img, d.imageid,title, i.langcode, itype,  imgsize
,(select  top 1 dbo.gaogetitemfolderpath(i.pageid , '') + ISNULL('/' + dbo.percReport_getPretty_url_name(i.pageid) ,'')
	from (select 0 as ctype, imageid,pageid from #cgov_image union all select 1 as ctype, imageid,pageid from #contextual_image ) i where d.imageid = i.imageid  order by ctype)  as parenturl
,'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(d.imageid,''),10,999) + '/'+ img as imgurl
, i.ctype 
, imageid1 as imageid1, title1 as title1, i1.langcode as langcode1, itype1 as itype1, imgsize1 as imgsize1
,(select  top 1 dbo.gaogetitemfolderpath(i.pageid , '') + ISNULL('/' + dbo.percReport_getPretty_url_name(i.pageid) ,'')
	from (select 0 as ctype, imageid,pageid from #cgov_image union all select 1 as ctype, imageid,pageid from #contextual_image ) i where d.imageid1 = i.imageid  order by ctype)  as parenturl1
,'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(d.imageid1,''),10,999) + '/'+ img	as imgurl1
, i1.ctype 
from #isizediff d 
inner join #i i on d.imageid = i.imageid 
inner join #i i1 on i1.imageid = d.imageid1
order by img


--select * from #isizediff where langcode = langcode1


--diff size EN_ES
drop table #ien_es
select img, d.imageid,d.title, d.langcode, itype,  imgsize
,'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(d.imageid,''),10,999) + '/'+ img as englishImg
, i.ctype as englishitype	
, c.TITLE as englishpagetitle
, imageid1 as imageid1, title1 as title1, langcode1 as locale1, itype1 as itype1, imgsize1 as imgsize1
,'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(d.imageid1,''),10,999) + '/'+ img	as spanishImg
, i1.ctype as spanishitype
, c1.TITLE as spanishpagetitle
, r.RID 
, c.CONTENTID
, c1.CONTENTID as spanishpageid 
into #ien_es
from #isizediff d 
inner join #i i on d.imageid = i.imageid 
inner join #i i1 on i1.imageid = d.imageid1
inner join #cgov_image ci on ci.imageid = d.imageid 
inner join #cgov_image ci1 on ci1.imageid = d.imageid1
inner join CONTENTSTATUS c on c.CONTENTID = ci.pageid 
inner join CONTENTSTATUS c1 on c1.CONTENTID = ci1.pageid 
left outer join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION	= c.CURRENTREVISION and r.CONFIG_ID = 6 and r.DEPENDENT_ID = c1.CONTENTID 
where --dbo.gaogetitemFolderPath(d.imageid,'') = dbo.gaogetitemFolderPath(d.imageid1,'') and 
d.langcode = 'en' and langcode1 = 'es'
order by img

--translation
select * from #ien_es where RID is not null
-- no translation
--select * from #ien_es where RID is  null

alter table #cgov_image add englishimageid int 
Go
update i set i.englishimageid = a.englishimageid
from #cgov_image i inner join
(select i.imageid, imageid as englishimageid
from #cgov_image i where langcode = 'es' and  exists (select * from #cgov_image i1 where i1.langcode = 'en' and i1.imageid = i.imageid)
union
select i.imageid, ci.imageid 
from #cgov_image ci inner join (select distinct imageid,imageid1 from #isamesize where langcode1 = 'es' and langcode = 'en') i on ci.imageid = i.imageid1
union
select i.imageid, ci.imageid 
from #cgov_image ci inner join (select distinct imageid, imageid1 from #ien_es where RID is not null) i on ci.imageid = i.imageid1
) a on  a.imageid = i.imageid 
where i.langcode = 'es'






select distinct c1.CONTENTID as imageid  into #nottranslation 
from CONTENTSTATUS c 
inner join (select id, langcode from #enpage union all select ID, langcode  from #espage  union all select dependent_id, langcode  from #externallink union all select dependent_id, langcode  from #externalpromocard) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GENIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.CURRENTREVISION
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c1.CONTENTID and si.REVISIONID = c1.CURRENTREVISION
where sl.slotname = 'gloImageSl' and t1.CONTENTTYPENAME <> 'gloImageTranslation'




drop table #i1

select distinct i.imageid
, u.IMG_UTILITY_FILENAME
,si.IMG1_FILENAME, si.IMG2_FILENAME
,gi.IMG3_FILENAME, gi.IMG4_FILENAME
,gi.IMG5_FILENAME, gi.IMG6_FILENAME
into #i1
from (select imageid, 0 as ctype from #nottranslation union all select imageid, 1 as ctype from #contextual_image) i inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.CURRENTREVISION
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.CURRENTREVISION



drop table #ifile1
select * into #ifile1 from (
select imageid, IMG1_FILENAME as img, 1 as itype from #i1 where IMG1_FILENAME is not null
union all
select imageid, IMG2_FILENAME, 2 from #i1 where IMG2_FILENAME is not null
union all
select imageid, IMG3_FILENAME, 3from #i1 where IMG3_FILENAME is not null
union all 
select imageid,  IMG4_FILENAME, 4 from #i1 where IMG4_FILENAME is not null
union all
select imageid,  IMG5_FILENAME, 5 from #i1 where IMG5_FILENAME is not null
union all
select imageid,  IMG6_FILENAME, 6  from #i1 where IMG6_FILENAME is not null
union all
select imageid,  IMG_UTILITY_FILENAME, 0  from #i1 where IMG_UTILITY_FILENAME is not null 
) a 








; with cte as
(select *, dbo.gaogetitemfolderpath(imageid,'') as folder  from #ifile1 )
select cte.*, total from 
(select folder, img, COUNT(*) as total from cte 
group by folder, img
having COUNT(*) > 1) a  inner join cte on cte.folder = a.folder and cte.img = a.img 

----------------
--EN image

select * from (
select 
distinct
1 as tag
, 0 as parent
,i.imageid as [row!1!id]
,'en' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME) as [row!1!field_media_image!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ si.IMG2_FILENAME as  [row!1!field_override_img_thumbnail!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG4_FILENAME as  [row!1!field_override_img_featured!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG5_FILENAME as  [row!1!field_override_img_panoramic!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG6_FILENAME as  [row!1!field_override_img_social_media!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
, i.field_original_source as [row!1!field_original_source!Element]
 from 
(select * from #cgov_image where langcode = 'en' and title not like '%spanish%'
) i 
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.CURRENTREVISION
union all
select 
distinct
1 as tag
, 0 as parent
,i.imageid as [row!1!id]
,'es' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME) as [row!1!field_media_image!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ si.IMG2_FILENAME as  [row!1!field_override_img_thumbnail!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG4_FILENAME as  [row!1!field_override_img_featured!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG5_FILENAME as  [row!1!field_override_img_panoramic!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG6_FILENAME as  [row!1!field_override_img_social_media!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
, i.field_original_source as [row!1!field_original_source!Element]
 from 
(select * from #cgov_image where langcode = 'es' and englishimageid is null
) i 
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.CURRENTREVISION
) a
for xml explicit , root('rows')


---ES Image
select 
distinct
1 as tag
, 0 as parent
,i.englishimageid as [row!1!id]
,'es' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME) as [row!1!field_media_image!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ si.IMG2_FILENAME as  [row!1!field_override_img_thumbnail!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG4_FILENAME as  [row!1!field_override_img_featured!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG5_FILENAME as  [row!1!field_override_img_panoramic!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+ gi.IMG6_FILENAME as  [row!1!field_override_img_social_media!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
, i.field_original_source as [row!1!field_original_source!Element]
 from #cgov_image i
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.CURRENTREVISION
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.CURRENTREVISION
where langcode = 'es' and englishimageid is not null
for xml explicit , root('rows')













----------------------------

---!!! success
--- English article
select d.* 
,(select top 1 imageid from #cgov_image i where i.pageid = d.[row!2!id]  and imagefield = 'lead'  and langcode = d.[row!2!langcode]) as [row!2!field_image_article!Element]
,(select top 1 imageid from #cgov_image i where i.pageid = d.[row!2!id]  and imagefield = 'promotion' and langcode =  d.[row!2!langcode]) as [row!2!field_image_promotional!Element]
from #enpagedata d 
where Tag =1 or 
[row!2!id] 
in  (
select id from #enpage p 
where p.CONTENTTYPENAME not in ( 'nciHome', 'cgvpressrelease', 'cgvblogpost', 'cgvblogseries', 'cgvCancerResearch', 'gloInstitution', 'cgvinfographic', 'glovideo') 
and p.CONTENTTYPENAME not like '%landing%'
and p.id not in (select contentid from #mini)
) 
order by tag
for xml explicit 


--- !! spanish as translation artcile
select d.* 
,(select top 1 imageid from #cgov_image i where i.pageid = d.[row!2!id]  and imagefield = 'lead' and langcode = 'es') as [row!2!field_image_article!Element]
,(select top 1 imageid from #cgov_image i where i.pageid = d.[row!2!id]  and imagefield = 'promotion' and langcode = 'es') as [row!2!field_image_promotional!Element]
from #espagedata d 
where Tag =1 or 
[row!2!id] in  (
select englishid from #espage p 
where p.CONTENTTYPENAME not in ( 'nciHome', 'cgvpressrelease', 'cgvblogpost', 'cgvblogseries', 'cgvCancerResearch', 'gloInstitution', 'cgvinfographic', 'glovideo') 
and p.CONTENTTYPENAME not like '%landing%'
and p.id not in (select contentid from #mini)
)
order by tag
for xml explicit

---infographic


select d.*,  a.[row!2!body!CDATA], 
 [row!2!field_accessible_version!Element],
  [row!2!field_infographic!CDATA] ,
  [row!2!field_image_promotional!Element] 
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_accessible_version!Element],
NULL as  [row!2!field_infographic!CDATA] ,
NULL as  [row!2!field_image_promotional!Element] 
union all 
select 
2 as tag
, 1 as parent
, p.id
,h.[body] 
,gr.LONGDESC_ATTRIBUTE
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid, ''), 10,999) + '/' +    gr.FULL_INFOGRAPHIC_FILENAME as field_infographic
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode) as field_image_promotional
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and slotname = 'gloImageSl'
inner join CT_CGVINFOGRAPHIC gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.CURRENTREVISION
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME  = 'cgvinfographic'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



select d.*,  a.[row!2!body!CDATA], 
 [row!2!field_accessible_version!Element],
  [row!2!field_infographic!CDATA] ,
  [row!2!field_image_promotional!Element] 
 from #espagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_accessible_version!Element],
NULL as  [row!2!field_infographic!CDATA] ,
NULL as  [row!2!field_image_promotional!Element] 
union all 
select 
2 as tag
, 1 as parent
, p.englishid
,h.[body] 
,gr.LONGDESC_ATTRIBUTE
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid, ''), 10,999) + '/' +    gr.FULL_INFOGRAPHIC_FILENAME as field_infographic
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode) as field_image_promotional
from #espage p inner join CONTENTSTATUS c on c.CONTENTID = p.id inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and slotname = 'gloImageSl'
inner join CT_CGVINFOGRAPHIC gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.CURRENTREVISION
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME  = 'cgvinfographic'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



---------
--video

select d.*,  a.[row!2!body!CDATA], 
  [row!2!field_media_oembed_video!Element]
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_caption!Element],
NULL as [row!2!field_media_oembed_video!Element]
union all 
select 
2 as tag
, 1 as parent
, p.id
,h.[body] 
,gr.CAPTION
, 'https://www.youtube.com/watch?v=' + gr.VIDEO_ID as field_media_oembed_video

from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVVIDEOPLAYER gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.CURRENTREVISION
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME  = 'glovideo'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



--ES video

select d.*,  a.[row!2!body!CDATA], 
  [row!2!field_media_oembed_video!Element]
from #espagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_caption!Element],
NULL as [row!2!field_media_oembed_video!Element]
union all 
select 
2 as tag
, 1 as parent
, p.englishid
,h.[body] 
,gr.CAPTION
, 'https://www.youtube.com/watch?v=' + gr.VIDEO_ID as field_media_oembed_video

from #espage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVVIDEOPLAYER gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.CURRENTREVISION
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME  = 'glovideo'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit










---englsih and none translateds press release
select d.*,  a.[row!2!body!CDATA], a.[row!2!field_press_release_type], a.[row!2!field_subtitle]
,[row!2!field_image_article!Element] , [row!2!field_image_promotional!Element] 
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_press_release_type],
NULL as  [row!2!field_subtitle] ,
NULL as  [row!2!field_image_article!Element] ,
NULL as  [row!2!field_image_promotional!Element] 
union all 
select 
2 as tag
, 1 as parent
, p.id
,h.[body] 
, pr.press_release_type 
, pr.SUBHEADER 
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode) as field_image_article
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'promotion' and langcode = p.langcode) as field_image_promotional
from #enpage p 
inner join (select * from #es union all select * from #en) s on p.term_id = s.term_id
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
inner join CT_CGVPRESSRELEASE pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
where p.CONTENTTYPENAME = 'cgvPressRelease' 
and (s.computed_path like '%2017%' or s.computed_path like '%2016%' or s.computed_path like '%2015%' or s.computed_path like '%2014%' or s.computed_path like '%2018%' or s.computed_path like '%2019%')
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit


------ Spanish  press release 
select d.*,  a.[row!2!body!CDATA], a.[row!2!field_press_release_type], a.[row!2!field_subtitle]
,[row!2!field_image_article!Element] , [row!2!field_image_promotional!Element] 
from #espagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_press_release_type],
NULL as  [row!2!field_subtitle] ,
NULL as  [row!2!field_image_article!Element] ,
NULL as  [row!2!field_image_promotional!Element] 

union all 
select 
2 as tag
, 1 as parent
, p.englishid
,h.[body] 
, pr.press_release_type 
, pr.SUBHEADER 
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = 'es') as field_image_article
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'promotion' and langcode = 'es') as field_image_promotional
from #espage p 
inner join (select * from #es ) s on p.term_id = s.term_id
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
inner join CT_CGVPRESSRELEASE pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
where p.CONTENTTYPENAME = 'cgvPressRelease' 
and (s.computed_path like '%2017%' or s.computed_path like '%2016%' or s.computed_path like '%2015%' or s.computed_path like '%2014%' or s.computed_path like '%2018%' or s.computed_path like '%2019%')
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit

------------------------
---blog series english
select d.*,[row!2!field_about_blog!CDATA]
, [row!2!field_allow_comments]
,[row!2!field_feedburner_url]
, [row!2!field_num_display_posts]
, [row!2!field_blog_series_shortname]
, [row!2!field_recommended_content_header]
, [row!2!field_banner_image!Element]  
,[row!2!field_image_promotional!Element]
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id 
,NULL as [row!2!field_about_blog!CDATA]
,NULL as [row!2!field_allow_comments]
,NULL as [row!2!field_feedburner_url]
,NULL as [row!2!field_num_display_posts]
,NULL as [row!2!field_blog_series_shortname]
,NULL as [row!2!field_recommended_content_header]
,NULL as [row!2!field_banner_image!Element]
,NULL as [row!2!field_image_promotional!Element]
union all 
select 
2 as tag
, 1 as parent
, p.id
, b.[ABOUT_BLOG] 
,isnull(b.COMMENTING_AVAILABLE , 0)
, b.FEEDBURNER_URL 
, b.NUMBER_POSTS 
, b.BLOG_SHORTNAME 
, b.FEATURE_CARDS_HEADER 
,
(select   
	'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c2.contentid,''),10,999) + '/'+ 
	si.IMG_UTILITY_FILENAME as field_banner_image
		from CONTENTSTATUS c 
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.CURRENTREVISION
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
, (select top 1  imageid from #cgov_image i where i.pageid = p.id and langcode = 'en') as field_image_promotional
from CONTENTSTATUS c inner join CT_CGVBLOGSERIES b on c.CONTENTID = b.CONTENTID and c.CURRENTREVISION = b.REVISIONID
inner join #enpage p on p.id = c.CONTENTID 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit





--spanish translation of blog series  //TODO
select d.*,[row!2!field_about_blog!CDATA]
, [row!2!field_allow_comments]
,[row!2!field_feedburner_url]
, [row!2!field_num_display_posts]
, [row!2!field_blog_series_shortname]
, [row!2!field_recommended_content_header]
, [row!2!field_banner_image!Element]  
,[row!2!field_image_promotional!Element]
from #espagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id 
,NULL as [row!2!field_about_blog!CDATA]
,NULL as [row!2!field_allow_comments]
,NULL as [row!2!field_feedburner_url]
,NULL as [row!2!field_num_display_posts]
,NULL as [row!2!field_blog_series_shortname]
,NULL as [row!2!field_recommended_content_header]
,NULL as [row!2!field_banner_image!Element]
,NULL as [row!2!field_image_promotional!Element]
union all 
select 
2 as tag
, 1 as parent
, p.englishid
, b.[ABOUT_BLOG] 
,isnull(b.COMMENTING_AVAILABLE , 0)
, b.FEEDBURNER_URL 
, b.NUMBER_POSTS 
, b.BLOG_SHORTNAME 
, b.FEATURE_CARDS_HEADER 
,
(select   
	'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c2.contentid,''),10,999) + '/'+ 
	si.IMG_UTILITY_FILENAME as field_banner_image
		from CONTENTSTATUS c 
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.CURRENTREVISION
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
, (select top 1  imageid from #cgov_image i where i.pageid = p.id and langcode = 'es') as field_image_promotional
from CONTENTSTATUS c inner join CT_CGVBLOGSERIES b on c.CONTENTID = b.CONTENTID and c.CURRENTREVISION = b.REVISIONID
inner join #espage p on p.id = c.CONTENTID 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit


---!!blog topics   
select distinct v.ID as term_id,  v.name , b.BLOG_SERIES as field_owner_blog, 'en' as langcode
from #enpage p inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_CGVBLOGPOST b on b.CONTENTID = c.CONTENTID and b.REVISIONID = c.CURRENTREVISION
 outer apply perccancergov.dbo.udf_StringSplit(b.blog_topics,',') tax
left outer join TAX_VALUE v on v.NODE_ID = tax.ObjectID
left outer join TAX_NODE n on n.ID = v.node_id and n.TAXONOMY_ID = 15
where   CONTENTTYPENAME = 'cgvBlogpost'
and v.NAME is not null
for xml path









---englsih and none translateds blogpost
select d.* 
, [row!2!field_image_article!Element] 
, [row!2!field_image_promotional!Element] 
,  [row!2!field_blog_series]
, [row!2!field_blog_topics!Element]
, [row!2!body!CDATA] 
, [row!2!author] 
, [row!2!field_recommended_content!Element] 
, [row!2!field_recommended_contents!Element] 

from #enpagedata d 
inner join 
(select 
1 as Tag
,0 as Parent
,NULL AS id
, NULL as [row!2!field_image_article!Element] 
, NULL as [row!2!field_image_promotional!Element] 
,NULL as [row!2!field_blog_series]
,NULL as [row!2!field_blog_topics!Element]
,NULL as [row!2!body!CDATA] 
, NULL as [row!2!author] 
, NULL as [row!2!field_recommended_content!Element] 
, NULL as [row!2!field_recommended_contents!Element] 

union all 
select 
2 as Tag,  
1 as Parent
,p.id 
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode ) as field_image_article
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'promotion' and langcode = p.langcode) as field_image_promotional
, case when p.langcode = 'es' then (select englishid from #espage where id =pr.BLOG_SERIES) else pr.BLOG_SERIES END 
	,(select v.id from 
	 CT_CGVBLOGPOST pr1 inner join CONTENTSTATUS c1 on c1.CONTENTID = pr1.CONTENTID  and c1.CURRENTREVISION = pr1.REVISIONID
	cross apply perccancergov.dbo.udf_StringSplit(pr.blog_topics,',') tax
	inner join TAX_VALUE v on v.NODE_ID = tax.ObjectID
	inner join TAX_NODE n on n.ID = v.node_id and n.TAXONOMY_ID = 15
	where pr1.CONTENTID = c.CONTENTID and pr1.REVISIONID = c.CURRENTREVISION
	FOR XML path (''), TYPE, ELEMENTS
	),
	BODY,
	author 
	
,(select RID  as field_recommended_content
	from #blogfeature f inner join (select promocard_id from #promocard union all select externalpromocard_id from #externalpromocard) a on f.RID = a.promocard_id
	where CONTENTID = p.id and f.CONTENTID in (select CONTENTID from #blogfeature group by CONTENTID having COUNT(*) = 1)
	order by SORT_RANK FOR XML path (''), TYPE, ELEMENTS 
	)			
,(select RID  as field_recommended_contents
	from #blogfeature f inner join (select promocard_id from #promocard union all select externalpromocard_id from #externalpromocard) a on f.RID = a.promocard_id
	where CONTENTID = p.id and f.CONTENTID in (select CONTENTID from #blogfeature group by CONTENTID having COUNT(*) > 1)
	order by SORT_RANK FOR XML path (''), TYPE, ELEMENTS 
	)			
from  #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
inner join CT_CGVBLOGPOST pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
where p.CONTENTTYPENAME = 'cgvblogpost' 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit


-------spanish translation blogpost
select d.* 
, [row!2!field_image_article!Element] 
, [row!2!field_image_promotional!Element] 
,  [row!2!field_blog_series]
, [row!2!field_blog_topics!Element]
, [row!2!body!CDATA] 
, [row!2!author] 
, [row!2!field_recommended_content!Element] 
, [row!2!field_recommended_contents!Element] 
from #espagedata d 
inner join 
(select 
1 as Tag
,0 as Parent
,NULL AS id
, NULL as [row!2!field_image_article!Element] 
, NULL as [row!2!field_image_promotional!Element] 
,NULL as [row!2!field_blog_series]
,NULL as [row!2!field_blog_topics!Element]
,NULL as [row!2!body!CDATA] 
, NULL as [row!2!author] 
, NULL as [row!2!field_recommended_content!Element] 
, NULL as [row!2!field_recommended_contents!Element] 
union all 
select 
2 as Tag,  
1 as Parent
,p.englishid 
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode) as field_image_article
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'promotion' and langcode = p.langcode) as field_image_promotional
,(select englishid from #espage where id =pr.BLOG_SERIES)
,(select   v.id 
from 
 CT_CGVBLOGPOST pr1 inner join CONTENTSTATUS c1 on c1.CONTENTID = pr1.CONTENTID  and c1.CURRENTREVISION = pr1.REVISIONID
cross apply perccancergov.dbo.udf_StringSplit(pr.blog_topics,',') tax
inner join TAX_VALUE v on v.NODE_ID = tax.ObjectID
inner join TAX_NODE n on n.ID = v.node_id and n.TAXONOMY_ID = 15
where pr1.CONTENTID = c.CONTENTID and pr1.REVISIONID = c.CURRENTREVISION
FOR XML path (''), TYPE, ELEMENTS
),
BODY,
author 
,(select RID  as field_recommended_content
	from #blogfeature f inner join (select promocard_id from #promocard union all select externalpromocard_id from #externalpromocard) a on f.RID = a.promocard_id
	where CONTENTID = p.id and f.CONTENTID in (select CONTENTID from #blogfeature group by CONTENTID having COUNT(*) = 1)
	order by SORT_RANK FOR XML path (''), TYPE, ELEMENTS 
	)			
,(select RID  as field_recommended_contents
	from #blogfeature f inner join (select promocard_id from #promocard union all select externalpromocard_id from #externalpromocard) a on f.RID = a.promocard_id
	where CONTENTID = p.id and f.CONTENTID in (select CONTENTID from #blogfeature group by CONTENTID having COUNT(*) > 1)
	order by SORT_RANK FOR XML path (''), TYPE, ELEMENTS 
	)		
from  #espage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.CURRENTREVISION
inner join CT_CGVBLOGPOST pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
where p.CONTENTTYPENAME = 'cgvblogpost' 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



-------------
--region
select  50+ROW_NUMBER () over (order by region) as term_id, REGION as name from 
(select distinct cc.REGION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME = 'gloinstitution'
) a
for xml path , root('rows')


select  50+ROW_NUMBER () over (order by region) as term_id, REGION as name 
into #r
from 
(select distinct cc.REGION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME = 'gloinstitution'
) a

--cancer center type
select  70+ROW_NUMBER () over (order by classification) as term_id, classification as name from 
(select distinct cc.CLASSIFICATION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME = 'gloinstitution'
) a
for xml path , root('rows')


select  70+ROW_NUMBER () over (order by classification) as term_id, classification as name 
into #t
from 
(select distinct cc.CLASSIFICATION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.CURRENTREVISION
where CONTENTTYPENAME = 'gloinstitution'
) a


CREATE TABLE #states (
  
  STATEID varchar(2) NOT NULL,
  FULLNAME varchar(30) NOT NULL,
  
) 

INSERT INTO #states ( STATEID, FULLNAME) VALUES 
('AK', 'Alaska'),
('AL', 'Alabama'),
('AR', 'Arkansas'),
('AZ', 'Arizona'),
('CA', 'California'),
('CO', 'Colorado'),
('CT', 'Connecticut'),
('DC', 'District of Columbia'),
('DE', 'Delaware'),
('FL', 'Florida'),
('GA', 'Georgia'),
('HI', 'Hawaii'),
('IA', 'Iowa'),
('ID', 'Idaho'),
('IL', 'Illinois'),
('IN', 'Indiana'),
('KS', 'Kansas'),
('KY', 'Kentucky'),
('LA', 'Louisiana'),
('MA', 'Massachusetts'),
('MD', 'Maryland'),
('ME', 'Maine'),
('MI', 'Michigan'),
('MN', 'Minnesota'),
('MO', 'Missouri'),
('MS', 'Mississippi'),
('MT', 'Montana'),
('NC', 'North Carolina'),
('ND', 'North Dakota'),
('NE', 'Nebraska'),
('NH', 'New Hampshire'),
('NJ', 'New Jersey'),
('NM', 'New Mexico'),
('NV', 'Nevada'),
('NY', 'New York'),
('OH', 'Ohio'),
('OK', 'Oklahoma'),
('OR', 'Oregon'),
('PA', 'Pennsylvania'),
('RI', 'Rhode Island'),
('SC', 'South Carolina'),
('SD', 'South Dakota'),
('TN', 'Tennessee'),
('TX', 'Texas'),
('UT', 'Utah'),
('VA', 'Virginia'),
('VI', 'Virgin Islands'),
('VT', 'Vermont'),
('WA', 'Washington'),
('WI', 'Wisconsin'),
('WV', 'West Virginia'),
('WY', 'Wyoming');





------ cancer center
--TODO PARENT
select 
1 as Tag,  
0 as Parent
,NULL AS 'rows!1!'
,NULL as [row!2!term_id],
null as [row!2!id],
NULL as [row!2!title],
NULL as [row!2!langcode],
NULL as [row!2!field_sort_title],
NULL as [row!2!field_region!Element],
NULL as [row!2!field_institution_type!Element],	
NULL as [row!2!field_short_title],
NULL as [row!2!field_page_description],
NULL as [row!2!field_feature_card_description],
NULL as [row!2!field_list_description],
NULL as [row!2!field_search_engine_restrictions],
NULL as [row!2!field_date_posted],
NULL as [row!2!field_date_reviewed],
NULL as [row!2!field_date_updated],
NULL as [row!2!field_pretty_url],
NULL as [row!2!field_browser_title],
NULL as [row!2!field_card_title],
NULL as [row!2!body!CDATA] ,
Null as [row!2!field_org_head_name],
Null as [row!2!field_org_head_title],
Null as [row!2!field_phone_number_1],
Null as [row!2!field_phone_label_1],
Null as [row!2!field_phone_number_2],
Null as [row!2!field_phone_label_2],
Null as [row!2!field_website_title],
Null as [row!2!field_website_url],
Null as [row!2!address_line1!Element],
Null as [row!2!address_line2!Element],
Null as [row!2!city!Element],
Null as [row!2!state!Element],
Null as [row!2!zipcode!Element],
NULL as [row!2!related_resource_id!Element]
,NULL as [row!2!related_resource_ids!Element]
,NULL as [row!2!field_parent_institution!Element]
,NULL as [row!2!field_image_promotional!Element]
union all 
select 
2 as Tag,  
1 as Parent
,NULL
,p.term_id
,p.id,
p.title,
p.langcode,
cc.SORT_TITLE,
r.term_id,
t.term_id,
field_short_title,
field_page_description,
field_feature_card_description,
field_list_description,
field_search_engine_restrictions,
field_date_posted,
field_date_reviewed,
field_date_updated,
field_pretty_url,
field_browser_title
,field_card_title,
cc.BODYFIELD
,cc.DIRECTOR_NAME
, cc.DIRECTOR_TITLE
, cc.PHONE_NUMBER1
, cc.PHONE_LABEL1
, cc.PHONE_NUMBER2
, cc.PHONE_LABEL2
, cc.WEBSITE_TITLE
, cc.WEBSITE_URL
, a.ADDRESS_LINE1 
, a.ADDRESS_LINE2
, a.CITY 
,  s.STATEID
, a.ZIPCODE
,(
		select internallink_id as related_resource_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select internallink_id as related_resource_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
, cc.INSTITUTE_NAME
,i.imageid 
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.CURRENTREVISION
left outer join #r r on r.name = cc.REGION
left outer join #t t on t.name = cc.CLASSIFICATION
left outer join GLOADDRESSSET_GLOADDRESSSET a on a.CONTENTID = c.CONTENTID and a.REVISIONID = c.CURRENTREVISION
left outer join #states s on s.FULLNAME = a.state
left outer join #cgov_image i on i.pageid = p.id and langcode = 'en'
where CONTENTTYPENAME = 'gloinstitution'
for xml explicit



-------






---------------------------------------

---------------------------------------

---------------------------------------
drop table #twocolumn1
select lc.row_rid
, case when lc.SLOTNAME like '%generalA' then lc.card_rid else null END as field_main_contents
, case when lc.SLOTNAME like '%generalB' then lc.card_rid else null END as field_secondary_contents
, lc.langcode 
, lc.sort_rank
into #twocolumn1
from #landing_content lc inner join #rawhtml r on lc.card_rid = r.rawcard_rid
where SLOTNAME like '%general%'


-- tow column row
select tc.row_rid, langcode
, (select field_main_contents from #twocolumn1 tc2 where tc2.row_rid = tc.row_rid and field_main_contents is not null) as field_main_contents
, (select field_secondary_contents as field_secondary_content 
		from #twocolumn1 tc1 
				where tc1.row_rid = tc.row_rid 
			and tc1.row_rid in (select row_rid from #twocolumn1 group by row_rid having COUNT(*) = 1)
			for XML path (''), TYPE, ELEMENTS)
, (select field_secondary_contents 
		from #twocolumn1 tc1 
				where tc1.row_rid = tc.row_rid 
			and tc1.row_rid in (select row_rid from #twocolumn1 group by row_rid having COUNT(*) > 1)
			order by tc1.sort_rank 
			for XML path (''), TYPE, ELEMENTS)
from  (select distinct row_rid, langcode from #twocolumn1) tc
for xml path, root('rows')



drop table #pfcrow
select * into #pfcrow  from 
(select  lc.row_rid, lc.card_rid as field_row_cards, lc.langcode , lc.sublayouttitle , lc.sort_rank
from #landing_content lc 
inner join (select promocard_id from #promocard union all select rawcard_rid from #rawhtml) pc on lc.card_rid = pc.promocard_id
where SLOTNAME = 'nvcgSlLayoutFeatureA'  and lc.row_rid not in (select row_rid from #landing_contentMM)
union all
select lc.row_rid, lc.card_rid as field_row_cards , lc.langcode , lc.sublayouttitle,  lc.sort_rank
from #landing_content lc inner join #externalpromocard pc on lc.card_rid = pc.externalpromocard_id
where SLOTNAME = 'nvcgSlLayoutFeatureA' and lc.row_rid not in (select row_rid from #landing_contentMM)
) a



drop table #twoitemfcrow
select * into #twoitemfcrow  from 
(select  lc.row_rid, lc.card_rid as field_row_cards, lc.langcode ,  lc.sort_rank
from #twoitemfeaturecardrow lc inner join #promocard pc on lc.card_rid = pc.promocard_id
union all
select lc.row_rid, lc.card_rid as field_row_cards , lc.langcode ,   lc.sort_rank
from #twoitemfeaturecardrow lc inner join #externalpromocard pc on lc.card_rid = pc.externalpromocard_id
) a



drop table #gcrow
select  lc.row_rid, lc.card_rid as field_guide_cards, lc.langcode , lc.sublayouttitle , lc.sort_rank
into #gcrow
from #landing_content lc 
inner join #rawhtml pc on lc.card_rid = pc.rawcard_rid
where SLOTNAME = 'nvcgSlLayoutGuideB'


drop table #sfcrow
select * into #sfcrow  from 
(select  lc.row_rid, lc.card_rid as field_row_cards, lc.langcode , lc.sublayouttitle, lc.sort_rank
from #landing_content lc inner join #promocard pc on lc.card_rid = pc.promocard_id
where SLOTNAME = 'nvcgSlLayoutFeatureB' and lc.row_rid not in (select row_rid from #landing_contentMM)
union all
select lc.row_rid, lc.card_rid as field_row_cards , lc.langcode , lc.sublayouttitle, lc.sort_rank
from #landing_content lc inner join #externalpromocard pc on lc.card_rid = pc.externalpromocard_id
where SLOTNAME = 'nvcgSlLayoutFeatureB' and lc.row_rid not in (select row_rid from #landing_contentMM)
) a


drop table #list 

select * into #list from
(
select distinct lc.row_rid, lc.card_rid as field_list_items, lc.langcode, lc.sort_rank
, 'list_item_title_desc_image' as field_list_item_style
, ll.listitem_rank 
from #landinglistitem ll inner join #landing_content lc on ll.listitem_rid = lc.card_rid
union all
select ll.parentid, ll.listitem_rid as field_list_items, ll.langcode, ll.listitem_rank
, 'list_item_title_desc_image' as field_list_item_style
, ll.listitem_rank 
 from #landinglistitem ll
where ll.parentid in (select CONTENTID from #mini) 
) a
where field_list_items  in (select internallink_id from #internallink)
or field_list_items  in (select externallink_id from #externallink)

GO






---!! list
select  row_rid, langcode, field_list_item_style
, (select field_list_items as field_list_item 
	from #list l1 
	where l1.row_rid = l.row_rid and l1.row_rid in (select row_rid from #list group by row_rid having COUNT(*) =1 )
	for XML path (''), TYPE, ELEMENTS
	)
, (select field_list_items as field_list_items 
	from #list l1 
	where l1.row_rid = l.row_rid and l1.row_rid in (select row_rid from #list group by row_rid having COUNT(*) >1 )
	order by l1.listitem_rank
	for XML path (''), TYPE, ELEMENTS
	)
from (select distinct row_rid, langcode, field_list_item_style from #list ) l 
for xml path, root ('rows')




--- !! primary feature card row
select  row_rid, langcode, sublayouttitle as field_container_heading
,(select distinct field_row_cards as field_row_card 
		from #pfcrow r where r.row_rid =a.row_rid 
			and r.row_rid in (select row_rid from #pfcrow group by row_rid having COUNT(*) = 1) for XML path (''), TYPE, ELEMENTS) 
,(select distinct field_row_cards, r.sort_rank
		from #pfcrow r 
			where r.row_rid =a.row_rid 
			and r.row_rid in (select row_rid from #pfcrow group by row_rid having COUNT(*) > 1) 
			order by r.sort_rank
			for XML path (''), TYPE, ELEMENTS) 

from 
(select distinct row_rid, langcode, sublayouttitle 
 from #pfcrow )a
 for xml path , root ('rows')


select * from #pfcrow where row_rid = 7081165
select * from #landing_content


--- !! secondary feature card row
select  row_rid, langcode, 
sublayouttitle as field_container_heading
,(select distinct field_row_cards as field_row_card
	from #sfcrow r 
	where r.row_rid =a.row_rid and r.row_rid in (select row_rid from #sfcrow group by row_rid having COUNT(*) =1)
	for XML path (''), TYPE, ELEMENTS) 
,(select distinct field_row_cards , r.sort_rank
	from #sfcrow r 
	where r.row_rid =a.row_rid and r.row_rid in (select row_rid from #sfcrow group by row_rid having COUNT(*) >1)
	order by r.sort_rank
	for XML path (''), TYPE, ELEMENTS) 
from 
(select distinct row_rid, langcode, sublayouttitle 
 from #sfcrow )a
 for xml path, root ('rows')



--- !! guide card row
select  row_rid, langcode
, sublayouttitle as field_container_heading
,(select distinct field_guide_cards as field_guide_card
	from #gcrow r where r.row_rid =a.row_rid 
	and r.row_rid in (select row_rid from #gcrow group by row_rid having COUNT(*)= 1 ) for XML path (''), TYPE, ELEMENTS) 
  ,(select distinct field_guide_cards , r.sort_rank
		from #gcrow r where r.row_rid =a.row_rid 
		and r.row_rid in (select row_rid from #gcrow group by row_rid having COUNT(*)> 1 )
		order by r.sort_rank
		for XML path (''), TYPE, ELEMENTS) 
from 
(select distinct row_rid, langcode, sublayouttitle 
 from #gcrow )a
 for xml path, root ('rows')

---two item feature card row 

select row_rid, langcode
, (select distinct field_row_cards as field_two_item_row_cards , SORT_RANK
		from #twoitemfcrow where row_rid = a.row_rid 
		order by SORT_RANK
		for XML path (''), TYPE, ELEMENTS)
from (select distinct row_rid, langcode from #twoitemfcrow )a
for xml path , root ('rows')




--- multi media row

drop table #landing_contentMM1
select * into #landing_contentMM1 
from #landing_contentMM
where slotname = 'nvcgSlLayoutFeatureB' and card_rid in
 (select promocard_id from #promocard union all select externalpromocard_id from #externalpromocard union all select rawcard_rid from #rawhtml)

insert into #landing_contentMM1 
select *
from #landing_contentMM
where slotname = 'nvcgSlLayoutMultimediaA' and linkid in 
(select id from (select id, CONTENTTYPENAME  from #enpage  union all select id, contenttypename from #espage) a where CONTENTTYPENAME in ('cgvInfographic', 'glovideo'))



---!!TODO nvcgSlLayoutMultimediaA
--select * from #landing_contentMM1 
--where slotname = 'nvcgSlLayoutFeatureB' and card_rid in




drop table #MMrow
select row_rid, 
(select card_rid from #landing_contentMM1 l
where l.row_rid = mm.row_rid and SLOTNAME = 'nvcgSlLayoutFeatureB') as field_mm_feature_card
,(select linkid from #landing_contentMM1 l
where l.row_rid = mm.row_rid and SLOTNAME = 'nvcgSlLayoutMultimediaA') as field_mm_media_item
, langcode
into #MMrow
from (select distinct row_rid, langcode from #landing_contentMM  where SLOTNAME ='nvcgSlLayoutMultimediaA' ) mm


select * from #landing_contentMM


select row_rid, langcode
, (select distinct field_mm_feature_card
		from #MMrow where row_rid = a.row_rid 
		for XML path (''), TYPE, ELEMENTS)
, (select distinct field_mm_media_item
		from #MMrow where row_rid = a.row_rid 
		for XML path (''), TYPE, ELEMENTS)		
from (select distinct row_rid, langcode from #MMrow )a
for xml path , root ('rows')





drop table #l
select distinct  r.row_rid as field_landing_content 
, id,  rowtype, r.langcode, r.sublayout_rank
 into #l
	from #landing_content r 
	inner join 
	(select  row_rid, '1pfc' as rowtype, langcode from #pfcrow
	union all
	select row_rid, '4sfc', langcode from #sfcrow
	union all
	select row_rid, '2gc' , langcode from #gcrow
	union all
	select row_rid, '9list', langcode from #list
	union all
	select distinct row_rid , '52col' , langcode from #twocolumn1
	union all
	select distinct rawcard_rid, '3rawhtml', langcode   from #rawhtml 
	union all
	select distinct row_rid , '6mm', langcode from #MMrow
	) a on r.row_rid = a.row_rid
	




-- mini landing content block
drop table #minicontentblock
select * into #minicontentblock from
(
select p.id as parentid, p.id + 20000 as id, pp.BODY as field_html_content, 2 as sort_rank, langcode
from ( select id, langcode from #enpage union all select id , langcode from #espage ) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id inner join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA pp on pp.CONTENTID = c.CONTENTID and pp.REVISIONID = c.CURRENTREVISION
where p.id in (select CONTENTID from #mini) and pp.BODY is not null
union all
select p.id as parentid, p.id + 10000, p.field_intro_text, 1, langcode
from ( select id, langcode,field_intro_text from #enpage union all select id , langcode,field_intro_text from #espage ) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
where p.id in (select CONTENTID from #mini) and p.field_intro_text is not null
)a

select   
1 as tag
, 0 as parent
,id as [row!1!id]
, langcode as [row!1!langcode]
, field_html_content [row!1!body!CDATA]
from #minicontentblock
for xml explicit , root ('rows')
---------


drop table #minilandingcontent
select * into #minilandingcontent from
(
select distinct parentid, parentid as id,  3 as sort_rank from #landinglistitem l 
union 
select distinct parentid, ID, 1 from #minicontentblock b 
union
select  distinct CONTENTID, row_rid,2   from #twoitemfeaturecardrow
) a
order by 1




----mini landing English
select pd.*,[row!2!field_landing_content],[row!2!field_landing_contents]
, [row!2!field_banner_image]
,[row!2!field_image_promotional!Element]
from #enpagedata pd 
inner join 
(select
1 as tag,
0 as parent,
NULL as id 
,NULL as [row!2!field_landing_contents]
,NULL as [row!2!field_landing_content]
,NULL as [row!2!field_banner_image]
,NULL as [row!2!field_image_promotional!Element]
union all 
select 
2 as tag
, 1 as parent
, p.id
 ,		(select id as field_landing_contents from #minilandingcontent mc where mc.parentid = p.id 
			and mc.parentid in (select parentid from #minilandingcontent group by parentid having COUNT(*) > 1)
		 order by sort_rank
		 for XML path (''), TYPE, ELEMENTS) 
,		(select id as field_landing_content from #minilandingcontent mc where mc.parentid = p.id 
			and mc.parentid in (select parentid from #minilandingcontent group by parentid having COUNT(*) = 1)
		 order by sort_rank
		 for XML path (''), TYPE, ELEMENTS) 
,

(select   
	'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c2.contentid,''),10,999) + '/'+ 
	si.IMG_UTILITY_FILENAME as field_banner_image
		from CONTENTSTATUS c 
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.CURRENTREVISION
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = p.langcode) as field_image_promotional
from  #enpage p where p.id in (select contentid from #mini )
) a
on (a.tag = pd.Tag and a.parent = pd.Parent and a.tag =1) or (a.tag = 2 and a.id = pd.[row!2!id])
order by pd.tag
for xml explicit





----mini landing spanish
select pd.*,[row!2!field_landing_content],[row!2!field_landing_contents]
, [row!2!field_banner_image]
,[row!2!field_image_promotional!Element]
from #espagedata pd 
inner join 
(select
1 as tag,
0 as parent,
NULL as id 
,NULL as [row!2!field_landing_contents]
,NULL as [row!2!field_landing_content]
,NULL as [row!2!field_banner_image]
,NULL as [row!2!field_image_promotional!Element]
union all 
select 
2 as tag
, 1 as parent
, p.englishid
 ,		(select id as field_landing_contents from #minilandingcontent mc where mc.parentid = p.id 
			and mc.parentid in (select parentid from #minilandingcontent group by parentid having COUNT(*) > 1)
		 order by sort_rank
		 for XML path (''), TYPE, ELEMENTS) 
,		(select id as field_landing_content from #minilandingcontent mc where mc.parentid = p.id 
			and mc.parentid in (select parentid from #minilandingcontent group by parentid having COUNT(*) = 1)
		 order by sort_rank
		 for XML path (''), TYPE, ELEMENTS) 
,

(select   
	'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c2.contentid,''),10,999) + '/'+ 
	si.IMG_UTILITY_FILENAME as field_banner_image
		from CONTENTSTATUS c 
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.CURRENTREVISION
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = 'es') as field_image_promotional
from  #espage p where p.id in (select contentid from #mini )
) a
on (a.tag = pd.Tag and a.parent = pd.Parent and a.tag =1) or (a.tag = 2 and a.id = pd.[row!2!id])
order by pd.tag
for xml explicit




---home landing page  English
select p.*
, (select field_landing_content 
		from #l l
		where l.id = p.id and l.id in 
		(select id from #l group by id having COUNT(*) = 1	) 
		for XML path (''), TYPE, ELEMENTS) 
, (select field_landing_content as field_landing_contents 
		from #l l
		where l.id = p.id and l.id in 
		(select id from #l group by id having COUNT(*) > 1	) 
		 order by l.rowtype
			for XML path (''), TYPE, ELEMENTS) 
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = p.langcode) as field_image_promotional
from #enpage p 
where p.id in (select id from #landing_content )
for xml path , root ('rows')



---  home landing spanish
select 
CONTENTTYPENAME,
term_id,
englishid as id,
title,
langcode,
field_short_title,
field_page_description,
field_feature_card_description,
field_list_description,
field_search_engine_restrictions,
field_public_use,
field_date_posted,
field_date_reviewed,
field_date_updated,
field_pretty_url,
field_browser_title,
field_card_title,
field_intro_text
, (select field_landing_content 
		from #l l
		where l.id = p.id and l.id in 
		(select id from #l group by id having COUNT(*) = 1	) 
		for XML path (''), TYPE, ELEMENTS) 
, (select field_landing_content as field_landing_contents 
		from #l l
		where l.id = p.id and l.id in 
		(select id from #l group by id having COUNT(*) > 1	) 
		 order by l.rowtype
			for XML path (''), TYPE, ELEMENTS) 
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = 'es') as field_image_promotional
from #espage p 
where p.id in (select id from #landing_content )
for xml path , root ('rows')
















----------

select c.CONTENTID, c.TITLE, dbo.gaogetitemFolderPath(c.contentid, '') as folder, c1.title from 
(select *, null as englished from #enpage union all select * from #espage) a
inner join contentstatus c on c.contentid = a.id 
inner join psx_objectrelationship r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where sl.SLOTNAME like '%related%'
and t1.CONTENTTYPENAME = 'ncifile'
union all
select c.CONTENTID, c.TITLE, dbo.gaogetitemFolderPath(c.contentid, '') as folder, c2.title from #landing_content lc 
inner join contentstatus c on c.contentid = lc.id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = lc.linkid
inner join CT_CGVCUSTOMLINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.CURRENTREVISION
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID
where lc.CONTENTTYPENAME = 'cgvcustomlink' and t2.CONTENTTYPENAME = 'ncifile'



select c.CONTENTID, c.TITLE, c2.title from 
(select *, null as englished from #enpage union all select * from #espage) a
inner join contentstatus c on c.contentid = a.id 
inner join psx_objectrelationship r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCUSTOMLINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.CURRENTREVISION
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID
where sl.SLOTNAME like '%related%'
and t1.CONTENTTYPENAME = 'cgvcustomlink' and sl1.SLOTNAME = 'cgvCustomLink'
and t2.CONTENTTYPENAME = 'ncifile'



select 



------------------------

--rawhtml
select   
1 as tag
, 0 as parent
,rawcard_rid as [row!1!id]
, langcode as [row!1!langcode]
, BODYFIELD [row!1!body!CDATA]
from #rawhtml
for xml explicit , root('rows')




--------------------------

select * from #landinglist


select  c.CONTENTID , c.TITLE, t1.CONTENTTYPENAME , r.SORT_RANK, sl.SLOTNAME, r.RID, c1.TITLE 
 , c1.contentid
from CONTENTSTATUS c 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where c.CONTENTID in (select CONTENTID from #mini)
and sl.SLOTNAME not like 'sys%' and sl.SLOTNAME not like 'gloimage%' and sl.SLOTNAME not like '%header'
--and sl.SLOTNAME = 'nvcgSlLayoutThumbnailA'
order by 1

select * from #mini where CONTENTID = 911505

select  c.CONTENTID , c.TITLE, t1.CONTENTTYPENAME , r.SORT_RANK, sl.SLOTNAME, r.RID, c1.TITLE 
 , c1.contentid
from CONTENTSTATUS c 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where c.CONTENTID = 911505


select lc.* from #landing_content lc inner join #espage p on lc.id = p.id 
where p.field_short_title = 'El cáncer'
where id  = 13367

select * from #espage where englishid = 13367

select * from #landing_content lc 
where id = 76315
inner join #espage p on lc.linkid 


select * from #promocard where promocard_id = 7280107


select lc.* from #landing_content lc inner join #espage p on lc.id = p.id 
where p.field_short_title = 'Noticias'




select * from #landing_content
where id = 13367


select * from #landing_content where id = 13963

select * from #l
where id = 13367
order by id , sort_rank


select * from #pfcrow
where row_rid = 7213166

select * from #landing_content where card_rid = 7301434


select * from #landing_content
where id = 13367

-------

---------------------------------------
----------------------------------------

select p.CONTENTTYPENAME,p.title, lc.* 
from #landing_content lc inner join #enpage p on p.id = lc.id
where  title like  'news%'
--where SLOTNAME =  'nvcgSlLayoutGuideB'




select p.contenttypename, sl.slotname ,  t1.contenttypename, p.title
, sl1.SLOTNAME
, sub.*
, c2.TITLE, t2.CONTENTTYPENAME 
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join (PSX_OBJECTRELATIONSHIP r1 inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
inner join CT_CGVSUBLAYOUT sub on sub.CONTENTID = c1.CONTENTID and sub.REVISIONID = c1.CURRENTREVISION
where sl.SLOTNAME  = 'nvcgSlBodyLayout'
and sl1.SLOTNAME in ('nvcgSlLayoutFeatureA','nvcgSlLayoutFeatureB', 'nvcgSlLayoutGuideB', 'nvcgSlLayoutGeneralB', 'nvcgSlLayoutGeneralA' , 'nvcgSlLayoutThumbnailA')
order by 1, 2, 4, sl1.slotname, r1.SORT_RANK




---------------------





---!! MM question
select  c.TITLE as pageTitle, c.CONTENTID , dbo.gaogetitemFolderPath(c.CONTENTID, '') as folder,
(select top 1 sub.TEMPLATE from CT_CGVSUBLAYOUT sub where sub.CONTENTID = c1.CONTENTID and sub.template is not null order by sub.REVISIONID desc) as cardContainerTemplate,
c1.TITLE as cardContainer,
sl1.SLOTNAME, pt1.NAME as SnippetTemplate, c2.TITLE , t2.CONTENTTYPENAME 
into #landing
from (select id, langcode, contenttypename from #enpage union select id, langcode, CONTENTTYPENAME  from #espage) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join PSX_TEMPLATE pt on pt.TEMPLATE_ID = r.VARIANT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVSUBLAYOUT sub on sub.CONTENTID = c1.CONTENTID and sub.REVISIONID = c1.CURRENTREVISION
left outer join (PSX_OBJECTRELATIONSHIP r1 
			inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
			inner join PSX_TEMPLATE pt1 on pt1.TEMPLATE_ID = r1.VARIANT_ID
			 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
where p.CONTENTTYPENAME in ('ncihome', 'ncilandingpage')
--and (c1.TITLE like '%multimedia%' or sl.SLOTNAME like '%Multi%' or sl1.SLOTNAME like '%MM%' or sl1.SLOTNAME like '%multimedia%')
order by 3, sl1.slotname , r1.sort_rank 






select SLOTNAME, t1.contenttypename, p.contenttypename , COUNT(*)
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where SLOTNAME not like 'sys%' and SLOTNAME not in ('cgvCitationSl', 'cgvRelatedPages', 'cgvBlogSeriesRelationship', 'gloImageSl', 'nciFile', 'cgvTileSlot', 'nvcgSlCTHPAudienceToggle')
and SLOTNAME not like '%infoslot'
group by SLOTNAME , t1.contenttypename, p.contenttypename
order by 1,2,3
 
 
 --Landing  nvcgSlBodyLayout   --> cgvSubLayout
 --(card container)
select p.contenttypename, sl.slotname ,  t1.contenttypename, p.title
, sl1.SLOTNAME, c2.TITLE, t2.CONTENTTYPENAME 
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join (PSX_OBJECTRELATIONSHIP r1 inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
where sl.slotid = 987
order by 1, 2, 4, sl1.slotname, r1.SORT_RANK







--nvcgSlLayoutFeatureA  --> internal link
--primary feature A
select p.contenttypename, sl.slotname ,  t1.contenttypename, p.title
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where sl.slotid = 969
order by 1, 2, 4

nvcgSlLayoutThumbnailA --> internal link
select p.contenttypename, sl.slotname ,  t1.contenttypename, p.title
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where sl.slotid = 981
order by 1, 2, 4


select contenttypename, COUNT(*) from #enpage group by CONTENTTYPENAME 

select * from CONTENTTYPES t where CONTENTTYPENAME like '%guide%'



------------

use tempdb

select * from 

select '[' + name + '],' 
from tempdb.sys.columns where object_id =object_id('tempdb..#enpagedata');


select * from #enpagedata



select s.SLOTNAME ,  p.*  from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join contenttypes t1 on t1.contenttypeid = c1.contenttypeid 
where s.SLOTNAME like 'sys%' and p.CONTENTTYPENAME not in ('cgvfactsheet')
and t1.CONTENTTYPENAME like '%im%'





declare @agent table
(    
    AgentID int,
    Fname varchar(5),
    SSN varchar(11)
)

insert into @agent
select 1, 'Vimal', '123-23-4521' union all
select 2, 'Jacob', '321-52-4562' union all
select 3, 'Tom', '252-52-4563'

SELECT
    1 AS Tag,
    NULL AS Parent,
    NULL AS 'Agents!1!',
    NULL AS 'Agent!2!AgentID',
    NULL AS 'Agent!2!Fname!Element',
    NULL AS 'Agent!2!SSN!cdata'
UNION ALL
SELECT
    2 AS Tag,
    1 AS Parent,
    NULL, 
    AgentID,
    Fname,
    SSN
FROM @agent
FOR XML EXPLICIT



-----!!! BODY and INTRO CDATA as element



select * from #enpage where CONTENTTYPENAME not in ( 'cgvblogpost', 'cgvpressrelease') and field_intro_text is not null



select * from #espage where CONTENTTYPENAME not in ( 'cgvblogpost', 'cgvpressrelease') and field_intro_text is not null




select * from #espage where CONTENTTYPENAME not in ( 'cgvblogpost', 'cgvpressrelease') and englishid  is not null













--------------




-- !!replace inner join with para


---!!
--Select lower(name) +' as [row!1!' + LOWER(name) + '],'  From  Tempdb.Sys.Columns Where Object_ID = Object_ID('tempdb..#enpage')
--Select lower(name) + ','  From  Tempdb.Sys.Columns Where Object_ID = Object_ID('tempdb..#en')
--select contenttypename, COUNT(*) from #enpage group by CONTENTTYPENAME 

select * from #internallink where internallink_id = 6779591











select p.*
from  #enpage 	 p 
left outer join (select * from #para union all select * from #espara) pa on p.id = pa.id 
where p.CONTENTTYPENAME not in ( 'cgvpressrelease', 'cgvblogpost') and p.field_intro_text is not null


select * from #espage where  id= 911562

select * from CONTENTSTATUS c inner join contenttypes t on t.contenttypeid = c.contenttypeid where CONTENTID = 312922


select r.OWNER_ID from #internallink l inner join PSX_OBJECTRELATIONSHIP r on l.internallink_id = r.DEPENDENT_ID
intersect
select r.OWNER_ID from #externallink l inner join PSX_OBJECTRELATIONSHIP r on l.externallink_id = r.DEPENDENT_ID











--select p.*, pa.para_id
--	,(
--		select internallink_id as related_resource_id
--		from  CONTENTSTATUS c
--		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
--		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
--		where  c.contentid = p.id and c.contentid in 
--				(select p.id
--				from #enpage p 
--				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
--				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
--				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
--				where il.internallink_id is NOT null
--				group by p.id
--				having COUNT(distinct internallink_id)  = 1)
--			FOR XML path (''), TYPE, ELEMENTS
--			)
--	,(
--		select internallink_id as related_resource_ids
--		from  CONTENTSTATUS c
--		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
--		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
--		where  c.contentid = p.id and c.contentid in 
--				(select p.id
--				from #enpage p 
--				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
--				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
--				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
--				where il.internallink_id is NOT null
--				group by p.id
--				having COUNT(distinct internallink_id)  > 1)
--			FOR XML path (''), TYPE, ELEMENTS
--			)
--from  #enpage 	 p 
--left outer join (select * from #para union all select * from #espara) pa on p.id = pa.id 
--where p.CONTENTTYPENAME not in ( 'cgvpressrelease', 'cgvblogpost')
--for xml path











-------------------

select p.*, pa.para_id
	,(
		select internallink_id as related_resource_id 
		from
		(select internallink_id 
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #internallink il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p inner join #para pa on p.id = pa.id 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #internallink il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			union all
			select externallink_id 
				from  CONTENTSTATUS c
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				inner join #externallink el on el.externallink_id = r.RID
				where  c.contentid = p.id and c.contentid in 
						(select p.id
						from #enpage p inner join #para pa on p.id = pa.id 
						inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
						inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
						left outer join #externallink el on el.externallink_id = r.RID
						where el.externallink_id is NOT null
						group by p.id
						having COUNT(distinct externallink_id)  = 1
						)
				)a
				FOR XML path (''), TYPE, ELEMENTS
			)
				
	,(select related_resource_ids
		from 
		(select internallink_id as related_resource_ids 
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #internallink il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p inner join #para pa on p.id = pa.id 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #internallink il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1
				)
			union all
			select externallink_id as externallink_ids 
			from  CONTENTSTATUS c
			inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
			inner join #externallink el on el.externallink_id = r.RID
			where  c.contentid = p.id and c.contentid in 
					(select p.id
					from #enpage p inner join #para pa on p.id = pa.id 
					inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
					inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
					left outer join #externallink el on el.externallink_id = r.RID
					where el.externallink_id is NOT null
					group by p.id
					having COUNT(distinct externallink_id)  > 1
					)
				)b
			FOR XML path (''), TYPE, ELEMENTS )  
	
from #enpage p left outer join #para pa on p.id = pa.id 
for xml path











------------------------------


---!!! success
---!!!
select p.*, pa.para_id
	,(select internallink_id 
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #internallink il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p inner join #para pa on p.id = pa.id 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #internallink il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1
				)
		FOR XML path (''), TYPE, ELEMENTS) 
	,(select internallink_id as internallink_ids 
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #internallink il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p inner join #para pa on p.id = pa.id 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #internallink il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1
				)
	FOR XML path (''), TYPE, ELEMENTS ) 
	,(select externallink_id 
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #externallink el on el.externallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p inner join #para pa on p.id = pa.id 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #externallink el on el.externallink_id = r.RID
				where el.externallink_id is NOT null
				group by p.id
				having COUNT(distinct externallink_id)  = 1
				)
		FOR XML path (''), TYPE, ELEMENTS) 
	,(select externallink_id as externallink_ids 
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
		inner join #externallink el on el.externallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p inner join #para pa on p.id = pa.id 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.CURRENTREVISION = r.OWNER_REVISION
				left outer join #externallink el on el.externallink_id = r.RID
				where el.externallink_id is NOT null
				group by p.id
				having COUNT(distinct externallink_id)  > 1
				)
	FOR XML path (''), TYPE, ELEMENTS ) 
from #enpage p left outer join #para pa on p.id = pa.id 

for xml path










---------------------------------



select c1.contentid as internallink_id,  cl.OVERRIDE_TITLE as field_override_title
from #enpage en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = r.OWNER_REVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCUSTOMLINK cl on cl.CONTENTID = c1.CONTENTID and cl.REVISIONID = c1.CURRENTREVISION
where sl.SLOTNAME like  '%related%' and t1.CONTENTTYPENAME = 'cgvCustomLink'
union all
select c1.contentid as internallink_id, 
--r.RID , 
COUNT(*)
from #enpage en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = r.OWNER_REVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where sl.SLOTNAME like  '%related%' and t1.CONTENTTYPENAME <> 'cgvCustomLink' and t1.CONTENTTYPENAME <> 'ncilink'
group by c1.CONTENTID 
having COUNT(*) > 1
order by 













select * from PSX_RELATIONSHIPCONFIGNAME




select en.id, en.field_short_title, es.field_short_title
from #enpage en 
inner join CONTENTSTATUS c on en.id = c.CONTENTID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION and r.CONFIG_ID = 6 
inner join #espage es on r.DEPENDENT_ID = es.id 
inner join #espara pa on es.id = pa.id 




select en.id, es.CONTENTTYPENAME, es.field_date_posted,es.field_date_reviewed, es.field_page_description, es.field_pretty_url, es.field_short_title, es.langcode, es.term_id, es.title
, pa.para_id
from #enpage en 
inner join CONTENTSTATUS c on en.id = c.CONTENTID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION and r.CONFIG_ID = 6 
inner join #espage es on r.DEPENDENT_ID = es.id 
inner join #espara pa on es.id = pa.id 
for xml path 





