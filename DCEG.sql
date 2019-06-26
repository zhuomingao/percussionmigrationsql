--select * from  PSX_folder f join contentstatus cs on f.contentid = cs.contentid where  cs.TITLE ='dceg'

IF OBJECT_ID('tempdb..#d') IS NOT NULL  drop table   #d
select * into  #d from
 (select 2 as id, 'posted' as date_display_mode 
 union all 
 select 2, 'updated'
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






select 'rawhmlblock'
select 
1 as tag
, 0 as parent
,mega.field_mega_menu_content as [row!1!id], langcode as [row!1!langcode], df.BODYFIELD as [row!1!body!CDATA], 'Megamenu: '+ mega.computed_path as [row!1!info!Element]
from CONTENTSTATUS c inner join 
(select  field_mega_menu_content, langcode, computed_path from qtp.dbo.endceg where field_mega_menu_content is not null
) mega on mega.field_mega_menu_content = c.CONTENTID 
inner join CT_GLORAWHTML df on df.CONTENTID = c.contentid and df.REVISIONID = c.public_revision
for xml explicit , root('rows')

-------------


IF OBJECT_ID('tempdb..#enpage') IS NOT NULL drop table #enpage
select 
t.CONTENTTYPENAME
, dp.[SiteSection TermID] as term_id--en.term_id 
, c.CONTENTID as id, p.SHORT_TITLE  as title
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
, p.BROWSER_TITLE as field_browser_title
,p.card_title as field_card_title
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
and CONTENTTYPENAME not in ( 'genExternalLink',  'cgvDynamicList')
and CONTENTTYPENAME not like 'pdq%'
and CONTENTTYPENAME not like '%image%'
and CONTENTTYPENAME not like 'rffNav%'


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
IF OBJECT_ID('tempdb..#externallink') IS NOT NULL  drop table #externallink

select r.dependent_id, r.RID as externallink_id
, l.URL as field_external_link_uri
, en.langcode
into #externallink 
from #enpage en inner join CONTENTSTATUS c on c.CONTENTID = en.id
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


---!!!inline content block?

select 'contentblock'
select 
1 as tag
, 0 as parent
, *
from #contentblock
for xml explicit, root('rows')



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
    NULL AS 'row!2!content!CDATA'
UNION ALL
SELECT
    2 AS Tag,
    1 AS Parent,
    NULL, 
    para_id,
     content
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
select * from (
select 
distinct
1 as tag
, 0 as parent
,i.imageid as [row!1!id]
,'en' as [row!1!langcode!Element]
, i.title as [row!1!name!Element]
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME,  u.img_utility_filename) as [row!1!field_media_image!Element]
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
, 'https://www.cancer.gov/PublishedContent/Images' + substring(dbo.gaogetitemFolderPath(c.contentid,''),10,999) + '/'+  coalesce(gi.IMG3_FILENAME, si.IMG1_FILENAME, gi.img4_FILENAME) as [row!1!field_media_image!Element]
, i.field_accessible_version as [row!1!field_accessible_version!Element]
, i.field_caption as [row!1!field_caption!CDATA]
, i.field_display_enlarge as [row!1!field_display_enlarge!Element]
, i.field_credit as [row!1!field_credit!Element]
 from 
(select * from #contextual_image where langcode = 'es' ) i 
inner join CONTENTSTATUS c on i.imageid = c.contentid 
left outer join RXS_CT_SHAREDIMAGE si on si.CONTENTID = c.CONTENTID and si.REVISIONID = c.public_revision
left outer join CT_genimage gi on gi.CONTENTID = c.CONTENTID and gi.REVISIONID = c.public_revision
) a
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
,pr.ORGANIZATION
,pr.SUBDIVISION
, case when pr.ADDRESS1 like '%shady%' OR pr.ADDRESS1 like '%9609%' then 300 else 301 end
, pr.ADDRESS2
from #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_GENBIOGRAPHY pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
) a
on (a.tag = d.Tag and a.parent = d.Parent and a.tag =1) or (a.tag = 2 and a.id = d.[row!2!id])
order by d.tag
for xml explicit




