# Usa un'immagine Node.js per costruire il progetto Flutter
FROM node:16 AS build

# Installa Flutter
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.5-stable.tar.xz && \
    tar -xf flutter_linux_3.13.5-stable.tar.xz -C /usr/local && \
    export PATH="$PATH:/usr/local/flutter/bin" && flutter doctor

# Copia i file del progetto
WORKDIR /app
COPY . .

# Costruisci il progetto Flutter
RUN flutter build web --release

# Usa un'immagine Nginx per servire l'applicazione
FROM nginx:stable

# Copia i file generati dal build nel web server
COPY --from=build /app/build/web /usr/share/nginx/html

# Esponi la porta 80
EXPOSE 80

# Avvia Nginx
CMD ["nginx", "-g", "daemon off;"]