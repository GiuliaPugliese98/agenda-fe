# Usa un'immagine Node.js per costruire il progetto Flutter
FROM node:16 AS build

# Installa Flutter 3.22.2
RUN apt-get update && apt-get install -y wget unzip && \
    mkdir -p /usr/local/flutter && \
    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz && \
    tar -xf flutter_linux_3.22.2-stable.tar.xz -C /usr/local/flutter --strip-components=1 && \
    git config --global --add safe.directory /usr/local/flutter && \
    export PATH="/usr/local/flutter/bin:$PATH" && \
    flutter doctor --android-licenses || true && \
    flutter doctor && \
    flutter --version

# Imposta il PATH per Flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Copia i file del progetto
WORKDIR /app
COPY . .

# Costruisci il progetto Flutter
RUN flutter pub get && flutter build web --release

# Usa un'immagine Nginx per servire l'applicazione
FROM nginx:stable

# Copia i file generati dal build nel web server
COPY --from=build /app/build/web /usr/share/nginx/html

# Copia la configurazione personalizzata di Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Esponi la porta 80
EXPOSE 80

# Avvia Nginx
CMD ["nginx", "-g", "daemon off;"]