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
