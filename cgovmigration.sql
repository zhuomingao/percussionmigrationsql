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
select CONTENTID into #mini 
from contentstatus where CONTENTID  in
(916031,
858227,
859583,
859634,
14222,
14304,
1099430,
909708,
910917,
910942,
429220,
1080199,
14587,
915971,
883849,
13054,
911134,
911505,
14034,
63867,
1090830,
1043595,
941434,
1026781,
321607,
1057088,
866280,
1074842,
1117590,
747150,
828020,
1038929,
988378,
1052650,
1047566,
1087420,
1088972,
768882,
867853,
810260,
776914,
1026249,
1078650,
936591,
918974,
912884,
915080,
1054479,
105818,
14879,
956474,
1091338,
901508,
1061048,
1113026,
951603,
936686,
936680,
936681,
936682,
936685,
951608,
914801,
916849,
916766,
1092431,
915271,
1011470,
16360,
1102955,
1114852,
951125,
919000,
922513,
930168,
915591,
14257,
1034951,
866188,
1061645,
799546,
1061727,
799373,
916695,
1033175,
916661,
608324,
1041143,
917286,
917517,
941591,
922315,
941619,
941622,
941581,
941598,
176775,
917508,
917507,
14272,
102551,
65156,
905730,
918912,
65192,
1104024,
969702,
970160,
974319,
1026805,
425591,
14404,
14539,
13194,
177549,
921709,
941585,
951081,
951121,
919123,
913440,
913462,
15184,
64633,
950983,
950985,
1040936,
1071686,
1110088,
557445,
894100,
847704,
844674,
844695,
844705,
845082,
586772,
579694,
595697,
686212,
675681,
641530,
499957,
989419,
989420,
1028685,
1059679,
909856,
952582,
952519,
15754,
386622,
386688,
13177,
14132,
445961,
13082,
1107630,
1107631,
1107624,
1107629,
915368,
840882,
1111025,
929700,
929880,
951269,
1078449,
1078448,
1078446,
1102830,
936262,
936263,
1034471,
1070069,
1106668,
505627,
919682,
909853,
909433,
989416,
989418,
1001033,
1060214,
836316,
836317,
836320,
836324,
836256,
836658,
836659,
836725,
836754,
836829,
836921,
837258,
586656,
586657,
532546,
685623,
488281,
464419,
464420,
464421,
463785,
463786,
463787,
463788,
929890,
14308,
15076,
14490,
15611,
13866,
14106,
929896,
799547,
267267,
941586,
1104012,
1104013,
1104010,
1104011,
941596,
1135267,
1135289,
1140635,
1134663)
--(916031,858227,859583,859634,14222,14304,1099430,909708,910917,910942,429220,1080199,14587,915971,883849,13054,911134,911505,14034,63867,1090830,1043595,941434,1026781,321607,1057088,866280,1074842,1117590,747150,828020,1038929,988378,1052650,1047566,1087420,1088972,768882,867853,810260,776914,1026249,1078650,936591,918974,912884,915080,1054479,105818,14879,956474,1091338,901508,1061048,1113026,951603,936686,936680,936681,936682,936685,951608,914801,916849,916766,1092431,915271,1011470,16360,1102955,1114852,951125,919000,922513,930168,915591,14257,1034951,866188,1061645,799546,1061727,799373,916695,1033175,916661,608324,1041143,917286,917517,941591,922315,941619,941622,941581,941598,176775,14272,102551,65156,905730,918912,65192,1104024,969702,970160,974319,1026805,425591,917733,917734)
--or CONTENTID in 
--(
--select c.CONTENTID
--from CONTENTSTATUS c inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID  and c.public_revision = r.OWNER_REVISION
--inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
--inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
--inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
--inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
--inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
--where t1.CONTENTTYPENAME = 'cgvDynamicList' and sl.SLOTNAME = 'cgvBody' 
--and c.TITLE not like '%2013%press%' and c.TITLE not like '%2012%press%'
--)


