--select * from  PSX_folder f join contentstatus cs on f.contentid = cs.contentid where  cs.TITLE ='dceg'

IF OBJECT_ID('tempdb..#d') IS NOT NULL  drop table   #d
select * into  #d from
 (select 2 as id, 'updated' as date_display_mode 
 union all
 select 1, 'posted'
 union all
 select 4, 'reviewed'
 )a

--!! sitesection
IF OBJECT_ID('tempdb..#s') IS NOT NULL drop table #s
select * into #s from
(
select 'hide_in_main_nav' as field_navigation_display_options
union all 
select 'hide_in_mobile_nav'
union all
select 'hide_in_section_nav'
)a

select 'sitesectionsql'
select
computed_path
, c.CONTENTID 
--level,
,s.sort_rank AS weight
,name,
term_id,
parent,
field_pretty_url,
field_section_nav_root,
field_main_nav_root,
case when field_navigation_display_options Is NOT null then (select field_navigation_display_options from #s for XML path('') , type, elements ) else null end ,
field_landing_page,
description_value,
field_navigation_label,
field_levels_to_display
,m.CONTENTID as field_mega_menu_content
, case when s.computed_path = '/' then 1 else null END as   field_breadcrumb_root
, 'en' as langcode
, w.CHANNEL as field_channel
, w.CONTENT_GROUP as field_content_group
from qtp.dbo.endceg s inner join contentstatus c on s.term_id = c.CONTENTID 
left outer join GENWEBANALYTICS_GENWEBANALYTICS w on w.CONTENTID = c.CONTENTID and w.REVISIONID = c.public_revision
outer apply (select  h.CONTENTID from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_GLORAWHTML h on h.CONTENTID = r1.DEPENDENT_ID and c1.public_revision = h.REVISIONID 
		where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.public_revision
			and st.SLOTNAME = 'nvcgSlMegamenuHtml' ) m
order by 1
for xml path , root('rows')




--select
--computed_path
--, c.CONTENTID 
----level,
--,s.sort_rank AS weight
--,name,
--term_id,
--parent,
--field_pretty_url,
--field_section_nav_root,
--field_main_nav_root,
--case when field_navigation_display_options Is NOT null then (select field_navigation_display_options from #s for XML path('') , type, elements ) else null end ,
--field_landing_page, r.DEPENDENT_ID
--,description_value,
--field_navigation_label,
--field_levels_to_display
--,NULL as field_mega_menu_content
--, case when s.computed_path = '/' then 1 else null END as   field_breadcrumb_root
--, 'en' as langcode
--, w.CHANNEL as field_channel
--, w.CONTENT_GROUP as field_content_group
--from qtp.dbo.endceg s inner join contentstatus c on s.term_id = c.CONTENTID 
--left outer join GENWEBANALYTICS_GENWEBANALYTICS w on w.CONTENTID = c.CONTENTID and w.REVISIONID = c.public_revision
--left outer join PSX_OBJECTRELATIONSHIP r  on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.PUBLIC_REVISION and r.slot_id = 510
--where field_landing_page <> r.DEPENDENT_ID
--or (field_landing_page is null and r.DEPENDENT_ID is NOT null)
--or (field_landing_page is not null and r.DEPENDENT_ID is  null)
--order by 1



-------------


IF OBJECT_ID('tempdb..#enpage') IS NOT NULL drop table #enpage
select 
t.CONTENTTYPENAME
, dp.[SiteSection TermID] as term_id--en.term_id 
, c.CONTENTID as id
 ,left(c.title, charindex('[', c.title)-1)  as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),600) as field_page_description
, left(p.SHORT_DESCRIPTION,254) as field_feature_card_description
, p.long_description as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
, 0 as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, (select distinct #d.date_display_mode from GENDATEDISPLAYMODE_GENDATEDISPLAYMODE d inner join #d on d.DATE_DISPLAY_MODE = #d.id  
where d.CONTENTID = c.contentid and d.REVISIONID = c.PUBLIC_REVISION
for XML path('') , type, elements) as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as field_intro_text
into #enpage
from dbo.contentstatus c 		
		inner join qtp.dbo.dcegpage dp on dp.contentid = c.CONTENTID 
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		left outer join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		left outer join GENDATESSET_GENDATESSET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME not in ( 'genExternalLink',  'cgvDynamicList', 'glovideo')
and CONTENTTYPENAME not like 'pdq%'
and CONTENTTYPENAME not like '%image%'
and CONTENTTYPENAME not like 'rffNav%'


