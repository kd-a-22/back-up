@AbapCatalog.sqlViewName: 'ZC122CDS0003_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Fake Standard Table'
define view ZC122CDS0003 as select from ztsa2204 
{
    bukrs,
    belnr,
    gjahr,
    buzei,
    bschl
}
