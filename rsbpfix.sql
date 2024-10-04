-- Tabel ayah
CREATE TABLE ayah (
    ayah_NIK CHAR(5) NOT NULL PRIMARY KEY,
    ayah_nama VARCHAR(100) NOT NULL,
    ayah_tglLahir DATE NOT NULL,
    jenis_kelamin CHAR(1) NOT NULL CHECK (jenis_kelamin IN ('L', 'P')) -- Laki-laki (L), Perempuan (P)
);

-- Tabel ibu
CREATE TABLE ibu (
    ibu_NIK CHAR(5) NOT NULL PRIMARY KEY,
    ibu_nama VARCHAR(100) NOT NULL,
    ibu_tglLahir DATE NOT NULL,
    jenis_kelamin CHAR(1) NOT NULL CHECK (jenis_kelamin IN ('L', 'P'))
);

-- Tabel nikah
CREATE TABLE nikah (
    kd_nikah CHAR(6) NOT NULL PRIMARY KEY,
    n_ayah_NIK CHAR(5),
    n_ibu_NIK CHAR(5),
    status_menikah VARCHAR(10) NOT NULL CHECK (status_menikah IN ('menikah', 'cerai')), -- Status pernikahan
    FOREIGN KEY (n_ayah_NIK) REFERENCES ayah (ayah_NIK),
    FOREIGN KEY (n_ibu_NIK) REFERENCES ibu (ibu_NIK)
);

-- Tabel anak
CREATE TABLE anak (
    anak_kd_nikah CHAR(6) NOT NULL,
    anak_NIK CHAR(5) NOT NULL PRIMARY KEY,
    anak_nama VARCHAR(100) NOT NULL,
    jenis_kelamin CHAR(1) NOT NULL CHECK (jenis_kelamin IN ('L', 'P')),
    anak_status VARCHAR(20) CHECK (anak_status IN ('kandung', 'angkat', 'tiri')), -- Anak kandung, angkat, atau tiri
    FOREIGN KEY (anak_kd_nikah) REFERENCES nikah (kd_nikah)
);

-- Tabel pasangan_ideal
CREATE TABLE pasangan_ideal (
    pasangan_id CHAR(5) NOT NULL PRIMARY KEY,
    goodlooking BOOLEAN NOT NULL,
    pintar BOOLEAN NOT NULL,
    baik BOOLEAN NOT NULL
);

-- Tabel mahasiswa
CREATE TABLE mahasiswa (
    mahasiswa_nrp CHAR(7) NOT NULL PRIMARY KEY,
    mahasiswa_nama VARCHAR(100) NOT NULL,
    mahasiswa_kd_nikah CHAR(6),
    m_ayah_NIK CHAR(5),
    m_ibu_NIK CHAR(5),
    FOREIGN KEY (mahasiswa_kd_nikah) REFERENCES nikah (kd_nikah),
    FOREIGN KEY (m_ayah_NIK) REFERENCES ayah (ayah_NIK),
    FOREIGN KEY (m_ibu_NIK) REFERENCES ibu (ibu_NIK)
);

-- Dummy data ayah
INSERT INTO ayah (ayah_NIK, ayah_nama, ayah_tglLahir, jenis_kelamin) VALUES ('12511', 'Parto', '1960-01-05', 'L');
INSERT INTO ayah (ayah_NIK, ayah_nama, ayah_tglLahir, jenis_kelamin) VALUES ('13711', 'Ali', '1975-01-05', 'L');
INSERT INTO ayah (ayah_NIK, ayah_nama, ayah_tglLahir, jenis_kelamin) VALUES ('13755', 'Bram', '1980-01-05', 'L');
INSERT INTO ayah (ayah_NIK, ayah_nama, ayah_tglLahir, jenis_kelamin) VALUES ('13715', 'Ace', '1982-01-05', 'L');

-- Dummy data ibu
INSERT INTO ibu (ibu_NIK, ibu_nama, ibu_tglLahir, jenis_kelamin) VALUES ('12422', 'Iis', '1962-01-05', 'P');
INSERT INTO ibu (ibu_NIK, ibu_nama, ibu_tglLahir, jenis_kelamin) VALUES ('15455', 'Bety', '1977-01-05', 'P');
INSERT INTO ibu (ibu_NIK, ibu_nama, ibu_tglLahir, jenis_kelamin) VALUES ('15477', 'Mia', '1983-01-05', 'P');
INSERT INTO ibu (ibu_NIK, ibu_nama, ibu_tglLahir, jenis_kelamin) VALUES ('15466', 'Lely', '1985-01-05', 'P');

-- Dummy data nikah
INSERT INTO nikah (kd_nikah, n_ayah_NIK, n_ibu_NIK, status_menikah) VALUES ('BDG005', '12511', '12422', 'menikah');
INSERT INTO nikah (kd_nikah, n_ayah_NIK, n_ibu_NIK, status_menikah) VALUES ('SBY005', '13711', '15455', 'menikah');
INSERT INTO nikah (kd_nikah, n_ayah_NIK, n_ibu_NIK, status_menikah) VALUES ('SBY009', '13755', '15477', 'menikah');
INSERT INTO nikah (kd_nikah, n_ayah_NIK, n_ibu_NIK, status_menikah) VALUES ('SBY008', '13715', '15466', 'cerai');

-- Dummy data anak
INSERT INTO anak (anak_kd_nikah, anak_NIK, anak_nama, jenis_kelamin, anak_status) VALUES ('BDG005', '13711', 'Ali', 'L', 'kandung');
INSERT INTO anak (anak_kd_nikah, anak_NIK, anak_nama, jenis_kelamin, anak_status) VALUES ('BDG005', '13755', 'Bram', 'L', 'kandung');
INSERT INTO anak (anak_kd_nikah, anak_NIK, anak_nama, jenis_kelamin, anak_status) VALUES ('BDG005', '15466', 'Lely', 'P', 'kandung');
INSERT INTO anak (anak_kd_nikah, anak_NIK, anak_nama, jenis_kelamin, anak_status) VALUES ('SBY009', '52230', 'Dodi', 'L', 'angkat');

-- Dummy data mahasiswa
INSERT INTO mahasiswa (mahasiswa_nrp, mahasiswa_nama, mahasiswa_kd_nikah, m_ayah_NIK, m_ibu_NIK) 
VALUES ('5223001', 'Dodi', 'SBY005', '13711', '15455');

INSERT INTO mahasiswa (mahasiswa_nrp, mahasiswa_nama, mahasiswa_kd_nikah, m_ayah_NIK, m_ibu_NIK) 
VALUES ('5223002', 'Sri', 'SBY009', '13755', '15477');

INSERT INTO mahasiswa (mahasiswa_nrp, mahasiswa_nama, mahasiswa_kd_nikah, m_ayah_NIK, m_ibu_NIK) 
VALUES ('5223003', 'Nunu', 'SBY008', '13715', '15466');


-- Query untuk menentukan apakah cucu bisa menikah (berbeda jenis kelamin dan tidak memiliki orang tua yang sama)
SELECT a1.anak_nama AS cucu_1, a2.anak_nama AS cucu_2
FROM anak a1
JOIN anak a2 ON a1.anak_kd_nikah != a2.anak_kd_nikah -- berbeda pernikahan
JOIN nikah n1 ON a1.anak_kd_nikah = n1.kd_nikah
JOIN nikah n2 ON a2.anak_kd_nikah = n2.kd_nikah
WHERE a1.jenis_kelamin != a2.jenis_kelamin
AND (n1.n_ayah_NIK != n2.n_ayah_NIK OR n1.n_ibu_NIK != n2.n_ibu_NIK);
