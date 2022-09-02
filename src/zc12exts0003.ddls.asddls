@AbapCatalog.sqlViewAppendName: 'ZC122EXT0003_V'
@EndUserText.label: '[C1] Fake Standard Table Extend'
extend view ZC122CDS0003 with ZC12EXTS0003 
{
    ztsa2204.zzsaknr,
    ztsa2204.zzkostl,
    ztsa2204.zzshkzg,
    ztsa2204.zzlgort
}