insert into #enpage
select 
t.CONTENTTYPENAME
, dp.[SiteSection TermID] as term_id--en.term_id 
, c.CONTENTID as id
 ,left(c.title, charindex('[', c.title)-1)  as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),600) as field_page_description
, left(p.SHORT_DESCRIPTION,254) as field_feature_card_description
, p.long_description as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
, 0 as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, (select distinct #d.date_display_mode from GENDATEDISPLAYMODE_GENDATEDISPLAYMODE d inner join #d on d.DATE_DISPLAY_MODE = #d.id  
where d.CONTENTID = c.contentid and d.REVISIONID = c.PUBLIC_REVISION
for XML path('') , type, elements) as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as field_intro_text
from dbo.contentstatus c 		
		inner join qtp.dbo.dcegpage dp on dp.contentid = c.CONTENTID 
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		left outer join GLOPAGEMETADATASET_GLOPAGEMETADATASET p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		left outer join GLODATESET_GLODATESET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and CONTENTTYPENAME = 'glovideo'




insert into #enpage 
select 
t.CONTENTTYPENAME
, 302032 as term_id--en.term_id 
, c.CONTENTID as id
 ,left(c.title, charindex('[', c.title)-1)  as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, left(convert(nvarchar(max),coalesce( p.META_DESCRIPTION, p.long_description)),600) as field_page_description
, left(p.SHORT_DESCRIPTION,254) as field_feature_card_description
, p.long_description as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else 'IncludeSearch' end as field_search_engine_restrictions
, 0 as field_public_use
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, convert(DATE, d.DATE_LAST_MODIFIED) as field_date_updated
, (select distinct #d.date_display_mode from GENDATEDISPLAYMODE_GENDATEDISPLAYMODE d inner join #d on d.DATE_DISPLAY_MODE = #d.id  
where d.CONTENTID = c.contentid and d.REVISIONID = c.PUBLIC_REVISION
for XML path('') , type, elements) as date_display_mode
, p.PRETTY_URL_NAME as field_pretty_url
, coalesce(p.BROWSER_TITLE, p.short_title) as field_browser_title
, coalesce(p.card_title, p.short_title) as field_card_title
, o.INTRO_TEXT as field_intro_text
from dbo.contentstatus c 		
		inner join CT_GENEVENT e on c.CONTENTID = e.CONTENTID and c.PUBLIC_REVISION = e.REVISIONID
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		left outer join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		left outer join GENDATESSET_GENDATESSET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join CGVONTHISPAGE_CGVONTHISPAGE o on o.CONTENTID = c.CONTENTID and o.REVISIONID = c.CURRENTREVISION
		inner join PSX_OBJECTRELATIONSHIP r on r.DEPENDENT_ID = c.CONTENTID and CONFIG_ID = 3 and r.OWNER_ID = 1117650