delete from #mini where CONTENTID in (
select m.CONTENTID  from #mini m inner join #espage s on m.CONTENTID = s.id 
where s.englishid not in (select CONTENTID from #mini) )




drop table #d
select * into #d from
 (select 'updated' as date_display_mode union all select 'posted')a


---long title -> title , short title -> short title

drop table #summary 
select c.contentid as id, su.CDRID as field_pdq_cdr_id, p.Long_title as title 
--, su.PILOT_SHORT_TITLE as field_short_title
into #summary
from CONTENTSTATUS c 
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
inner join #folder f on f.id = r.owner_id
inner join CT_PDQCANCERINFOSUMMARY su on c.CONTENTID = su.CONTENTID and c.public_revision = su.REVISIONID
inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
left outer join 
( PSX_OBJECTRELATIONSHIP rs inner join CONTENTSTATUS cs on cs.CONTENTID = rs.DEPENDENT_ID
inner join CT_PDQCANCERINFOSUMMARY sus on cs.CONTENTID = sus.CONTENTID and cs.public_revision = sus.REVISIONID
) 
on rs.OWNER_ID = c.CONTENTID and rs.OWNER_REVISION = c.public_revision and rs.CONFIG_ID = 6
where c.locale = 'en-us'


select * from #summary
for xml path , root ('rows')




drop table #summaryes 
select cs.contentid as id, c.CONTENTID as spanishid 
, su.cdrid as field_pdq_cdr_id 
, p.LONG_TITLE as title, 'es' as langcode
into #summaryes
from CONTENTSTATUS c 
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
inner join #folder f on f.id = r.owner_id
inner join CT_PDQCANCERINFOSUMMARY su on c.CONTENTID = su.CONTENTID and c.public_revision = su.REVISIONID
inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
left outer join 
( PSX_OBJECTRELATIONSHIP rs inner join CONTENTSTATUS cs on cs.CONTENTID = rs.owner_id and cs.public_revision = rs.OWNER_REVISION
inner join CT_PDQCANCERINFOSUMMARY sus on cs.CONTENTID = sus.CONTENTID and cs.public_revision = sus.REVISIONID
) 
on rs.DEPENDENT_ID = c.contentid and rs.CONFIG_ID = 6
where c.locale = 'es-us'
and cs.TITLE is not null

select * from #summaryes
for xml path , root ('rows')


drop table #dis
select c.contentid as id, su.CDRID as field_pdq_cdr_id, p.LONG_TITLE as title
into #dis 
from CONTENTSTATUS c 
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
inner join #folder f on f.id = r.owner_id
inner join CT_PDQDRUGINFOSUMMARY su on c.CONTENTID = su.CONTENTID and c.public_revision = su.REVISIONID
inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
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
,m.CONTENTID as field_mega_menu_content
, case f.path when '' then 1 else 0 end as field_breadcrumb_root
, 'en' as langcode
, w.CHANNEL as field_channel
, w.CONTENT_GROUP as field_content_group
into #en
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		left outer join GENWEBANALYTICS_GENWEBANALYTICS w on w.CONTENTID = c.CONTENTID and w.REVISIONID = c.public_revision
		inner join #folder f on f.id = r.owner_id
		left outer join (PSX_OBJECTRELATIONSHIP rsubmenu inner join RXSLOTTYPE slsub on rsubmenu.SLOT_ID  = slsub.SLOTID and SLOTNAME = 'rffNavSubmenu' inner join CONTENTSTATUS co on co.CONTENTID = rsubmenu.OWNER_ID and co.public_revision = rsubmenu.OWNER_REVISION) 
			on rsubmenu.DEPENDENT_ID = c.CONTENTID 
		left outer join 
		(PSX_OBJECTRELATIONSHIP rp 
		inner join CONTENTSTATUS cpn on cpn.CONTENTID = rp.DEPENDENT_ID 
		inner join CONTENTTYPES tpn on tpn.CONTENTTYPEID = cpn.CONTENTTYPEID and tpn.CONTENTTYPENAME in ('rffNavon', 'rffNavtree') )
		 on rp.OWNER_ID = f.ParentID and rp.CONFIG_ID = 3
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVNAVMETADATA_CGVNAVMETADATA n on n.contentid = c.contentid and n.REVISIONID = c.public_revision 
		 outer apply 
		 (select c1.contentid, p.SHORT_TITLE from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c1.CONTENTID and p.REVISIONID = c1.public_revision
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and st.SLOTNAME = 'rffNavLandingPage' 
		) landing
		outer apply 
		 (select c1.contentid from PSX_OBJECTRELATIONSHIP r1 
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
		 where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and t1.contenttypename = 'cgvBreadcrumb' ) breadcrumb
			outer apply 
			(select c1.title, sn.LEVELS_TO_SHOW, sn.SECTION_NAV_TITLE 
			from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_NCISECTIONNAV sn on sn.CONTENTID = c1.CONTENTID and sn.REVISIONID = c1.public_revision
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and st.SLOTNAME = 'nvcgSlSectionNav' ) sectionNav
			outer apply (select  h.CONTENTID from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_GLORAWHTML h on h.CONTENTID = r1.DEPENDENT_ID and c1.public_revision = h.REVISIONID 
		where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
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
and f.Path not like '/nci/pediatric-adult-rare-tumor%'
order by 1,2



update #en set name = replace(REPLACE(name, '&reg;','®'), '&amp;', '&')






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
, coalesce( p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(  p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as field_intro_text
, syn.SYNDICATE
, p.META_KEYWORDS
into #enpage
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
		inner join CGVCONTENTDATES_CGVCONTENTDATES1 d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.public_revision
		left outer join CGVDATEDISPLAYMODE_CGVDATEDISPLAYMODE1 dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.public_revision
		inner join #en en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.public_revision
		left outer join CGVSYNDICATION_CGVSYNDICATION1 syn on syn.CONTENTID = c.CONTENTID and syn.REVISIONID = c.PUBLIC_REVISION
where c.LOCALE = 'en-us' 
and s.STATENAME not like '%archive%'
and s.STATENAME <> 'draft' 
and s.STATENAME not like '%(D)%'
and CONTENTTYPENAME not in ( 'nciLink',  'cgvDynamicList')
and CONTENTTYPENAME not like 'pdq%'
and CONTENTTYPENAME not like '%image%'
and CONTENTTYPENAME not like 'rffNav%'




select * from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME like '%keyword%'


select * from CGVSEARCHFIELDS_CGVSEARCHFIELDS1
GO







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
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as field_intro_text
, syn.SYNDICATE
, null
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
		inner join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.public_revision
		left outer join GLODATEDISPLAYMODE_GLODATEDISPLAYMODE dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.public_revision
		inner join #en en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.public_revision
		left outer join CGVSYNDICATION_CGVSYNDICATION1 syn on syn.CONTENTID = c.CONTENTID and syn.REVISIONID = c.PUBLIC_REVISION
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME = 'glovideo'
and s.STATENAME <> 'draft' 
and s.STATENAME not like '%(D)%'


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
,p.PRETTY_URL_NAME as field_pretty_url
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(p.card_title, p.short_title) as field_card_title
, null
, syn.SYNDICATE
, null
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
		inner join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.public_revision
		left outer join GLODATEDISPLAYMODE_GLODATEDISPLAYMODE dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.public_revision
		inner join #en en on en.computed_path = f.Path 
		left outer join CGVSYNDICATION_CGVSYNDICATION1 syn on syn.CONTENTID = c.CONTENTID and syn.REVISIONID = c.PUBLIC_REVISION
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME = 'gloinstitution'
and s.STATENAME <> 'draft' 
and s.STATENAME not like '%(D)%'



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
,m.CONTENTID as field_mega_menu_content
, case f.path when '' then 1 else 0 end as field_breadcrumb_root
,'es' as langcode
, w.CHANNEL as field_channel
, w.CONTENT_GROUP  as field_content_group
into #es
from dbo.contentstatus c 		
		left outer join GENWEBANALYTICS_GENWEBANALYTICS w on w.CONTENTID = c.CONTENTID and w.REVISIONID = c.public_revision
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		left outer join (PSX_OBJECTRELATIONSHIP rsubmenu inner join RXSLOTTYPE slsub on rsubmenu.SLOT_ID  = slsub.SLOTID and SLOTNAME = 'rffNavSubmenu' inner join CONTENTSTATUS co on co.CONTENTID = rsubmenu.OWNER_ID and co.public_revision = rsubmenu.OWNER_REVISION) 
			on rsubmenu.DEPENDENT_ID = c.CONTENTID 
		left outer join 
		(PSX_OBJECTRELATIONSHIP rp 
		inner join CONTENTSTATUS cpn on cpn.CONTENTID = rp.DEPENDENT_ID 
		inner join CONTENTTYPES tpn on tpn.CONTENTTYPEID = cpn.CONTENTTYPEID and tpn.CONTENTTYPENAME in ('rffNavon', 'rffNavtree') )
		 on rp.OWNER_ID = f.ParentID and rp.CONFIG_ID = 3
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVNAVMETADATA_CGVNAVMETADATA n on n.contentid = c.contentid and n.REVISIONID = c.public_revision 
		 outer apply 
		 (select c1.contentid, p.SHORT_TITLE from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c1.CONTENTID and p.REVISIONID = c1.public_revision
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and st.SLOTNAME = 'rffNavLandingPage' 
		) landing
		outer apply 
		 (select c1.contentid from PSX_OBJECTRELATIONSHIP r1 
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
		 where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and t1.contenttypename = 'cgvBreadcrumb' ) breadcrumb
			outer apply 
			(select c1.title, sn.LEVELS_TO_SHOW, sn.SECTION_NAV_TITLE 
			from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_NCISECTIONNAV sn on sn.CONTENTID = c1.CONTENTID and sn.REVISIONID = c1.public_revision
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and st.SLOTNAME = 'nvcgSlSectionNav' ) sectionNav
			outer apply (select  h.contentid from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_GLORAWHTML h on h.CONTENTID = r1.DEPENDENT_ID and c1.public_revision = h.REVISIONID 
		where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and st.SLOTNAME = 'nvcgSlMegamenuHtml' ) m
where t.CONTENTTYPENAME in ( 'rffNavon', 'rffNavtree')
order by 1



 
 update #es set name = 'espanol' where computed_path = '/'
 update #es set name = 'El cáncer' where computed_path = '/cancer'
 update #es set name = 'Tipos de cáncer' where computed_path = '/tipos'
 
 
 update #es set name = replace(REPLACE(name, '&reg;','®'), '&amp;', '&')


drop table #espage1
select 
t.CONTENTTYPENAME
, isnull(en.term_id , 6703) as term_id 
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
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as   field_intro_text
, syn.SYNDICATE
, p.META_KEYWORDS
into #espage1
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVPUBLISHEDPAGEMETADATA_CGVPUBLISHEDPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
		inner join CGVCONTENTDATES_CGVCONTENTDATES1 d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.public_revision
		left outer join CGVDATEDISPLAYMODE_CGVDATEDISPLAYMODE1 dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.public_revision
		left join #es en on en.computed_path = f.Path or (en.computed_path ='/' and f.Path = '/espanol')
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.public_revision 
		left outer join CGVSYNDICATION_CGVSYNDICATION1 syn on syn.CONTENTID = c.CONTENTID and syn.REVISIONID = c.PUBLIC_REVISION
where c.LOCALE = 'es-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME not in ( 'nciLink',  'cgvDynamicList')
and CONTENTTYPENAME not like 'pdq%'
and CONTENTTYPENAME not like '%image%'
and s.STATENAME <> 'draft' 
and s.STATENAME not like '%(D)%'










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
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
,coalesce(p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as field_intro_text
, syn.SYNDICATE
, null 
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid and CONFIG_ID = 3
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.public_revision
		inner join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.public_revision
		left outer join GLODATEDISPLAYMODE_GLODATEDISPLAYMODE dd on dd.CONTENTID = c.CONTENTID and dd.REVISIONID = c.public_revision
		inner join #es en on en.computed_path = f.Path 
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.public_revision
		left outer join CGVSYNDICATION_CGVSYNDICATION1 syn on syn.CONTENTID = c.CONTENTID and syn.REVISIONID = c.PUBLIC_REVISION
where c.LOCALE = 'es-us' and s.STATENAME not like '%archive%'
and s.STATENAME <> 'draft' 
and s.STATENAME not like '%(D)%'
and CONTENTTYPENAME = 'glovideo'




drop table #espage

select es.*
, (
 select distinct c1.contentid as englishid 
 from PSX_OBJECTRELATIONSHIP r inner join CONTENTSTATUS c1 on c1.CONTENTID = r.OWNER_ID and c1.public_revision = r.OWNER_REVISION
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
,field_intro_text
, SYNDICATE
, META_KEYWORDS
 )
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
, SYNDICATE
, META_KEYWORDS
from #espage where englishid is null

GO






update #es set #es.field_landing_page = #espage.englishid
from #es inner join #espage on #es.field_landing_page = #espage.id 








select 'sitesectionsql'
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
langcode,
field_channel,
field_content_group
from (select * from #en union all select * from #es) a
order by 1
for xml path , root('rows')

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
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.public_revision
where p.CONTENTTYPENAME not in ( 'nciHome', 'cgvpressrelease', 'cgvblogpost', 'cgvblogseries', 'cgvCancerResearch', 'gloInstitution', 'cgvinfographic', 'glovideo', 'cgvCancerTypeHome', 'cgvCancerresearch', 'ncifile') 
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
left outer join CT_CGVFACTSHEET_Q_N_AS h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.public_revision
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
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.public_revision
where p.CONTENTTYPENAME not in ( 'nciHome', 'cgvpressrelease', 'cgvblogpost', 'cgvblogseries', 'cgvCancerResearch', 'gloInstitution', 'cgvinfographic', 'glovideo', 'cgvCancerTypeHome', 'cgvCancerresearch', 'ncifile') 
and h.BODY is not null
and p.id not in (select contentid from #mini )
union all
select  p.id, 
h.SYSID
, left(q.s,254 ) 
,h.ANSWER, p.langcode
, h.SORTRANK
from #espage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
left outer join CT_CGVFACTSHEET_Q_N_AS h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.public_revision
cross apply dbo.gaotagsearch(convert(nvarchar(max),h.QUESTION), '<p>','</p>', null, 0) q
where p.CONTENTTYPENAME = 'cgvfactsheet' and h.ANSWER is not null
order by id, sortrank

--!! English para
select 'para_en'
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
select 'para_es'
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

GO

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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_CGVSUBLAYOUT sub on sub.CONTENTID = c1.CONTENTID and sub.REVISIONID = c1.public_revision
left outer join (PSX_OBJECTRELATIONSHIP r1 
			inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
			 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_CGVSUBLAYOUT sub on sub.CONTENTID = c1.CONTENTID and sub.REVISIONID = c1.public_revision
left outer join (PSX_OBJECTRELATIONSHIP r1 
			inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID and sl1.SLOTNAME not like '%templateinfo%'
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID 
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
			 )  on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
where sl.SLOTNAME  = 'nvcgSlBodyLayout'
and c1.TITLE like '%multi%'
order by 1, sublayoutid , slotname, card_rank




insert into #landing_content1 (id, title, langcode, sublayoutid, sublayout_rid, sublayout_rank, row_rid )
select p.id, p.title
, p.langcode 
, c1.CONTENTID as sublayoutid
, r.RID as sublayout_rid
, r.SORT_RANK as sublayout_rank
, r.RID as row_rid
from (select id, langcode, title  from #enpage union select id, langcode , title from #espage) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
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





drop table #rawhtml
select * into #rawhtml from 
(
select   
lc.card_rid as rawcard_rid
, lc.langcode 
, df.BODYFIELD 
from #landing_content lc inner join CONTENTSTATUS c on c.contentid = lc.linkid 
inner join CT_GLORAWHTML df on df.CONTENTID = c.contentid and df.REVISIONID = c.public_revision
union all
select lc1.sublayout_rid, lc1.langcode , df.BODYFIELD
from #landing_content1 lc1 inner join CONTENTSTATUS c on c.CONTENTID = lc1.sublayoutid
inner join CT_GLORAWHTML df on df.CONTENTID = c.contentid and df.REVISIONID = c.public_revision
where lc1.linkid is null 
)a


--rawhtml
select 'rawhtml'
select   
1 as tag
, 0 as parent
,rawcard_rid as [row!1!id]
, langcode as [row!1!langcode]
, BODYFIELD [row!1!body!CDATA]
from #rawhtml
for xml explicit , root('rows')



drop table #contentblock
select   
lc.card_rid as rawcard_rid
, lc.langcode 
, df.BODYFIELD 
, df.LONG_TITLE
into #contentblock 
from #landing_content lc 
inner join CONTENTSTATUS c on c.contentid = lc.linkid 
inner join CT_NCIDOCFRAGMENT df on df.CONTENTID = c.contentid and df.REVISIONID = c.public_revision


-- mini landing content block
drop table #minicontentblock
select * into #minicontentblock from
(
select p.id as parentid, p.id + 20000 as id, pp.BODY as field_html_content, 2 as sort_rank, langcode
from ( select id, langcode from #enpage union all select id , langcode from #espage ) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id inner join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA pp on pp.CONTENTID = c.CONTENTID and pp.REVISIONID = c.public_revision
where p.id in (select CONTENTID from #mini) and pp.BODY is not null
union all
select p.id as parentid, p.id + 10000, p.field_intro_text, 1, langcode
from ( select id, langcode,field_intro_text from #enpage union all select id , langcode,field_intro_text from #espage ) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
where p.id in (select CONTENTID from #mini) and p.field_intro_text is not null
)a


--------CTHP
drop table #cthp
select p.id, p.title as pagetitle, langcode, r.RID as card_rid, r.sort_rank as card_rank
, c1.CONTENTID as card_id
, sl.SLOTNAME as card_slot, t1.CONTENTTYPENAME as card_type

, ( select card_title from CT_CGVCTHPFEATUREDCARD fc where fc.CONTENTID = c1.CONTENTID and fc.REVISIONID = c1.PUBLIC_REVISION
	union
	select card_title from CT_CGVCTHPGUIDECARD fc where fc.CONTENTID = c1.CONTENTID and fc.REVISIONID = c1.PUBLIC_REVISION
  ) as card_title

,r1.RID as link_rid
,sl1.slotname as link_slot, r1.SORT_RANK as link_rank
, c2.CONTENTID
, t2.CONTENTTYPENAME as link_type
, c2.title as link_title
into #cthp
from (select id, title, langcode from #enpage where contenttypename = 'cgvCancerTypeHome'  union all select ID, title, langcode from #espage where contenttypename = 'cgvCancerTypeHome')  p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join (PSX_OBJECTRELATIONSHIP r1 
inner join RXSLOTTYPE sl1 on r1.SLOT_ID = sl1.SLOTID 
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID ) 
on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision and t1.contenttypename in ('cgvCTHPFeaturedCard','cgvCTHPGuideCard')
where  sl.SLOTNAME not like 'sys%' and sl.SLOTNAME not in ( 'gloImageSl','nvcgSlCTHPAudienceToggle')
order by 1


--contentblock  ?? for cthp?

select 'contentblock'
select   
1 as tag
, 0 as parent
,rawcard_rid as [row!1!id]
, langcode as [row!1!langcode]
, convert(nvarchar(max),BODYFIELD) as [row!1!body!CDATA]
, LONG_TITLE as [row!1!long_title]
from #contentblock
union 
select   
1 as tag
, 0 as parent
,id as [row!1!id]
, langcode as [row!1!langcode]
, convert(nvarchar(max),field_html_content) [row!1!body!CDATA]
, null 
from  #minicontentblock 
for xml explicit , root ('rows')



---rawhtmlblock for mega menu
select 'rawhtmlblock'
select 
1 as tag
, 0 as parent
,mega.field_mega_menu_content as [row!1!id], langcode as [row!1!langcode], df.BODYFIELD as [row!1!body!CDATA], 'Megamenu: '+ mega.computed_path as [row!1!info!Element]
from CONTENTSTATUS c inner join 
(select  field_mega_menu_content, langcode, computed_path from #en where field_mega_menu_content is not null
union all 
select   field_mega_menu_content, langcode, '/espanol'+ computed_path from #es where field_mega_menu_content is not null
) mega on mega.field_mega_menu_content = c.CONTENTID 
inner join CT_GLORAWHTML df on df.CONTENTID = c.contentid and df.REVISIONID = c.public_revision
for xml explicit , root('rows')


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


------------------
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where c.CONTENTID in (select CONTENTID from #mini)
and sl.SLOTNAME = 'nvcgSlLayoutThumbnailA'
) a 


-------------------------

drop table #internallink1
select * into #internallink1 from
(
select 
r.rid  as internallink_id 
,  rc.DEPENDENT_ID as field_internal_link_target_id
, clink.OVERRIDE_TITLE as field_override_title
,en.langcode
, r.SORT_RANK
, t2.CONTENTTYPENAME 
from (select id, langcode from #enpage union all select id , langcode from #espage union all select distinct card_id, langcode from #cthp where card_type = 'cgvCTHPGuideCard' and link_type = 'cgvcustomlink'
) en inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CT_CGVCUSTOMLINK clink on clink.CONTENTID = c1.CONTENTID and clink.REVISIONID = c1.public_revision
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join PSX_OBJECTRELATIONSHIP rc on rc.OWNER_ID = c1.CONTENTID and rc.OWNER_REVISION = c1.public_revision
inner join rxslottype sc on sc.slotid = rc.SLOT_ID
inner join CONTENTSTATUS c2 on c2.CONTENTID = rc.DEPENDENT_ID 
inner join CONTENTTYPES t2 on t2.CONTENTTYPEid = c2.contenttypeid
where  sl.SLOTNAME in ( 'cgvRelatedPages', 'nvcgSlCancerResearchLinks' )
and t1.CONTENTTYPENAME = 'cgvcustomlink'
and sc.SLOTNAME = 'cgvCustomLink' and sc.slotid = 893
union all
select 
r.rid as internallink_id
,c1.contentid as field_internal_link_target_id
, NULL as field_override_title
,en.langcode
, r.SORT_RANK
, t1.contenttypename 
from 
(select id, langcode from #enpage 
	union all select id , langcode from #espage
	union all select distinct card_id, langcode from #cthp where card_type = 'cgvCTHPGuideCard' 
	) en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
where  sl.SLOTNAME in ( 'cgvRelatedPages', 'nvcgSlCancerResearchLinks' )  and t1.CONTENTTYPENAME not like  '%link%' 
union all
select listitem_rid, linkid, null, langcode,  l.listitem_rank, l.CONTENTTYPENAME
from #landinglistitem l where contenttypename not like  '%link%'
union all
select ll.listitem_rid,  r.DEPENDENT_ID as field_internal_link_target_id
, clink.OVERRIDE_TITLE as field_override_title
,ll.langcode
, r.SORT_RANK
, t1.CONTENTTYPENAME 
from #landinglistitem ll inner join contentstatus c on c.contentid = ll.linkid 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join rxslottype sc on sc.slotid = r.SLOT_ID and sc.SLOTNAME = 'cgvCustomLink' and sc.slotid = 893
inner join CT_CGVCUSTOMLINK clink on clink.CONTENTID = c.CONTENTID and clink.REVISIONID = c.public_revision
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
where ll.contenttypename  like  '%link%'
) a 



drop table #internallink
select * into #internallink from 
(select i.*
from #internallink1 i inner join (select id from #enpage union all select ID from #summary union all select ID from #dis ) p on i.field_internal_link_target_id = p.id 
union 
select i.internallink_id, coalesce(p.englishid,p.id) as field_internal_link_target_id, field_override_title, i.langcode, i.SORT_RANK, i.CONTENTTYPENAME 
from #internallink1 i inner join (select id, englishid from #espage union all select spanishid,ID from #summaryes ) p on i.field_internal_link_target_id = p.id 
) a


select 'internallinksql'
select internallink_id , field_internal_link_target_id, field_override_title, langcode 
from #internallink 
where CONTENTTYPENAME <> 'nciFile'
for xml path , root('rows')



select 'medialink'
select i.internallink_id as medialink_id  , i.field_internal_link_target_id  as field_media_link, field_override_title, langcode 
from #internallink i
where i.CONTENTTYPENAME  =  'nciFile'
for xml path , root('rows')




----------------------
drop table #externallink1
select * into #externallink1 from
(
select r.dependent_id, r.RID as externallink_id
, l.URL as field_external_link_uri, l.SHORT_TITLE as field_override_title
, l.LONG_DESCRIPTION as field_override_list_description
, en.langcode
, r.SORT_RANK
from (select id, langcode from #enpage union all select id, langcode from #espage union all select distinct card_id, langcode from #cthp where card_type = 'cgvCTHPGuideCard' 
) en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join CT_NCILINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.public_revision
where sl.SLOTNAME in ( 'cgvRelatedPages', 'nvcgSlCancerResearchLinks' )
and t1.CONTENTTYPENAME = 'ncilink'
union all
select ll.linkid, ll.listitem_rid
, l.URL as field_external_link_uri, l.SHORT_TITLE as field_override_title
, l.LONG_DESCRIPTION as field_override_list_description
, ll.langcode
, ll.listitem_rank
from #landinglistitem ll 
inner join CONTENTSTATUS c on c.CONTENTID = ll.linkid
inner join CT_NCILINK l on l.CONTENTID = c.CONTENTID and l.REVISIONID = c.public_revision
where CONTENTTYPENAME = 'ncilink'
union all
select 
l.contentid,  cp.link_rid , l.URL , l.SHORT_TITLE, l.LONG_DESCRIPTION, LEFT(c.locale, 2), 0 
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c1.CONTENTID and r.OWNER_REVISION = c1.PUBLIC_REVISION
inner join CONTENTSTATUS c2 on c2.CONTENTID = r.DEPENDENT_ID 
inner join CT_NCILINK l on l.CONTENTID = c2.CONTENTID and l.REVISIONID = c2.PUBLIC_REVISION
where card_type = 'cgvCTHPFeaturedCard' and cp.card_title not like 'coping%' and cp.card_title not like 'supp%'
and link_type = 'ncilink'
) a




drop table #externallink

select  e.*
,(select TOp 1  r.dependent_id from PSX_OBJECTRELATIONSHIP r where r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision and r.SLOT_ID = 953)
 as field_override_image_promotional
into #externallink 
from #externallink1 e inner join CONTENTSTATUS c on e.DEPENDENT_ID = c.CONTENTID 





update #externallink set field_external_link_uri = 'https://www.cancer.gov' + convert(varchar(max),field_external_link_uri )
where   field_external_link_uri like '/%'

select 'externallinksql'
select * from #externallink 
 for xml path , root('rows')




drop table #blogfeature
select c.contentid, r.RID, r.SORT_RANK, left(c.locale,2) as langcode into #blogfeature
from CT_CGVBLOGPOST b 
inner join CONTENTSTATUS c on c.CONTENTID = b.CONTENTID  and c.public_revision = b.REVISIONID
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where s.STATENAME not like '%archive%' and sl.SLOTNAME= 'nvcgSlLayoutFeatureA'



drop table #twoitemfeaturecardrow
select c.CONTENTID, c.CONTENTID + 40000 as row_rid, r.RID as card_rid, left(c.locale,2) as langcode, r.SORT_RANK
 into #twoitemfeaturecardrow
from CONTENTSTATUS c inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where c.CONTENTID in (select CONTENTID from #mini) and sl.SLOTNAME = 'nvcgSlLayoutFeatureA'


-------

drop table #citation
select * into #citation from 
(
select p.id , r.RID 
from #enpage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.public_revision
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
union 
select p.englishid , r.RID 
from #espage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.public_revision
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
) a


----
select 'citation'

select 
1 as Tag,  
0 as Parent
,p.langcode as [row!1!langcode]
,r.rid  as [row!1!citation_id]
,ct.CITATION_TEXT as [row!1!!CDATA] 
, ct.PUBMED_ID as [row!1!field_pubmed_id]
from #enpage p inner join contentstatus c on c.contentid = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.public_revision
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE  s on s.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CT_CGVCITATION ct on ct.CONTENTID = c1.CONTENTID and ct.REVISIONID = c1.public_revision
where t1.CONTENTTYPENAME = 'cgvcitation'  and s.SLOTNAME = 'cgvCitationSl'
for xml explicit , root ('rows')
-------------------------------
-------------------------------

-----------------------

---english page data

update #enpage set title = replace(REPLACE(title, '&reg;','®'), '&amp;', '&')
update #enpage set field_browser_title = replace(REPLACE(field_browser_title, '&reg;','®'), '&amp;', '&')
update #enpage set field_card_title = replace(REPLACE(field_card_title, '&reg;','®'), '&amp;', '&')

update #espage set title = replace(REPLACE(title, '&reg;','®'), '&amp;', '&')
update #espage set field_browser_title = replace(REPLACE(field_browser_title, '&reg;','®'), '&amp;', '&')
update #espage set field_card_title = replace(REPLACE(field_card_title, '&reg;','®'), '&amp;', '&')




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
,NULL as [row!2!syndicate!Element]
,NULL as [row!2!meta_keywords!Element]
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
, SYNDICATE 
, META_KEYWORDS
,(
		select distinct internallink_id as related_resource_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select distinct internallink_id as related_resource_ids, r.SORT_RANK
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1)
			order by r.SORT_RANK
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
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select il.rid as citation_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  > 1)
			order by r.SORT_RANK
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
,NULL as [row!2!syndicate!Element]
,NULL as [row!2!meta_keywords!Element]
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
, SYNDICATE
, META_KEYWORDS
,(
		select internallink_id as related_resource_id
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select internallink_id as related_resource_ids, r.SORT_RANK
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  > 1)
			order by r.SORT_RANK
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
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select il.rid as citation_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join #citation il on il.rid = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #espage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join #citation il on il.rid = r.RID
				where il.rid is NOT null
				group by p.id
				having COUNT(distinct il.rid)  > 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
from  #espage 	 p 
) a

GO







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
inner join CT_CGVCUSTOMLINK clink on clink.CONTENTID = c1.CONTENTID and clink.REVISIONID = c1.public_revision
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join PSX_OBJECTRELATIONSHIP rc on rc.OWNER_ID = c1.CONTENTID and rc.OWNER_REVISION = c1.public_revision
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




select 'promocard'
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
inner join CT_NCILINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.public_revision
where sl.SLOTNAME in ('nvcgSlLayoutFeatureA','nvcgSlLayoutFeatureB' )
and t1.CONTENTTYPENAME = 'ncilink'

drop table #externalpromocard
select e.*
, r.DEPENDENT_ID  as field_override_image_promotional
into #externalpromocard
from #externalpromocard1 e inner join CONTENTSTATUS c on e.DEPENDENT_ID = c.CONTENTID 
left outer join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision and r.SLOT_ID = 953

select 'externalpromocard'
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
inner join (select id, langcode from #enpage union all select ID, langcode  from #espage  union all select dependent_id, langcode  from #externallink union all select dependent_id, langcode  from #externalpromocard
--cthp external card image
union all select distinct CONTENTID, langcode from #cthp where link_type = 'ncilink' and card_type = 'cgvCTHPFeaturedCard' ) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GENIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.public_revision
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c1.CONTENTID and si.REVISIONID = c1.public_revision
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.public_revision
inner join CT_GENIMAGE i on i.CONTENTID = c2.CONTENTID and i.REVISIONID = c2.public_revision
inner join CT_GLOIMAGETRANSLATION trans on trans.CONTENTID = c1.CONTENTID and trans.REVISIONID = c1.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c2.CONTENTID and gi.REVISIONID = c2.public_revision
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GENIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.public_revision
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c1.CONTENTID and si.REVISIONID = c1.public_revision
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.public_revision
inner join CT_GENIMAGE i on i.CONTENTID = c2.CONTENTID and i.REVISIONID = c2.public_revision
inner join CT_GLOIMAGETRANSLATION trans on trans.CONTENTID = c1.CONTENTID and trans.REVISIONID = c1.public_revision
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
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GLOUTILITYIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.public_revision
where t1.CONTENTTYPENAME = 'gloutilityimage' and  sl.slotname  like 'sys%' 

)a



delete from #contextual_image where imageid in (select imageid from #cgov_image)






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
from (select distinct imageid, 'en' as langcode, 0 as ctype from #cgov_image
		where imageid in (select imageid from #cgov_image group by imageid having COUNT(distinct langcode) >1)
	 union 
	 select distinct imageid, langcode , 0 	as ctype from #cgov_image
		where imageid not in (select imageid from #cgov_image group by imageid having COUNT(distinct langcode) >1)
		 union 
		 select distinct imageid, 'en', 1 as ctype from #contextual_image
		where imageid in (select imageid from #contextual_image group by imageid having COUNT(distinct langcode) >1)
	 union 
	 select distinct imageid, langcode , 1 	as ctype from #contextual_image
		where imageid not in (select imageid from #contextual_image group by imageid having COUNT(distinct langcode) >1)
		 ) 
i inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.public_revision


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




--select 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(imageid,''),10,999) + '/'+ img as imgurl ,* from #ifile 
--where img in (select img from #ifile group by img having COUNT(*) > 1)
--order by img


drop table #idup 
select f.IMG, f.imageid,itype, 
case itype 
when 0 then (select si.IMG_UTILITY_SIZE from dbo.CT_GLOUTILITYIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
when 1 then (select IMG1_SIZE from dbo.RXS_CT_SHAREDIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
when 2 then (select IMG2_SIZE from dbo.RXS_CT_SHAREDIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
when 3 then (select IMG3_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
when 4 then (select IMG4_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
when 5 then (select IMG5_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
when 6 then (select IMG6_SIZE from dbo.CT_GENIMAGE si where si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision) 
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
select ROW_NUMBER () over (partition by img, imageid, langcode order by  itype) as seq, * into #idup1 from #idup

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
left outer join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION	= c.public_revision and r.CONFIG_ID = 6 and r.DEPENDENT_ID = c1.CONTENTID 
where --dbo.gaogetitemFolderPath(d.imageid,'') = dbo.gaogetitemFolderPath(d.imageid1,'') and 
d.langcode = 'en' and langcode1 = 'es'
order by img

--translation
--select * from #ien_es where RID is not null
-- no translation
--select * from #ien_es where RID is  null

GO

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

GO


alter table #contextual_image add englishimageid int 
Go
update i set i.englishimageid = a.englishimageid
from #contextual_image i inner join
(select i.imageid, imageid as englishimageid
from #contextual_image i where langcode = 'es' and  exists (select * from #contextual_image i1 where i1.langcode = 'en' and i1.imageid = i.imageid)
union
select i.imageid, ci.imageid 
from #contextual_image ci inner join (select distinct imageid,imageid1 from #isamesize where langcode1 = 'es' and langcode = 'en') i on ci.imageid = i.imageid1
union
select i.imageid, ci.imageid 
from #contextual_image ci inner join (select distinct imageid, imageid1 from #ien_es where RID is not null) i on ci.imageid = i.imageid1
) a on  a.imageid = i.imageid 
where i.langcode = 'es'



select * from #cgov_image where pageid = 



--select distinct c1.CONTENTID as imageid  into #nottranslation 
--from CONTENTSTATUS c 
--inner join (select id, langcode from #enpage union all select ID, langcode  from #espage  union all select dependent_id, langcode  from #externallink union all select dependent_id, langcode  from #externalpromocard) p on c.CONTENTID = p.id 
--inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
--inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
--inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
--inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
--left outer join CT_GENIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.public_revision
--left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c1.CONTENTID and si.REVISIONID = c1.public_revision
--where sl.slotname = 'gloImageSl' and t1.CONTENTTYPENAME <> 'gloImageTranslation'

--drop table #i1

--select distinct i.imageid
--, u.IMG_UTILITY_FILENAME
--,si.IMG1_FILENAME, si.IMG2_FILENAME
--,gi.IMG3_FILENAME, gi.IMG4_FILENAME
--,gi.IMG5_FILENAME, gi.IMG6_FILENAME
--into #i1
--from (select imageid, 0 as ctype from #nottranslation union all select imageid, 1 as ctype from #contextual_image) i inner join CONTENTSTATUS c on i.imageid = c.contentid 
--left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
--left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
--left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.public_revision



--drop table #ifile1
--select * into #ifile1 from (
--select imageid, IMG1_FILENAME as img, 1 as itype from #i1 where IMG1_FILENAME is not null
--union all
--select imageid, IMG2_FILENAME, 2 from #i1 where IMG2_FILENAME is not null
--union all
--select imageid, IMG3_FILENAME, 3from #i1 where IMG3_FILENAME is not null
--union all 
--select imageid,  IMG4_FILENAME, 4 from #i1 where IMG4_FILENAME is not null
--union all
--select imageid,  IMG5_FILENAME, 5 from #i1 where IMG5_FILENAME is not null
--union all
--select imageid,  IMG6_FILENAME, 6  from #i1 where IMG6_FILENAME is not null
--union all
--select imageid,  IMG_UTILITY_FILENAME, 0  from #i1 where IMG_UTILITY_FILENAME is not null 
--) a 


--; with cte as
--(select *, dbo.gaogetitemfolderpath(imageid,'') as folder  from #ifile1 )
--select cte.*, total from 
--(select folder, img, COUNT(*) as total from cte 
--group by folder, img
--having COUNT(*) > 1) a  inner join cte on cte.folder = a.folder and cte.img = a.img 

----------------

--EN image

select 'cgovimage'
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
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
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
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
) a
for xml explicit , root('rows')



---ES Image
select 'cgovimage_es'
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
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
where langcode = 'es' and englishimageid is not null
for xml explicit , root('rows')


--------------
--contextual image english

select 'contextualimage_en'
select * from (
select 
distinct
1 as tag
, 0 as parent
,i.imageid as [row!1!id]
,'en' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME, u.img_utility_type  ) as [row!1!field_media_image!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
 from 
(select * from #contextual_image where langcode = 'en' and title not like '%spanish%'
) i 
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.public_revision
union all
select 
distinct
1 as tag
, 0 as parent
,i.imageid as [row!1!id]
,'es' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME, u.img_utility_type ) as [row!1!field_media_image!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
 from 
(select * from #contextual_image where langcode = 'es' and englishimageid is null
) i 
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.public_revision
) a
for xml explicit , root('rows')




---contexual Image spanish
select 'contextualimage_es'
select 
distinct
1 as tag
, 0 as parent
,i.englishimageid as [row!1!id]
,'es' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME, u.img_utility_type ) as [row!1!field_media_image!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
 from #contextual_image  i
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.public_revision
where langcode = 'es' and englishimageid is not null
for xml explicit , root('rows')


GO


---------------------------------
---------------------------------

---!!! content block for guide card

--- cthp guide card

select 'cthpguidecard'
SELECT
    1 AS Tag,
    NULL AS Parent,
    NULL AS 'rows!1!'
   , null as [row!2!id]
, null as [row!2!langcode!Element]
, null as [row!2!field_cthp_card_theme!Element]
, null as [row!2!field_cthp_guide_card_desc!CDATA]
, NULL as [row!2!field_cthp_card_title!Element]
, NULL as [row!2!field_cthp_pdq_link_heading!Element]
, null as [row!2!field_cthp_pdq_links]
, null as [row!2!field_cthp_view_more_info]
, null as [row!2!field_cthp_view_more_infos]
union all
select 
2 as tag
, 1 as parent
, null 
, m.id as [row!2!id]
, m.langcode as [row!2!langcode!Element]
, m.field_cthp_card_theme as [row!2!field_cthp_card_theme!Element]
, m.field_cthp_guide_card_desc as [row!2!field_cthp_guide_card_desc!CDATA]
, m.field_cthp_card_title as [row!2!field_cthp_card_title!Element]
, m.field_cthp_pdq_link_heading as [row!2!field_cthp_pdq_link_heading!Element]
,	(select field_cthp_pdq_links from	
		(select c.CONTENTID as field_cthp_pdq_links, link_rank
			from #cthp c  
			where c.card_id  = m.id and link_slot = 'nvcgSlCTHPCancerSummary' 
				and c.CONTENTID  in (select id from #summary )
			union all 
			select sm.id as field_cthp_pdq_links, link_rank
			from #cthp c  inner join #summaryes sm on sm.spanishid = c.contentid 
			where c.card_id  = m.id and link_slot = 'nvcgSlCTHPCancerSummary' )a
	order by link_rank  
	for xml path (''), type, elements
 )
 ,(select c.link_rid as field_cthp_view_more_info
	from #cthp c  where c.card_id  = m.id and link_slot = 'cgvRelatedPages' 
	and link_rid in  (select internallink_id from #internallink union all select externallink_id from #externallink)
	and c.card_id in 
		(select card_id from #cthp where card_type = 'cgvCTHPGuideCard' and link_slot = 'cgvRelatedPages' 
			and link_rid in  (select internallink_id from #internallink union all select externallink_id from #externallink)
			group by card_id having COUNT(*) = 1)
		order by link_rank 
		for xml path (''), type, elements)
 
,(select c.link_rid as field_cthp_view_more_infos
	from #cthp c  where c.card_id  = m.id and link_slot = 'cgvRelatedPages' 
	and link_rid in  (select internallink_id from #internallink union all select externallink_id from #externallink)
	and c.card_id in 
		(select card_id from #cthp where card_type = 'cgvCTHPGuideCard' and link_slot = 'cgvRelatedPages' 
		and link_rid in  (select internallink_id from #internallink union all select externallink_id from #externallink)
		group by card_id having COUNT(*) > 1)
		order by link_rank 
		for xml path (''), type, elements)
from 
(select distinct  card_id as id, langcode, convert(nvarchar(max),g.CARD_TEXT) as field_cthp_guide_card_desc
, convert(nvarchar(max),g.CARD_TITLE) as field_cthp_card_title, convert(nvarchar(max),g.PDQ_LABEL) as field_cthp_pdq_link_heading
, g.THEME as field_cthp_card_theme
from #cthp  inner join contentstatus c on c.contentid = #cthp.card_id 
inner join CT_CGVCTHPGUIDECARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
where card_type = 'cgvCTHPGuideCard' 
) m
for xml explicit



--cthpblockcontent
select distinct 
g.CONTENTID as id 
,g.CARD_TITLE as field_cthp_card_title 
,g.THEME as field_cthp_card_theme
,langcode 
, h.CONTENTID as field_cthp_block_card_content
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
inner join CT_GLORAWHTML h on h.CONTENTID = c1.CONTENTID and h.REVISIONID = c1.public_revision
where card_type = 'cgvCTHPFeaturedCard' 
and cp.link_type = 'glorawhtml'
for xml path , root('rows')



-- cthp_video_card  
drop table #cthpvideo
select 'cthpvideocard'
select * into #cthpvideo from 
(
select card_id as id, g.CARD_TITLE  as field_cthp_card_title, langcode
, (select l.CONTENTID from  PSX_OBJECTRELATIONSHIP r 
inner join CONTENTSTATUS c2 on c2.CONTENTID = r.DEPENDENT_ID 
inner join CT_CGVVIDEOPLAYER  l on l.CONTENTID = c2.CONTENTID and l.REVISIONID = c2.PUBLIC_REVISION
 where r.OWNER_ID = c1.CONTENTID and r.OWNER_REVISION = c1.PUBLIC_REVISION
)  as field_cthp_video
, 'cthp-survival' as field_cthp_card_theme
, (select r.RID  from  PSX_OBJECTRELATIONSHIP r 
inner join CONTENTSTATUS c2 on c2.CONTENTID = r.DEPENDENT_ID 
inner join CT_NCILINK l on l.CONTENTID = c2.CONTENTID and l.REVISIONID = c2.PUBLIC_REVISION
 where r.OWNER_ID = c1.CONTENTID and r.OWNER_REVISION = c1.PUBLIC_REVISION
) as field_cthp_target_link
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
where card_type = 'cgvCTHPFeaturedCard' 
and link_type =  'cgvLinkableMultimedia'
union all 
select card_id as id, g.CARD_TITLE as field_cthp_card_title, langcode
, (select l.CONTENTID from  CONTENTSTATUS c2 
inner join CT_CGVVIDEOPLAYER  l on l.CONTENTID = c2.CONTENTID and l.REVISIONID = c2.PUBLIC_REVISION
 where c2.CONTENTID = cp.CONTENTID 
)  as field_cthp_video
, 'cthp-survival' as field_cthp_card_theme
,null
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
where card_type = 'cgvCTHPFeaturedCard' 
and link_type =  'glovideo'
) a 

select * from #cthpvideo 
for xml path , root('rows')


--cthp external feature card 

drop table #cthpexternal 
select 'cthpexternalfeaturecard'
select 
cp.card_id as id
, g.card_title as field_cthp_card_title
, 'cthp-statistics' as field_cthp_card_theme
,l.URL as   field_cthp_featured_url
, (select top 1 coalesce(englishimageid,imageid) from #cgov_image where pageid = cp.CONTENTID )  as field_override_image_promotional
, langcode 
, L.short_DESCRIPTION  as field_cthp_override_description
into #cthpexternal
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
inner join ct_ncilink l on l.contentid = c1.contentid and l.revisionid = c1.public_revision
where card_type = 'cgvCTHPFeaturedCard' 
and link_type = 'nciLink'
order by l.SHORT_DESCRIPTION







select * from #cthpexternal 
for xml path , root('rows')


--cthp internal feature card 
drop table #cthpinternal 
select 'cthpinternalfeaturecard'
select cp.card_id as id 
, 'Statistics' as field_cthp_card_title
, 'cthp-statistics' as field_cthp_card_theme
, coalesce (  (select englishid from #espage where id = cp.contentid), cp.CONTENTID)  as field_cthp_featured_content
, (select coalesce(englishimageid,imageid) from #cgov_image where pageid = cp.CONTENTID )  as field_override_image_promotional
, left(c.LOCALE,2) as langcode 
into #cthpinternal 
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
where card_type = 'cgvCTHPFeaturedCard' 
--and pagetitle like '%lung%health%'
and link_type <> 'cgvLinkableMultimedia' 
and link_type <> 'nciLink'
and link_type <> 'glorawhtml'
and link_type <> 'glovideo'

select * from #cthpinternal
for xml path , root('rows')






-- cthp_research_card
select card_id as id
, 'Research' as field_cthp_card_title
, 'cthp-research' as field_cthp_card_theme
, langcode
, coalesce((select englishid from #espage where id = card_id), card_id) as field_cthp_research_page
from #cthp 
where card_type = 'cgvCancerResearch'
for xml path , root('rows')



select * from #cthp 
where card_type = 'cgvCancerResearch'


-- cthp overview card
select 
1 as tag
,0 as parent
,p.id as [row!1!id], langcode as [row!1!langcode]
, 'Overview' as [row!1!field_cthp_card_title]
, 'cthp-overview' as [row!1!field_cthp_card_theme]
,  h.body as [row!1!field_cthp_overview_card_text!CDATA]
from (select id, langcode, contenttypename from #enpage union all select id, langcode, contenttypename from #espage) p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVCANCERTYPEHOME cp on cp.CONTENTID = c.CONTENTID and cp.REVISIONID = c.public_revision
inner join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.CONTENTID = c.CONTENTID and h.REVISIONID = c.public_revision
where p.contenttypename = 'cgvCancerTypeHome'  and h.BODY is not null
for xml explicit, root('rows')

GO







---
drop table #cthpcard
go

select * into #cthpcard from 
(
--'block'
select distinct 
cp.id
,g.CONTENTID as card_id , langcode , card_rank + 1 as card_rank
, 'block' as card_type
from #cthp cp  
inner join contentstatus c on c.contentid = cp.card_id
inner join contentstatus c1 on c1.contentid = cp.contentid 
inner join CT_CGVCTHPFEATUREDCARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
inner join CT_GLORAWHTML h on h.CONTENTID = c1.CONTENTID and h.REVISIONID = c1.public_revision
where card_type = 'cgvCTHPFeaturedCard' 
and cp.link_type = 'glorawhtml'
--video
union 
select p.id, p.card_id   , p.langcode, card_rank+ 1 
, 'video' as card_type
from #cthpvideo v inner join #cthp p on v.id = p.card_id
union 
select p.id, p.card_id   , p.langcode, card_rank+ 1 
, 'internal' as card_type
from #cthpinternal v inner join #cthp p on v.id = p.card_id
union 
select p.id, p.card_id   , p.langcode, card_rank+ 1 
, 'external' as card_type
from #cthpexternal  v inner join #cthp p on v.id = p.card_id
union 
--'guide'
select distinct #cthp.id, card_id as id, langcode, card_rank + 1
, 'guide' as card_type
from #cthp  inner join contentstatus c on c.contentid = #cthp.card_id 
inner join CT_CGVCTHPGUIDECARD g on g.CONTENTID = c.CONTENTID and g.REVISIONID = c.public_revision
where card_type = 'cgvCTHPGuideCard'
union all
--research
select distinct id, card_id , langcode, card_rank+ 1
, 'research' as card_type
from #cthp where card_type = 'cgvCancerResearch'
union all
--overview
select distinct id, id , langcode, 0
, 'overview' as card_type
from (select id, langcode, CONTENTTYPENAME from #enpage union all select ID, langcode, contenttypename from #espage) p inner join 
 CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVCANCERTYPEHOME cp on cp.CONTENTID = c.CONTENTID and cp.REVISIONID = c.public_revision
inner join cdrlivegk.dbo.GlossaryTermDefinition td on td.GlossaryTermID = convert(varchar(90),cp.DEFINITIONID) and case td.Language  when 'english' then 'en' else 'es' END = p.langcode
where p.contenttypename = 'cgvCancerTypeHome' 
) a


select * from #cthpcard where id = 12880
order by card_rank 

---English CTHP
select 'cthp_en'
select p.*, cp.AUDIENCE as field_audience
, (select top 1 r.dependent_id from PSX_OBJECTRELATIONSHIP r 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision and sl.SLOTNAME = 'nvcgSlCTHPAudienceToggle'
and r.DEPENDENT_ID in (select id from #cthp)
) as field_audience_toggle
, (select imageid from #cgov_image i where i.pageid = p.id) as field_image_promotional
, 
(select card_id as field_cthp_cards
from #cthpcard cc where cc.id = p.id  order by card_rank for XML path(''), type, Elements) as field_cthp_cards
from #enpage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVCANCERTYPEHOME cp on cp.CONTENTID = c.CONTENTID and cp.REVISIONID = c.public_revision
where p.contenttypename = 'cgvCancerTypeHome' 
for xml path , root('rows')




---Spanish CTHP
select 'cthp_es'
select 
[term_id],
englishid as id ,
p.[title],
[langcode],
[field_short_title],
[field_page_description],
[field_feature_card_description],
[field_list_description],
[field_search_engine_restrictions],
[field_public_use],
[field_date_posted],
[field_date_reviewed],
[field_date_updated],
[date_display_mode],
[field_pretty_url],
[field_browser_title],
[field_card_title],
[field_intro_text]
, cp.AUDIENCE as field_audience
, (select englishid from #espage where id =(select top 1 r.dependent_id from PSX_OBJECTRELATIONSHIP r 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
where r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision and sl.SLOTNAME = 'nvcgSlCTHPAudienceToggle'
and r.DEPENDENT_ID in (select id from #cthp)
)) as field_audience_toggle
, (select coalesce(i.englishimageid, imageid) from #cgov_image i where i.pageid = p.id) as field_image_promotional
, 
(select card_id as field_cthp_cards
from #cthpcard cc where cc.id = p.id  order by card_rank for XML path(''), type, Elements) as field_cthp_cards
from #espage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVCANCERTYPEHOME cp on cp.CONTENTID = c.CONTENTID and cp.REVISIONID = c.public_revision
where p.contenttypename = 'cgvCancerTypeHome' 
for xml path , root('rows')



--select  sl.SLOTNAME , t1.CONTENTTYPENAME , COUNT(*)
--from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
--inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
--inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
--inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
--inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
--where p.contenttypename = 'cgvCancerTypeHome' and sl.slotname not like 'sys%' and sl.SLOTNAME not in ('gloImageSl')
--group by sl.SLOTNAME , t1.CONTENTTYPENAME







--- cancer research
select 'cancerresearch_en'
select p.*
, (
select RID as field_selected_researchs
from  CONTENTSTATUS c inner join 
 PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 inner join (select internallink_id from #internallink union all select externallink_id from #externallink) l on l.internallink_id = r.RID 
 where c.CONTENTID = [row!2!id]   and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 and c.CONTENTID in (select CONTENTID from contentstatus c inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'  and sl.SLOTNAME = 'nvcgSlCancerResearchLinks' group by CONTENTID having COUNT(*) > 1)
  order by r.SORT_RANK
for XML path ('')  , TYPE, ELEMENTS
) as [row!2!field_selected_researchs]
, (
select RID as field_selected_research
from  CONTENTSTATUS c inner join 
 PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 inner join (select internallink_id from #internallink union all select externallink_id from #externallink) l on l.internallink_id = r.RID 
 where c.CONTENTID = [row!2!id]   and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 and c.CONTENTID in (select CONTENTID from contentstatus c inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'  and sl.SLOTNAME = 'nvcgSlCancerResearchLinks' group by CONTENTID having COUNT(*) = 1)
for XML path ('')  , TYPE, ELEMENTS
)as [row!2!field_selected_research]
, (select top 1 imageid from #cgov_image i where i.pageid = [row!2!id]) as [row!2!field_image_promotional!Element]
from #enpagedata p 
where tag = 1 or   [row!2!id]  in (select ID from #enpage ep where  ep.CONTENTTYPENAME = 'cgvcancerresearch')
order by tag
for xml explicit 






      

--- cancer research spanish
select 'cancerresearch_es'
select d.*
, (
select RID as field_selected_researchs
from  CONTENTSTATUS c inner join 
 PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 inner join (select internallink_id from #internallink union all select externallink_id from #externallink) l on l.internallink_id = r.RID 
 where c.CONTENTID = p.id  and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 and c.CONTENTID in (select CONTENTID from contentstatus c inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'  and sl.SLOTNAME = 'nvcgSlCancerResearchLinks' group by CONTENTID having COUNT(*) > 1)
 order by r.SORT_RANK
for XML path ('')  , TYPE, ELEMENTS
) as [row!2!field_selected_researchs]
, (
select RID as field_selected_research
from  CONTENTSTATUS c inner join 
 PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 inner join (select internallink_id from #internallink union all select externallink_id from #externallink) l on l.internallink_id = r.RID 
 where c.CONTENTID = p.id   and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'
 and c.CONTENTID in (select CONTENTID from contentstatus c inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and sl.SLOTNAME = 'nvcgSlCancerResearchLinks'  and sl.SLOTNAME = 'nvcgSlCancerResearchLinks' group by CONTENTID having COUNT(*) = 1)
for XML path ('')  , TYPE, ELEMENTS
)as [row!2!field_selected_research]
, (select top 1 coalesce(i.englishimageid, imageid) from #cgov_image i where i.pageid = p.id) as [row!2!field_image_promotional!Element]
from #espagedata d inner join #espage p on d.[row!2!id] = p.englishid 
where  [row!2!id]  in (select englishID from #espage ep where  ep.CONTENTTYPENAME = 'cgvcancerresearch')
union all
select d.*, NULL, NULL, null
from #espagedata d
where Tag = 1
order by tag
for xml explicit 

---------




--cgov_file, there is no spanish translation
select 'file'
select 
 ep.*
, 'https://www.cancer.gov/publishedcontent/Files' + substring(dbo.gaogetitemFolderPath([row!2!id] , ''), 10,999) + '/' 
+ 
(select f.ITEM_FILENAME  from CONTENTSTATUS c 
inner join RXS_CT_SHAREDBINARY f on f.CONTENTID = c.CONTENTID and f.REVISIONID = c.public_revision
where c.CONTENTID = ep.[row!2!id]
)as [row!2!field_media_file!Element]
, (select imageid from #cgov_image i where i.pageid = ep.[row!2!id] ) as [row!2!field_image_promotional!Element]
from  #enpagedata ep
where Tag =1 or 
[row!2!id] 
in  (
select ID from #enpage p 
where CONTENTTYPENAME = 'ncifile'
)
order by tag
for xml explicit

GO

----------------------------





---!!! success
--- English article
select 'article_en'
select d.* 
,(select top 1 imageid from #cgov_image i where i.pageid = d.[row!2!id]  and imagefield = 'lead'  and langcode = d.[row!2!langcode]) as [row!2!field_image_article!Element]
,(select top 1 imageid from #cgov_image i where i.pageid = d.[row!2!id]  and imagefield = 'promotion' and langcode =  d.[row!2!langcode]) as [row!2!field_image_promotional!Element]
from #enpagedata d 
where Tag =1 or 
[row!2!id] 
in  (
select id from #enpage p 
where p.CONTENTTYPENAME not in ( 'nciHome', 'cgvpressrelease', 'cgvblogpost', 'cgvblogseries', 'cgvCancerResearch', 'gloInstitution', 'cgvinfographic', 'glovideo', 'cgvCancerTypeHome', 'cgvCancerresearch', 'ncifile') 
and p.CONTENTTYPENAME not like '%landing%'
and p.id not in (select contentid from #mini)
) 
order by tag
for xml explicit 


--- !! spanish as translation artcile
select 'article_es'
select * from 
(select d.* 
,(select top 1 coalesce(i.englishimageid, imageid) from #cgov_image i where i.pageid = p.id  and imagefield = 'lead' and langcode = 'es') as [row!2!field_image_article!Element]
,(select top 1 coalesce(i.englishimageid, imageid) from #cgov_image i where i.pageid = p.id  and imagefield = 'promotion' and langcode = 'es') as [row!2!field_image_promotional!Element]
from #espagedata d inner join #espage p on d.[row!2!id] = p.englishid
where p.CONTENTTYPENAME not in ( 'nciHome', 'cgvpressrelease', 'cgvblogpost', 'cgvblogseries', 'cgvCancerResearch', 'gloInstitution', 'cgvinfographic', 'glovideo', 'cgvCancerTypeHome', 'cgvCancerresearch', 'ncifile') 
and p.CONTENTTYPENAME not like '%landing%'
and p.id not in (select contentid from #mini)
and p.englishid not in (select contentid from #mini)
union all
select d.* , null,null
from #espagedata d 
where Tag = 1
)a
order by tag
for xml explicit



---infographic
select 'infographic_en'
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
,  id 
,h.[body] 
,gr.LONGDESC_ATTRIBUTE
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid, ''), 10,999) + '/' +    gr.FULL_INFOGRAPHIC_FILENAME as field_infographic
,(select top 1 imageid from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode) as field_image_promotional
from #enpage p 
inner join CONTENTSTATUS c on c.CONTENTID = p.id inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and slotname = 'gloImageSl'
inner join CT_CGVINFOGRAPHIC gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.public_revision
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.public_revision
where CONTENTTYPENAME  = 'cgvinfographic'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit




--infographic spanish
select 'infographic_es'
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
from #espage p inner join CONTENTSTATUS c on c.CONTENTID = p.id inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID and slotname = 'gloImageSl'
inner join CT_CGVINFOGRAPHIC gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.public_revision
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.public_revision
where CONTENTTYPENAME  = 'cgvinfographic'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



--video
select 'video_en'
select d.*
,  a.[row!2!field_caption!CDATA], 
  [row!2!field_media_oembed_video!Element]
  , [row!2!body!CDATA]
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!field_caption!CDATA],
NULL as [row!2!field_media_oembed_video!Element],
null as [row!2!body!CDATA]
union all 
select 
2 as tag
, 1 as parent
, p.id
, gr.CAPTION  as field_caption
, 'https://www.youtube.com/watch?v=' + gr.VIDEO_ID as field_media_oembed_video
, gr.BODYFIELD
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVVIDEOPLAYER gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.public_revision
where CONTENTTYPENAME  = 'glovideo'  and p.id <> 701561
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag, [row!2!id]
for xml explicit


select * from #cthp where pagetitle like 'breast%patient%'
order by card_rank 


--ES video
select 'video_es'
select d.*
,  a.[row!2!body!CDATA], 
  [row!2!field_media_oembed_video!Element],
  [row!2!field_caption!CDATA]
from #espagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as [row!2!field_media_oembed_video!Element],
NULL as  [row!2!field_caption!CDATA]
union all 
select 
2 as tag
, 1 as parent
, p.englishid
,gr.BODYFIELD
, 'https://www.youtube.com/watch?v=' + gr.VIDEO_ID as field_media_oembed_video
,gr.CAPTION
from #espage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join CT_CGVVIDEOPLAYER gr on gr.CONTENTID =
 c.CONTENTID and gr.REVISIONID = c.public_revision
where CONTENTTYPENAME  = 'glovideo'
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



---englsih and none translateds press release
select 'pressrelease_en'
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
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.public_revision
inner join CT_CGVPRESSRELEASE pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.public_revision
where p.CONTENTTYPENAME = 'cgvPressRelease' 
and (s.computed_path like '%2017%' or s.computed_path like '%2016%' or s.computed_path like '%2015%' or s.computed_path like '%2014%' or s.computed_path like '%2018%' or s.computed_path like '%2019%')
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit


------ Spanish  press release 
select 'pressrelease_es'
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
,(select top 1 coalesce(i.englishimageid,imageid) from #cgov_image i where i.pageid = p.id and imagefield = 'promotion' and langcode = 'es') as field_image_promotional
from #espage p 
inner join (select * from #es ) s on p.term_id = s.term_id
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.public_revision
inner join CT_CGVPRESSRELEASE pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.public_revision
where p.CONTENTTYPENAME = 'cgvPressRelease' 
and (s.computed_path like '%2017%' or s.computed_path like '%2016%' or s.computed_path like '%2015%' or s.computed_path like '%2014%' or s.computed_path like '%2018%' or s.computed_path like '%2019%')
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit
GO



------------------------
---blogseries english
select 'blogseries_en'
select d.*,[row!2!field_about_blog!CDATA]
, [row!2!field_allow_comments]
,[row!2!field_feedburner_url]
, [row!2!field_num_display_posts]
, [row!2!field_blog_series_shortname]
, [row!2!field_recommended_content_header]
, [row!2!field_banner_image!Element]  
,[row!2!field_image_promotional!Element]
, [row!2!field_archive_back_years!Element]
,[row!2!field_archive_group_by!Element]
,[row!2!field_featured_posts]
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
, NULL as [row!2!field_archive_back_years!Element]
, NULL as [row!2!field_archive_group_by!Element]
, NULL as [row!2!field_featured_posts]
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
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.public_revision
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
, (select top 1  imageid from #cgov_image i where i.pageid = p.id and langcode = 'en') as field_image_promotional
, 7
, case when c.title like '%Cancer Currents%' Or c.title like 'Temas y relatos%' then  'month' else 'year' end 
, (select r2.DEPENDENT_ID as field_featured_posts
from CONTENTSTATUS c1 inner join  PSX_OBJECTRELATIONSHIP r on  r.OWNER_ID = c1.CONTENTID and r.OWNER_REVISION = c1.PUBLIC_REVISION 
inner join rxslottype s on r.SLOT_ID = s.SLOTID    
inner join contentstatus c2 on c2.contentid = r.DEPENDENT_ID
inner join CT_NCILIST l on l.CONTENTID = c2.CONTENTID and l.REVISIONID = c2.PUBLIC_REVISION
inner join PSX_OBJECTRELATIONSHIP r2 on r2.OWNER_ID = c2.CONTENTID and r2.OWNER_REVISION = c2.PUBLIC_REVISION
inner join RXSLOTTYPE sl2 on sl2.SLOTID = r2.SLOT_ID
where c1.CONTENTID = p.term_id  and c2.TITLE like '%featured%' and sl2.SLOTNAME like '%listitem%'
order by r.SORT_RANK
for XML path ('')  , TYPE, ELEMENTS
)
from CONTENTSTATUS c inner join CT_CGVBLOGSERIES b on c.CONTENTID = b.CONTENTID and c.public_revision = b.REVISIONID
inner join #enpage p on p.id = c.CONTENTID 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



--spanish translation of blog series  //TODO
select 'blogseries_es'
select d.*,[row!2!field_about_blog!CDATA]
, [row!2!field_allow_comments]
,[row!2!field_feedburner_url]
, [row!2!field_num_display_posts]
, [row!2!field_blog_series_shortname]
, [row!2!field_recommended_content_header]
, [row!2!field_banner_image!Element]  
,[row!2!field_image_promotional!Element]
, [row!2!field_archive_back_years!Element]
, [row!2!field_archive_group_by!Element]
,  [row!2!field_featured_posts]
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
, NULL as [row!2!field_archive_back_years!Element]
, NULL as [row!2!field_archive_group_by!Element]
, NULL as [row!2!field_featured_posts]
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
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.public_revision
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
, (select top 1 coalesce(i.englishimageid,imageid) from #cgov_image i where i.pageid = p.id and langcode = 'es') as field_image_promotional
, 7
, case when c.title like '%Cancer Currents%' Or c.title like 'Temas y relatos%' then  'month' else 'year' end 
, (select r2.DEPENDENT_ID as field_featured_posts
from CONTENTSTATUS c1 inner join  PSX_OBJECTRELATIONSHIP r on  r.OWNER_ID = c1.CONTENTID and r.OWNER_REVISION = c1.PUBLIC_REVISION 
inner join rxslottype s on r.SLOT_ID = s.SLOTID    
inner join contentstatus c2 on c2.contentid = r.DEPENDENT_ID
inner join CT_NCILIST l on l.CONTENTID = c2.CONTENTID and l.REVISIONID = c2.PUBLIC_REVISION
inner join PSX_OBJECTRELATIONSHIP r2 on r2.OWNER_ID = c2.CONTENTID and r2.OWNER_REVISION = c2.PUBLIC_REVISION
inner join RXSLOTTYPE sl2 on sl2.SLOTID = r2.SLOT_ID
where c1.CONTENTID = p.term_id  and c2.TITLE like '%featured%' and sl2.SLOTNAME like '%listitem%'
order by r.SORT_RANK
for XML path ('')  , TYPE, ELEMENTS
)
from CONTENTSTATUS c inner join CT_CGVBLOGSERIES b on c.CONTENTID = b.CONTENTID and c.public_revision = b.REVISIONID
inner join #espage p on p.id = c.CONTENTID 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit


---!!blog topics   
select 'blogtopics_en'
select distinct v.ID as term_id,  v.name , b.BLOG_SERIES as field_owner_blog, 'en' as langcode
,LOWER( REPLACE( v.name,' ','-'))  as field_pretty_url
from #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_CGVBLOGPOST b on b.CONTENTID = c.CONTENTID and b.REVISIONID = c.public_revision
 outer apply perccancergov.dbo.udf_StringSplit(b.blog_topics,',') tax
left outer join TAX_VALUE v on v.NODE_ID = tax.ObjectID
left outer join TAX_NODE n on n.ID = v.node_id and n.TAXONOMY_ID = 15
where   CONTENTTYPENAME = 'cgvBlogpost'
and v.NAME is not null
for xml path , root('rows')




---englsih and none translateds blogpost
select 'blogpost_en'
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
	 CT_CGVBLOGPOST pr1 inner join CONTENTSTATUS c1 on c1.CONTENTID = pr1.CONTENTID  and c1.public_revision = pr1.REVISIONID
	cross apply perccancergov.dbo.udf_StringSplit(pr.blog_topics,',') tax
	inner join TAX_VALUE v on v.NODE_ID = tax.ObjectID
	inner join TAX_NODE n on n.ID = v.node_id and n.TAXONOMY_ID = 15
	where pr1.CONTENTID = c.CONTENTID and pr1.REVISIONID = c.public_revision
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
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.public_revision
inner join CT_CGVBLOGPOST pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.public_revision
where p.CONTENTTYPENAME = 'cgvblogpost' 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit







-------spanish translation blogpost
select 'blogpost_es'
select d.* 
, [row!2!field_image_article!Element] 
, [row!2!field_image_promotional!Element] 
,  [row!2!field_blog_series]
--, [row!2!field_blog_topics!Element]
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
--,NULL as [row!2!field_blog_topics!Element]
,NULL as [row!2!body!CDATA] 
, NULL as [row!2!author] 
, NULL as [row!2!field_recommended_content!Element] 
, NULL as [row!2!field_recommended_contents!Element] 
union all 
select 
2 as Tag,  
1 as Parent
,p.englishid 
,(select top 1 coalesce(i.englishimageid,imageid) from #cgov_image i where i.pageid = p.id and imagefield = 'lead' and langcode = p.langcode) as field_image_article
,(select top 1 coalesce(i.englishimageid,imageid) from #cgov_image i where i.pageid = p.id and imagefield = 'promotion' and langcode = p.langcode) as field_image_promotional
,(select englishid from #espage where id =pr.BLOG_SERIES)
--,(select   v.id 
--	from  CT_CGVBLOGPOST pr1 inner join CONTENTSTATUS c1 on c1.CONTENTID = pr1.CONTENTID  and c1.public_revision = pr1.REVISIONID
--	cross apply perccancergov.dbo.udf_StringSplit(pr.blog_topics,',') tax
--	inner join TAX_VALUE v on v.NODE_ID = tax.ObjectID
--	inner join TAX_NODE n on n.ID = v.node_id and n.TAXONOMY_ID = 15
--	where pr1.CONTENTID = c.CONTENTID and pr1.REVISIONID = c.public_revision
--	FOR XML path (''), TYPE, ELEMENTS
--)
,BODY,
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
left outer join CGVHTMLCONTENTDATA_CGVHTMLCONTENTDATA h on h.contentid = c.contentid and h.REVISIONID = c.public_revision
inner join CT_CGVBLOGPOST pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.public_revision
where p.CONTENTTYPENAME = 'cgvblogpost' 
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit
GO
-------------
--region
select 'region'
select  50+ROW_NUMBER () over (order by region) as term_id, REGION as name from 
(select distinct cc.REGION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.public_revision
where CONTENTTYPENAME = 'gloinstitution'
) a
for xml path , root('rows')


select  50+ROW_NUMBER () over (order by region) as term_id, REGION as name 
into #r
from 
(select distinct cc.REGION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.public_revision
where CONTENTTYPENAME = 'gloinstitution'
) a

--cancer center type
select 'cancercentertype'
select  70+ROW_NUMBER () over (order by classification) as term_id, classification as name from 
(select distinct cc.CLASSIFICATION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.public_revision
where CONTENTTYPENAME = 'gloinstitution'
) a
for xml path , root('rows')


select  70+ROW_NUMBER () over (order by classification) as term_id, classification as name 
into #t
from 
(select distinct cc.CLASSIFICATION
from #enpage p
inner join contentstatus c on c.contentid = p.id 
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.public_revision
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
select 'cancercenter'
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
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
				left outer join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
				where il.internallink_id is NOT null
				group by p.id
				having COUNT(distinct internallink_id)  = 1)
			FOR XML path (''), TYPE, ELEMENTS
			)
,(
		select internallink_id as related_resource_ids
		from  CONTENTSTATUS c
		inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
		inner join (select internallink_id from #internallink union all select externallink_id from #externallink) il on il.internallink_id = r.RID
		where  c.contentid = p.id and c.contentid in 
				(select p.id
				from #enpage p 
				inner join  CONTENTSTATUS c on p.id = c.CONTENTID 
				inner join PSX_OBJECTRELATIONSHIP r on c.contentid = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
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
inner join CT_CGVCANCERCENTER cc on cc.CONTENTID = c.CONTENTID and cc.REVISIONID = c.public_revision
left outer join #r r on r.name = cc.REGION
left outer join #t t on t.name = cc.CLASSIFICATION
left outer join GLOADDRESSSET_GLOADDRESSSET a on a.CONTENTID = c.CONTENTID and a.REVISIONID = c.public_revision
left outer join #states s on s.FULLNAME = a.state
left outer join #cgov_image i on i.pageid = p.id and p.langcode = 'en'
where CONTENTTYPENAME = 'gloinstitution'
for xml explicit

GO

-------






---------------------------------------

---------------------------------------

---------------------------------------


drop table #dlist 
create table #dlist (contentid int, title varchar(300), data varchar(900))
insert into #dlist
values
(76318,'Noticias[#2459]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:0:"";s:5:"limit";s:1:"10";s:6:"offset";N;s:5:"title";i:0;}')
,(919000,'Resources for News Media[#5152]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:0:"";s:5:"limit";s:1:"3";s:6:"offset";N;s:5:"title";i:0;}')
,(936262,  '2014',   'a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2014";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(936263,'2015 Press Releases[#1683]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2015";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(936282,'News Card Container[#9744]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:0:"";s:5:"limit";s:1:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(936327,'Noticias Card Container[#6835]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:0:"";s:5:"limit";s:1:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(950983,'Comunicados de prensa de 2014[#8093]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2014";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(950985,'Comunicados de prensa de 2015[#1683]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2015";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1034471,'2016 Press Releases[#1683]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2016";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1040936,'Comunicados de prensa de 2016[#1683]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2016";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1070069,'2017 Press Releases[#3725]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2017";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1071686,'Comunicados de prensa de 2017[#3725]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2017";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1106668,'2018 Press Releases[#1336]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2018";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1110088,'Comunicados de prensa de 2018[#6198]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2018";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1134661,'2019 Press Releases[#1336]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2019";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')
,(1134663,'Comunicados de prensa de 2019[#1545]','a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2019";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}')




drop table #dynamiclist
select c.CONTENTID , c.title 
, r.RID, c1.CONTENTID as listid
, LEFT(c.locale,2) as langcode
, d.VIEW_MORE_LINK as field_view_more_link
, d.VIEW_MORE_TEXT as field_view_more_text
, case when d.TITLE_DISPLAY = 'none' then null else left(c1.title, charindex('[',c1.title)-1) end as field_list_title
, 'press_releases' as target_id
, case when c.title like 'noti%' or c.title like '%news%' then  'pr_home_block' else 'pr_archive_block' end as display_id
, coalesce(l.data, 'a:5:{s:5:"pager";s:0:"";s:8:"argument";s:0:"";s:5:"limit";s:1:"5";s:6:"offset";N;s:5:"title";i:0;}') as data
into #dynamiclist
from CONTENTSTATUS c inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID  and c.public_revision = r.OWNER_REVISION
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
left outer join #dlist l on l.contentid = c.CONTENTID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join STATES s on s.STATEID = c.CONTENTSTATEID and s.WORKFLOWAPPID = c.WORKFLOWAPPID
inner join CT_CGVDYNAMICLIST d on d.CONTENTID = c1.CONTENTID and d.REVISIONID = c1.PUBLIC_REVISION
where t1.CONTENTTYPENAME = 'cgvDynamicList' --and sl.SLOTNAME = 'cgvBody' 
and c.TITLE not like '%2013%press%' and c.TITLE not like '%2012%press%' and c.TITLE not like 'Comunicados de prensa de 2012%' and c.TITLE not like 'Comunicados de prensa de 2013%'
and c.TITLE not like '%blog%'
and dbo.gaogetitemFolderPath(c.contentid,'') not like '%blog%'



select 'dynamiclist'
select RID as id, field_list_title,target_id, data, display_id, langcode
from #dynamiclist
for xml path , root('rows')

--'a:5:{s:5:"pager";s:0:"";s:8:"argument";s:4:"2019";s:5:"limit";s:2:"20";s:6:"offset";N;s:5:"title";i:0;}'
--select '(' + convert(varchar(50),CONTENTID) + ','''+ TITLE +''',''' +  data  + ''')'  from #dynamiclist



drop table #twocolumn1
select lc.row_rid
, case when  CONTENTTYPENAME = 'cgvDynamicList' then lc.card_rid else null END as field_main_contents
, case when   CONTENTTYPENAME <> 'cgvDynamicList' then lc.card_rid else null END as field_secondary_contents
, lc.langcode 
, lc.sort_rank
into #twocolumn1
from #landing_content lc 
inner join (select rawcard_rid from  #rawhtml union all select rid from #dynamiclist
) r on lc.card_rid = r.rawcard_rid
where SLOTNAME like '%general%' or CONTENTTYPENAME = 'cgvDynamicList'


-- tow column row
select 'twocolumnrow'
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
inner join (select rawcard_rid from #rawhtml union all select rawcard_rid from #contentblock) pc on lc.card_rid = pc.rawcard_rid
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
select 'list'
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
select 'primaryfeaturecardrow'
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



--- !! secondary feature card row
select 'secondaryfeaturecardrow'
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
select 'guidecardrow'
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
select 'twoitemfeaturecardrow'
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
,(select coalesce((select englishid from #espage where id =linkid) , linkid)
from #landing_contentMM1 l
where l.row_rid = mm.row_rid and SLOTNAME = 'nvcgSlLayoutMultimediaA'
) as field_mm_media_item
, langcode
into #MMrow
from (select distinct row_rid, langcode from #landing_contentMM  where SLOTNAME ='nvcgSlLayoutMultimediaA' ) mm


--Multi media row
select 'multimediarow'
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
	



---------


drop table #minilandingcontent
select * into #minilandingcontent from
(
select distinct parentid, parentid as id,  4 as sort_rank from #landinglistitem l 
union 
select distinct parentid, ID, 1 from #minicontentblock b 
union
select  distinct CONTENTID, row_rid,2   from #twoitemfeaturecardrow
union
select distinct  contentid, rid, 3  from #dynamiclist where contentid in (Select contentid from #mini)

) a
order by 1





----mini landing English
select 'minilanding_en'
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
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.public_revision
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
select 'minilanding_es'
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
			inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.public_revision = r.OWNER_REVISION
			inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
			inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.public_revision
			inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
			inner join CT_GLOUTILITYIMAGE si on si.CONTENTID = c2.CONTENTID and si.REVISIONID = c2.public_revision
			inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
		where c.CONTENTID =p.id and r.SLOT_ID = 527
	) 
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = 'es') as field_image_promotional
from  #espage p where p.id in (select contentid from #mini ) and id not in (950980, 950981)
) a
on (a.tag = pd.Tag and a.parent = pd.Parent and a.tag =1) or (a.tag = 2 and a.id = pd.[row!2!id])
order by pd.tag
for xml explicit


select * from #l where id =13019





---home landing page  English
select 'homelanding_en'
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
		 order by l.sublayout_rank
			for XML path (''), TYPE, ELEMENTS) 
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = p.langcode) as field_image_promotional
from #enpage p 
where p.id in (select id from #landing_content )
for xml path , root ('rows')



---  home landing spanish
select 'homelanding_es'
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


-------------------















----------






