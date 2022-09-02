@AbapCatalog.sqlViewName: 'ZC122CDS0001_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Airline Flight CDS View'
define view ZC122CDS0001 as select from scarr
inner join sflight
        on scarr.mandt = sflight.mandt
       and scarr.carrid = sflight.carrid
{
     key scarr.carrid, 
     key scarr.carrname,
     key sflight.connid,
     sflight.fldate,
     sflight.paymentsum,
     scarr.currcode,
     sflight.price,
     sflight.planetype
    
}
