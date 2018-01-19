defaults = ['kelompok', 'nama', 'alamat', 'bentuk', 'kondisi']
@fasilitas =
	pendidikan: [defaults..., 'jumlah siswa', 'jumlah guru', 'jumlah kelas']
	pariwisata: [defaults..., 'jumlah kunjungan', 'jarak pekanbaru']
	kesehatan: [defaults..., 'jumlah pasien', 'jumlah dokter', 'jumlah kapasitas']
	industri: [defaults..., 'jumlah produksi']
	kominfo: [defaults..., 'luas cakupan']
	sosial: [defaults..., 'jumlah penghuni']
	perhubungan: [defaults..., 'jumlah trafik']
	pora: [defaults..., 'jumlah kegiatan']
	kebudayaan: [defaults..., 'jumlah kegiatan']
	agama: [defaults..., 'jumlah kegiatan']

