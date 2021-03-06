defaults = <[ nama alamat bentuk kondisi ]>
@fasilitas =
	pendidikan: ['baik', 'rusak ringan', 'rusak sedang', 'rusak berat', 'jumlah siswa', 'jumlah guru']
	pariwisata: ['jumlah kunjungan', 'jarak pekanbaru']
	kesehatan: ['jumlah pasien', 'jumlah dokter', 'jumlah kapasitas']
	industri: ['jumlah produksi']
	kominfo: ['luas cakupan']
	sosial: ['jumlah penghuni']
	perhubungan: ['jumlah trafik']
	pora: ['jumlah kegiatan']
	kebudayaan: ['jumlah kegiatan']
	agama: ['jumlah kegiatan']

_.map fasilitas, (val, key) ->
	fasilitas[key] = [...defaults, ...fasilitas[key]]

makeOpts = (arr) -> _.map arr, -> value: it, label: _.startCase it

@selects =
	pendidikan:
		bentuk: makeOpts <[ sd smp sma smk ]>
	kesehatan:
		bentuk: makeOpts ['rsud prov', 'rsud kab', 'puskesmas', 'pustu']
	pariwisata:
		bentuk: makeOpts <[ alam buatan religi destinasi ]>
	kondisi: makeOpts ['baik', 'rusak ringan', 'rusak sedang', 'rusak berat']
