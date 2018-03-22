defaults = ['nama', 'alamat', 'bentuk', 'kondisi']
@fasilitas =
	pendidikan: ['jumlah siswa', 'jumlah guru', 'jumlah kelas']
	pariwisata: ['jumlah kunjungan', 'jarak pekanbaru']
	kesehatan: ['jumlah pasien', 'jumlah dokter', 'jumlah kapasitas']
	industri: ['jumlah produksi']
	kominfo: ['luas cakupan']
	sosial: ['jumlah penghuni']
	perhubungan: ['jumlah trafik']
	pora: ['jumlah kegiatan']
	kebudayaan: ['jumlah kegiatan']
	agama: ['jumlah kegiatan']

_.map (_.keys fasilitas), (i) ->
	fasilitas[i] = [defaults..., fasilitas[i]...]

makeOpts = (arr) -> _.map arr, (i) -> value: i, label: _.startCase i

@selects =
	pendidikan:
		bentuk: makeOpts ['sd', 'smp', 'sma', 'smk']
	kesehatan:
		bentuk: makeOpts ['rsud prov', 'rsud kab', 'puskesmas', 'pustu']
	pariwisata:
		bentuk: makeOpts ['alam', 'buatan', 'religi', 'destinasi']
	kondisi: makeOpts ['baik', 'rusak ringan', 'rusak sedang', 'rusak berat']
