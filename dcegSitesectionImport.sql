select * into qtp.dbo.endceg from qtp.dbo.sitesectiondceg1
insert into qtp.dbo.endceg
select '/' as computed_path,
'dceg',
cpn.contentid as  term_id,
Null as field_navigation_label,
Null as field_pretty_url ,
Null as parent ,
null field_section_nav_root,
1 as field_main_nav_root,
null as field_navigation_display_options,
null as hide_in_main_nav,
null as hide_in_mobile_nav,
302687 as field_landing_page,
null as description_value,
null as field_levels_to_display
from  PSX_folder f join contentstatus cs on f.contentid = cs.contentid 
left outer join 
		(PSX_OBJECTRELATIONSHIP rp 
		inner join CONTENTSTATUS cpn on cpn.CONTENTID = rp.DEPENDENT_ID 
		inner join CONTENTTYPES tpn on tpn.CONTENTTYPEID = cpn.CONTENTTYPEID and tpn.CONTENTTYPENAME in ('rffNavon', 'rffNavtree') )
		 on rp.OWNER_ID = cs.contentid and rp.CONFIG_ID = 3
where  cs.TITLE ='dceg'



select * from qtp.dbo.endceg where computed_path = '/'


select * from qtp.dbo.dcegpage where contentid = 302687






------------------
------------------
------------------
------------------







select column_name + ',' from qtp.INFORMATION_SCHEMA.COLUMNS where TABLE_NAME  = 'endceg'

select * from  PSX_folder f inner join contentstatus cs on f.contentid = cs.contentid 
inner join 
where  cs.TITLE ='dceg'

----- !!!!!! Success
select 
	(
	select field_navigation_display_options 
	from
	(
	select field_navigation_display_options,  computed_path
	from sitesectiondceg1
	where field_navigation_display_options is not null and computed_path = s.computed_path 
	union all
	select  hide_in_main_nav,  computed_path
	from sitesectiondceg1
	where hide_in_main_nav is not null and computed_path = s.computed_path 
	union all
	select  hide_in_mobile_nav,  computed_path
	from sitesectiondceg1
	where hide_in_mobile_nav is not null and computed_path = s.computed_path 
	)
	a
	FOR XML path (''), TYPE, ELEMENTS  
	) as field_navigation_display_options 
,lower(computed_path)
,lower(name),
term_id,
field_navigation_label,
field_pretty_url,
parent,
field_section_nav_root,
field_main_nav_root,
field_landing_page,
description_value,
field_levels_to_display
from sitesectiondceg1 s where term_id is not null
for xml path



select * from sitesectiondceg1  where computed_path = '/about/organization/arc'


update sitesectiondceg1 set field_navigation_label = null where field_navigation_label = 'null'
update sitesectiondceg1 set field_navigation_display_options = null where field_navigation_display_options = 'null'
update sitesectiondceg1 set hide_in_main_nav = null where hide_in_main_nav = 'null'
update sitesectiondceg1 set hide_in_mobile_nav = null where hide_in_mobile_nav = 'null'



select  column_name + '=' + 'nullif(' + column_name + ' , ''NULL'' ),'
from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'sitesectiondceg'


select COLUMN_NAME + ','
from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'sitesectiondceg1'

select * from sitesectiondceg


update sitesectiondceg set field_navigation_label = null where field_navigation_label = 'null'
update sitesectiondceg set field_navigation_display_options = null where field_navigation_display_options = 'null'
update sitesectiondceg set hide_in_main_nav = null where hide_in_main_nav = 'null'
update sitesectiondceg set hide_in_mobile_nav = null where hide_in_mobile_nav = 'null'


----!!! field_navigation_display_options  TODO
select computed_path,
name,
field_navigation_label,
field_pretty_url,
convert(int,term_id) as term_id,
convert(int,parent) as parent,
convert(int,field_section_nav_root) as field_section_nav_root,
convert(int,field_main_nav_root) as field_main_nav_root,
field_navigation_display_options,
hide_in_main_nav,
hide_in_mobile_nav,
convert(int,field_landing_page) as field_landing_page,
description_value,
convert(int,field_levels_to_display) as field_levels_to_display
from sitesectiondceg 
for xml path 


use percussion


select 
dbo.gaogetitemFolderPath(contentid, '') + ISNULL('/'+ dbo.percReport_getPretty_url_name(contentid), '') as url
, * 
from qtp.dbo.videos

------------------




select ',('+ convert(varchar(50),contentid) + ','''+ [Drupal CONTENTTYPENAME] +  ''')' from qtp.dbo.dcegpage
where [Drupal CONTENTTYPENAME] is not null




select ',('+ convert(varchar(50),contentid) + ','''+ contenttype +  ',' + convert(varchar(50),[sitesection termid])    +  ''')' ]
from qtp.dbo.dceg
where CONTENTTYPE is not null




use Percussion 

select t.CONTENTTYPENAME
, en.contentid  as  term_id 
, c.CONTENTID as id, p.LONG_TITLE as title
, left(c.locale,2) as langcode
, p.SHORT_TITLE as field_short_title
, coalesce( p.META_DESCRIPTION, p.long_description) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL then p.LONG_DESCRIPTION else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else null end as field_search_engine_restrictions
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, p.PRETTY_URL_NAME as field_pretty_url

select en.[drupal contenttypename], [sitesection termid] as term_id, c.CONTENTID as id,  left(c.title, charindex('[', c.title) -1) as title
, p.SHORT_TITLE as field_short_title
, coalesce( p.META_DESCRIPTION, p.long_description) as field_page_description
, p.SHORT_DESCRIPTION as field_feature_card_description
, case when convert(nvarchar(max),p.long_description) <> convert(nvarchar(max),p.META_DESCRIPTION) and p.META_DESCRIPTION IS NOT NULL then p.LONG_DESCRIPTION else null end as field_list_description
, case when  p.DO_NOT_INDEX = 1 then 'ExcludeSearch' else null end as field_search_engine_restrictions
, convert(date,d.DATE_FIRST_PUBLISHED) as field_date_posted
, convert(DATE, d.DATE_LAST_REVIEWED) as field_date_reviewed
, lower(p.PRETTY_URL_NAME) as field_pretty_url
from qtp.dbo.dcegpage en inner join CONTENTSTATUS c on en.contentid = c.CONTENTID 
inner join GENPAGEMETADATA_GENPAGEMETADATA1 p on p.CONTENTID = c.CONTENTID and p.REVISIONID = c.CURRENTREVISION
inner join GENDATESSET_GENDATESSET d on d.CONTENTID = c.CONTENTID and d.REVISIONID = c.CURRENTREVISION


