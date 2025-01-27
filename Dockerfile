# Etapa 1: Build
FROM golang:1.20 AS builder
WORKDIR /app

# Copiar arquivos de módulo primeiro
COPY go.mod ./
# (Se existir, também inclua o arquivo go.sum)
# COPY go.sum ./

# Baixar dependências do Go
RUN go mod download

# Copiar o restante dos arquivos do projeto
COPY . .

# Construir o binário com linkagem estática
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Etapa 2: Imagem final
FROM scratch
COPY --from=builder /app/app /app
ENTRYPOINT ["/app"]