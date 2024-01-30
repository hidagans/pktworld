# Stage 1: Build
FROM rust:latest as build

ARG BRANCH=develop

WORKDIR /build

RUN cargo version

RUN git clone https://github.com/cjdelisle/packetcrypt_rs --branch ${BRANCH} \
    && cd packetcrypt_rs \
    && cargo build --release

# Stage 2: Final Image
FROM gcr.io/distroless/cc

# Menyalin file biner yang telah dibangun dari tahap sebelumnya
COPY --from=build /build/packetcrypt_rs/target/release/packetcrypt /

# Menetapkan titik masuk untuk kontainer
ENTRYPOINT ["/packetcrypt"]

# Menjalankan perintah `ann` saat kontainer dimulai
CMD ["ann", "-p", "pkt1qq8vr3r3c2vj79nz5uyrt75fsfy493n6m29a4rc", "http://pool.pkt.world", "http://pool.pktpool.io", "http://pool.pkteer.com", "https://stratum.zetahash.com"]