where c.LOCALE = 'en-us' and s.STATENAME not like '%archive%'
and c.CONTENTID not in (select ID from #enpage)











------------------
IF OBJECT_ID('tempdb..#list') IS NOT NULL drop table #list 
select 
c.CONTENTID as pageid 
,   r.RID as list_rid
, r.SORT_RANK as list_rank 
,    c1.CONTENTID as list_id 
,  r1.RID as link_rid , c2.CONTENTID as linkid, t2.CONTENTTYPENAME , r1.SORT_RANK
, case when pt.name like '%NoTitle%' then null else left(c1.TITLE, charindex('[', c1.title) -1)  END as field_list_title
into #list
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE  sl on sl.SLOTID = r.SLOT_ID 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID

inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.CURRENTREVISION
inner join RXSLOTTYPE  sl1 on sl1.SLOTID = r1.SLOT_ID 
inner join CONTENTSTATUS c2 on c2.CONTENTID = r1.DEPENDENT_ID
inner join CONTENTTYPES t2 on t2.CONTENTTYPEID = c2.CONTENTTYPEID 
inner join PSX_TEMPLATE pt on pt.template_id = r.VARIANT_ID
where sl.SLOTNAME ='genSlotBody' and t1.CONTENTTYPENAME = 'genlist'


IF OBJECT_ID('tempdb..#internallink1') IS NOT NULL drop table #internallink1
--- TODO internallink for cgvcustomer link?, media link? 
select * into #internallink1 from
(
select 
r.rid as internallink_id
,c1.contentid as field_internal_link_target_id
, NULL as field_override_title
,en.langcode
, t1.CONTENTTYPENAME 
from 
#enpage en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
where  sl.SLOTNAME in ( 'genSlotRelatedPages' )  and t1.CONTENTTYPENAME not like  '%link%' 
union all
select link_rid, linkid, null, 'en', CONTENTTYPENAME 
from #list where contenttypename not like  '%link%'
--union all
--select 
--r.rid as internallink_id
--,c1.contentid as field_internal_link_target_id
--, NULL as field_override_title
--,en.langcode
----, t1.CONTENTTYPENAME 
----, sl1.SLOTNAME 
--from #enpage en 
--inner join CONTENTSTATUS c on c.CONTENTID = en.id
--inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
--inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
--inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
--inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
--inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
--inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c1.CONTENTID and r1.OWNER_REVISION = c1.PUBLIC_REVISION
--inner join RXSLOTTYPE sl1 on sl1.SLOTID = r1.SLOT_ID
--where  sl.SLOTNAME in ( 'genSlotRelatedPages' )  and t1.CONTENTTYPENAME  like  '%link%' 
--union all
--select link_rid, linkid, null, 'en'
--from #list where contenttypename not like  '%link%'
) a 




IF OBJECT_ID('tempdb..#internallink') IS NOT NULL drop table #internallink
select * into #internallink from 
(select i.*
from #internallink1 i inner join #enpage p on i.field_internal_link_target_id = p.id 
) a


GO 
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



---------------------

--!! TODO  externallink title?
IF OBJECT_ID('tempdb..#externallink') IS NOT NULL  drop table #externallink

select r.dependent_id, r.RID as externallink_id
, left(c1.TITLE,  case when CHARINDEX('[' , c1.TITLE) -1 <=  0 then 999 else CHARINDEX('[' , c1.TITLE) -1 END) as field_override_title
, l.URL as field_external_link_uri
, en.langcode
, r.SORT_RANK
into #externallink 
from #enpage en 
inner join CONTENTSTATUS c on c.CONTENTID = en.id
inner join CONTENTTYPES t on t.CONTENTTYPEID = c.CONTENTTYPEID 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.CURRENTREVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.contentid = r.DEPENDENT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.contenttypeid 
inner join CT_GENEXTERNALLINK l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.CURRENTREVISION
where  sl.SLOTNAME in ( 'genSlotRelatedPages' )




select 'externallinksql'
select * from #externallink 
 for xml path , root('rows')

delete from #list  where link_rid not  in (select internallink_id from #internallink) and link_rid  not in (select externallink_id from #externallink)
GO


--list
select 'list'
select  list_rid as row_rid,  'list_item_title_desc' as field_list_item_style, 'en' as langcode
, field_list_title
, (select link_rid as field_list_item 
	from #list l1 
	where l1.list_rid = l.list_rid and l1.list_rid in (select list_rid from #list group by list_rid having COUNT(*) =1 )
	for XML path (''), TYPE, ELEMENTS
	)
, (select link_rid as field_list_items 
	from #list l1 
	where l1.list_rid = l.list_rid and l1.list_rid in (select list_rid from #list group by list_rid having COUNT(*) >1 )
	order by l1.SORT_RANK
	for XML path (''), TYPE, ELEMENTS
	)
from (select distinct list_rid, field_list_title from #list ) l 
for xml path, root ('rows')

--contentblock
IF OBJECT_ID('tempdb..#contentblock') IS NOT NULL   drop table #contentblock 
select distinct
 c1.CONTENTID as [row!1!id]
, langcode as [row!1!langcode]
, convert(nvarchar(max),BODYFIELD) as [row!1!body!CDATA]
into #contentblock 
from CONTENTSTATUS c inner join 
 (select id, contenttypename, langcode from #enpage )  a
 on c.CONTENTID = a.id 
 inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.PUBLIC_REVISION
 inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
 inner join PSX_TEMPLATE t on t.TEMPLATE_ID = r.VARIANT_ID 
 inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
 inner join CT_NCIDOCFRAGMENT  h on h.CONTENTID = c1.CONTENTID and h.REVISIONID = c1.PUBLIC_REVISION
where sl.SLOTNAME = 'sys_inline_variant' 


insert into #contentblock 
select
p.id 
, 'en' as [row!1!langcode]
,coalesce( (select bodyfield from dbo.CT_GENLANDING gl where gl.contentid = c.contentid and gl.revisionid = c.CURRENTREVISION)
, (select bodyfield from dbo.CT_gengeneral gl where gl.contentid = c.contentid and gl.revisionid = c.CURRENTREVISION)) as body
from #enpage p inner join CONTENTSTATUS c on c.CONTENTID = p.id
where id in (select contentid from qtp.dbo.dcegpage where [Drupal CONTENTTYPENAME] = 'cgov_mini_landing_page')
and coalesce( (select bodyfield from dbo.CT_GENLANDING gl where gl.contentid = c.contentid and gl.revisionid = c.CURRENTREVISION)
, (select bodyfield from dbo.CT_gengeneral gl where gl.contentid = c.contentid and gl.revisionid = c.CURRENTREVISION)) is not null



select 'contentblock'
select 
1 as tag
, 0 as parent
, *
from #contentblock
for xml explicit, root('rows')


GO


IF OBJECT_ID('tempdb..#minilanding') IS NOT NULL  drop table #minilanding 
select * into #minilanding from 
(select distinct pageid, list_rid, list_RANK + 1  as sort_rank from #list 
union all 
select [row!1!id], [row!1!id], 0 from #contentblock 
) a



IF OBJECT_ID('tempdb..#para') IS NOT NULL  drop table #para
select  p.id, 
p.id as para_id
,coalesce( (select g.BODYFIELD from CT_GENGENERAL g where g.CONTENTID = p.id  and g.revisionid = c.currentrevision )
, (select g.BODYFIELD from CT_GENNEWSLETTERARTICLE g where g.CONTENTID = p.id and g.revisionid = c.currentrevision )
, (select g.BODYFIELD from CT_GENLANDING g where g.CONTENTID = p.id and g.revisionid = c.currentrevision ) 
)as content
, 'en' as langcode
, null as sortrank 
into #para
from #enpage p inner join qtp.dbo.dcegpage dp on p.id = dp.contentid 
inner join CONTENTSTATUS c on c.CONTENTID = p.id 
where dp.[Drupal CONTENTTYPENAME] = 'cgov_article'




select 'para_en'
SELECT
    1 AS Tag,
    NULL AS Parent,
    NULL AS 'rows!1!',
    NULL AS 'row!2!para_id',
    NULL AS 'row!2!content!CDATA',
    NULL AS 'row!2!langcode'
UNION ALL
SELECT
    2 AS Tag,
    1 AS Parent,
    NULL, 
    para_id,
     content,
     'en'
FROM #para 
where para_id is not null and content is not null
FOR XML EXPLICIT
GO







IF OBJECT_ID('tempdb..#enpagedata') IS NOT NULL  drop table #enpagedata 
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
		and p.id in (select id from #para where content is not null group by id having COUNT(*) = 1)
		FOR XML path (''), TYPE, ELEMENTS
   )
from  #enpage 	 p 
) a



IF OBJECT_ID('tempdb..#cgov_image') IS NOT NULL  drop table #cgov_image
select 
p.id as pageid
, c.CONTENTID as imageid 
, pr.SORT_FIRST_NAME +'_' + pr.SORT_last_NAME as name
,'https://dceg.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.CONTENTID, ''), 5,999) + '/' + IMG1_FILENAME as field_media_image
into #cgov_image 
from #enpage p
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_GENBIOGRAPHY pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION

select 'cgovimage'
select 
1 as tag,
0 as parent
,imageid as [row!1!id] 
, name as [row!1!name!Element]
, field_media_image as [row!1!field_media_image!element]
from #cgov_image
for xml explicit , root('rows')

GO





--contextual image
IF OBJECT_ID('tempdb..#contextual_image') IS NOT NULL  drop table  #contextual_image
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
inner join (select id, langcode from #enpage  ) p on c.CONTENTID = p.id 
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
inner join (select id, langcode from #enpage ) p on c.CONTENTID = p.id 
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
inner join (select id, langcode from #enpage ) p on c.CONTENTID = p.id 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.public_revision
inner join RXSLOTTYPE sl on sl.SLOTID = r.slot_id 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID 
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID 
left outer join CT_GLOUTILITYIMAGE i on i.CONTENTID = c1.CONTENTID and i.REVISIONID = c1.public_revision
where t1.CONTENTTYPENAME = 'gloutilityimage' and  sl.slotname  like 'sys%' 

)a



delete from #contextual_image where imageid in (select imageid from #cgov_image)



--------------
--contextual image english
select 'contextualimage'

select 
distinct
1 as tag
, 0 as parent
,i.imageid as [row!1!id]
,'en' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://dceg.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),5,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME,  u.img_utility_filename) as [row!1!field_media_image!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
 from 
(select * from #contextual_image where langcode = 'en' 
) i 
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
left outer join CT_GLOUTILITYIMAGE u on u.CONTENTID = c.CONTENTID and u.REVISIONID = c.public_revision
for xml explicit , root('rows')

GO



select 'biography'
select d.*
,  a.[row!2!body!CDATA]
, [row!2!field_image_promotional!Element] 
,  [row!2!field_email_address]
,  [row!2!field_first_name]
,  [row!2!field_last_name]
,  [row!2!field_phone_number]
,  [row!2!field_org_name_1]
,  [row!2!field_org_name_2]
,  [row!2!field_campus]
,  [row!2!field_office_location]
,[row!2!field_display_bio_press_info]
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA],
NULL as  [row!2!field_image_promotional!Element] 
,NULL as  [row!2!field_email_address]
, null as [row!2!field_first_name]
, null as [row!2!field_last_name]
, null as [row!2!field_phone_number]
, null as [row!2!field_org_name_1]
, null as [row!2!field_org_name_2]
, null as [row!2!field_campus]
, null as [row!2!field_office_location]
, null as [row!2!field_display_bio_press_info]
union all 
select 
2 as tag
, 1 as parent
, p.id
,pr.[BODYFIELD] 
,(select top 1 imageid from #cgov_image i where i.pageid = p.id ) as field_image_promotional
, pr.EMAIL_ADDRESS
, pr.SORT_FIRST_NAME
,pr.SORT_LAST_NAME
, pr.PHONE
,pr.DIVISION
,pr.SUBDIVISION
, case when pr.ADDRESS1 like '%shady%' OR pr.ADDRESS1 like '%9609%' then 300 else 301 end
, pr.ADDRESS2
, (select 1 from PSX_OBJECTRELATIONSHIP r where r.OWNER_ID = c.CONTENTID and r.OWNER_REVISION = c.PUBLIC_REVISION and r.SLOT_ID = 801)
from #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_GENBIOGRAPHY pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit






--select  pr.ADDRESS1, COUNT(*)
--from #enpage p 
--inner join CONTENTSTATUS c on p.id = c.CONTENTID 
--inner join CT_GENBIOGRAPHY pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
--where ADDRESS1 is not null
--group by pr.ADDRESS1
--event

---!!!!!! TODO  venue   tax   bio's campus taxs
select 'event'
select d.*
,  [row!2!body!CDATA]
,  [row!2!field_event_end_date]
,  [row!2!field_event_start_date]
,  [row!2!field_venue]
,  [row!2!field_city_state]
,  [row!2!field_all_day_event]
,  [row!2!field_event_series]
from #enpagedata d 
inner join 
(select
1 as tag,
0 as parent,
NULL as id ,
NULL as [row!2!body!CDATA]
, NULL as [row!2!field_event_end_date]
, NULL as [row!2!field_event_start_date]
, NULL as [row!2!field_venue]
, NULL as [row!2!field_city_state]
, NULL as [row!2!field_all_day_event]
, NULL as [row!2!field_event_series]
union all
select 
2 as tag
, 1 as parent
, p.id
,pr.[BODYFIELD] 
, dateadd(hh,4,pr.END_DATE) 
,dateadd(hh,4,pr.START_DATE)
, case when venue like '%shady%' then 400 when CITY like '%bethesda%' then 401   END as venue
, pr.CITY
, pr.ALL_DAY
, 350 as field_event_series
from #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_GENEVENT pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit



select 
2 as tag
, 1 as parent
, p.id
,pr.[BODYFIELD] 
, pr.START_DATE
, convert(datetimeoffset,pr.START_DATE) --AT TIME ZONE 'UTC'

,SYSDATETIMEOFFSET() 
, case when venue like '%shady%' then 400 when CITY like '%bethesda%' then 401   END as venue
, pr.CITY
, pr.ALL_DAY
, 350 as field_event_series
from #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_GENEVENT pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION



--article
select 'article'
select d.* 
from #enpagedata d 
where Tag =1 or 
[row!2!id] 
in  (
select contentid from qtp.dbo.dcegpage p 
where p.[Drupal CONTENTTYPENAME] = 'cgov_article'
) 
order by tag
for xml explicit
GO


select 'homelanding_en'
select p.*
,
(select top 1 imageid from #cgov_image i where i.pageid = p.id and langcode = p.langcode) as field_image_promotional
from #enpage p 
where p.id in -- 302687
(select contentid from qtp.dbo.dcegpage p where p.[Drupal CONTENTTYPENAME] like 'cgov_home%' )
for xml path , root ('rows')



---blog post !!!!!!! blog_series
select 'blogpost_en'
select d.* 
, [row!2!field_blog_topics!Element]
, [row!2!body!CDATA] 
, [row!2!author] 
,  [row!2!field_blog_series]
from #enpagedata d 
inner join 
(select 
1 as Tag
,0 as Parent
,NULL AS id
, NULL as [row!2!body!CDATA] 
,NULL as [row!2!author] 
, NULL as [row!2!field_blog_series]
, null as  [row!2!field_blog_topics!Element]
union all 
select 
2 as Tag,  
1 as Parent
,p.id 
,coalesce((select pr.bodyfield  from CT_GENNEWSLETTERARTICLE pr where pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION) 
,(select pr.bodyfield  from CT_GENNEWSRELEASE  pr where pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION) 
, (select pr.bodyfield  from CT_GENgeneral pr where pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION) 
) as  BODY

,case when (select pr.authors  from CT_GENNEWSLETTERARTICLE pr where pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION) Is null then 'DCEG Staff' else null END
as author
, 500
,
(select case id when 'linkage Newsletter' then 502 when 'research highlights' then 501 when 'people in the news' then 503 when 'Fellowships & Training' then 504 end as id  
from 
	(select qdp.[Blog Tag] as id
	from qtp.dbo.dcegpage qdp 
	where qdp.contentid = p.ID and qdp.[Blog Tag] is not null 
	union 
	select qdp.[Blog Tag 2]
	from qtp.dbo.dcegpage qdp 
	where qdp.contentid = p.ID and qdp.[Blog Tag 2] is not null 
	) a
FOR XML path (''), TYPE, ELEMENTS) 
from  #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
left outer join CT_GENNEWSLETTERARTICLE pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
left outer join CT_GENNEWSLETTER l on l.CONTENTID = c.CONTENTID and l.REVISIONID = c.CURRENTREVISION
inner join qtp.dbo.dcegpage dp on dp.contentid = p.id 
where dp.[Drupal CONTENTTYPENAME]= 'cgov_blog_post'
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit




--select 
--c.contentid,
--c.title,
--(select pr.authors  from CT_GENNEWSLETTERARTICLE pr where pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION)
-- as author
--from  #enpage p 
--inner join CONTENTSTATUS c on p.id = c.CONTENTID 
--left outer join CT_GENNEWSLETTERARTICLE pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
--left outer join CT_GENNEWSLETTER l on l.CONTENTID = c.CONTENTID and l.REVISIONID = c.CURRENTREVISION
--inner join qtp.dbo.dcegpage dp on dp.contentid = p.id 
--where dp.[Drupal CONTENTTYPENAME]= 'cgov_blog_post'
--and (select pr.authors  from CT_GENNEWSLETTERARTICLE pr where pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION) is not null





--cgov file 
select 'file'
select 
 ep.*
, 'https://dceg.cancer.gov/publishedcontent/Files' + substring(dbo.gaogetitemFolderPath([row!2!id] , ''), 5,999) + '/' 
+ 
(select f.ITEM_FILENAME  from CONTENTSTATUS c 
inner join RXS_CT_SHAREDBINARY f on f.CONTENTID = c.CONTENTID and f.REVISIONID = c.CURRENTREVISION
where c.CONTENTID = ep.[row!2!id]
)as [row!2!field_media_file!Element]
from  #enpagedata ep
where Tag =1 or 
[row!2!id] 
in  (
select contentID from qtp.dbo.dcegpage p 
where p.[Drupal CONTENTTYPENAME] like '%file'
)
order by tag
for xml explicit

GO


select 'minilanding_en'
select pd.*,[row!2!field_landing_content],[row!2!field_landing_contents]
from #enpagedata pd 
inner join 
(select
1 as tag,
0 as parent,
NULL as id 
,NULL as [row!2!field_landing_contents]
,NULL as [row!2!field_landing_content]
union all 
select 
2 as tag
, 1 as parent
, p.id
 ,		(select distinct list_rid as field_landing_contents,sort_rank from #minilanding mc where mc.pageid = p.id 
			and mc.pageid in (select pageid from #minilanding group by pageid having COUNT(distinct list_rid) > 1)
		 order by sort_rank
		 for XML path (''), TYPE, ELEMENTS) 
,		(select distinct list_rid as field_landing_content,sort_rank from #minilanding mc where mc.pageid = p.id 
			and mc.pageid in (select pageid from #minilanding group by pageid having COUNT(distinct list_rid) = 1)
		 order by sort_rank
		 for XML path (''), TYPE, ELEMENTS)
from  #enpage p where p.id in (select contentid from qtp.dbo.dcegpage p where p.[Drupal CONTENTTYPENAME] = 'cgov_mini_landing_page' )

) a
on (a.tag = pd.Tag and a.parent = pd.Parent and a.tag =1) or (a.tag = 2 and a.id = pd.[row!2!id])
order by pd.tag
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
inner join CT_CGVVIDEOPLAYER gr on gr.CONTENTID = c.CONTENTID and gr.REVISIONID = c.public_revision
where p.id in (select CONTENTID from qtp.dbo.dcegpage dp where dp.[Drupal CONTENTTYPENAME] = 'cgov_video')
)a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag, [row!2!id]
for xml explicit








--------------

-----------
----------------



--select dp.[Drupal CONTENTTYPENAME], COUNT(*) from qtp.dbo.dcegpage dp
--group by dp.[Drupal CONTENTTYPENAME]



--select ct.TITLE, ct.contentid, s.s, t.CONTENTTYPENAME 
--from #contentblock c cross apply dbo.gaoTagSearch(  c.[row!1!body!CDATA] , 'class="','"', 'callout', 1) s 
--left outer join (dbo.CONTENTSTATUS ct inner join CONTENTTYPES t on t.CONTENTTYPEID = ct.CONTENTTYPEID ) on ct.CONTENTID = c.[row!1!id]
--union all
--select ct.TITLE, ct.contentid, s.s, t.CONTENTTYPENAME 
--from #para c cross apply dbo.gaoTagSearch(  c.content , 'class="','"', 'callout', 1) s 
--left outer join (dbo.CONTENTSTATUS ct inner join CONTENTTYPES t on t.CONTENTTYPEID = ct.CONTENTTYPEID ) on ct.CONTENTID = c.id