select  pr.ADDRESS1, COUNT(*)
from #enpage p 
inner join CONTENTSTATUS c on p.id = c.CONTENTID 
inner join CT_GENBIOGRAPHY pr on pr.CONTENTID = c.CONTENTID and pr.REVISIONID = c.CURRENTREVISION
where ADDRESS1 is not null
group by pr.ADDRESS1
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
, pr.END_DATE
,pr.START_DATE
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
select 'blogpost'
select d.* 
, [row!2!field_blog_topics!Element]
, [row!2!body!CDATA] 
--, [row!2!author] 
,  [row!2!field_blog_series]
from #enpagedata d 
inner join 
(select 
1 as Tag
,0 as Parent
,NULL AS id
, NULL as [row!2!body!CDATA] 
--,NULL as [row!2!author] 
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
, 500
,
(select case id when 'linkage Newsletter' then 502 when 'research highlights' then 501 when 'people in the news' then 503 when 'Fellowships &amp; Training' then 504 end as id  from 
(select qdp.[Blog Tag (cgv_blog_post only)] as id
from qtp.dbo.dcegpage qdp 
where qdp.contentid = p.ID and qdp.[Blog Tag (cgv_blog_post only)] is not null 
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


--cgov file 
select 'file'
select 
 ep.*
, 'https://dceg.cancer.gov/publishedcontent/Files' + substring(dbo.gaogetitemFolderPath([row!2!id] , ''), 10,999) + '/' 
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




select dp.[Drupal CONTENTTYPENAME], COUNT(*) from qtp.dbo.dcegpage dp
group by dp.[Drupal CONTENTTYPENAME]



--------------

-----------
----------------



select computed_path, p.contentid, p.[Drupal CONTENTTYPENAME]
from qtp.dbo.endceg e left outer join qtp.dbo.dcegpage p on e.field_landing_page = p.contentid 
order by computed_path






select c.CONTENTID, c.TITLE , dbo.gaogetitemFolderPath(c.contentid, '')  as url 
, c1.TITLE as listitle 
from CONTENTSTATUS c inner join PSX_OBJECTRELATIONSHIP r on c.CONTENTID = r.OWNER_ID and c.PUBLIC_REVISION = r.OWNER_REVISION
inner join RXSLOTTYPE sl on sl.SLOTID = r.SLOT_ID
inner join CONTENTSTATUS c1 on c1.CONTENTID = r.DEPENDENT_ID
inner join CT_GENList l on l.CONTENTID = c1.CONTENTID and l.REVISIONID = c1.PUBLIC_REVISION
where c.CONTENTID in (select contentid from qtp.dbo.dcegpage p where p.[Drupal CONTENTTYPENAME] = 'cgov_mini_landing_page')
and sl.SLOTNAME like 'sys%'





drop table #folder
;with folders as (
					  select null as ParentID, f.ContentID as ID, cs.title as FolderName, 
					convert(varchar(512),'') as Path
					  from PSX_folder f join contentstatus cs on f.contentid = cs.contentid
					  where cs.contentid = 301465
					  UNION ALL
					  select r.owner_ID as ParentID, f.contentid as ID, cs.title as FolderName, 
					convert(varchar(512),folders.Path + '/' + cs.title) as Path
					  from PSX_folder f inner JOIN PSX_ObjectRelationship r  ON r.dependent_id = f.contentid
					  inner JOIN folders ON folders.ID = r.owner_id
					  inner join contentstatus cs on f.contentid = cs.contentid
				)
				
select * into #folder from folders

update #folder set FolderName = '' where ParentID is null



select   
case when f.Path = '' then '/' else f.Path end as computed_path,
coalesce(n.NAV_TITLE, landing.short_title, f.FolderName) as name 
,c.CONTENTID as term_id
, isnull(rp.DEPENDENT_ID, 0) as parent
, f.FolderName as field_pretty_url
, case when sectionNav.TITLE IS NOT null then 1 else 0 END AS field_section_nav_root
, case f.path when '' then 1 else 0 end as field_main_nav_root
, case  n.SHOW_IN_NAV when 1 then NULL else 'hide_in_section_nav' END as field_navigation_display_options
, landing.contentid      as field_landing_page
, landing.SHORT_TITLE as description_value
, Null as field_navigation_label	
, sectionNav.LEVELS as field_levels_to_display
,m.bodyfield as field_mega_menu_content
, case f.path when '' then 1 else 0 end as field_breadcrumb_root
into #en
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		left outer join 
		(PSX_OBJECTRELATIONSHIP rp 
		inner join CONTENTSTATUS cpn on cpn.CONTENTID = rp.DEPENDENT_ID 
		inner join CONTENTTYPES tpn on tpn.CONTENTTYPEID = cpn.CONTENTTYPEID and tpn.CONTENTTYPENAME in ('rffNavon', 'rffNavtree') )
		 on rp.OWNER_ID = f.ParentID and rp.CONFIG_ID = 3
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CGVNAVMETADATA_CGVNAVMETADATA n on n.contentid = c.contentid and n.REVISIONID = c.CURRENTREVISION 
		 outer apply 
		 (select pl.short_title, pl.contentid 
		 from contentstatus cl 
				inner join GENPAGEMETADATA_GENPAGEMETADATA1 pl on pl.contentid = cl.contentid and pl.revisionid = cl.currentrevision
				inner join PSX_OBJECTRELATIONSHIP rl on rl.DEPENDENT_ID = cl.CONTENTID 
				inner join STATES sl on sl.STATEID = cl.CONTENTSTATEID and sl.WORKFLOWAPPID = cl.WORKFLOWAPPID
		where rl.owner_id = f.id and pl.pretty_url_name is null  and sl.STATENAME not like '%archiv%') landing
		outer apply 
			(select substring(c1.title,1, charindex( '[', c1.title)-1) as title , sn.LEVELS
			from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join (select * FROM CT_genSECTIONNAV  union all select * from CT_GENMAINNAV)  sn on sn.CONTENTID = c1.CONTENTID and sn.REVISIONID = c1.CURRENTREVISION
			where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME in ( 'genSlotSectionNav', 'genSlotSectionNavRootNavon' )) sectionNav
			outer apply (select  h.BODYFIELD from PSX_OBJECTRELATIONSHIP r1 
		 inner join RXSLOTTYPE st on st.SLOTID = r1.SLOT_ID
		 inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		 inner join CT_GLORAWHTML h on h.CONTENTID = r1.DEPENDENT_ID and c1.CURRENTREVISION = h.REVISIONID 
		where r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
			and st.SLOTNAME = 'nvcgSlMegamenuHtml' ) m
where t.CONTENTTYPENAME in ( 'rffNavon', 'rffNavtree')
and f.Path not like '/configuration%'
and f.Path not like '/private%'
and f.Path not like '/shareditem%'
and f.Path not like '/image%'
and f.Path not like '/file%'
order by 1




select * from ct_gensectionnav
SELECT * from CT_GENMAINNAV


select * from contenttypes where contenttypename like '%sectionnav%'   '%bread%'
select * from rxslottype where slotname like '%sectionnav%' 
select * from rxslottype where slotname like '%mega%' 


select dbo.gaogetitemfolderpath(c.CONTENTID, '') 
from CONTENTSTATUS c inner join CONTENTTYPES t on c.CONTENTTYPEID = t.CONTENTTYPEID 
where t.CONTENTTYPENAME = 'gensectionnav'

select dbo.gaogetitemfolderpath(c.CONTENTID, '') 
from CONTENTSTATUS c inner join CONTENTTYPES t on c.CONTENTTYPEID = t.CONTENTTYPEID 
where t.CONTENTTYPENAME = 'genmainnav'









select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
, a.AUTHORS

, p.SUBHEADER
, a.FEATURED_ARTICLE
, p.NAV_LABEL

, IMG2_EXT
,IMG2_FILENAME
,IMG2_HEIGHT
,IMG2_SIZE
,IMG2_TYPE
,IMG2_WIDTH
, d.DATE_DISPLAY_MODE
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CT_GENNEWSLETTERARTICLE a on a.CONTENTID = c.CONTENTID and a.REVISIONID = c.CURRENTREVISION
		inner join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		left outer join GENDATEDISPLAYMODE_GENDATEDISPLAYMODE d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join RXS_CT_SHAREDIMAGE i on i.CONTENTID = c.CONTENTID and i.REVISIONID = c.CURRENTREVISION
where contenttypename = 'gennewsletterarticle'





select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
, p.SUBHEADER
, p.NAV_LABEL
,p.SOURCE
, p.LINK_TO_SOURCE
, i.SORT_DATE
, d.DATE_DISPLAY_MODE
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CT_GENGENERAL a on a.CONTENTID = c.CONTENTID and a.REVISIONID = c.CURRENTREVISION
		inner join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		left outer join GENDATEDISPLAYMODE_GENDATEDISPLAYMODE d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join GENQUERYSET_GENQUERYSET i on i.CONTENTID = c.CONTENTID and i.REVISIONID = c.CURRENTREVISION
where contenttypename = 'genGeneral'





select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
, sl.SLOTNAME 
, t1.CONTENTTYPENAME 
, c1.TITLE 
from dbo.contentstatus c 		
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		left outer join ( PSX_OBJECTRELATIONSHIP r1 inner join RXSLOTTYPE sl on r1.SLOT_ID = sl.slotid
		inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID  ) 
		on r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
where t.contenttypename = 'genGeneral' and SLOTNAME not like 'sys%' and SLOTNAME <> 'genSlotRelatedPages'




select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
, sl.SLOTNAME 
, t1.CONTENTTYPENAME 
, c1.TITLE 
from dbo.contentstatus c 		
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		left outer join ( PSX_OBJECTRELATIONSHIP r1 inner join RXSLOTTYPE sl on r1.SLOT_ID = sl.slotid
		inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.DEPENDENT_ID
		inner join CONTENTTYPES t1 on t1.CONTENTTYPEID = c1.CONTENTTYPEID  ) 
		on r1.OWNER_ID = c.CONTENTID and r1.OWNER_REVISION = c.CURRENTREVISION
where t.contenttypename = 'genNews' and SLOTNAME not like 'sys%' and SLOTNAME <> 'genSlotRelatedPages'




select * from CONTENTTYPES where CONTENTTYPENAME like 'gennews%'

select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
, p.SUBHEADER
, p.NAV_LABEL
,p.SOURCE
, p.LINK_TO_SOURCE
, i.SORT_DATE
, d.DATE_DISPLAY_MODE
, a.EMBARGO_TEXT
, a.CONTACT_TEXT
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CT_GENnewsrelease a on a.CONTENTID = c.CONTENTID and a.REVISIONID = c.CURRENTREVISION
		inner join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
		left outer join GENDATEDISPLAYMODE_GENDATEDISPLAYMODE d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
		left outer join GENQUERYSET_GENQUERYSET i on i.CONTENTID = c.CONTENTID and i.REVISIONID = c.CURRENTREVISION
where contenttypename = 'genNews' and CONTACT_TEXT is not null






select distinct table_name
, column_name from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME like '%embargo%' and TABLE_NAME not like '%TCGA%'





select distinct  c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + coalesce (dbo.gaogetGenpretty_url_name(c.contentid), '/'+ dbo.percreport_getpretty_url_name(c.contentid), '')  as url
, CONTENTTYPENAME
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join PSX_CONTENTTYPE_TEMPLATE tt on tt.CONTENTTYPEID = c.contenttypeid 
		inner join psx_template pt on pt.TEMPLATE_ID = tt.TEMPLATE_ID
where pt.OUTPUTFORMAT = 1
and contenttypename not like 'rff%'
and contenttypename not like '%image'
and contenttypename not like '%config%'
and contenttypename <> 'genExternalLink'
order by contenttypename , 4


drop table #page
select distinct  c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + coalesce (dbo.gaogetGenpretty_url_name(c.contentid), '/'+ dbo.percreport_getpretty_url_name(c.contentid), '')  as url
, CONTENTTYPENAME
into #page
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join PSX_CONTENTTYPE_TEMPLATE tt on tt.CONTENTTYPEID = c.contenttypeid 
		inner join psx_template pt on pt.TEMPLATE_ID = tt.TEMPLATE_ID
where pt.OUTPUTFORMAT = 1
and contenttypename not like 'rff%'
and contenttypename not like '%image'
and contenttypename not like '%config%'
and contenttypename <> 'genExternalLink'



select p.CONTENTID, p.CONTENTTYPENAME, p.STATENAME 
, 'dceg.cancer.gov' + p.folder + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
, d.DATE_FIRST_PUBLISHED, d.DATE_LAST_MODIFIED, d.DATE_LAST_REVIEWED
from #page p inner join CONTENTSTATUS c on c.CONTENTID = p.CONTENTID
inner join GENDATESSET_GENDATESSET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
where STATENAME not like '%archive%'
order by 1



select p.CONTENTID, p.CONTENTTYPENAME, p.STATENAME 
, 'dceg.cancer.gov' + p.folder + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
,  (select max(sh.EVENTTIME) from CONTENTSTATUSHISTORY sh where  sh.CONTENTID = c.CONTENTID ) 
from #page p inner join CONTENTSTATUS c on c.CONTENTID = p.CONTENTID
where STATENAME not like '%archive%'
order by 1

select * from CONTENTSTATUShistory where CONTENTID = 1140727

select distinct  c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
into #navon
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
where contenttypename = 'rffnavon'



select p.*, c1.contentid as childID, t1.contenttypename as childtype, c1.CURRENTREVISION
into #lb
from #page p inner join contentstatus c on p.contentid = c.contentid 
inner join PSX_OBJECTRELATIONSHIP r on r.OWNER_ID = c.contentid and r.OWNER_REVISION = c.CURRENTREVISION
inner join contentstatus c1 on c1.contentid = r.DEPENDENT_ID 
inner join contenttypes t1 on t1.contenttypeid = c1.contenttypeid 
where t1.contenttypename in ('genlist', 'genContentBlock')




select p.*
--, s.slotname , po.CONTENTTYPENAME, sn.slotname
into #unused
from #page p
left outer join ( PSX_OBJECTRELATIONSHIP r inner join contentstatus c on r.OWNER_ID = c.contentid and r.OWNER_REVISION = c.CURRENTREVISION
					inner join #page po on po.contentid = c.contentid
					inner join RXSLOTTYPE s on s.slotid = r.SLOT_ID )  on p.contentid = r.DEPENDENT_ID

left outer join 
( #navon n inner join contentstatus cn on n.contentid = cn.contentid inner join PSX_OBJECTRELATIONSHIP rn on rn.OWNER_ID = cn.contentid and rn.OWNER_REVISION = cn.CURRENTREVISION
			inner join RXSLOTTYPE sn on sn.SLOTID = rn.SLOT_ID) on  p.contentid = rn.DEPENDENT_ID


where r.rid is null and rn.rid is null 
order by contenttypename 




select contenttypename, count(*) from #page
where contenttypename not in 
(select t.contenttypename
from RXCONTENTTYPECOMMUNITY cm inner join contenttypes t on t.contenttypeid = cm.CONTENTTYPEID inner join RXCOMMUNITY m on m.COMMUNITYID = cm.COMMUNITYID
where m.name like 'cancer%'
)
group by contenttypename 



select t.contenttypename, m.NAME
from RXCONTENTTYPECOMMUNITY cm inner join contenttypes t on t.contenttypeid = cm.CONTENTTYPEID inner join RXCOMMUNITY m on m.COMMUNITYID = cm.COMMUNITYID
where m.name like 'cancer%'



select distinct u.*
from #unused u inner join PSX_OBJECTRELATIONSHIP r1 on r1.DEPENDENT_ID = u.CONTENTID inner join #lb lb on lb.childid = r1.OWNER_ID  and lb.CURRENTREVISION = r1.OWNER_REVISION
order by contenttypename , contentid 



select  u.*, lb.childID as List_contentBlockID , lb.childtype as list_contentblock , lb.contentid as parentID, lb.url as parentURL, lb.contenttypename as parentContenttype
from #unused u inner join PSX_OBJECTRELATIONSHIP r1 on r1.DEPENDENT_ID = u.CONTENTID inner join #lb lb on lb.childid = r1.OWNER_ID  and lb.CURRENTREVISION = r1.OWNER_REVISION
order by u.contenttypename , u.contentid 






select p.*
--, s.slotname , po.CONTENTTYPENAME, sn.slotname
from #page p
left outer join ( PSX_OBJECTRELATIONSHIP r inner join contentstatus c on r.OWNER_ID = c.contentid and r.OWNER_REVISION = c.CURRENTREVISION
					inner join #page po on po.contentid = c.contentid
					inner join RXSLOTTYPE s on s.slotid = r.SLOT_ID )  on p.contentid = r.DEPENDENT_ID

left outer join 
( #navon n inner join contentstatus cn on n.contentid = cn.contentid inner join PSX_OBJECTRELATIONSHIP rn on rn.OWNER_ID = cn.contentid and rn.OWNER_REVISION = cn.CURRENTREVISION
			inner join RXSLOTTYPE sn on sn.SLOTID = rn.SLOT_ID) on  p.contentid = rn.DEPENDENT_ID



left outer join ( #lb lb inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = lb.childID and r1.OWNER_REVISION = lb.CURRENTREVISION ) on r1.dependent_id = p.contentid 


where r.rid is null and rn.rid is null and r1.rid is null
order by contenttypename 








select p.*
--, s.slotname , po.CONTENTTYPENAME, sn.slotname
from #page p
left outer join ( PSX_OBJECTRELATIONSHIP r inner join contentstatus c on r.OWNER_ID = c.contentid and r.OWNER_REVISION = c.CURRENTREVISION
					inner join #page po on po.contentid = c.contentid
					inner join RXSLOTTYPE s on s.slotid = r.SLOT_ID )  on p.contentid = r.DEPENDENT_ID

left outer join 
( #navon n inner join contentstatus cn on n.contentid = cn.contentid inner join PSX_OBJECTRELATIONSHIP rn on rn.OWNER_ID = cn.contentid and rn.OWNER_REVISION = cn.CURRENTREVISION
			inner join RXSLOTTYPE sn on sn.SLOTID = rn.SLOT_ID) on  p.contentid = rn.DEPENDENT_ID

where r.rid is not null and rn.rid is not null 
order by contenttypename 




select distinct  c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '')  as url
, contenttypename 
, sl.SLOTNAME
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
	left outer join ( PSX_OBJECTRELATIONSHIP r1 inner join contentstatus c1 on c1.contentid = r1.OWNER_ID  and c1.CURRENTREVISION = R1.OWNER_REVISION
								inner join RXSLOTTYPE sl on sl.SLOTID = r1.SLOT_ID
				) ON R1.DEPENDENT_ID = c.contentid 
where contenttypename like '%image%'
and sl.SLOTNAME is null





select * from #page where contenttypename like '%agg%'





--------------------
select  c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + isnull(dbo.gaogetGenpretty_url_name(c.contentid), '') as url
, CONTENTTYPENAME
,pt.name 
, pt.OUTPUTFORMAT
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join dbo.GENPAGEMETADATA_GENPAGEMETADATA1 p on p.contentid = c.contentid 	and p.revisionid = c.currentrevision
		inner join PSX_CONTENTTYPE_TEMPLATE tt on tt.CONTENTTYPEID = c.contenttypeid 
		inner join psx_template pt on pt.TEMPLATE_ID = tt.TEMPLATE_ID
where pt.OUTPUTFORMAT = 1




select * from psx_template






---------------



select c.LOCALE as sys_lang, 'site' as community, 'cgvTopicPage' as contenttype
, gp.SHORT_TITLE, gp.BROWSER_TITLE, c.TITLE
, gp.LONG_DESCRIPTION, gp.SHORT_DESCRIPTION
, gp.META_DESCRIPTION, gp.META_KEYWORDS
, b.BODYFIELD
from #page p inner join contentstatus c on c.contentid = p.CONTENTID 
inner join GENPAGEMETADATA_GENPAGEMETADATA1 gp on gp.CONTENTID = c.contentid and gp.REVISIONID = c.CURRENTREVISION
inner join CT_GENLANDING b  on b.CONTENTID = c.contentid and b.REVISIONID = c.CURRENTREVISION
where c.contentid = 302378

select * from INFORMATION_SCHEMA.columns where COLUMN_NAME like 'body%'


select contenttypename, count(*) from #page
group by contenttypename


select t.CONTENTTYPENAME, m.NAME
from RXCONTENTTYPECOMMUNITY cc inner join contenttypes t on cc.CONTENTTYPEID = t.contenttypeid 
inner join RXCOMMUNITY m on m.COMMUNITYID = cc.COMMUNITYID
where contenttypename = 'genLanding'



select t.CONTENTTYPENAME, m.NAME
from RXCONTENTTYPECOMMUNITY cc inner join contenttypes t on cc.CONTENTTYPEID = t.contenttypeid 
inner join RXCOMMUNITY m on m.COMMUNITYID = cc.COMMUNITYID
where m.name = 'cancergov' 
order by 1 



select distinct  c.contentid
, c.title
, s.STATENAME
, f.path as folder
--, 'dceg.cancer.gov' + f.path + coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '')  as url
, t.contenttypename 
--, sl.slotname 
--, t1.contenttypename 
, b.IMG1_FILENAME, b.IMG1_HEIGHT, b.IMG1_WIDTH , b.IMG1_SIZE
, b.IMG2_FILENAME, b.IMG2_HEIGHT, b.IMG2_WIDTH, b.IMG2_SIZE
, n.IMG3_FILENAME, n.IMG3_HEIGHT, n.IMG3_WIDTH, n.IMG3_SIZE
, n.IMG4_FILENAME, n.IMG4_HEIGHT, n.IMG4_WIDTH, n.IMG4_SIZE
, n.IMG5_FILENAME, n.IMG5_HEIGHT, n.IMG5_WIDTH, n.IMG5_SIZE
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join RXS_CT_SHAREDIMAGE b on b.contentid = c.contentid and b.REVISIONID = c.CURRENTREVISION
		left outer join CT_GENIMAGE n on n.contentid = c.contentid and n.REVISIONID = c.CURRENTREVISION
		inner join PSX_OBJECTRELATIONSHIP r1 on r1.DEPENDENT_ID = c.contentid 
		inner join contentstatus c1 on c1.contentid = r1.OWNER_ID and c1.CURRENTREVISION = r1.OWNER_REVISION
		inner join contenttypes t1 on t1.contenttypeid = c1.contenttypeid 
		inner join RXSLOTTYPE sl on sl.slotid = r1.SLOT_ID
where t.contenttypename like '%image%'



select c.contentid , s.statename, f.Path,  'dceg.cancer.gov' + b.PROMO_URL as secondaryURL, dbo.gaogetitemFolderPath( r1.DEPENDENT_ID,'DCEG') + isnull('/' + dbo.gaogetGenpretty_url_name(r1.DEPENDENT_ID),'') as targetedURL
from dbo.contentstatus c 		
		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join CT_genSecondaryURL b on b.contentid = c.contentid and b.REVISIONID = c.CURRENTREVISION
		inner join PSX_OBJECTRELATIONSHIP r1 on r1.OWNER_ID = c.contentid and r1.OWNER_REVISION = c.CURRENTREVISION
where contenttypename =  'genSecondaryURL'





select contentid into #t from CONTENTSTATUS where CONTENTID in 
(419167,
302493,
419391,
302667,
623824,
302647,
302574,
419390,
537075,
409963,
349598,
352611,
349991,
491841,
491842,
491844,
491845,
491846,
491850,
491851,
491852,
491853,
491854,
491855,
491856,
491857,
491858,
491859,
492042,
492043,
492044,
492045,
492046,
492047,
492048,
492049,
492050,
492051,
492052,
492055,
492057,
492058,
492059,
492060,
492077,
492079,
492080,
492081,
492082,
492083,
492084,
492085,
492086,
492087,
492088,
492089,
492090,
492091,
492092,
492093,
492094,
492095,
492096,
492097,
492100,
492099,
492101,
492102,
492103,
492104,
492115,
492138,
492139,
492140,
492141,
492164,
492175,
492176,
492177,
492178,
492179,
492180,
492187,
492198,
492205,
491527,
491486,
491581,
491487,
491488,
491489,
491490,
491491,
491492,
491495,
491496,
491497,
491498,
491500,
491501,
491502,
491507,
491523,
491524,
491525,
491526,
491528,
491529,
491530,
491531,
491532,
491533,
491534,
491535,
491536,
491545,
491557,
491558,
491816,
491817,
491818,
491819,
491820,
491821,
491822,
491823,
491824,
491825,
491826,
491827,
491828,
491830,
491627,
491607,
491614,
491622,
491623,
491625,
491624,
491626,
491628,
491629,
491631,
491630,
491632,
491633,
491634,
491635,
491636,
491637,
491638,
491639,
491641,
491640,
491643,
491642,
491648,
491702,
491661,
491681,
491703,
491704,
491715,
491731,
491749,
491764,
491765,
498227,
498226,
491763,
498228,
491766,
491767,
491768,
491769,
491770,
491771,
491772,
491774,
491775,
491773,
491776,
491777,
491778,
491779,
491780,
491781,
491782,
491783,
491784,
491785,
491787,
491786,
491789,
491788,
491790,
491791,
491792,
491793,
491794,
491795,
491797,
491796,
491798,
491800,
491799,
491801,
491833,
491837,
491838,
491839,
491840,
349527,
395035,
395020,
351538,
395042,
395039,
395038,
395036,
394987,
351535,
351534,
351537,
394657,
394702,
394787,
394842,
302458,
351386,
545133,
551628,
545311,
545312,
517683,
506204,
520875,
544734,
547324,
544733,
527708,
551626,
543005,
555416,
565387,
574512,
636666,
636668,
636729,
636669,
545064,
551629,
610992,
545171,
584965,
586651,
636674,
636675,
636681,
636682,
681755,
572426,
642368,
657106,
642720,
656543,
681756,
702036,
702042,
649591,
650105,
702987,
703154,
822464,
819479,
834303,
716880,
649588,
798138,
759629,
681860,
658286,
705406,
650104,
702847,
642717,
649561,
649589,
762589,
819309,
832330,
815054,
828698,
765083,
746339,
760147,
832782,
832779,
832783,
705292,
833034,
832775,
798137,
832814,
832778,
838460,
832780,
821961,
702848,
789451,
972293,
541648,
449498,
409842,
406174,
406261,
406238,
406263,
406262,
406043,
404397,
404400,
404401,
404402,
404398,
409899,
409900,
409901,
403055,
405990,
403056,
404378,
404403,
409838,
408208,
408595,
409840,
409837,
408294,
408406,
406268,
408512,
409839,
409836,
409834,
401807,
401806,
401812,
401811,
401813,
401817,
401823,
401822,
401824,
401810,
401833,
401839,
401831,
401834,
401836,
401847,
401849,
401846,
401848,
401843,
401844,
401840,
401841,
401845,
401842,
401850,
375662,
375664,
375660,
375663,
375661,
375651,
375654,
375655,
375656,
375659,
375658,
375657,
409902,
409903,
409920,
375646,
375468,
375470,
375430,
375417,
375322,
375428,
375332,
375393,
386910,
1108353,
1102278,
417796,
416989,
416987,
416986,
412666,
428422,
433546,
433858,
433859,
428498,
392824,
1036082,
303729,
351391,
463355,
550799,
463271,
463213,
463354,
463215,
463353,
463389,
463214,
463272,
463179,
463178,
463212,
463248,
303553,
303563,
707777,
303572,
303574,
303609,
303598,
464416,
366149,
336213,
303714,
303715,
302486,
473488,
302658,
303487,
303766,
303767,
303769,
303670,
303667,
303689,
303695,
302560,
302583,
302439,
302645,
303737,
760553,
351390,
594072,
594141,
594140,
809937,
809936,
810261,
810262,
867965,
867964,
594138,
594142,
594139,
1036920,
1036919,
303031,
303011,
1036913,
303010,
1041854,
1041855,
1041773,
303030,
303052,
303053,
753544,
702832,
570440,
569617,
611668,
569623,
702840,
569239,
766361,
569620,
569618,
569619,
702742,
611655,
702834,
570826,
570737,
569621,
570694,
570641,
570770,
570845,
570730,
702838,
569622,
570608,
702839,
702835,
702692,
702836,
434006,
434008,
434004,
433861,
433864,
433866,
433860,
434003,
433862,
433865,
434005,
433863,
302435,
302435,
302435,
302435,
302449,
302449,
302491,
302491,
302491,
302500,
302500,
302559,
302559,
302625,
302625,
302625,
303875,
303875,
386808,
449498,
449498,
449498,
449498,
449498,
449498,
449498)


select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, 'dceg.cancer.gov' + f.path + 
coalesce (dbo.gaogetGenpretty_url_name(c.contentid), dbo.percreport_getpretty_url_name(c.contentid), '') 
as url
, t.CONTENTTYPENAME 
, d.DATE_FIRST_PUBLISHED
, d.DATE_LAST_MODIFIED
from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
inner join GENDATESSET_GENDATESSET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION
where c.CONTENTID not in (select CONTENTID from #t)




select contentid into #n from CONTENTSTATUS where CONTENTID in (434453,
434452,
1033211,
1033210,
457474,
491834,
301550,
303249,
301551,
379607,
301553,
301554,
301555,
301556,
303144,
301557,
301558,
301559,
301560,
301561,
301562,
301563,
301564,
338035,
440846,
1073889,
409865,
301565,
301566,
301567,
349899,
696199,
303394,
303273,
303015,
303274,
1097928,
335238,
660911,
760805,
953353,
1071689,
1072696,
1074268,
1104884,
847598,
951684,
1051191,
1081701,
1087278,
1088673,
1098082,
815056,
815056,
815056,
815056,
815056,
815056,
815056,
815056,
1088961,
1088962,
1099905,
1099751,
815056,
815056,
815056,
1118975,
1109230,
1109225,
1118939,
815056,
1031953,
550802,
608569)











select   c.contentid
, c.title
, s.STATENAME
, f.path as folder
, t.CONTENTTYPENAME 

, c1.CONTENTID as parentid 
, t1.CONTENTTYPENAME as parentType
, st.SLOTNAME 
, dbo.gaogetitemFolderPath(c1.contentid, '') + ISNULL('/' + dbo.percreport_getPretty_url_name(c1.contentid),'') as parenturl 

from dbo.contentstatus c 		
inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		
left outer join (PSX_OBJECTRELATIONSHIP r1 
inner join CONTENTSTATUS c1 on c1.CONTENTID = r1.owner_id and c1.CURRENTREVISION = r1.OWNER_REVISION
inner join RXSLOTTYPE st on st.slotid = r1.SLOT_ID
inner join CONTENTTYPES t1 on t1.CONTENTTYPEID  = c1.CONTENTTYPEID ) 
  on r1.DEPENDENT_ID = c.CONTENTID 
where c.CONTENTID in (303513,
303514)



c.CONTENTID not in (select CONTENTID from #n)
and c.CONTENTID not in (select CONTENTID from #t1)
and t.CONTENTTYPENAME not like 'rff%' and t.CONTENTTYPENAME <> 'genSecondaryURL'
order by c.CONTENTID 


select distinct  c.contentid
into #t1

from dbo.contentstatus c 		inner join PSX_ObjectRelationship r  ON r.dependent_id = c.contentid
		inner join #folder f on f.id = r.owner_id
		inner join contenttypes t on t.contenttypeid = c.contenttypeid
		inner join states s on s.stateid = c.contentstateid and s.workflowappid = c.workflowappid
		inner join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION